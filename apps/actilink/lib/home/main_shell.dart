import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

class MainShell extends StatelessWidget {
  const MainShell({required this.child, super.key});
  final Widget child;

  static const tabs = [
    '/events',
    '/venues',
    '/post',
    '/map',
    '/profile',
  ];

  int _locationToTabIndex(String location) {
    return tabs.indexWhere((path) => location.startsWith(path));
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _locationToTabIndex(location);

    return SafeArea(
      child: Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => context.go(tabs[index]),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.accent,
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.event_rounded),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Venues',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_rounded),
              label: 'Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_rounded),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
