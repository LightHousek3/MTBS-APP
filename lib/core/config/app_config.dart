abstract final class AppConfig {
  static const appName = 'MTBS';
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:3000/api/v1',
  );
  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 20);
  static const googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue:
        '379529891325-bpn2ilofrgpp4bot396rvd48qr6flnmn.apps.googleusercontent.com',
  );
  static const googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue:
        '379529891325-361b0ueahpb25rquh8m3gfnqvvjot436.apps.googleusercontent.com',
  );
}
