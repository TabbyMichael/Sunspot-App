import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sunspot/shared/widgets/badges/status_badge.dart';
import 'package:sunspot/shared/widgets/cards/app_card.dart';
import 'package:sunspot/shared/widgets/layout/screen_wrapper.dart';
import 'package:sunspot/shared/widgets/loading/circular_spinner.dart';
import 'package:sunspot/features/orders/bloc/orders_bloc.dart';
import 'package:sunspot/features/orders/bloc/orders_event.dart';
import 'package:sunspot/features/orders/bloc/orders_state.dart';
import 'package:sunspot/features/auth/bloc/auth_bloc.dart';
import 'package:sunspot/features/auth/bloc/auth_state.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(FetchOrders());
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
          title: userRole == 'staff' ? 'Orders' : 'My Orders',
          showDrawer: true,
          userRole: userRole,
          userName: userName,
          child: BlocBuilder<OrdersBloc, OrdersState>(
            builder: (context, state) {
              if (state is OrdersLoading) {
                return const Center(child: CircularSpinner());
              }

              if (state is OrdersError) {
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
                          context.read<OrdersBloc>().add(FetchOrders());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is OrdersLoaded) {
                if (state.orders.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 48,
                          color: Color(0xFF9CA3AF),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No orders found',
                          style: TextStyle(color: Color(0xFF9CA3AF)),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: state.orders.length,
                  itemBuilder: (context, index) {
                    final order = state.orders[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          context.go('/dashboard/orders/${order.id}');
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
                                    order.orderId,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                  ),
                                  StatusBadge(status: order.status),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                order.customerName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                order.address,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${order.currency} ${order.totalAmount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFF59E0B),
                                    ),
                                  ),
                                  if (order.estimatedDelivery != null)
                                    Text(
                                      'Est. Delivery: ${_formatDate(order.estimatedDelivery!)}',
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
