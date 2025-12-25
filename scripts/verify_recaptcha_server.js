/*
Simple Express server to verify reCAPTCHA Enterprise tokens using Google Cloud
Requires: set GOOGLE_APPLICATION_CREDENTIALS to a service account json file
and set RECAPTCHA_PROJECT_ID to your GCP project id.

Install deps:
  npm init -y
  npm install express google-auth-library axios body-parser

Run:
  node scripts/verify_recaptcha_server.js

Request body example (JSON):
{
  "event": {
    "token": "TOKEN",
    "expectedAction": "USER_ACTION",
    "siteKey": "6Lfv-zIsAAAAALTYYbPKlaV0K8m_RAighMf8WehK"
  }
}
*/

const express = require('express');
const bodyParser = require('body-parser');
const {GoogleAuth} = require('google-auth-library');
const axios = require('axios');

const app = express();
app.use(bodyParser.json());

const PROJECT_ID = process.env.RECAPTCHA_PROJECT_ID;
if (!PROJECT_ID) {
  console.error('Please set RECAPTCHA_PROJECT_ID environment variable to your GCP project id.');
  process.exit(1);
}

const auth = new GoogleAuth({ scopes: ['https://www.googleapis.com/auth/cloud-platform'] });

app.post('/verify', async (req, res) => {
  try {
    const { event } = req.body || {};
    if (!event || !event.token) return res.status(400).json({ error: 'Missing event.token' });

    const client = await auth.getClient();
    const accessToken = (await client.getAccessToken()).token;
    if (!accessToken) return res.status(500).json({ error: 'Failed to obtain access token' });

    const url = `https://recaptchaenterprise.googleapis.com/v1/projects/${PROJECT_ID}/assessments`;

    const body = { event };

    const r = await axios.post(url, body, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
        'Content-Type': 'application/json'
      }
    });

    // The API response contains tokenProperties and riskAnalysis
    const result = r.data;

    // Server-side enforcement
    const tokenProps = result.tokenProperties || {};
    const risk = result.riskAnalysis || {};
    const score = typeof risk.score === 'number' ? risk.score : null;
    const valid = tokenProps.valid === true;

    const expectedAction = event.expectedAction;
    const action = tokenProps.action || null;

    // Configurable threshold (env or default 0.5)
    const threshold = parseFloat(process.env.RECAPTCHA_THRESHOLD || '0.5');

    const reasons = [];
    if (!valid) reasons.push('token_invalid');
    if (expectedAction && action && expectedAction !== action) reasons.push('action_mismatch');
    if (score === null) reasons.push('no_score');
    else if (score < threshold) reasons.push('low_score');

    const pass = reasons.length === 0;

    return res.json({
      success: pass,
      passed: pass,
      reasons: reasons,
      score: score,
      tokenProperties: tokenProps,
      riskAnalysis: risk,
      raw: result,
    });
  } catch (err) {
    console.error(err?.response?.data || err.toString());
    return res.status(500).json({ error: 'verification_failed', detail: err?.response?.data || err.toString() });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`reCAPTCHA verify server listening on ${PORT}`));
