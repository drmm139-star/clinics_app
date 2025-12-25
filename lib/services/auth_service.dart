import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Enable/disable debug logging to console
  static bool debugLog = true;

  /// Create user with email & password and return the [UserCredential]
  static Future<UserCredential> signUp(
    String email,
    String password, {
    String? recaptchaToken,
  }) async {
    if (email.isEmpty) {
      throw Exception('البريد الإلكتروني فارغ');
    }
    if (password.isEmpty) {
      throw Exception('كلمة المرور فارغة');
    }

    try {
      if (debugLog && recaptchaToken != null) {
        // ignore: avoid_print
        print('AuthService.signUp recaptchaToken: $recaptchaToken');
      }
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred;
    } on FirebaseAuthException catch (e) {
      if (debugLog) {
        // ignore: avoid_print
        print('AuthService.signUp error: ${e.code} ${e.message}');
      }
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('البريد الإلكتروني مستخدم بالفعل');
        case 'invalid-email':
          throw Exception('البريد الإلكتروني غير صالح');
        case 'weak-password':
          throw Exception('كلمة المرور ضعيفة');
        default:
          throw Exception(e.message ?? 'خطأ في إنشاء الحساب');
      }
    }
  }

  /// Request phone verification. Returns a map with
  /// `{ 'verificationId': String?, 'resendToken': int? }` when code is sent
  /// or auto-verified (verificationId may be null in automatic verification).
  static Future<Map<String, dynamic>?> requestPhoneVerification(
    String phone, {
    int? forceResendingToken,
  }) {
    final completer = Completer<Map<String, dynamic>?>();

    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      forceResendingToken: forceResendingToken,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          final user = _auth.currentUser;
          if (user != null) {
            await user.linkWithCredential(credential);
            if (!completer.isCompleted) {
              completer.complete({'verificationId': null, 'resendToken': null});
            }
          } else {
            await _auth.signInWithCredential(credential);
            if (!completer.isCompleted) {
              completer.complete({'verificationId': null, 'resendToken': null});
            }
          }
        } catch (e) {
          if (!completer.isCompleted) {
            completer.completeError(e);
          }
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        if (!completer.isCompleted) {
          completer.complete({
            'verificationId': verificationId,
            'resendToken': resendToken,
          });
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (!completer.isCompleted) {
          completer.complete({
            'verificationId': verificationId,
            'resendToken': null,
          });
        }
      },
      timeout: const Duration(seconds: 60),
    );

    return completer.future;
  }

  /// Link the given SMS code (together with the verificationId) to the
  /// currently signed-in user. Returns the resulting [UserCredential].
  static Future<UserCredential> linkPhoneCredential(
    String verificationId,
    String smsCode,
  ) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('لا يوجد مستخدم مسجل حالياً لربط الهاتف');
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final res = await user.linkWithCredential(credential);
    return res;
  }

  /// Sends a password reset email using Firebase Auth
  static Future<void> sendPasswordReset(String email, {String? phone}) async {
    if (email.isEmpty) {
      throw Exception('البريد الإلكتروني فارغ');
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (debugLog) {
        // ignore: avoid_print
        print('AuthService.sendPasswordReset error: ${e.code} ${e.message}');
      }
      switch (e.code) {
        case 'user-not-found':
          throw Exception('لم يتم العثور على مستخدم بهذا البريد');
        case 'invalid-email':
          throw Exception('البريد الإلكتروني غير صالح');
        default:
          throw Exception(e.message ?? 'فشل في إرسال رابط إعادة التعيين');
      }
    }
  }

  /// Sends verification email to the current signed-in user
  static Future<void> sendEmailVerificationToCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('لا يوجد مستخدم مسجل حالياً');
    }

    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (debugLog) {
        // ignore: avoid_print
        print(
          'AuthService.sendEmailVerification error: ${e.code} ${e.message}',
        );
      }
      throw Exception(e.message ?? 'فشل في إرسال رابط التحقق');
    }
  }

  /// Signs in a user using email and password
  static Future<UserCredential> signIn(String email, String password) async {
    if (email.isEmpty) {
      throw Exception('البريد الإلكتروني فارغ');
    }
    if (password.isEmpty) {
      throw Exception('كلمة المرور فارغة');
    }

    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred;
    } on FirebaseAuthException catch (e) {
      if (debugLog) {
        // ignore: avoid_print
        print('AuthService.signIn error: ${e.code} ${e.message}');
      }
      switch (e.code) {
        case 'user-not-found':
          throw Exception('لم يتم العثور على مستخدم بهذا البريد');
        case 'wrong-password':
          throw Exception('كلمة المرور غير صحيحة');
        case 'invalid-email':
          throw Exception('البريد الإلكتروني غير صالح');
        case 'user-disabled':
          throw Exception('تم تعطيل هذا الحساب');
        default:
          throw Exception(e.message ?? 'فشل في تسجيل الدخول');
      }
    }
  }

  /// Delete the currently signed-in user (used to roll back on failed flows).
  static Future<void> deleteCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('لا يوجد مستخدم لتتم إزالته');
    }
    try {
      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (debugLog) {
        // ignore: avoid_print
        print('AuthService.deleteCurrentUser error: ${e.code} ${e.message}');
      }
      throw Exception(e.message ?? 'فشل في حذف المستخدم');
    }
  }
}
