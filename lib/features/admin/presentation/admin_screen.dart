import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store Administration')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _AdminStatRow(),
          SizedBox(height: 20),
          Text(
            'Operations',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          SizedBox(height: 12),
          _AdminActionCard(
            title: 'Manage Inventory & SKUs',
            subtitle: 'Add new tools, update pricing, synchronize stock counts.',
            icon: Icons.inventory_2_outlined,
          ),
          SizedBox(height: 12),
          _AdminActionCard(
            title: 'Customer Orders Fulfillment',
            subtitle: 'Dispatch orders, issue invoices and process returns.',
            icon: Icons.local_shipping_outlined,
          ),
          SizedBox(height: 12),
          _AdminActionCard(
            title: 'Tutorial & Blueprint CMS',
            subtitle: 'Publish video guides, tool checklists and PDF attachments.',
            icon: Icons.post_add_outlined,
          ),
        ],
      ),
    );
  }
}

class _AdminStatRow extends StatelessWidget {
  const _AdminStatRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(title: 'Revenue Today', value: '₹3,98,400'),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(title: 'Pending Orders', value: '14'),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _AdminActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, color: AppColors.accent, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textTertiary),
        onTap: () {},
      ),
    );
  }
}
