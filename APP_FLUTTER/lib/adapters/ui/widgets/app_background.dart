import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme_manager.dart';
import '../../../theme/color_palette.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final isDark = themeManager.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        gradient: isDark ? darkGradientBackground : lightGradientBackground,
      ),
      child: child,
    );
  }
}