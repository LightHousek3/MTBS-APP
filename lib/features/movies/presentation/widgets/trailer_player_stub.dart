import 'package:flutter/material.dart';

class TrailerPlayer extends StatelessWidget {
  const TrailerPlayer({required this.url, required this.uri, super.key});

  final String url;
  final Uri uri;

  @override
  Widget build(BuildContext context) => _TrailerFallback(url: url);
}

class _TrailerFallback extends StatelessWidget {
  const _TrailerFallback({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: SelectableText(url, textAlign: TextAlign.center),
    ),
  );
}
