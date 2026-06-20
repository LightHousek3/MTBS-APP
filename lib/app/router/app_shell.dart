import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: navigationShell,
    bottomNavigationBar: NavigationBar(
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      ),
      destinations: const <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        NavigationDestination(
          icon: Icon(Icons.confirmation_number_outlined),
          selectedIcon: Icon(Icons.confirmation_number),
          label: 'Rạp',
        ),
        NavigationDestination(
          icon: Icon(Icons.local_activity_outlined),
          selectedIcon: Icon(Icons.local_activity),
          label: 'Giá vé',
        ),
        NavigationDestination(
          icon: Icon(Icons.card_giftcard_outlined),
          selectedIcon: Icon(Icons.card_giftcard),
          label: 'Khuyến mãi',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Tài khoản',
        ),
      ],
    ),
  );
}
