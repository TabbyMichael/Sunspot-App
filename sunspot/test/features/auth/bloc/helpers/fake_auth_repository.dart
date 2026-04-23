import 'package:sunspot/core/models/user.dart';
import 'package:sunspot/core/services/api_service.dart';
import 'package:sunspot/core/services/secure_storage_service.dart';
import 'package:sunspot/features/auth/data/auth_repository.dart';

class FakeAuthRepository extends AuthRepository {
  FakeAuthRepository({
    this.loginShouldThrow = false,
    this.authenticated = false,
    this.currentUser,
    this.token,
  }) : super(ApiService(baseUrl: 'https://example.com'), SecureStorageService());

  final bool loginShouldThrow;
  final bool authenticated;
  final User? currentUser;
  final String? token;
  bool logoutCalled = false;

  @override
  Future<User> login(String email, String password) async {
    if (loginShouldThrow) {
      throw Exception('Invalid credentials');
    }

    return User(
      id: '1',
      email: email,
      name: 'Test User',
      role: 'staff',
    );
  }

  @override
  Future<void> logout() async {
    logoutCalled = true;
  }

  @override
  Future<String?> getToken() async => token;

  @override
  Future<bool> isAuthenticated() async => authenticated;

  @override
  Future<User?> getCurrentUser() async => currentUser;
}
