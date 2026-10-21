import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/order_entity.dart';

List<TrackingStep> generateTimelineSteps(OrderStatus currentStatus, {String? customDeliveryDate}) {
  const stepsDef = [
    (
      OrderStatus.orderPlaced,
      'Order Placed',
      'Order created & transaction authorized via UPI / Card',
      'Online Gateway',
      'Sat, 17th Oct @09:30 AM',
    ),
    (
      OrderStatus.underAdminReview,
      'Under Admin Review',
      'Engineering desk inspecting CAD blueprints & component availability',
      'SDS Central Hub, Bengaluru',
      'Sat, 17th Oct @11:15 AM',
    ),
    (
      OrderStatus.expectedDeliveryDateUpdated,
      'Expected Delivery Date Updated',
      'Delivery window confirmed by logistic logistics dispatcher',
      'Bengaluru Tech Hub',
      'Sat, 17th Oct @01:45 PM',
    ),
    (
      OrderStatus.shipped,
      'Shipped / Dispatched',
      'Package departed from sorting warehouse via Express Cargo',
      'Departed From BLR Hub to VIJAYAWADA',
      'Sat, 17th Oct @05:20 PM',
    ),
    (
      OrderStatus.outForDelivery,
      'Out for Delivery',
      'Courier rider assigned for doorstep delivery with OTP verification',
      'Local Delivery Centre',
      'Pending',
    ),
    (
      OrderStatus.delivered,
      'Delivered',
      'Consignment delivered to customer doorstep successfully',
      'Recipient Location',
      'Pending',
    ),
  ];

  final currentIndex = OrderStatus.values.indexOf(currentStatus);

  return stepsDef.map((def) {
    final stepStatus = def.$1;
    final stepIndex = OrderStatus.values.indexOf(stepStatus);
    final isCompleted = stepIndex < currentIndex || (stepIndex == currentIndex && stepStatus == OrderStatus.delivered);
    final isCurrent = stepIndex == currentIndex && stepStatus != OrderStatus.delivered;

    String desc = def.$3;
    if (stepStatus == OrderStatus.expectedDeliveryDateUpdated && customDeliveryDate != null) {
      desc = 'Estimated delivery locked for: $customDeliveryDate';
    }

    return TrackingStep(
      status: stepStatus,
      title: def.$2,
      description: desc,
      location: def.$4,
      timestamp: def.$5,
      isCompleted: isCompleted,
      isCurrent: isCurrent,
    );
  }).toList();
}

class OrdersNotifier extends StateNotifier<List<OrderEntity>> {
  OrdersNotifier() : super(_initialOrders);

  static final List<OrderEntity> _initialOrders = [
    OrderEntity(
      id: 'SDS-98231',
      type: OrderType.hardware,
      title: 'ESP32-S3 DevKit + Arduino R4 + Sensor Array',
      totalAmount: 2147.0,
      status: OrderStatus.expectedDeliveryDateUpdated,
      createdAt: 'Oct 15, 2026',
      estimatedDelivery: 'Tue, 20 Oct 2026',
      trackingNumber: 'BLR-EXP-982310',
      courierPartner: 'Bluedart Express',
      deliveryAddress: 'Flat 402, Green Glen Layout, Bellandur, Bengaluru 560103',
      contactPhone: '9876543210',
      adminReviewNotes: 'BOM verified by Hardware Lead. ESD packaging approved for transit.',
      items: const [
        OrderItemEntity(
          productId: 'prod-esp32-s3',
          title: 'ESP32-S3 DevKit 8MB PSRAM',
          quantity: 2,
          unitPrice: 499.0,
        ),
        OrderItemEntity(
          productId: 'prod-arduino-r4',
          title: 'Arduino Uno R4 WiFi Board',
          quantity: 1,
          unitPrice: 1890.0,
        ),
      ],
      timelineSteps: generateTimelineSteps(
        OrderStatus.expectedDeliveryDateUpdated,
        customDeliveryDate: 'Tue, 20 Oct 2026',
      ),
    ),
    OrderEntity(
      id: 'ENG-40291',
      type: OrderType.customService,
      title: 'Precision CNC Aluminum & Acrylic Laser Cut',
      totalAmount: 1450.0,
      status: OrderStatus.underAdminReview,
      createdAt: 'Oct 17, 2026',
      estimatedDelivery: 'Thu, 22 Oct 2026 (Pending Admin Confirmation)',
      trackingNumber: 'SDS-ENG-40291',
      courierPartner: 'SDS Internal Fleet',
      deliveryAddress: 'Indiranagar 100ft Rd, HAL 2nd Stage, Bengaluru 560038',
      contactPhone: '9876543210',
      adminReviewNotes: 'CAD DXF drawing undergoing kerf tolerance verification.',
      items: const [
        OrderItemEntity(
          productId: 'srv-precision-cutting',
          title: 'Custom Laser Cut - 5mm Frosted Acrylic (420x297mm)',
          quantity: 1,
          unitPrice: 1450.0,
        ),
      ],
      timelineSteps: generateTimelineSteps(OrderStatus.underAdminReview),
    ),
    OrderEntity(
      id: 'SDS-98104',
      type: OrderType.hardware,
      title: 'Raspberry Pi Pico 2 W',
      totalAmount: 890.0,
      status: OrderStatus.delivered,
      createdAt: 'Oct 02, 2026',
      estimatedDelivery: 'Oct 05, 2026',
      trackingNumber: 'DEL-AIR-981045',
      courierPartner: 'Delhivery Express',
      deliveryAddress: 'Indiranagar 100ft Rd, HAL 2nd Stage, Bengaluru 560038',
      contactPhone: '9876543210',
      adminReviewNotes: 'Delivered and OTP verified by recipient.',
      items: const [
        OrderItemEntity(
          productId: 'prod-pico-w',
          title: 'Raspberry Pi Pico 2 W',
          quantity: 1,
          unitPrice: 590.0,
        ),
      ],
      timelineSteps: generateTimelineSteps(OrderStatus.delivered),
    ),
  ];

  void addOrder(OrderEntity order) {
    state = [order, ...state];
  }

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    state = state.map((order) {
      if (order.id == orderId) {
        final updatedSteps = generateTimelineSteps(
          newStatus,
          customDeliveryDate: order.estimatedDelivery,
        );
        return order.copyWith(
          status: newStatus,
          timelineSteps: updatedSteps,
        );
      }
      return order;
    }).toList();
  }

  void advanceOrderStep(String orderId) {
    final order = state.firstWhere((o) => o.id == orderId, orElse: () => state.first);
    final currentIndex = OrderStatus.values.indexOf(order.status);
    if (currentIndex < OrderStatus.values.length - 1) {
      final nextStatus = OrderStatus.values[currentIndex + 1];
      updateOrderStatus(orderId, nextStatus);
    }
  }

  void updateOrderDeliveryInfo({
    required String orderId,
    required String address,
    required String phone,
  }) {
    state = state.map((order) {
      if (order.id == orderId) {
        return order.copyWith(
          deliveryAddress: address,
          contactPhone: phone,
        );
      }
      return order;
    }).toList();
  }
}

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<OrderEntity>>((ref) {
  return OrdersNotifier();
});

final orderByIdProvider = Provider.family<OrderEntity?, String>((ref, id) {
  final orders = ref.watch(ordersProvider);
  return orders.firstWhere(
    (order) => order.id == id,
    orElse: () => orders.isNotEmpty ? orders.first : null as dynamic,
  );
});
