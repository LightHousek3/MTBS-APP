abstract final class AppConfig {
  static const appName = 'MTBS';
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://2g0wbc53-3000.asse.devtunnels.ms/api/v1',
  );
  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 20);
}
