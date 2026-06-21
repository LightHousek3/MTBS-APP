import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mtbs_app/core/storage/device_id_store.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  const storedDeviceId = '4b960570-8f43-4f6a-a16e-c17aaf8d67a2';

  test('reuses the installation device ID from secure storage', () async {
    final storage = _MockSecureStorage();
    when(
      () => storage.read(key: any(named: 'key')),
    ).thenAnswer((_) async => storedDeviceId);
    final store = DeviceIdStore(storage);

    expect(await store.getOrCreate(), storedDeviceId);
    expect(await store.getOrCreate(), storedDeviceId);
    verify(() => storage.read(key: 'mtbs_device_id')).called(1);
    verifyNever(
      () => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    );
  });

  test('creates and persists a UUID v4 when no device ID exists', () async {
    final storage = _MockSecureStorage();
    when(
      () => storage.read(key: any(named: 'key')),
    ).thenAnswer((_) async => null);
    when(
      () => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});
    final store = DeviceIdStore(storage);

    final deviceId = await store.getOrCreate();

    expect(
      deviceId,
      matches(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ),
      ),
    );
    verify(
      () => storage.write(key: 'mtbs_device_id', value: deviceId),
    ).called(1);
  });
}
