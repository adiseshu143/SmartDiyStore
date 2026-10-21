import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/admin_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/catalog/presentation/catalog_screen.dart';
import '../../features/catalog/presentation/product_detail_screen.dart';
import '../../domain/entities/product_entity.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/orders/presentation/order_tracking_screen.dart';
import '../../features/orders/presentation/orders_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/services/presentation/services_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/tutorials/presentation/tutorials_screen.dart';

import 'main_navigation_shell.dart';

/// Provider for the application's GoRouter instance.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth',
        redirect: (context, state) => '/login',
      ),

      // Persistent Shell Navigation for primary tabs: Home, Catalog, Services, Orders, Profile
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigationShell(
            currentPath: state.uri.path,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            redirect: (context, state) => '/home',
          ),
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/catalog',
            name: 'catalog',
            builder: (context, state) {
              final autoFocus = state.uri.queryParameters['focus'] == 'true' || state.extra == true;
              return CatalogScreen(autoFocusSearch: autoFocus);
            },
          ),
          GoRoute(
            path: '/services',
            name: 'services',
            builder: (context, state) => const ServicesScreen(),
          ),
          GoRoute(
            path: '/orders',
            name: 'orders',
            builder: (context, state) => const OrdersScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      GoRoute(
        path: '/product-detail',
        name: 'product_detail',
        builder: (context, state) {
          final id = state.uri.queryParameters['id'];
          final product = state.extra as ProductEntity?;
          return ProductDetailScreen(productId: id, product: product);
        },
      ),
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/orders/tracking',
        name: 'order_tracking',
        builder: (context, state) {
          final id = state.uri.queryParameters['id'];
          return OrderTrackingScreen(orderId: id);
        },
      ),
      GoRoute(
        path: '/tutorials',
        name: 'tutorials',
        builder: (context, state) => const TutorialsScreen(),
      ),
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) => const AdminScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Text('No route defined for ${state.uri.toString()}'),
      ),
    ),
  );
});
