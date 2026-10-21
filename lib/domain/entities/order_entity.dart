enum OrderStatus {
  orderPlaced,
  underAdminReview,
  expectedDeliveryDateUpdated,
  shipped,
  outForDelivery,
  delivered,
}

enum OrderType {
  hardware,
  customService,
}

class TrackingStep {
  final OrderStatus status;
  final String title;
  final String description;
  final String location;
  final String timestamp;
  final bool isCompleted;
  final bool isCurrent;

  const TrackingStep({
    required this.status,
    required this.title,
    required this.description,
    required this.location,
    required this.timestamp,
    this.isCompleted = false,
    this.isCurrent = false,
  });

  TrackingStep copyWith({
    bool? isCompleted,
    bool? isCurrent,
    String? timestamp,
  }) {
    return TrackingStep(
      status: status,
      title: title,
      description: description,
      location: location,
      timestamp: timestamp ?? this.timestamp,
      isCompleted: isCompleted ?? this.isCompleted,
      isCurrent: isCurrent ?? this.isCurrent,
    );
  }
}

class OrderItemEntity {
  final String productId;
  final String title;
  final int quantity;
  final double unitPrice;
  final String imageUrl;

  const OrderItemEntity({
    required this.productId,
    required this.title,
    required this.quantity,
    required this.unitPrice,
    this.imageUrl = 'assets/images/app_logo.png',
  });
}

class OrderEntity {
  final String id;
  final OrderType type;
  final String title;
  final double totalAmount;
  final OrderStatus status;
  final String createdAt;
  final String estimatedDelivery;
  final String trackingNumber;
  final String courierPartner;
  final String deliveryAddress;
  final String? contactPhone;
  final String? adminReviewNotes;
  final List<OrderItemEntity> items;
  final List<TrackingStep> timelineSteps;

  const OrderEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.estimatedDelivery,
    required this.trackingNumber,
    this.courierPartner = 'Bluedart Express',
    this.deliveryAddress = 'Flat 402, Green Glen Layout, Bellandur, Bengaluru, KA 560103',
    this.contactPhone = '9876543210',
    this.adminReviewNotes,
    required this.items,
    required this.timelineSteps,
  });

  String get safeContactPhone {
    final phone = contactPhone;
    if (phone == null || phone.isEmpty) return '9876543210';
    final cleaned = phone.replaceAll(RegExp(r'\D'), '').trim();
    return cleaned.isNotEmpty ? cleaned : '9876543210';
  }

  OrderEntity copyWith({
    OrderStatus? status,
    String? estimatedDelivery,
    String? deliveryAddress,
    String? contactPhone,
    String? adminReviewNotes,
    List<TrackingStep>? timelineSteps,
  }) {
    return OrderEntity(
      id: id,
      type: type,
      title: title,
      totalAmount: totalAmount,
      status: status ?? this.status,
      createdAt: createdAt,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      trackingNumber: trackingNumber,
      courierPartner: courierPartner,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      contactPhone: contactPhone ?? this.contactPhone ?? '9876543210',
      adminReviewNotes: adminReviewNotes ?? this.adminReviewNotes,
      items: items,
      timelineSteps: timelineSteps ?? this.timelineSteps,
    );
  }
}
