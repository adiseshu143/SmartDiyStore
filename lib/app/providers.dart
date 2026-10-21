import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'theme/app_theme.dart';

export 'router/app_router.dart';
export 'theme/app_theme.dart';
export 'theme/app_colors.dart';

/// Provider for current theme mode
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

/// Global App Theme Provider
final appThemeProvider = Provider<ThemeData>((ref) {
  return AppTheme.lightTheme;
});

/// Global App Initialization state provider
final appInitializedProvider = StateProvider<bool>((ref) => true);

/// Global Auth State provider stub
final authStateChangesProvider = StreamProvider<String?>((ref) async* {
  // Emits current user ID or null
  yield null;
});
