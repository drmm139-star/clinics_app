# Getting Started - دليل البدء

## 1. التأكد من البيئة

تأكد من تثبيت Flutter و Dart:

```bash
flutter --version
dart --version
```

## 2. الحصول على المتطلبات

```bash
cd d:\clinics_app
flutter pub get
flutter pub upgrade
```

## 3. إعداد Firebase (إن لم يكن معداً)

إذا لم تقم بإعداد Firebase من قبل:

```bash
# تثبيت FlutterFire CLI إذا لم يكن مثبتاً
dart pub global activate flutterfire_cli

# تشغيل إعداد FlutterFire
flutterfire configure
```

## 4. اختيار والتحقق من جهازك

قائمة الأجهزة المتاحة:

```bash
flutter devices
```

## 5. التشغيل على المنصات المختلفة

### Android/Emulator

```bash
# تشغيل على محاكي
flutter run

# أو تشغيل على جهاز معين
flutter run -d <device_id>

# مع وضع Release
flutter run --release
```

### iOS (على Mac فقط)

```bash
# تشغيل على محاكي iOS
flutter run -d ios

# إذا كنت بحاجة لتثبيت POD
cd ios
pod install
cd ..
flutter run
```

### Web

```bash
# تشغيل على Chrome (الافتراضي)
flutter run -d chrome

# أو متصفح آخر
flutter run -d firefox
flutter run -d edge

# بناء للويب
flutter build web --release

# تشغيل محلي
cd build/web
python -m http.server 8000
# ثم افتح http://localhost:8000
```

### Windows

```bash
# تشغيل على Windows
flutter run -d windows

# بناء للويندوز
flutter build windows --release
```

## 6. تطوير التطبيق

### Hot Reload أثناء التطوير

```bash
# الضغط على 'r' لإعادة تحميل الكود
# الضغط على 'R' لإعادة تشغيل كامل
```

### Debugging

```bash
# تشغيل مع وضع debug
flutter run

# تشغيل مع Observatory (Debugger)
flutter run --observe=http://127.0.0.1:8181
```

## 7. بناء الإصدارات

### Debug Build

```bash
flutter build apk --debug         # Android
flutter build ios                 # iOS
flutter build web                 # Web
flutter build windows             # Windows
```

### Release Build

```bash
flutter build apk --release       # Android
flutter build appbundle --release # Android Bundle
flutter build ios --release       # iOS
flutter build web --release       # Web
flutter build windows --release   # Windows
```

## 8. استكشاف الأخطاء

### تنظيف المشروع

```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### حل مشاكل شائعة

#### مشكلة: "Target debug_android_application failed"

```bash
# حذف مجلد build والبناء من جديد
flutter clean
flutter pub get
flutter run
```

#### مشكلة: "NDK version mismatch"

```bash
# تحديث NDK أو تثبيته من جديد
flutter doctor
flutter doctor --android-licenses
```

#### مشكلة: "Web app not loading"

```bash
# تأكد من أن الويب مفعل
flutter config --enable-web

# قم ببناء جديد
flutter clean
flutter pub get
flutter run -d chrome
```

## 9. اختبار التطبيق

```bash
# تشغيل الاختبارات
flutter test

# اختبار ملف محدد
flutter test test/platform_service_test.dart

# الاختبارات مع التغطية
flutter test --coverage
```

## 10. بدء التطوير

### المجلدات الرئيسية

- `lib/screens/` - الشاشات والواجهات
- `lib/services/` - الخدمات والمنطق
- `lib/models/` - نماذج البيانات
- `lib/theme/` - التصميم والألوان
- `lib/config/` - الإعدادات

### إضافة ميزة جديدة

1. أنشئ شاشة جديدة في `lib/screens/`
2. أنشئ نموذج بيانات إذا لزم الأمر في `lib/models/`
3. أنشئ خدمة إذا لزمت في `lib/services/`
4. أضف المسار الجديد في `main.dart`

## ملاحظات مهمة

- التطبيق يدعم **جميع المنصات**: Android, iOS, Web, Windows
- جميع الرسائل مترجمة إلى **العربية**
- يستخدم **Firebase** للمصادقة والبيانات
- الواجهة **مستجيبة** وتعمل على جميع الأحجام

## المساعدة

للمزيد من المساعدة:

```bash
flutter --help
flutter run --help
```

أو زيارة [Flutter Documentation](https://flutter.dev/docs)
