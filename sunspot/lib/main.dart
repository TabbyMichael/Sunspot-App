import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_bloc.dart';
import 'core/services/api_service.dart';
import 'core/services/secure_storage_service.dart';
import 'core/services/onboarding_service.dart';
import 'core/services/haptics_service.dart';
import 'core/providers/haptics_provider.dart';
import 'core/router/app_router.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/leads/bloc/leads_bloc.dart';
import 'features/leads/data/leads_repository.dart';
import 'features/installations/bloc/installations_bloc.dart';
import 'features/installations/data/installations_repository.dart';
import 'features/quotes/bloc/quotes_bloc.dart';
import 'features/quotes/data/quotes_repository.dart';
import 'features/orders/bloc/orders_bloc.dart';
import 'features/orders/data/orders_repository.dart';
import 'features/products/bloc/products_bloc.dart';
import 'features/products/bloc/cart_bloc.dart';
import 'features/products/data/products_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final secureStorageService = SecureStorageService();
  final onboardingService = OnboardingService(secureStorageService);
  final onboardingCompleted = await onboardingService.isCompleted();
  final onboardingStatus = ValueNotifier<bool>(onboardingCompleted);

  final hapticsService = HapticsService();
  await hapticsService.initialize();

  runApp(
    SunspotApp(
      onboardingService: onboardingService,
      onboardingStatus: onboardingStatus,
      hapticsService: hapticsService,
    ),
  );
}

class SunspotApp extends StatelessWidget {
  final OnboardingService onboardingService;
  final ValueNotifier<bool> onboardingStatus;
  final HapticsService hapticsService;

  const SunspotApp({
    super.key,
    required this.onboardingService,
    required this.onboardingStatus,
    required this.hapticsService,
  });

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final secureStorageService = SecureStorageService();

    final authRepository = AuthRepository(apiService, secureStorageService);
    final authBloc = AuthBloc(authRepository);

    final leadsRepository = LeadsRepository(apiService);
    final leadsBloc = LeadsBloc(leadsRepository);

    final installationsRepository = InstallationsRepository(apiService);
    final installationsBloc = InstallationsBloc(installationsRepository);

    final quotesRepository = QuotesRepository(apiService);
    final quotesBloc = QuotesBloc(quotesRepository);

    final ordersRepository = OrdersRepository(apiService);
    final ordersBloc = OrdersBloc(ordersRepository);

    final productsRepository = ProductsRepository();
    final productsBloc = ProductsBloc(productsRepository);
    final cartBloc = CartBloc();

    return HapticsProvider(
      hapticsService: hapticsService,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authBloc),
          BlocProvider.value(value: leadsBloc),
          BlocProvider.value(value: installationsBloc),
          BlocProvider.value(value: quotesBloc),
          BlocProvider.value(value: ordersBloc),
          BlocProvider.value(value: productsBloc),
          BlocProvider.value(value: cartBloc),
          BlocProvider(create: (_) => ThemeBloc()),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp.router(
              title: 'Sunspot Solar',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeState.mode == AppThemeMode.dark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              routerConfig: AppRouter(
                onboardingService: onboardingService,
                onboardingStatus: onboardingStatus,
              ).createRouter(authBloc),
            );
          },
        ),
      ),
    );
  }
}
