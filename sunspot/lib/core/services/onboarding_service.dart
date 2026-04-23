import 'secure_storage_service.dart';

class OnboardingService {
  static const _onboardingKey = 'onboarding_completed';
  final SecureStorageService _secureStorageService;

  OnboardingService(this._secureStorageService);

  Future<bool> isCompleted() async {
    final value = await _secureStorageService.read(_onboardingKey);
    return value == 'true';
  }

  Future<void> markCompleted() async {
    await _secureStorageService.write(_onboardingKey, 'true');
  }
}

