import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mtbs_app/core/auth/auth_invalidation_notifier.dart';
import 'package:mtbs_app/core/network/dio_client.dart';
import 'package:mtbs_app/core/storage/device_id_store.dart';
import 'package:mtbs_app/core/storage/session_store.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
});

final sessionStoreProvider = Provider<SessionStore>((ref) {
  return SessionStore(ref.watch(secureStorageProvider));
});

final deviceIdStoreProvider = Provider<DeviceIdStore>((ref) {
  return DeviceIdStore(ref.watch(secureStorageProvider));
});

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(
    ref.watch(sessionStoreProvider),
    onUnauthorized: () {
      ref.read(authInvalidationProvider.notifier).invalidate();
    },
  );
});
