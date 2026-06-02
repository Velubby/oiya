import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../style/oiya_styles.dart';
import 'home/home_screen.dart';
import 'capture/capture_screen.dart';
import 'search/search_screen.dart';
import 'resurface/resurface_screen.dart';
import 'settings/settings_screen.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  void _goToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(onTabSelected: _goToTab),
      CaptureScreen(onCaptureSaved: () => _goToTab(0)),
      const SearchScreen(),
      const ResurfaceScreen(),
      const SettingsScreen(),
    ];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? OiyaStyles.surfaceBlack : OiyaStyles.canvasParchment,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: _OiyaBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _goToTab,
      ),
    );
  }
}

class _OiyaBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _OiyaBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary;
    final inactiveColor = isDark ? OiyaStyles.inkMuted48 : Colors.black38;

    const items = [
      _BottomNavItem(icon: CupertinoIcons.house, activeIcon: CupertinoIcons.house_fill, label: 'Vault'),
      _BottomNavItem(icon: CupertinoIcons.plus_circle, activeIcon: CupertinoIcons.plus_circle_fill, label: 'Capture'),
      _BottomNavItem(icon: CupertinoIcons.search, activeIcon: CupertinoIcons.search, label: 'Search'),
      _BottomNavItem(icon: CupertinoIcons.sparkles, activeIcon: CupertinoIcons.sparkles, label: 'Resurface'),
      _BottomNavItem(icon: CupertinoIcons.settings, activeIcon: CupertinoIcons.settings_solid, label: 'Settings'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: (isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas).withOpacity(0.88),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline,
            width: 0.5,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 52,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final isSelected = index == currentIndex;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onTap(index);
                      },
                      child: Center(
                        child: Icon(
                          isSelected ? item.activeIcon : item.icon,
                          color: isSelected ? activeColor : inactiveColor,
                          size: 24,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
