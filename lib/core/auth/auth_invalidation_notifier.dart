import 'package:flutter_riverpod/flutter_riverpod.dart';

final authInvalidationProvider =
    NotifierProvider<AuthInvalidationNotifier, int>(
      AuthInvalidationNotifier.new,
    );

class AuthInvalidationNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void invalidate() => state++;
}
