#!/bin/bash

echo "Building backend..."
cd backend
chmod +x build.sh
./build.sh

echo "Building Flutter app..."
# Set to production mode in api_config.dart
sed -i 's/static const bool isDevelopment = true/static const bool isDevelopment = false/' lib/src/config/api_config.dart

# Build APK
flutter build apk --release

# Create final distribution directory
mkdir -p dist
cp build/app/outputs/flutter-apk/app-release.apk dist/
cp -r backend/dist dist/backend

echo "Build completed. Distribution files are in the dist directory:"
echo "- dist/app-release.apk (Android app)"
echo "- dist/backend/ (Backend server)"
echo ""
echo "To deploy:"
echo "1. Install the APK on your Android device"
echo "2. Deploy the backend files to your server"
echo "3. Update the prodApiUrl in lib/src/config/api_config.dart with your server URL"
