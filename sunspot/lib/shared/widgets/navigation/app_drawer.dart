import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sunspot/core/theme/app_colors.dart';
import 'package:sunspot/core/theme/app_spacing.dart';
import 'package:sunspot/core/theme/app_text_styles.dart';
import 'package:sunspot/features/auth/bloc/auth_bloc.dart';
import 'package:sunspot/features/auth/bloc/auth_event.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;
  final String userRole;
  final String userName;

  const AppDrawer({
    super.key,
    required this.currentRoute,
    required this.userRole,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(color: AppColors.border),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.dashboard_outlined,
                    label: 'Dashboard',
                    route: '/dashboard',
                  ),
                  if (userRole == 'staff') ...[
                    _buildMenuItem(
                      context,
                      icon: Icons.people_outline,
                      label: 'Leads',
                      route: '/dashboard/leads',
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.construction_outlined,
                      label: 'Installations',
                      route: '/dashboard/installations',
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.description_outlined,
                      label: 'Quotes',
                      route: '/dashboard/quotes',
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.inventory_2_outlined,
                      label: 'Orders',
                      route: '/dashboard/orders',
                    ),
                  ],
                  if (userRole == 'customer') ...[
                    _buildMenuItem(
                      context,
                      icon: Icons.shopping_bag_outlined,
                      label: 'Shop',
                      route: '/dashboard/shop',
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.shopping_cart_outlined,
                      label: 'Cart',
                      route: '/dashboard/cart',
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.construction_outlined,
                      label: 'My Installations',
                      route: '/dashboard/installations',
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.description_outlined,
                      label: 'My Quotes',
                      route: '/dashboard/quotes',
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.receipt_long_outlined,
                      label: 'My Orders',
                      route: '/dashboard/orders',
                    ),
                  ],
                  _buildMenuItem(
                    context,
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    route: '/dashboard/notifications',
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    route: '/dashboard/settings',
                  ),
                ],
              ),
            ),
            _buildLogoutSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.2),
            AppColors.secondary.withOpacity(0.2),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primary,
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(userName, style: AppTextStyles.h3),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _getRoleColor().withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              userRole.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _getRoleColor(),
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    final isSelected = currentRoute.contains(route);

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.textMuted,
        size: 24,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? AppColors.primary : Colors.white,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primary.withOpacity(0.1),
      onTap: () {
        context.go(route);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: ListTile(
        leading: const Icon(
          Icons.logout_outlined,
          color: AppColors.error,
          size: 24,
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.error,
          ),
        ),
        onTap: () {
          context.read<AuthBloc>().add(LogoutRequested());
          context.go('/login');
        },
      ),
    );
  }

  Color _getRoleColor() {
    switch (userRole) {
      case 'staff':
        return AppColors.primary;
      case 'customer':
        return AppColors.secondary;
      default:
        return AppColors.textMuted;
    }
  }
}
