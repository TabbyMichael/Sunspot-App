import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sunspot/shared/widgets/buttons/primary_button.dart';
import 'package:sunspot/shared/widgets/inputs/app_text_field.dart';
import 'package:sunspot/shared/widgets/layout/screen_wrapper.dart';
import 'package:sunspot/features/auth/bloc/auth_bloc.dart';
import 'package:sunspot/features/auth/bloc/auth_event.dart';
import 'package:sunspot/features/auth/bloc/auth_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedRole = 'customer';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignupRequested(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
          _selectedRole,
        ),
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
    final surfaceColor = isLightMode
        ? const Color(0xFFF3F4F6)
        : const Color(0xFF1F2937);
    final borderColor = isLightMode
        ? const Color(0xFFD1D5DB)
        : const Color(0xFF374151);

    return ScreenWrapper(
      title: 'Sign Up',
      appBarTitleColor: appBarTextColor,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              'Create Account',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign up to get started',
              style: TextStyle(fontSize: 14, color: secondaryTextColor),
            ),
            const SizedBox(height: 48),
            AppTextField(
              hint: 'Full Name',
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            AppTextField(
              hint: 'Confirm Password',
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  color: secondaryTextColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: borderColor,
                  width: 1,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedRole,
                  dropdownColor: surfaceColor,
                  style: TextStyle(color: primaryTextColor, fontSize: 16),
                  iconEnabledColor: secondaryTextColor,
                  items: const [
                    DropdownMenuItem(
                      value: 'customer',
                      child: Text('Customer'),
                    ),
                    DropdownMenuItem(
                      value: 'staff',
                      child: Text('Staff'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                ),
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
                  label: 'Sign Up',
                  onPressed: state is AuthLoading ? () {} : _handleSignup,
                  isLoading: state is AuthLoading,
                );
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(color: secondaryTextColor),
                  ),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: Text(
                      'Sign In',
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
