import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_diy_store/main.dart';

void main() {
  testWidgets('SmartDiyStoreApp loads Splash screen and navigates to Login, Home and Catalog', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SmartDiyStoreApp(),
      ),
    );
    // Pump frames through animation controller
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump(const Duration(milliseconds: 1000));

    // Verify Splash Screen
    expect(find.text('SmartDiyStore'), findsOneWidget);
    expect(find.textContaining('BUILD'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    // Tap "Get Started" to navigate to /login
    await tester.tap(find.text('Get Started'), warnIfMissed: false);
    await tester.pumpAndSettle();

    // Verify Login Screen
    expect(find.text('Welcome to SDS'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);

    // Enter email & password
    await tester.enterText(find.byType(TextFormField).first, 'builder@smartdiystore.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');

    // Tap "Sign In"
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    // Verify Home Screen with branding & Featured items
    expect(find.text('SmartDiyStore'), findsWidgets);
    expect(find.text('Next-Gen IoT & Robotics Kits'), findsOneWidget);
    expect(find.text('Featured Engineering Items'), findsOneWidget);

    // Top AppBar contains Search Icon, Notification Bell, and Shopping Cart with badge
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_outlined), findsOneWidget);
    expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);

    // Long search bar input is removed from Home body
    expect(find.text('Search microcontrollers, sensors, motors...'), findsNothing);

    // 5-item floating navigation bar: Home, Catalog, Services, Orders, Profile
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Catalog'), findsOneWidget);
    expect(find.text('Services'), findsWidgets);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Tap Top Search Icon to navigate to Catalog screen (/catalog) with auto-focus
    await tester.tap(find.byIcon(Icons.search_rounded));
    await tester.pumpAndSettle();

    // Verify Catalog Screen has persistent navigation bar
    expect(find.text('DIY Hardware & Kits'), findsOneWidget);
    expect(find.text('Components'), findsWidgets);
    expect(find.text('Catalog'), findsOneWidget); // Navbar is present on Catalog!

    // Tap on the ESP32 product card to open Product Detail Screen (/product-detail)
    await tester.tap(find.text('ESP32-S3 DevKit 8MB PSRAM'));
    await tester.pumpAndSettle();

    // Verify Product Detail Screen elements
    expect(find.text('In Stock'), findsOneWidget);
    expect(find.text('SKU: PROD-ESP32-S3'), findsOneWidget);
    expect(find.text('Key Specifications'), findsOneWidget);
    expect(find.text('32-Bit Dual-Core Xtensa LX7'), findsOneWidget);
    expect(find.text('₹499'), findsWidgets); // Price tag and total bar

    // Scroll to and test Quantity Selector: Increment to 2
    await tester.ensureVisible(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('2'), findsWidgets); // Qty counter + subtotal badge/bar
    expect(find.text('₹998'), findsWidgets); // Updated sticky bottom bar total

    // Tap "Add to Cart" sticky button
    await tester.tap(find.text('Add to Cart'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Branded Cart SnackBar with Electric Cyan checkmark and Warm Gold "VIEW CART"
    expect(find.text('VIEW CART'), findsOneWidget);
    expect(find.textContaining('Added 2 x ESP32-S3'), findsOneWidget);
    expect(find.descendant(of: find.byType(SnackBar), matching: find.byIcon(Icons.check_circle_rounded)), findsOneWidget);

    // Tap "VIEW CART" action on the branded SnackBar to navigate to /cart
    await tester.tap(find.text('VIEW CART'));
    await tester.pumpAndSettle();

    // Verify Shopping Cart & Checkout Screen (/cart)
    expect(find.text('Shopping Cart & Checkout'), findsOneWidget);
    expect(find.text('Items in Cart (2)'), findsOneWidget);
    expect(find.text('Delivery Destination'), findsOneWidget);
    expect(find.text('Edit'), findsWidgets);
    expect(find.text('+91 9876543210'), findsOneWidget);
    expect(find.text('Order Summary'), findsOneWidget);

    // Verify Order Summary Breakdown in Indian Rupees (₹)
    expect(find.text('₹998'), findsWidgets); // Items Total
    expect(find.text('₹50'), findsOneWidget); // Delivery fee (subtotal < ₹999)
    expect(find.text('₹1,048'), findsWidgets); // Total payable (998 + 50)
    expect(find.text('Proceed to Checkout'), findsWidgets);

    // Tap "Proceed to Checkout" button -> triggers Success Popup Dialog
    await tester.tap(find.text('Proceed to Checkout').first);
    await tester.pumpAndSettle();

    // Verify Order Success Popup Dialog elements
    expect(find.text('Order Placed Successfully!'), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget); // Prominent green checkmark in solid circle
    expect(find.text('₹1,048'), findsWidgets); // Paid amount in INR
    expect(find.text('View Live Tracking'), findsOneWidget);

    // Tap "View Live Tracking" in popup -> navigates to /orders/tracking
    await tester.tap(find.text('View Live Tracking'));
    await tester.pumpAndSettle();

    // Verify Delivery Tracking Screen (/orders/tracking)
    expect(find.text('Delivery Tracking'), findsOneWidget);
    expect(find.text('Live Shipment Progress'), findsOneWidget);
    expect(find.text('Estimated Delivery Window'), findsOneWidget);
    expect(find.text('Order Placed'), findsOneWidget);
    expect(find.text('Under Admin Review'), findsWidgets);
    expect(find.text('Expected Delivery Date Updated'), findsOneWidget);
    expect(find.text('Shipped / Dispatched'), findsOneWidget);
    expect(find.text('Out for Delivery'), findsOneWidget);
    expect(find.text('Delivered'), findsOneWidget);

    // Verify top-to-bottom completed/active indicator icons
    expect(find.byIcon(Icons.check), findsWidgets); // Solid green circle with white checkmark
    expect(find.text('Order Package Summary'), findsOneWidget);

    // Verify Delivery Destination card on Live Tracking and test Edit Bottom Sheet
    expect(find.text('Delivery Destination'), findsOneWidget);
    expect(find.text('Edit'), findsWidgets);
    expect(find.text('+91 9876543210'), findsWidgets);

    // Open Edit Delivery Bottom Sheet on Live Tracking
    await tester.ensureVisible(find.text('Edit').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit').last);
    await tester.pumpAndSettle();

    // Verify bottom sheet title and form fields
    expect(find.text('Edit Delivery Address & Contact'), findsOneWidget);
    expect(find.text('Save & Update Address'), findsOneWidget);

    // Update phone number to 9123456789
    final phoneField = find.widgetWithText(TextFormField, '9876543210');
    await tester.enterText(phoneField, '9123456789');
    await tester.pumpAndSettle();

    // Tap Save
    await tester.tap(find.text('Save & Update Address'));
    await tester.pumpAndSettle();

    // Verify updated phone on tracking card
    expect(find.text('+91 9123456789'), findsWidgets);

    // Navigate back to Orders History screen (/orders)
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    // Verify Orders History List (/orders)
    expect(find.text('My DIY Orders & Requests'), findsOneWidget);
    expect(find.text('HARDWARE'), findsWidgets);
    expect(find.text('CUSTOM SERVICE'), findsWidgets);
    expect(find.text('SDS-98231'), findsOneWidget);
    expect(find.text('₹2,147'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget); // Navbar is present on Orders!

    // Clear any lingering SnackBars so they do not block navbar hit testing
    final messenger = ScaffoldMessenger.of(tester.element(find.byType(Scaffold).first));
    messenger.clearSnackBars();
    await tester.pumpAndSettle();

    // Tap "Services" tab on the persistent navbar to check Custom Engineering Services
    await tester.tap(find.text('Services').last);
    await tester.pumpAndSettle();

    // Verify Custom Engineering Services Screen
    expect(find.text('Custom Engineering Services'), findsOneWidget);
    expect(find.text('On-Demand Precision Laser & CNC Cutting'), findsOneWidget);
    expect(find.text('₹1,450'), findsWidgets);

    // Tap "Home" tab on the persistent navbar to return to Home Hub
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Next-Gen IoT & Robotics Kits'), findsOneWidget);

    // Test scroll hide behavior on Home:
    // Scroll down by dragging upwards
    await tester.drag(find.text('Next-Gen IoT & Robotics Kits'), const Offset(0, -300));
    await tester.pumpAndSettle();

    // Verify AnimatedSlide has offset to bottom (offset.dy > 0)
    final slideFinder = find.byType(AnimatedSlide);
    expect(slideFinder, findsOneWidget);
    final animatedSlide = tester.widget<AnimatedSlide>(slideFinder);
    expect(animatedSlide.offset.dy, greaterThan(0));

    // Scroll up by dragging downwards immediately shows navbar
    await tester.drag(find.text('Featured Engineering Items'), const Offset(0, 300));
    await tester.pumpAndSettle();
    final restoredSlide = tester.widget<AnimatedSlide>(slideFinder);
    expect(restoredSlide.offset, Offset.zero);
  });
}
