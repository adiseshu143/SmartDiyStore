import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/widgets/floating_notched_nav_bar.dart';

/// Shell wrapper that keeps the floating navigation bar persistent across
/// Home, Catalog, Services, Orders, and Profile sections.
/// Includes reactive scroll hide/show behavior: hides on scroll down, shows on scroll up.
class MainNavigationShell extends StatefulWidget {
  final Widget child;
  final String currentPath;

  const MainNavigationShell({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  bool _isNavbarVisible = true;

  @override
  void didUpdateWidget(covariant MainNavigationShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When changing primary tabs, ensure navbar is always visible
    if (widget.currentPath != oldWidget.currentPath) {
      if (!_isNavbarVisible) {
        setState(() => _isNavbarVisible = true);
      }
    }
  }

  int _calculateSelectedIndex(String path) {
    if (path.startsWith('/catalog')) return 1;
    if (path.startsWith('/services')) return 2;
    if (path.startsWith('/orders')) return 3;
    if (path.startsWith('/profile')) return 4;
    return 0; // Default to Home for /home or /
  }

  void _onItemSelected(int index) {
    if (!_isNavbarVisible) {
      setState(() => _isNavbarVisible = true);
    }
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/catalog');
        break;
      case 2:
        context.go('/services');
        break;
      case 3:
        context.go('/orders');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  bool _onScrollNotification(ScrollNotification notification) {
    // 1. Detect user gesture scroll direction
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse) {
        // Scrolling down into content -> hide navbar to bottom
        if (_isNavbarVisible) {
          setState(() => _isNavbarVisible = false);
        }
      } else if (notification.direction == ScrollDirection.forward) {
        // Scrolling up towards top -> show navbar immediately
        if (!_isNavbarVisible) {
          setState(() => _isNavbarVisible = true);
        }
      }
    } else if (notification is ScrollUpdateNotification) {
      // 2. React to instantaneous scroll delta for immediate responsiveness
      final delta = notification.scrollDelta ?? 0;
      if (delta > 8 && _isNavbarVisible) {
        setState(() => _isNavbarVisible = false);
      } else if (delta < -6 && !_isNavbarVisible) {
        setState(() => _isNavbarVisible = true);
      }

      // 3. Always restore navbar when near the very top of the scrollable view
      if (notification.metrics.pixels <= 15 && !_isNavbarVisible) {
        setState(() => _isNavbarVisible = true);
      }
    }
    return false; // Allow notification to keep bubbling if needed
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(widget.currentPath);

    return Scaffold(
      body: Stack(
        children: [
          // Screen content wrapped in scroll notification listener
          Positioned.fill(
            child: NotificationListener<ScrollNotification>(
              onNotification: _onScrollNotification,
              child: widget.child,
            ),
          ),

          // Floating Navigation Bar with smooth slide & fade animation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSlide(
              offset: _isNavbarVisible ? Offset.zero : const Offset(0, 1.4),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOutCubic,
              child: AnimatedOpacity(
                opacity: _isNavbarVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: !_isNavbarVisible,
                  child: FloatingNotchedNavBar(
                    selectedIndex: selectedIndex,
                    onItemSelected: _onItemSelected,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
