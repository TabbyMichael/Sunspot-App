import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sunspot/core/theme/app_colors.dart';
import 'package:sunspot/core/theme/app_spacing.dart';
import 'package:sunspot/core/theme/app_text_styles.dart';
import 'package:sunspot/features/auth/bloc/auth_bloc.dart';
import 'package:sunspot/features/auth/bloc/auth_event.dart';

class AppDrawer extends StatefulWidget {
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
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _imagePicker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width,
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
                  if (widget.userRole == 'staff') ...[
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
                  if (widget.userRole == 'customer') ...[
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
          GestureDetector(
            onTap: () {
              if (widget.userRole == 'customer') {
                _showPhotoUploadDialog(context);
              }
            },
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary,
              child: _selectedImage != null
                  ? ClipOval(
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                      ),
                    )
                  : Text(
                      widget.userName.isNotEmpty
                          ? widget.userName[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Text(widget.userName, style: AppTextStyles.h3),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _getRoleColor().withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.userRole.toUpperCase(),
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

  void _showPhotoUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Theme.of(context).brightness == Brightness.dark
                  ? [const Color(0xFF1F2937), const Color(0xFF374151)]
                  : [
                      const Color(0xFFF59E0B).withOpacity(0.1),
                      const Color(0xFFD97706).withOpacity(0.1),
                    ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFF59E0B).withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upload Profile Photo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF111827),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF111827),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_selectedImage != null)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF374151)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF4B5563)
                          : const Color(0xFFE5E7EB),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 40,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFFD1D5DB),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to upload',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildAnimatedButton(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap: () {
                        _pickImage(ImageSource.camera);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildAnimatedButton(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () {
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    final isSelected = widget.currentRoute.contains(route);

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
    switch (widget.userRole) {
      case 'staff':
        return AppColors.primary;
      case 'customer':
        return AppColors.secondary;
      default:
        return AppColors.textMuted;
    }
  }

  Widget _buildAnimatedButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF374151)
              : const Color(0xFFF59E0B),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
