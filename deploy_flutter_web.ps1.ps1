# ملف: deploy_flutter_web.ps1
# وصف: يبني تطبيق Flutter Web وينسخ الملفات على فرع gh-pages ويرفعها على GitHub

# 1️⃣ اذهب لمجلد المشروع
$projectPath = "D:\clinics_app"  # عدل المسار حسب مشروعك
Set-Location $projectPath

# 2️⃣ تحقق من Flutter
Write-Host " Checking Flutter..."
flutter doctor

# 3️⃣ بناء التطبيق للويب
Write-Host " Building Flutter Web..."
flutter build web --release

# 4️⃣ انتقل لفرع gh-pages
Write-Host " Checking out gh-pages branch..."
git checkout gh-pages

# 5️⃣ نسخ الملفات من build/web إلى root الفرع
Write-Host " Copying build/web files to gh-pages..."
Copy-Item -Path ".\build\web\*" -Destination ".\" -Recurse -Force

# 6️⃣ إضافة الملفات للـ git
Write-Host " Adding files..."
git add .

# 7️⃣ Commit التغييرات
Write-Host " Committing changes..."
git commit -m "Deploy Flutter Web"

# 8️⃣ Push للـ GitHub
Write-Host " Pushing to origin/gh-pages..."
git push origin gh-pages

Write-Host " Deployment complete! Check your GitHub Pages URL."
