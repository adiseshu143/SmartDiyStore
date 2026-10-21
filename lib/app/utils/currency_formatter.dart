import 'package:intl/intl.dart';

/// Formatter for Indian Rupees using standard 'en_IN' locale formatting.
String formatInr(num amount, {bool showDecimals = false}) {
  final format = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: showDecimals ? 2 : 0,
  );
  return format.format(amount);
}
