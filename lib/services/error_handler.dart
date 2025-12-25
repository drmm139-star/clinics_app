import 'package:flutter/material.dart';

class ErrorHandler {
  /// Show error snackbar
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Show success message
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show info message
  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show loading dialog
  static void showLoadingDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message ?? 'جاري التحميل...'),
          ],
        ),
      ),
    );
  }

  /// Handle Firebase exceptions with Arabic messages
  static String handleError(dynamic error) {
    final errorMessage = error.toString();

    if (errorMessage.contains('network')) {
      return 'خطأ في الاتصال بالإنترنت';
    } else if (errorMessage.contains('invalid-email')) {
      return 'البريد الإلكتروني غير صالح';
    } else if (errorMessage.contains('user-not-found')) {
      return 'لم يتم العثور على مستخدم بهذا البريد';
    } else if (errorMessage.contains('wrong-password')) {
      return 'كلمة المرور غير صحيحة';
    } else if (errorMessage.contains('weak-password')) {
      return 'كلمة المرور ضعيفة جداً';
    } else if (errorMessage.contains('email-already-in-use')) {
      return 'البريد الإلكتروني مستخدم بالفعل';
    } else if (errorMessage.contains('operation-not-allowed')) {
      return 'العملية غير مسموحة حالياً';
    } else if (errorMessage.contains('too-many-requests')) {
      return 'عدد محاولات كثير جداً. حاول لاحقاً';
    }

    return error.toString();
  }
}
