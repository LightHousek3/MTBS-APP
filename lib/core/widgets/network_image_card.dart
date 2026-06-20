import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';

class NetworkImageCard extends StatelessWidget {
  const NetworkImageCard({
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    super.key,
  });

  final String? imageUrl;
  final BoxFit fit;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: borderRadius,
    child: imageUrl == null || imageUrl!.isEmpty
        ? const ColoredBox(
            color: Color(0xFF24262D),
            child: Center(child: Icon(Icons.movie_outlined, size: 48)),
          )
        : CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: fit,
            placeholder: (_, _) => const ColoredBox(
              color: Color(0xFF24262D),
              child: Center(child: AppHashLoader(size: 34)),
            ),
            errorWidget: (_, _, _) => const ColoredBox(
              color: Color(0xFF24262D),
              child: Center(child: Icon(Icons.broken_image_outlined)),
            ),
          ),
  );
}
