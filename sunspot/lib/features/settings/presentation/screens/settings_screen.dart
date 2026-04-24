import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sunspot/shared/widgets/cards/app_card.dart';
import 'package:sunspot/shared/widgets/layout/screen_wrapper.dart';
import 'package:sunspot/shared/widgets/buttons/primary_button.dart';
import 'package:sunspot/shared/widgets/loading/circular_spinner.dart';
import 'package:sunspot/features/auth/bloc/auth_bloc.dart';
import 'package:sunspot/features/auth/bloc/auth_event.dart';
import 'package:sunspot/features/auth/bloc/auth_state.dart';
import 'package:sunspot/core/theme/theme_bloc.dart';
import 'package:sunspot/core/providers/haptics_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _notificationsEnabled = true;
  bool _hapticsEnabled = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadHapticsPreference();
    _simulateLoading();
  }

  Future<void> _loadHapticsPreference() async {
    final haptics = HapticsProvider.of(context);
    setState(() {
      _hapticsEnabled = haptics.isHapticsEnabled;
    });
  }

  Future<void> _simulateLoading() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
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
        final userEmail = authState is AuthAuthenticated
            ? authState.user.email
            : '';
        final userPhone = authState is AuthAuthenticated
            ? (authState.user.phone ?? '')
            : '';

        // Initialize controllers if empty
        if (_nameController.text.isEmpty) {
          _nameController.text = userName;
        }
        if (_emailController.text.isEmpty) {
          _emailController.text = userEmail;
        }
        if (_phoneController.text.isEmpty) {
          _phoneController.text = userPhone;
        }

        return ScreenWrapper(
          title: 'Settings',
          showDrawer: true,
          userRole: userRole,
          userName: userName,
          child: _isLoading
              ? const Center(child: CircularSpinner())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Section
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : const Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppCard(
                        child: Column(
                          children: [
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? const Color(0xFF9CA3AF)
                                      : const Color(0xFF6B7280),
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? const Color(0xFF9CA3AF)
                                      : const Color(0xFF6B7280),
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                labelText: 'Phone',
                                labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? const Color(0xFF9CA3AF)
                                      : const Color(0xFF6B7280),
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            PrimaryButton(
                              label: 'Update Profile',
                              onPressed: () {
                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Profile updated successfully',
                                    ),
                                    backgroundColor: Color(0xFF10B981),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Preferences Section
                      Text(
                        'Preferences',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : const Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppCard(
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: Text(
                                'Push Notifications',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : const Color(0xFF111827),
                                ),
                              ),
                              subtitle: Text(
                                'Receive notifications for updates',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? const Color(0xFF9CA3AF)
                                      : const Color(0xFF6B7280),
                                ),
                              ),
                              value: _notificationsEnabled,
                              onChanged: (value) {
                                final haptics = HapticsProvider.of(context);
                                haptics.selectionClick();
                                setState(() {
                                  _notificationsEnabled = value;
                                });
                              },
                              activeColor: const Color(0xFFF59E0B),
                            ),
                            Divider(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color(0xFF374151)
                                  : const Color(0xFFE5E7EB),
                            ),
                            SwitchListTile(
                              title: Text(
                                'Haptic Feedback',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : const Color(0xFF111827),
                                ),
                              ),
                              subtitle: Text(
                                'Vibrate on interactions',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? const Color(0xFF9CA3AF)
                                      : const Color(0xFF6B7280),
                                ),
                              ),
                              value: _hapticsEnabled,
                              onChanged: (value) async {
                                final haptics = HapticsProvider.of(context);
                                haptics.selectionClick();
                                await haptics.setHapticsEnabled(value);
                                setState(() {
                                  _hapticsEnabled = value;
                                });
                              },
                              activeColor: const Color(0xFFF59E0B),
                            ),
                            Divider(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color(0xFF374151)
                                  : const Color(0xFFE5E7EB),
                            ),
                            BlocBuilder<ThemeBloc, ThemeState>(
                              builder: (context, themeState) {
                                final isDarkMode =
                                    themeState.mode == AppThemeMode.dark;
                                return SwitchListTile(
                                  title: Text(
                                    'Dark Mode',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : const Color(0xFF111827),
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Use dark theme',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? const Color(0xFF9CA3AF)
                                          : const Color(0xFF6B7280),
                                    ),
                                  ),
                                  value: isDarkMode,
                                  onChanged: (value) {
                                    final haptics = HapticsProvider.of(context);
                                    haptics.selectionClick();
                                    context.read<ThemeBloc>().add(
                                      ToggleTheme(),
                                    );
                                  },
                                  activeColor: const Color(0xFFF59E0B),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // About Section
                      Text(
                        'About',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : const Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sunspot Solar App',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : const Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Version 1.0.0',
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? const Color(0xFF9CA3AF)
                                    : const Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sunspot Solar is a comprehensive solar energy management platform designed to help customers and staff manage installations, quotes, orders, and more.',
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? const Color(0xFF9CA3AF)
                                    : const Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Logout Button
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF4444),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            final haptics = HapticsProvider.of(context);
                            haptics.heavyImpact();
                            context.read<AuthBloc>().add(LogoutRequested());
                            context.go('/login');
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
