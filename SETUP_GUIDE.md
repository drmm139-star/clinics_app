# مستشفيات جامعة بني سويف - تطبيق إدارة العيادات

تطبيق Flutter متعدد المنصات لإدارة العيادات بمستشفيات جامعة بني سويف.

## المنصات المدعومة

✅ Android  
✅ iOS  
✅ Web  
✅ Windows  

## المتطلبات الأساسية

- Flutter SDK >= 3.10.0
- Dart >= 3.10.0
- Android SDK (لـ Android)
- Xcode (لـ iOS)
- Visual Studio أو Android Studio (لـ Windows)

## التثبيت والإعداد

### 1. الحصول على المشروع

```bash
cd d:\clinics_app
```

### 2. تثبيت المتطلبات

```bash
flutter pub get
```

## التشغيل على المنصات المختلفة

### تشغيل على Android

```bash
flutter run -d android
```

أو محاكي محدد:

```bash
flutter run -d sdk\ gphone64\ x86\ 64
```

### تشغيل على iOS

```bash
flutter run -d ios
```

### تشغيل على الويب

```bash
flutter run -d chrome
```

أو بمتصفح مختلف:

```bash
flutter run -d firefox
flutter run -d edge
```

### تشغيل على Windows

```bash
flutter run -d windows
```

## البناء للإنتاج

### بناء APK (Android)

```bash
flutter build apk --release
```

### بناء AAB (Android App Bundle)

```bash
flutter build appbundle --release
```

### بناء IPA (iOS)

```bash
flutter build ios --release
```

### بناء Web

```bash
flutter build web --release
```

### بناء Windows

```bash
flutter build windows --release
```

## البنية

```
lib/
├── main.dart                 # نقطة الدخول الرئيسية
├── screens/                  # الشاشات
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── dashboard_screen.dart
│   └── ...
├── services/                 # الخدمات
│   ├── auth_service.dart     # خدمة المصادقة
│   ├── platform_service.dart # خدمة الكشف عن المنصة
│   └── ...
├── models/                   # نماذج البيانات
│   └── clinic_model.dart
├── theme/                    # التصميم والألوان
│   └── theme_tokens.dart
└── firebase_options.dart     # تكوين Firebase
```

## الميزات

- ✅ مصادقة آمنة عبر Firebase
- ✅ دعم اللغة العربية
- ✅ واجهة مستجيبة تعمل على جميع الأحجام
- ✅ دعم جميع المنصات (موبايل وويب وسطح مكتب)

## الخدمات المستخدمة

- **Firebase Authentication**: للمصادقة والتحقق من البريد الإلكتروني
- **Firebase Core**: لتهيئة Firebase
- **URL Launcher**: لفتح الروابط والاتصالات
- **Connectivity Plus**: للتحقق من الاتصال بالإنترنت

## استكشاف الأخطاء

### مشكلة: "NDK did not have a source.properties file"

الحل:
```bash
# احذف NDK الموجود
rm -r "%APPDATA%\Local\Android\sdk\ndk\28.2.13676358"

# أعد تشغيل البناء
flutter run
```

### مشكلة: "Assets not found"

تأكد من:
1. وضع ملفات الأصول في مجلد `assets/`
2. تحديث `pubspec.yaml` بشكل صحيح

### مشكلة: Firebase لا يعمل على الويب

تأكد من:
1. أن لديك بيانات اعتماد Firebase الصحيحة في `firebase_options.dart`
2. تشغيل التطبيق على `localhost` أو نطاق مصرح به

## دعم

للإبلاغ عن مشاكل أو طلب ميزات جديدة، يرجى فتح issue في المستودع.

## الترخيص

هذا المشروع مرخص تحت رخصة MIT.
