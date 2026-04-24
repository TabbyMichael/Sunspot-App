import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sunspot/shared/widgets/badges/status_badge.dart';
import 'package:sunspot/shared/widgets/cards/app_card.dart';
import 'package:sunspot/shared/widgets/layout/screen_wrapper.dart';
import 'package:sunspot/shared/widgets/loading/circular_spinner.dart';
import 'package:sunspot/features/quotes/bloc/quotes_bloc.dart';
import 'package:sunspot/features/quotes/bloc/quotes_event.dart';
import 'package:sunspot/features/quotes/bloc/quotes_state.dart';
import 'package:sunspot/features/auth/bloc/auth_bloc.dart';
import 'package:sunspot/features/auth/bloc/auth_state.dart';

class QuotesListScreen extends StatefulWidget {
  const QuotesListScreen({super.key});

  @override
  State<QuotesListScreen> createState() => _QuotesListScreenState();
}

class _QuotesListScreenState extends State<QuotesListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<QuotesBloc>().add(FetchQuotes());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final userName = authState is AuthAuthenticated
            ? authState.user.name
            : 'Staff';
        final userRole = authState is AuthAuthenticated
            ? authState.user.role
            : 'staff';

        return ScreenWrapper(
          title: userRole == 'staff' ? 'Quotes' : 'My Quotes',
          showDrawer: true,
          userRole: userRole,
          userName: userName,
          child: BlocBuilder<QuotesBloc, QuotesState>(
            builder: (context, state) {
              if (state is QuotesLoading) {
                return const Center(child: CircularSpinner());
              }

              if (state is QuotesError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<QuotesBloc>().add(FetchQuotes());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is QuotesLoaded) {
                if (state.quotes.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 48,
                          color: Color(0xFF9CA3AF),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No quotes found',
                          style: TextStyle(color: Color(0xFF9CA3AF)),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: state.quotes.length,
                  itemBuilder: (context, index) {
                    final quote = state.quotes[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          context.go('/dashboard/quotes/${quote.id}');
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    quote.customerName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  StatusBadge(status: quote.status),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                quote.address,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${quote.currency} ${quote.amount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFF59E0B),
                                    ),
                                  ),
                                  if (quote.expiresAt != null)
                                    Text(
                                      'Expires: ${_formatDate(quote.expiresAt!)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
