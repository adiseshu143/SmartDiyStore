import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveryInfo {
  final String street;
  final String city;
  final String state;
  final String pincode;
  final String phone;

  const DeliveryInfo({
    this.street = 'Flat 402, Green Glen Layout, Bellandur',
    this.city = 'Bengaluru',
    this.state = 'Karnataka',
    this.pincode = '560103',
    this.phone = '9876543210',
  });

  String get fullAddress => '$street, $city, $state - $pincode';
  String get formattedPhone => '+91 $phone';

  factory DeliveryInfo.fromAddressAndPhone({
    required String address,
    required String phone,
  }) {
    final cleanedPhone = phone.replaceAll(RegExp(r'\D'), '').trim();
    try {
      final parts = address.split(',').map((e) => e.trim()).toList();
      if (parts.length >= 3) {
        final street = parts.sublist(0, parts.length - 2).join(', ');
        final city = parts[parts.length - 2];
        final statePin = parts.last;
        String state = statePin;
        String pincode = '560103';
        if (statePin.contains('-')) {
          final sp = statePin.split('-');
          state = sp[0].trim();
          pincode = sp[1].trim();
        } else {
          final words = statePin.split(' ');
          if (words.isNotEmpty && RegExp(r'^\d{6}$').hasMatch(words.last)) {
            pincode = words.last;
            state = words.sublist(0, words.length - 1).join(' ').trim();
          }
        }
        return DeliveryInfo(
          street: street.isEmpty ? address : street,
          city: city.isEmpty ? 'Bengaluru' : city,
          state: state.isEmpty ? 'Karnataka' : state,
          pincode: pincode.isEmpty ? '560103' : pincode,
          phone: cleanedPhone.isEmpty ? '9876543210' : cleanedPhone,
        );
      }
    } catch (_) {}
    return DeliveryInfo(
      street: address,
      city: 'Bengaluru',
      state: 'Karnataka',
      pincode: '560103',
      phone: cleanedPhone.isEmpty ? '9876543210' : cleanedPhone,
    );
  }

  DeliveryInfo copyWith({
    String? street,
    String? city,
    String? state,
    String? pincode,
    String? phone,
  }) {
    return DeliveryInfo(
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      phone: phone ?? this.phone,
    );
  }
}

class DeliveryInfoNotifier extends StateNotifier<DeliveryInfo> {
  DeliveryInfoNotifier() : super(const DeliveryInfo());

  void setInfo(DeliveryInfo info) {
    state = info;
  }

  void update({
    required String street,
    required String city,
    required String state,
    required String pincode,
    required String phone,
  }) {
    this.state = DeliveryInfo(
      street: street.trim(),
      city: city.trim(),
      state: state.trim(),
      pincode: pincode.trim(),
      phone: phone.replaceAll(RegExp(r'\D'), '').trim(),
    );
  }
}

final deliveryInfoProvider = StateNotifierProvider<DeliveryInfoNotifier, DeliveryInfo>((ref) {
  return DeliveryInfoNotifier();
});
