import 'package:flutter/material.dart';
import 'package:sunspot/core/theme/app_colors.dart';
import 'package:sunspot/core/providers/haptics_provider.dart';
import 'package:sunspot/shared/widgets/loading/circular_spinner.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final haptics = HapticsProvider.of(context);

    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.textMuted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isEnabled && !isLoading
            ? () {
                haptics.lightImpact();
                onPressed();
              }
            : null,
        child: isLoading
            ? const CircularSpinner(size: 20, color: Colors.white)
            : Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
