import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sunspot/features/auth/bloc/auth_bloc.dart';
import 'package:sunspot/features/auth/bloc/auth_event.dart';
import 'package:sunspot/features/auth/bloc/auth_state.dart';
import 'package:sunspot/shared/widgets/buttons/primary_button.dart';
import 'package:sunspot/shared/widgets/inputs/app_text_field.dart';
import 'package:sunspot/shared/widgets/layout/screen_wrapper.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        PasswordResetRequested(_emailController.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final appBarTextColor = isLightMode ? Colors.black : Colors.white;
    final primaryTextColor = isLightMode ? Colors.black : Colors.white;
    final secondaryTextColor = isLightMode
        ? Colors.black
        : const Color(0xFF9CA3AF);
    final actionTextColor = isLightMode
        ? Colors.black
        : const Color(0xFFF59E0B);

    return ScreenWrapper(
      title: 'Reset Password',
      appBarTitleColor: appBarTextColor,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              'Reset Password',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your email to receive a reset link',
              style: TextStyle(fontSize: 14, color: secondaryTextColor),
            ),
            const SizedBox(height: 48),
            AppTextField(
              hint: 'Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthPasswordResetEmailSent) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Password reset link sent to ${state.email}',
                      ),
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  );
                  context.go('/login');
                }

                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: const Color(0xFFEF4444),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return PrimaryButton(
                  label: 'Send Reset Link',
                  onPressed: state is AuthLoading ? () {} : _handleResetPassword,
                  isLoading: state is AuthLoading,
                );
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: Text(
                  'Back to Login',
                  style: TextStyle(color: actionTextColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
