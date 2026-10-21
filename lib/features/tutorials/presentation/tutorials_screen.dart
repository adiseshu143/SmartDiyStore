import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class TutorialsScreen extends StatelessWidget {
  const TutorialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutorials & Blueprints')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _TutorialCard(
            title: 'Building a Floating Walnut Wall Shelf',
            difficulty: 'Intermediate',
            duration: '2.5 hrs',
            toolsCount: '5 tools needed',
          ),
          SizedBox(height: 12),
          _TutorialCard(
            title: 'Complete Plumbing Retrofit for Garden Drip Systems',
            difficulty: 'Beginner',
            duration: '1 hr',
            toolsCount: '3 tools needed',
          ),
          SizedBox(height: 12),
          _TutorialCard(
            title: 'Drywall Repair & Flawless Joint Compound Blending',
            difficulty: 'Advanced',
            duration: '4 hrs',
            toolsCount: '6 tools needed',
          ),
        ],
      ),
    );
  }
}

class _TutorialCard extends StatelessWidget {
  final String title;
  final String difficulty;
  final String duration;
  final String toolsCount;

  const _TutorialCard({
    required this.title,
    required this.difficulty,
    required this.duration,
    required this.toolsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _Badge(label: difficulty),
                const SizedBox(width: 8),
                _Badge(label: duration),
                const SizedBox(width: 8),
                _Badge(label: toolsCount),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;

  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500),
      ),
    );
  }
}
