import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sunspot/shared/widgets/buttons/primary_button.dart';
import 'package:sunspot/shared/widgets/inputs/app_text_field.dart';
import 'package:sunspot/shared/widgets/layout/screen_wrapper.dart';
import 'package:sunspot/features/auth/bloc/auth_bloc.dart';
import 'package:sunspot/features/auth/bloc/auth_event.dart';
import 'package:sunspot/features/auth/bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(_emailController.text.trim(), _passwordController.text),
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
      title: 'Login',
      appBarTitleColor: appBarTextColor,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to continue',
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
            const SizedBox(height: 16),
            AppTextField(
              hint: 'Password',
              controller: _passwordController,
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: secondaryTextColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthAuthenticated) {
                  context.go('/dashboard');
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
                  label: 'Sign In',
                  onPressed: state is AuthLoading ? () {} : _handleLogin,
                  isLoading: state is AuthLoading,
                );
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () => context.go('/reset-password'),
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: actionTextColor),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: secondaryTextColor),
                  ),
                  TextButton(
                    onPressed: () => context.go('/signup'),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: actionTextColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
