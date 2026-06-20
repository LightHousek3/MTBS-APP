import 'package:flutter/material.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    required this.title,
    required this.icon,
    this.description,
    super.key,
  });

  final String title;
  final IconData icon;
  final String? description;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 76, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 18),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              description ?? 'Tính năng đang được chuẩn bị.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    ),
  );
}
