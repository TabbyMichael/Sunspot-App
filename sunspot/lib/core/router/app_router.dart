import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/secure_storage_service.dart';
import '../models/user.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/bloc/auth_state.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/customer_dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/staff_dashboard_screen.dart';
import '../../features/leads/presentation/screens/leads_list_screen.dart';
import '../../features/leads/presentation/screens/lead_detail_screen.dart';
import '../../features/installations/presentation/screens/installations_list_screen.dart';
import '../../features/installations/presentation/screens/installation_timeline_screen.dart';
import '../../features/quotes/presentation/screens/quotes_list_screen.dart';
import '../../features/orders/presentation/screens/orders_list_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/products/presentation/screens/products_catalog_screen.dart';
import '../../features/products/presentation/screens/cart_screen.dart';

class AppRouter {
  final SecureStorageService _storageService = SecureStorageService();

  GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final isAuthenticated = authState is AuthAuthenticated;

        final isLoginRoute = state.matchedLocation == '/login';
        final isDashboardRoute = state.matchedLocation == '/dashboard';

        if (!isAuthenticated && !isLoginRoute) {
          return '/login';
        }

        if (isAuthenticated && isLoginRoute) {
          return '/dashboard';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) {
            return BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                if (authState is AuthAuthenticated) {
                  if (authState.user.role == 'staff') {
                    return const StaffDashboardScreen();
                  } else {
                    return const CustomerDashboardScreen();
                  }
                }
                return const SizedBox.shrink();
              },
            );
          },
          routes: [
            GoRoute(
              path: 'leads',
              name: 'leads',
              builder: (context, state) => const LeadsListScreen(),
              routes: [
                GoRoute(
                  path: ':leadId',
                  name: 'leadDetails',
                  builder: (context, state) {
                    final leadId = state.pathParameters['leadId']!;
                    return LeadDetailScreen(leadId: leadId);
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'installations',
              name: 'installations',
              builder: (context, state) => const InstallationsListScreen(),
              routes: [
                GoRoute(
                  path: ':installationId',
                  name: 'installationDetails',
                  builder: (context, state) {
                    final installationId =
                        state.pathParameters['installationId']!;
                    return InstallationTimelineScreen(
                      installationId: installationId,
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'quotes',
              name: 'quotes',
              builder: (context, state) => const QuotesListScreen(),
            ),
            GoRoute(
              path: 'orders',
              name: 'orders',
              builder: (context, state) => const OrdersListScreen(),
            ),
            GoRoute(
              path: 'notifications',
              name: 'notifications',
              builder: (context, state) => const NotificationsScreen(),
            ),
            GoRoute(
              path: 'settings',
              name: 'settings',
              builder: (context, state) => const SettingsScreen(),
            ),
            GoRoute(
              path: 'shop',
              name: 'shop',
              builder: (context, state) => const ProductsCatalogScreen(),
            ),
            GoRoute(
              path: 'cart',
              name: 'cart',
              builder: (context, state) => const CartScreen(),
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page not found: ${state.uri}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/dashboard'),
                child: const Text('Go to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyOnChange(stream);
  }

  void notifyOnChange(Stream<dynamic> stream) {
    stream.listen((dynamic _) => notifyListeners());
  }
}
