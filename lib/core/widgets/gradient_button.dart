import 'package:flutter/material.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.height = 52,
    this.borderRadius = 18,
    this.textStyle,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;

  static const gradient = LinearGradient(
    begin: Alignment(0.82, -0.57),
    end: Alignment(-0.82, 0.57),
    colors: <Color>[Color(0xFFFE6969), Color(0xFFE30713)],
    stops: <double>[0, 1],
  );

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final child = AnimatedOpacity(
      duration: const Duration(milliseconds: 160),
      opacity: enabled || isLoading ? 1 : 0.55,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x4DFE6969),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: SizedBox(
          height: height,
          child: Center(
            child: isLoading
                ? const AppHashLoader(size: 22, color: Colors.white)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ?icon,
                      if (icon != null && label.isNotEmpty)
                        const SizedBox(width: 8),
                      if (label.isNotEmpty)
                        Text(
                          label,
                          style:
                              textStyle ??
                              const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    );
  }
}
