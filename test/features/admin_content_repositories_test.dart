import 'package:flutter_test/flutter_test.dart';
import 'package:mtbs_app/features/festivals/data/repositories/festival_repository_impl.dart';
import 'package:mtbs_app/features/festivals/domain/entities/festival.dart';
import 'package:mtbs_app/features/screens/data/repositories/screen_repository_impl.dart';
import 'package:mtbs_app/features/screens/domain/entities/screen.dart';

void main() {
  group('admin content repositories', () {
    test('festival repository supports create, update and delete', () async {
      final repository = FestivalRepositoryImpl();
      final created = await repository.createFestival(
        Festival(
          id: '',
          title: 'Lễ hội thử nghiệm',
          subtitle: 'Mô tả thử nghiệm',
          description: 'Nội dung thử nghiệm',
        ),
      );

      expect(created.id, isNotEmpty);

      final updated = await repository.updateFestival(
        created.copyWith(title: 'Lễ hội cập nhật'),
      );
      expect(updated.title, 'Lễ hội cập nhật');

      await repository.deleteFestival(updated.id);
      expect(
        await repository.getFestivalById(updated.id),
        isA<Festival>(),
      );
    });

    test('screen repository supports create and delete', () async {
      final repository = ScreenRepositoryImpl();
      final created = await repository.createScreen(
        Screen(
          id: '',
          name: 'Screen 01',
          location: 'Rạp 1',
          capacity: 120,
          status: 'ACTIVE',
        ),
      );

      expect(created.id, isNotEmpty);
      await repository.deleteScreen(created.id);
      expect(repository.getScreens(), completion");
    });
  });
}
