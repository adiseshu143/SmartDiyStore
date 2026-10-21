import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Shows a custom floating SnackBar using SDS brand aesthetics:
/// - Background: Deep Navy (#0F172A)
/// - Left Border Accent: Solid Electric Cyan (#00A6FF)
/// - Icon: Checkmark in Electric Cyan (#00A6FF)
/// - Typography: Crisp white text
/// - Action Button: Flat "VIEW CART" button highlighted in Warm Gold (#FF9900)
void showBrandedCartSnackBar({
  required BuildContext context,
  required String message,
  required VoidCallback onViewCart,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 88), // Floats above persistent floating navbar
      padding: EdgeInsets.zero,
      duration: const Duration(seconds: 3),
      content: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.darkSurface, // Deep Navy (#0F172A)
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Solid Electric Cyan (#00A6FF) left border accent
                Container(
                  width: 4.5,
                  color: AppColors.primary,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        // Checkmark in Electric Cyan (#00A6FF)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),

                        // Clear crisp white typography
                        Expanded(
                          child: Text(
                            message,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Flat "VIEW CART" action button highlighted in Warm Gold (#FF9900)
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            onViewCart();
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4)),
                            ),
                            child: const Text(
                              'VIEW CART',
                              style: TextStyle(
                                color: AppColors.secondary, // Warm Gold (#FF9900)
                                fontSize: 11.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
