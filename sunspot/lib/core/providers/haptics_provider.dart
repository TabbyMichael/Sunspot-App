import 'package:flutter/widgets.dart';
import 'package:sunspot/core/services/haptics_service.dart';

/// InheritedWidget that provides the HapticsService to the widget tree.
/// 
/// Usage:
/// ```dart
/// final haptics = HapticsProvider.of(context);
/// haptics.lightImpact();
/// ```
class HapticsProvider extends InheritedWidget {
  final HapticsService hapticsService;

  const HapticsProvider({
    super.key,
    required this.hapticsService,
    required Widget child,
  }) : super(child: child);

  static HapticsService of(BuildContext context) {
    final HapticsProvider? provider =
        context.dependOnInheritedWidgetOfExactType<HapticsProvider>();
    assert(
      provider != null,
      'No HapticsProvider found in context. Make sure to wrap your app with HapticsProvider.',
    );
    return provider!.hapticsService;
  }

  @override
  bool updateShouldNotify(HapticsProvider oldWidget) {
    return hapticsService != oldWidget.hapticsService;
  }
}
