import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/habits/models/habit.dart';
import '../style/oiya_styles.dart';
import 'habit_streak_detail_sheet.dart';

class GradientIcon extends StatelessWidget {
  const GradientIcon(
    this.icon, {
    super.key,
    required this.colors,
    this.size = 24.0,
  });

  final IconData icon;
  final List<Color> colors;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: colors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(bounds);
      },
      child: Icon(
        icon,
        size: size,
        color: Colors.white,
      ),
    );
  }
}

class StreakTierStyle {
  final String name;
  final IconData icon;
  final List<Color> gradientColors;
  final Color bgTint;
  final Color borderTint;
  final Color textColor;

  const StreakTierStyle({
    required this.name,
    required this.icon,
    required this.gradientColors,
    required this.bgTint,
    required this.borderTint,
    required this.textColor,
  });
}

StreakTierStyle getStreakTierStyle(int streak, bool isDark) {
  if (streak <= 0) {
    return StreakTierStyle(
      name: 'No Streak',
      icon: CupertinoIcons.flame,
      gradientColors: [
        isDark ? Colors.white30 : Colors.black26,
        isDark ? Colors.white30 : Colors.black26,
      ],
      bgTint: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.02),
      borderTint: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
      textColor: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48,
    );
  }

  if (streak < 7) {
    return StreakTierStyle(
      name: 'Classic Flame',
      icon: CupertinoIcons.flame_fill,
      gradientColors: const [Color(0xFFFF453A), Color(0xFFFF9F0A)],
      bgTint: const Color(0xFFFF9F0A).withOpacity(0.12),
      borderTint: const Color(0xFFFF9F0A).withOpacity(0.35),
      textColor: isDark ? const Color(0xFFFFD60A) : const Color(0xFFD67A00),
    );
  }

  if (streak < 15) {
    return StreakTierStyle(
      name: 'Ice Flame',
      icon: CupertinoIcons.flame_fill,
      gradientColors: const [Color(0xFF64D2FF), Color(0xFF0A84FF)],
      bgTint: const Color(0xFF0A84FF).withOpacity(0.12),
      borderTint: const Color(0xFF0A84FF).withOpacity(0.35),
      textColor: isDark ? const Color(0xFF64D2FF) : const Color(0xFF0056B3),
    );
  }

  if (streak < 30) {
    return StreakTierStyle(
      name: 'Emerald Flame',
      icon: CupertinoIcons.flame_fill,
      gradientColors: const [Color(0xFF30D158), Color(0xFF00A86B)],
      bgTint: const Color(0xFF30D158).withOpacity(0.12),
      borderTint: const Color(0xFF30D158).withOpacity(0.35),
      textColor: isDark ? const Color(0xFF30D158) : const Color(0xFF00754A),
    );
  }

  if (streak < 50) {
    return StreakTierStyle(
      name: 'Mystic Flame',
      icon: CupertinoIcons.flame_fill,
      gradientColors: const [Color(0xFFFF2D55), Color(0xFFBF5AF2)],
      bgTint: const Color(0xFFBF5AF2).withOpacity(0.12),
      borderTint: const Color(0xFFBF5AF2).withOpacity(0.35),
      textColor: isDark ? const Color(0xFFE5A4FF) : const Color(0xFF861F9C),
    );
  }

  if (streak < 100) {
    return StreakTierStyle(
      name: 'Radiant Flame',
      icon: CupertinoIcons.flame_fill,
      gradientColors: const [Color(0xFFFFD60A), Color(0xFFFF9F0A)],
      bgTint: const Color(0xFFFFD60A).withOpacity(0.12),
      borderTint: const Color(0xFFFFD60A).withOpacity(0.4),
      textColor: isDark ? const Color(0xFFFFD60A) : const Color(0xFFB8860B),
    );
  }

  return StreakTierStyle(
    name: 'Cosmic Flame',
    icon: CupertinoIcons.flame_fill,
    gradientColors: const [Color(0xFFFF2D55), Color(0xFF00F5FF), Color(0xFFFFD60A)],
    bgTint: const Color(0xFF00F5FF).withOpacity(0.15),
    borderTint: const Color(0xFFFF2D55).withOpacity(0.4),
    textColor: isDark ? const Color(0xFF00F5FF) : const Color(0xFFC71585),
  );
}

class StreakBadge extends ConsumerWidget {
  final Habit habit;

  const StreakBadge({super.key, required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final streak = habit.streakCount;
    final style = getStreakTierStyle(streak, isDark);

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        showHabitStreakDetailSheet(context, ref, habit);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: style.bgTint,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: style.borderTint, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (streak == 0)
              Icon(
                style.icon,
                size: 13,
                color: style.textColor.withOpacity(0.5),
              )
            else
              GradientIcon(
                style.icon,
                colors: style.gradientColors,
                size: 13,
              ),
            const SizedBox(width: 4),
            Text(
              '${streak}d',
              style: OiyaStyles.finePrint(color: style.textColor).copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
