import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/utils/currency_formatter.dart';
import '../../../domain/entities/order_entity.dart';
import '../../orders/presentation/widgets/order_status_dialog.dart';
import '../../orders/providers/delivery_info_provider.dart';
import '../../orders/providers/orders_providers.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const services = [
      _EngineeringServiceItem(
        id: 'srv-cnc-laser',
        title: 'On-Demand Precision Laser & CNC Cutting',
        description: 'Sub-millimeter kerf tolerance for Acrylic, FR4, Balsa wood, and 6061 Aluminum sheets.',
        startingPrice: 1450.0,
        unit: 'per job / sheet',
        icon: Icons.precision_manufacturing_outlined,
        turnaround: '24-48 Hours',
        badge: 'POPULAR FABRICATION',
      ),
      _EngineeringServiceItem(
        id: 'srv-pcb-stencil',
        title: 'PCB Stencil & SMT Telemetry Validation',
        description: 'Gerber file verification, solder paste stencil laser-cutting, and automated optical check.',
        startingPrice: 2890.0,
        unit: 'per batch (up to 5 boards)',
        icon: Icons.developer_board_outlined,
        turnaround: '3-4 Business Days',
        badge: 'ENGINEERING LAB',
      ),
      _EngineeringServiceItem(
        id: 'srv-consultation',
        title: '1-on-1 Embedded Systems & IoT Consultation',
        description: 'Live video inspection with Senior Hardware Architects to review power budgets, schematics, and pinouts.',
        startingPrice: 999.0,
        unit: 'per 60-min session',
        icon: Icons.support_agent_rounded,
        turnaround: 'Same-Day Scheduling',
        badge: 'EXPERT REVIEW',
      ),
      _EngineeringServiceItem(
        id: 'srv-calibration',
        title: 'Lab Tool Rental & Sensor Calibration',
        description: 'Calibrated Siglent 100MHz digital storage oscilloscopes, logic analyzers, and thermal cameras.',
        startingPrice: 650.0,
        unit: 'per day rental',
        icon: Icons.handyman_outlined,
        turnaround: 'Immediate Dispatch',
        badge: 'EQUIPMENT HUB',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 16,
        title: const Text('Custom Engineering Services'),
        actions: [
          TextButton.icon(
            onPressed: () => context.go('/orders'),
            icon: const Icon(Icons.receipt_long_outlined, size: 18, color: AppColors.primary),
            label: const Text(
              'My Requests',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          // Banner Highlight
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 1.2),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.architecture_rounded, color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SDS Engineering Desk',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Upload schematics or book specialized fab tools directly with our Bengaluru hardware makerspace.',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12.5,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          const Text(
            'Available Fabrication & Consultation',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 12),

          ...services.map((service) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: _ServiceCard(
                service: service,
                onRequest: () => _openBookingSheet(context, ref, service),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _openBookingSheet(
    BuildContext context,
    WidgetRef ref,
    _EngineeringServiceItem service,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _BookingBottomSheet(
          service: service,
          onSubmit: (notes, simulateError) {
            Navigator.of(sheetContext).pop();

            if (simulateError) {
              showOrderErrorDialog(
                context: context,
                title: 'CAD Blueprint Validation Failed',
                description: 'The uploaded vector specifications contain intersecting geometry paths. Please verify vector CAD layers and retry.',
                onRetry: () => _openBookingSheet(context, ref, service),
              );
              return;
            }

            final orderId = 'ENG-${20000 + DateTime.now().millisecondsSinceEpoch % 80000}';
            final deliveryInfo = ref.read(deliveryInfoProvider);
            final newServiceOrder = OrderEntity(
              id: orderId,
              type: OrderType.customService,
              title: service.title,
              totalAmount: service.startingPrice,
              status: OrderStatus.underAdminReview,
              createdAt: 'Oct 17, 2026',
              estimatedDelivery: '3-4 Business Days (Pending Admin Confirmation)',
              trackingNumber: 'SDS-ENG-${orderId.replaceAll("ENG-", "")}',
              courierPartner: 'SDS Internal Fleet / Courier',
              deliveryAddress: deliveryInfo.fullAddress,
              contactPhone: deliveryInfo.phone,
              adminReviewNotes: notes.isNotEmpty
                  ? 'Client requirement: $notes. Under tolerance verification.'
                  : 'Design files queued for Senior Hardware Architect review.',
              items: [
                OrderItemEntity(
                  productId: service.id,
                  title: service.title,
                  quantity: 1,
                  unitPrice: service.startingPrice,
                ),
              ],
              timelineSteps: generateTimelineSteps(OrderStatus.underAdminReview),
            );

            // Save to active orders history
            ref.read(ordersProvider.notifier).addOrder(newServiceOrder);

            // Display Success Popup Dialog
            showOrderSuccessDialog(
              context: context,
              order: newServiceOrder,
              onViewTracking: () {
                context.push('/orders/tracking?id=${newServiceOrder.id}');
              },
              onContinueShopping: () {
                context.go('/services');
              },
            );
          },
        );
      },
    );
  }
}

class _EngineeringServiceItem {
  final String id;
  final String title;
  final String description;
  final double startingPrice;
  final String unit;
  final IconData icon;
  final String turnaround;
  final String badge;

  const _EngineeringServiceItem({
    required this.id,
    required this.title,
    required this.description,
    required this.startingPrice,
    required this.unit,
    required this.icon,
    required this.turnaround,
    required this.badge,
  });
}

class _ServiceCard extends StatelessWidget {
  final _EngineeringServiceItem service;
  final VoidCallback onRequest;

  const _ServiceCard({
    required this.service,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    service.badge,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      service.turnaround,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Center(
                    child: Icon(service.icon, color: AppColors.primary, size: 24),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service.description,
                        style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Service Estimate', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    Text(
                      formatInr(service.startingPrice),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: onRequest,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Book Request', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingBottomSheet extends StatefulWidget {
  final _EngineeringServiceItem service;
  final void Function(String notes, bool simulateError) onSubmit;

  const _BookingBottomSheet({
    required this.service,
    required this.onSubmit,
  });

  @override
  State<_BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<_BookingBottomSheet> {
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Request ${widget.service.title}',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'Estimated Base Rate: ${formatInr(widget.service.startingPrice)} (${widget.service.unit})',
            style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Enter technical specifications, tolerances, or CAD link...',
              labelText: 'Project Notes & Dimensions',
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => widget.onSubmit(_notesController.text, true),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFEF4444),
                    side: const BorderSide(color: Color(0xFFEF4444)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Simulate Error', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => widget.onSubmit(_notesController.text, false),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Confirm Request', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
