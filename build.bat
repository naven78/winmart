@echo off

echo Building backend...
cd backend
if not exist dist mkdir dist
copy server.js dist\
copy database.xml dist\
copy package.json dist\
cd dist
call npm install --production
cd ..
cd ..

echo Building Flutter app...
call flutter build apk --release

if not exist dist mkdir dist
copy build\app\outputs\flutter-apk\app-release.apk dist\

echo Build completed. Distribution files are in the dist directory:
echo - dist/app-release.apk (Android app)
echo - backend/dist/ (Backend server)
echo.
echo To deploy:
echo 1. Install the APK on your Android device
echo 2. Deploy the backend files to your server
echo 3. Update the prodApiUrl in lib/src/config/api_config.dart with your server URL

pause
