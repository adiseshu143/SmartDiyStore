import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../domain/entities/order_entity.dart';
import '../../orders/providers/orders_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allOrders = ref.watch(ordersProvider);
    final activeOrders = allOrders.where((o) => o.status != OrderStatus.delivered).length;
    final customServices = allOrders.where((o) => o.type == OrderType.customService).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          // User Avatar & Info
          const Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primaryContainer,
              child: Icon(Icons.person, size: 48, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'DIY Enthusiast',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
          const Center(
            child: Text(
              'builder@smartdiystore.com',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 20),

          // User Order Stats Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border, width: 1.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  count: '${allOrders.length}',
                  label: 'Total Orders',
                  color: AppColors.primary,
                ),
                Container(width: 1, height: 32, color: AppColors.border),
                _StatItem(
                  count: '$activeOrders',
                  label: 'Active Tracking',
                  color: const Color(0xFF059669),
                ),
                Container(width: 1, height: 32, color: AppColors.border),
                _StatItem(
                  count: '$customServices',
                  label: 'CAD Services',
                  color: AppColors.secondary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Options List
          _ProfileOption(
            icon: Icons.receipt_long_outlined,
            title: 'Order History & Tracking',
            subtitle: '${allOrders.length} orders synced',
            onTap: () => context.go('/orders'),
          ),
          _ProfileOption(
            icon: Icons.precision_manufacturing_outlined,
            title: 'Custom Engineering Requests',
            subtitle: '$customServices active projects',
            onTap: () => context.go('/services'),
          ),
          _ProfileOption(
            icon: Icons.bookmark_border_outlined,
            title: 'Saved Blueprints & Guides',
            onTap: () => context.push('/tutorials'),
          ),
          _ProfileOption(
            icon: Icons.admin_panel_settings_outlined,
            title: 'Admin Operations Hub',
            onTap: () => context.push('/admin'),
          ),
          _ProfileOption(
            icon: Icons.logout_outlined,
            title: 'Sign Out',
            isDestructive: true,
            onTap: () => context.go('/auth'),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;
  final Color color;

  const _StatItem({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileOption({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? AppColors.error : AppColors.textPrimary),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDestructive ? AppColors.error : AppColors.textPrimary,
          ),
        ),
        subtitle: subtitle != null
            ? Text(subtitle!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))
            : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: onTap,
      ),
    );
  }
}
