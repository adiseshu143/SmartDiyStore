import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Note: Firebase.initializeApp() can be initialized once google-services.json
  // / GoogleService-Info.plist are linked via flutterfire configure.

  runApp(
    const ProviderScope(
      child: SmartDiyStoreApp(),
    ),
  );
}

class SmartDiyStoreApp extends ConsumerWidget {
  const SmartDiyStoreApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final theme = ref.watch(appThemeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Smart DIY Store (SDS)',
      debugShowCheckedModeBanner: false,
      theme: theme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
