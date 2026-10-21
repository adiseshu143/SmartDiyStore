import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class _NavItemData {
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final String label;

  const _NavItemData({
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.label,
  });
}

const List<_NavItemData> _kNavItems = [
  _NavItemData(
    selectedIcon: Icons.home_rounded,
    unselectedIcon: Icons.home_outlined,
    label: 'Home',
  ),
  _NavItemData(
    selectedIcon: Icons.grid_view_rounded,
    unselectedIcon: Icons.grid_view_outlined,
    label: 'Catalog',
  ),
  _NavItemData(
    selectedIcon: Icons.build_rounded,
    unselectedIcon: Icons.build_outlined,
    label: 'Services',
  ),
  _NavItemData(
    selectedIcon: Icons.receipt_long_rounded,
    unselectedIcon: Icons.receipt_long_outlined,
    label: 'Orders',
  ),
  _NavItemData(
    selectedIcon: Icons.person_rounded,
    unselectedIcon: Icons.person_outline_rounded,
    label: 'Profile',
  ),
];

/// Floating Navigation Bar featuring flat zero-shadow aesthetic,
/// with light cyan (#E0F2FE) pill-shaped active icon highlight
/// and Electric Cyan (#00A6FF) active icon + bold label.
class FloatingNotchedNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback? onFabPressed;

  const FloatingNotchedNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.onFabPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          height: 66,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border, width: 1.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_kNavItems.length, (index) {
              final item = _kNavItems[index];
              final isSelected = selectedIndex == index;

              return _NavButton(
                selectedIcon: item.selectedIcon,
                unselectedIcon: item.unselectedIcon,
                label: item.label,
                isSelected: isSelected,
                onTap: () => onItemSelected(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavButton({
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pill-shaped highlight behind active icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE0F2FE) : Colors.transparent, // Light cyan (#E0F2FE)
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isSelected ? selectedIcon : unselectedIcon,
                color: isSelected ? AppColors.primary : const Color(0xFF94A3B8), // Electric Cyan (#00A6FF) vs neutral grey
                size: 22,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500, // Bold weight when active
                color: isSelected ? AppColors.primary : const Color(0xFF64748B), // Electric Cyan (#00A6FF) vs neutral grey
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
