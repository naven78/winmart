class ApiConfig {
  // Development URL
  static const String devApiUrl = 'http://10.0.2.2:3000';
  
  // Production URL - Render.com URL
  static const String prodApiUrl = 'https://winmart-backend.onrender.com';
  
  // Set this to false for production build
  static const bool isDevelopment = false;
  
  static String get baseUrl => isDevelopment ? devApiUrl : prodApiUrl;
  
  static String get productsUrl => '$baseUrl/api/products';
}
