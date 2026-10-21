import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/product_entity.dart';

/// Categories available across SDS Home and Catalog
final catalogCategories = [
  'All',
  'Components',
  'Kits',
  'Gadgets',
  'Custom Services',
];

/// Currently selected category filter
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

/// Active search query in catalog
final searchQueryProvider = StateProvider<String>((ref) => '');

/// All engineering & DIY hardware inventory with prices in Indian Rupees (INR)
final allProductsProvider = Provider<List<ProductEntity>>((ref) {
  return const [
    ProductEntity(
      id: 'prod-esp32-s3',
      name: 'ESP32-S3 DevKit 8MB PSRAM',
      description: 'Dual-core Xtensa 32-bit LX7 microprocessor, 2.4 GHz Wi-Fi & Bluetooth 5 (LE) for AIoT Edge computing.',
      price: 499.0,
      category: 'Components',
      stock: 48,
      imageUrls: [
        'assets/images/app_logo.png',
        'assets/images/app_logo.png',
        'assets/images/app_logo.png',
      ],
    ),
    ProductEntity(
      id: 'prod-arduino-r4',
      name: 'Arduino Uno R4 WiFi Board',
      description: 'Powered by RA4M1 32-bit Cortex-M4 with ESP32-S3 module, built-in 12x8 LED matrix, and CAN bus.',
      price: 1890.0,
      category: 'Components',
      stock: 22,
      imageUrls: [
        'assets/images/app_logo.png',
        'assets/images/app_logo.png',
      ],
    ),
    ProductEntity(
      id: 'prod-pico-w',
      name: 'Raspberry Pi Pico 2 W',
      description: 'Dual ARM Cortex-M33 with Hazard3 RISC-V cores, 2.4GHz 802.11n Wi-Fi, and 520KB SRAM.',
      price: 590.0,
      category: 'Components',
      stock: 85,
      imageUrls: [
        'assets/images/app_logo.png',
        'assets/images/app_logo.png',
      ],
    ),
    ProductEntity(
      id: 'prod-robotics-kit',
      name: 'Smart 4WD Omni Robot Car Kit',
      description: 'Mecanum wheels, ultrasonic obstacle avoidance, line tracking, Bluetooth telemetry, and modular aluminum chassis.',
      price: 4999.0,
      category: 'Kits',
      stock: 14,
      imageUrls: [
        'assets/images/app_logo.png',
        'assets/images/app_logo.png',
      ],
    ),
    ProductEntity(
      id: 'prod-weather-station-kit',
      name: 'Solar LoRa Weather Station Kit',
      description: 'Anemometer, rain gauge, BME280 sensor, ultra-low power solar PMIC, and long-range LoRaWAN transmitter.',
      price: 6499.0,
      category: 'Kits',
      stock: 9,
      imageUrls: [
        'assets/images/app_logo.png',
        'assets/images/app_logo.png',
      ],
    ),
    ProductEntity(
      id: 'prod-oled-display',
      name: '0.96" I2C Monochrome OLED Display',
      description: '128x64 pixels high-contrast blue/yellow display with SSD1306 driver, compatible with 3.3V and 5V logic.',
      price: 249.0,
      category: 'Gadgets',
      stock: 130,
      imageUrls: [
        'assets/images/app_logo.png',
      ],
    ),
    ProductEntity(
      id: 'prod-logic-analyzer',
      name: '8-Channel 24MHz USB Logic Analyzer',
      description: 'Digital signal protocol decoder for I2C, SPI, UART, CAN, and PWM with open-source Sigrok PulseView support.',
      price: 1190.0,
      category: 'Gadgets',
      stock: 31,
      imageUrls: [
        'assets/images/app_logo.png',
      ],
    ),
    ProductEntity(
      id: 'prod-precision-cut',
      name: 'Precision Laser Acrylic & PCB Milling',
      description: 'Custom CNC routing and laser cutting based on your CAD DXF/Gerber files. Includes deburring and edge flame polish.',
      price: 999.0,
      category: 'Custom Services',
      stock: 999,
      imageUrls: [
        'assets/images/app_logo.png',
      ],
    ),
    ProductEntity(
      id: 'prod-soldering-station',
      name: 'Smart Soldering Iron Station T12',
      description: 'PID digital temperature control from 100°C to 450°C in 6 seconds, auto-sleep, and quick-swap ceramic tips.',
      price: 2850.0,
      category: 'Gadgets',
      stock: 18,
      imageUrls: [
        'assets/images/app_logo.png',
      ],
    ),
  ];
});

/// Filtered products according to active category and search text
final filteredProductsProvider = Provider<List<ProductEntity>>((ref) {
  final products = ref.watch(allProductsProvider);
  final category = ref.watch(selectedCategoryProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();

  return products.where((product) {
    final matchesCategory = category == 'All' || product.category.toLowerCase() == category.toLowerCase();
    final matchesQuery = query.isEmpty ||
        product.name.toLowerCase().contains(query) ||
        product.description.toLowerCase().contains(query);
    return matchesCategory && matchesQuery;
  }).toList();
});

/// Cart state: Map of ProductId -> Quantity
class CartNotifier extends StateNotifier<Map<String, int>> {
  CartNotifier() : super({});

  void addItem(String productId, [int quantity = 1]) {
    state = {
      ...state,
      productId: (state[productId] ?? 0) + quantity,
    };
  }

  void decrementItem(String productId) {
    if (!state.containsKey(productId)) return;
    final current = state[productId]!;
    if (current <= 1) {
      deleteItem(productId);
    } else {
      state = {
        ...state,
        productId: current - 1,
      };
    }
  }

  void deleteItem(String productId) {
    final newState = Map<String, int>.from(state)..remove(productId);
    state = newState;
  }

  void clearCart() {
    state = {};
  }
}

/// Global Cart Provider
final cartProvider = StateNotifierProvider<CartNotifier, Map<String, int>>((ref) {
  return CartNotifier();
});

/// Total number of items in the cart for top bar badge count
final cartCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.values.fold(0, (sum, count) => sum + count);
});

/// Subtotal of all items in cart
final cartSubtotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  final allProducts = ref.watch(allProductsProvider);

  double subtotal = 0.0;
  cart.forEach((productId, qty) {
    final product = allProducts.firstWhere(
      (p) => p.id == productId,
      orElse: () => allProducts.first,
    );
    subtotal += product.price * qty;
  });
  return subtotal;
});

/// Delivery fee: Free for orders >= ₹999, else ₹50 (or ₹0 if cart is empty)
final cartDeliveryFeeProvider = Provider<double>((ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  if (subtotal == 0) return 0.0;
  return subtotal >= 999 ? 0.0 : 50.0;
});

/// Final Total Amount payable
final cartTotalProvider = Provider<double>((ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  final deliveryFee = ref.watch(cartDeliveryFeeProvider);
  return subtotal + deliveryFee;
});
