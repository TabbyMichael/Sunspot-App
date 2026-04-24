import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Centralized service for managing haptic feedback across the application.
/// 
/// This service provides a clean, reusable interface for triggering haptic
/// feedback on both iOS and Android devices. It includes a global enable/disable
/// flag that can be toggled by users in settings and persisted using SharedPreferences.
/// 
/// Usage:
/// ```dart
/// final hapticsService = HapticsService();
/// hapticsService.lightImpact();
/// ```
class HapticsService {
  static const String _hapticsEnabledKey = 'haptics_enabled';
  
  /// Global flag to enable or disable haptic feedback across the app.
  /// This value is persisted to SharedPreferences and loaded on app startup.
  bool isHapticsEnabled = true;

  /// Private constructor to enforce singleton pattern if needed.
  /// Currently using instance-based approach for flexibility with DI.
  HapticsService();

  /// Initialize the service by loading the haptics preference from storage.
  /// Should be called during app initialization (e.g., in main()).
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isHapticsEnabled = prefs.getBool(_hapticsEnabledKey) ?? true;
    } catch (e) {
      // If SharedPreferences fails, default to enabled
      isHapticsEnabled = true;
    }
  }

  /// Save the current haptics enabled state to persistent storage.
  Future<void> _savePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hapticsEnabledKey, isHapticsEnabled);
    } catch (e) {
      // Silently fail - preference won't persist but app continues to work
    }
  }

  /// Enable or disable haptic feedback globally.
  /// Changes are persisted to SharedPreferences.
  Future<void> setHapticsEnabled(bool enabled) async {
    isHapticsEnabled = enabled;
    await _savePreference();
  }

  /// Trigger a light impact haptic feedback.
  /// 
  /// Use for: Primary button taps, page transitions, subtle confirmations.
  /// Intensity: Light (10ms on iOS, light vibration on Android).
  Future<void> lightImpact() async {
    if (!isHapticsEnabled) return;
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      // Fail gracefully on unsupported devices
    }
  }

  /// Trigger a medium impact haptic feedback.
  /// 
  /// Use for: Successful form submissions, pull-to-refresh, important confirmations.
  /// Intensity: Medium (20ms on iOS, medium vibration on Android).
  Future<void> mediumImpact() async {
    if (!isHapticsEnabled) return;
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      // Fail gracefully on unsupported devices
    }
  }

  /// Trigger a heavy impact haptic feedback.
  /// 
  /// Use for: Destructive actions, long-press gestures, critical alerts.
  /// Intensity: Heavy (40ms on iOS, heavy vibration on Android).
  Future<void> heavyImpact() async {
    if (!isHapticsEnabled) return;
    try {
      await HapticFeedback.heavyImpact();
    } catch (e) {
      // Fail gracefully on unsupported devices
    }
  }

  /// Trigger a selection click haptic feedback.
  /// 
  /// Use for: Toggle switches, bottom navigation tab changes, selection changes.
  /// Intensity: Selection click (subtle tick on iOS, light tick on Android).
  Future<void> selectionClick() async {
    if (!isHapticsEnabled) return;
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      // Fail gracefully on unsupported devices
    }
  }

  /// Trigger a vibration haptic feedback.
  /// 
  /// Use for: Validation errors, warnings, attention-grabbing events.
  /// Intensity: Vibration (custom pattern on Android, light impact on iOS).
  Future<void> vibrate() async {
    if (!isHapticsEnabled) return;
    try {
      await HapticFeedback.vibrate();
    } catch (e) {
      // Fail gracefully on unsupported devices
    }
  }
}
