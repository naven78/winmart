# Winmart Shopping App

A Vietnamese grocery shopping app built with Flutter and Node.js.

## Project Structure

- `lib/` - Flutter app source code
- `backend/` - Node.js backend server
- `images/` - Product images and assets
- `build.sh` - Main build script for creating production builds

## Prerequisites

- Flutter SDK
- Node.js and npm
- Android Studio or VS Code with Flutter extensions
- Android SDK for building Android APK

## Development Setup

1. Install dependencies:
   ```bash
   # Install Flutter dependencies
   flutter pub get

   # Install backend dependencies
   cd backend
   npm install
   cd ..
   ```

2. Start the backend server:
   ```bash
   cd backend
   node server.js
   ```

3. Run the Flutter app:
   ```bash
   flutter run
   ```

## Building for Production

1. Update the production API URL:
   - Open `lib/src/config/api_config.dart`
   - Set your production server URL in `prodApiUrl`

2. Run the build script:
   ```bash
   chmod +x build.sh
   ./build.sh
   ```

   This will:
   - Build the backend for production
   - Build the Flutter app in release mode
   - Create a `dist` directory containing:
     - `app-release.apk` - Android app
     - `backend/` - Production backend files

## Deployment

1. Deploy the backend:
   - Copy the contents of `dist/backend/` to your server
   - Install Node.js on your server
   - Run `npm install` in the backend directory
   - Start the server with `node server.js` (or use PM2 for production)

2. Install the Android app:
   - Copy `dist/app-release.apk` to your Android device
   - Install the APK

## Features

- Browse products by category
- Search functionality
- Shopping cart
- Checkout process
- Product details view
- Vietnamese language support

## Backend API Endpoints

- `GET /api/products` - Get all products
- `GET /api/products?category=<category>` - Get products by category
- `GET /api/products/:name` - Get product by name
- `PATCH /api/products/:name/like` - Toggle product like status

## Database

The app uses an XML database (`backend/database.xml`) for storing product information. The structure includes:
- Product name
- Price
- Category
- Image path
- Discount information

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
