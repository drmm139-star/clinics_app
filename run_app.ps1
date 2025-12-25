#!/usr/bin/env pwsh

<#
.SYNOPSIS
    دليل تشغيل تطبيق Flutter على جميع المنصات
    Flutter App Runner for All Platforms

.DESCRIPTION
    هذا السكريبت يساعدك على تشغيل التطبيق على أي منصة بسهولة
    
.PARAMETER Platform
    المنصة المراد التشغيل عليها: android, ios, web, windows, all
    
.PARAMETER Action
    الإجراء المراد تنفيذه: run, build, clean, test
    
.EXAMPLE
    .\run_app.ps1 -Platform android -Action run
    .\run_app.ps1 -Platform web -Action build
#>

param(
    [ValidateSet('android', 'ios', 'web', 'windows', 'all')]
    [string]$Platform = 'android',
    
    [ValidateSet('run', 'build', 'clean', 'test')]
    [string]$Action = 'run'
)

# الألوان للطباعة
$greenColor = "Green"
$redColor = "Red"
$yellowColor = "Yellow"
$blueColor = "Cyan"

function Write-ColorOutput([string]$Message, [string]$Color = "White") {
    Write-Host $Message -ForegroundColor $Color
}

function Test-FlutterInstalled {
    try {
        $flutterVersion = flutter --version 2>$null
        Write-ColorOutput "✓ Flutter موجود: $flutterVersion" $greenColor
        return $true
    } catch {
        Write-ColorOutput "✗ Flutter غير موجود!" $redColor
        Write-ColorOutput "الرجاء تثبيت Flutter من: https://flutter.dev/docs/get-started/install" $yellowColor
        return $false
    }
}

function Invoke-Clean {
    Write-ColorOutput "`n🧹 تنظيف المشروع..." $blueColor
    flutter clean
    flutter pub get
    Write-ColorOutput "✓ تم التنظيف بنجاح!" $greenColor
}

function Invoke-Tests {
    Write-ColorOutput "`n🧪 تشغيل الاختبارات..." $blueColor
    flutter test
    Write-ColorOutput "✓ اكتملت الاختبارات!" $greenColor
}

function Invoke-Android {
    Write-ColorOutput "`n📱 تشغيل على Android..." $blueColor
    
    if ($Action -eq 'run') {
        flutter run -d android
    } elseif ($Action -eq 'build') {
        Write-ColorOutput "اختر نوع البناء:" $yellowColor
        Write-Host "1. APK (Debug)"
        Write-Host "2. APK (Release)"
        Write-Host "3. AAB (Release)"
        $choice = Read-Host "اختيارك"
        
        switch ($choice) {
            '1' { flutter build apk --debug }
            '2' { flutter build apk --release }
            '3' { flutter build appbundle --release }
            default { Write-ColorOutput "اختيار غير صحيح" $redColor }
        }
    }
}

function Invoke-iOS {
    Write-ColorOutput "`n🍎 تشغيل على iOS..." $blueColor
    
    if ($PSVersionTable.OS -notmatch "Darwin") {
        Write-ColorOutput "✗ iOS يتطلب macOS!" $redColor
        return
    }
    
    if ($Action -eq 'run') {
        flutter run -d ios
    } elseif ($Action -eq 'build') {
        flutter build ios --release
    }
}

function Invoke-Web {
    Write-ColorOutput "`n🌐 تشغيل على الويب..." $blueColor
    
    if ($Action -eq 'run') {
        flutter run -d chrome
    } elseif ($Action -eq 'build') {
        flutter build web --release
        Write-ColorOutput "✓ تم البناء بنجاح في: build/web" $greenColor
    }
}

function Invoke-Windows {
    Write-ColorOutput "`n🪟 تشغيل على Windows..." $blueColor
    
    if ($PSVersionTable.OS -notmatch "Windows") {
        Write-ColorOutput "✗ Windows يتطلب نظام Windows!" $redColor
        return
    }
    
    if ($Action -eq 'run') {
        flutter run -d windows
    } elseif ($Action -eq 'build') {
        flutter build windows --release
        Write-ColorOutput "✓ تم البناء بنجاح في: build/windows" $greenColor
    }
}

function Main {
    Write-ColorOutput @"
╔════════════════════════════════════════════════════════════╗
║  مستشفيات جامعة بني سويف - تطبيق إدارة العيادات           ║
║  Clinics App - Flutter Multi-Platform Runner               ║
╚════════════════════════════════════════════════════════════╝
"@ $blueColor

    # التحقق من تثبيت Flutter
    if (-not (Test-FlutterInstalled)) {
        exit 1
    }

    # تنفيذ الإجراء
    if ($Action -eq 'clean') {
        Invoke-Clean
        return
    }
    
    if ($Action -eq 'test') {
        Invoke-Tests
        return
    }

    # تشغيل المنصات
    Write-ColorOutput "`n🚀 الإجراء: $Action على $Platform" $blueColor

    switch ($Platform) {
        'android' { Invoke-Android }
        'ios' { Invoke-iOS }
        'web' { Invoke-Web }
        'windows' { Invoke-Windows }
        'all' {
            Write-ColorOutput "تشغيل على جميع المنصات..." $yellowColor
            Invoke-Android
            Invoke-Web
            if ($PSVersionTable.OS -match "Windows") { Invoke-Windows }
            if ($PSVersionTable.OS -match "Darwin") { Invoke-iOS }
        }
    }

    Write-ColorOutput "`n✓ انتهى العمل!" $greenColor
}

# تشغيل البرنامج الرئيسي
Main
