import 'package:flutter/material.dart';
import 'package:mtbs_app/core/constants/app_assets.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({this.width = 154, this.height = 58, super.key});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => Image.network(
    AppAssets.logoUrl,
    width: width,
    height: height,
    fit: BoxFit.contain,
    loadingBuilder: (context, child, progress) {
      if (progress == null) return child;
      return SizedBox(
        width: width,
        height: height,
        child: const Center(child: AppHashLoader(size: 26)),
      );
    },
    errorBuilder: (_, _, _) => SizedBox(
      width: width,
      height: height,
      child: const Center(
        child: Text('MTBS', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
    ),
  );
}
