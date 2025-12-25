const express = require('express');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

// Rate limiting: prefer Redis when REDIS_URL configured, otherwise in-memory.
const REDIS_URL = process.env.REDIS_URL;
let redis = null;
if (REDIS_URL) {
  try {
    const IORedis = require('ioredis');
    redis = new IORedis(REDIS_URL);
    console.log('Using Redis for rate limiting');
  } catch (e) {
    console.warn('ioredis not available, falling back to in-memory rate limiting');
    redis = null;
  }
}

const rateStore = new Map(); // fallback in-memory store

async function isRateLimited(phone) {
  const now = Date.now();
  if (redis) {
    const key = `sms:rates:${phone}`;
    // remove older than 1 hour
    const minScore = now - 60 * 60 * 1000;
    await redis.zremrangebyscore(key, 0, minScore);
    const count = await redis.zcount(key, minScore, now);
    const last = await redis.zrevrange(key, 0, 0, 'WITHSCORES');
    const lastTs = last && last.length >= 2 ? parseInt(last[1], 10) : 0;
    if (count >= 5) return true;
    if (lastTs && now - lastTs < 60 * 1000) return true;
    return false;
  } else {
    const entries = rateStore.get(phone) || [];
    const recent = entries.filter((t) => t > now - 60 * 60 * 1000);
    rateStore.set(phone, recent);
    if (recent.length >= 5) return true;
    const last = recent[recent.length - 1] || 0;
    if (now - last < 60 * 1000) return true;
    return false;
  }
}

async function recordSend(phone) {
  const now = Date.now();
  if (redis) {
    const key = `sms:rates:${phone}`;
    await redis.zadd(key, now, `${now}`);
    // set TTL a bit longer than one hour
    await redis.expire(key, 60 * 60 + 60);
  } else {
    const entries = rateStore.get(phone) || [];
    entries.push(now);
    rateStore.set(phone, entries);
  }
}

// Basic auth: expect SENDSMS_USER and SENDSMS_PASS env vars
const SENDSMS_USER = process.env.SENDSMS_USER;
const SENDSMS_PASS = process.env.SENDSMS_PASS;
function checkBasicAuth(req) {
  if (!SENDSMS_USER || !SENDSMS_PASS) return true; // no auth configured
  const auth = req.headers['authorization'];
  if (!auth || !auth.startsWith('Basic ')) return false;
  const b64 = auth.slice('Basic '.length);
  const decoded = Buffer.from(b64, 'base64').toString('utf8');
  return decoded === `${SENDSMS_USER}:${SENDSMS_PASS}`;
}

const PORT = process.env.PORT || 3000;

// Expected env vars for Twilio
const TWILIO_ACCOUNT_SID = process.env.TWILIO_ACCOUNT_SID;
const TWILIO_AUTH_TOKEN = process.env.TWILIO_AUTH_TOKEN;
const TWILIO_FROM = process.env.TWILIO_FROM;
const TWILIO_WHATSAPP_FROM = process.env.TWILIO_WHATSAPP_FROM;

let twilioClient = null;
if (TWILIO_ACCOUNT_SID && TWILIO_AUTH_TOKEN) {
  const twilio = require('twilio');
  twilioClient = twilio(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN);
}

app.post('/send-sms', async (req, res) => {
  const { phone, message } = req.body || {};
  if (!phone || !message) {
    return res.status(400).json({ error: 'Missing phone or message' });
  }

  if (!checkBasicAuth(req)) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  if (isRateLimited(phone)) {
    return res.status(429).json({ error: 'Rate limited' });
  }

  if (!twilioClient) {
    return res.status(501).json({ error: 'Twilio not configured' });
  }

  try {
    const msg = await twilioClient.messages.create({
      body: message,
      from: TWILIO_FROM,
      to: phone,
    });
    recordSend(phone);
    return res.json({ success: true, sid: msg.sid });
  } catch (err) {
    console.error('Twilio send error', err);
    return res.status(500).json({ error: err.message || String(err) });
  }
});

app.post('/send-whatsapp', async (req, res) => {
  const { phone, message } = req.body || {};
  if (!phone || !message) {
    return res.status(400).json({ error: 'Missing phone or message' });
  }

  if (!checkBasicAuth(req)) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  if (isRateLimited(phone)) {
    return res.status(429).json({ error: 'Rate limited' });
  }

  if (!twilioClient) {
    return res.status(501).json({ error: 'Twilio not configured' });
  }

  try {
    const whatsappFrom = TWILIO_WHATSAPP_FROM || TWILIO_FROM;
    if (!whatsappFrom) {
      return res.status(501).json({ error: 'WhatsApp sender not configured. Set TWILIO_WHATSAPP_FROM.' });
    }

    const msg = await twilioClient.messages.create({
      body: message,
      from: `whatsapp:${whatsappFrom}`,
      to: `whatsapp:${phone}`,
    });
    recordSend(phone);
    return res.json({ success: true, sid: msg.sid });
  } catch (err) {
    console.error('Twilio WhatsApp send error', err);
    return res.status(500).json({ error: err.message || String(err) });
  }
});

app.listen(PORT, () => {
  console.log(`Send-SMS server listening on ${PORT}`);
  if (!twilioClient) console.warn('Twilio not configured. Set TWILIO_ACCOUNT_SID and TWILIO_AUTH_TOKEN.');
});
