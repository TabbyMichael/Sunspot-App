import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sunspot/core/models/user.dart';
import 'package:sunspot/core/services/api_service.dart';
import 'package:sunspot/core/services/secure_storage_service.dart';

class AuthRepository {
  final ApiService _apiService;
  final SecureStorageService _storageService;

  AuthRepository(this._apiService, this._storageService);

  Future<User> login(String email, String password) async {
    // Demo mode - return mock data for testing
    if (email == 'staff@sunspot.com' && password == 'demo123') {
      final mockToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IlN0YWZmIFVzZXIiLCJyb2xlIjoic3RhZmYiLCJlbWFpbCI6InN0YWZmQHN1bnNwb3QuY29tIn0.mock';
      await _storageService.write('auth_token', mockToken);
      return User(
        id: '1',
        email: 'staff@sunspot.com',
        name: 'Staff User',
        role: 'staff',
        phone: '+1234567890',
      );
    }

    if (email == 'customer@sunspot.com' && password == 'demo123') {
      final mockToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODc2NTQzMjEwIiwibmFtZSI6IkN1c3RvbWVyIFVzZXIiLCJyb2xlIjoiY3VzdG9tZXIiLCJlbWFpbCI6ImN1c3RvbWVyQHN1bnNwb3QuY29tIn0.mock';
      await _storageService.write('auth_token', mockToken);
      return User(
        id: '2',
        email: 'customer@sunspot.com',
        name: 'Customer User',
        role: 'customer',
        phone: '+0987654321',
      );
    }

    try {
      final response = await _apiService.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['access_token'];
        await _storageService.write('auth_token', token);

        final userData = response.data['user'];
        return User.fromJson(userData);
      } else {
        throw Exception('Login failed');
      }
    } on DioException catch (_) {
      throw Exception(
        'Invalid credentials. Use staff@sunspot.com / demo123 or customer@sunspot.com / demo123 for demo mode',
      );
    }
  }

  Future<void> logout() async {
    await _storageService.delete('auth_token');
  }

  Future<String?> getToken() async {
    return await _storageService.read('auth_token');
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    if (token == null) return false;

    try {
      return !JwtDecoder.isExpired(token);
    } catch (e) {
      return false;
    }
  }

  Future<String?> getUserRole() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final decodedToken = JwtDecoder.decode(token);
      return decodedToken['role'];
    } catch (e) {
      return null;
    }
  }

  Future<User?> getCurrentUser() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final decodedToken = JwtDecoder.decode(token);
      return User(
        id: decodedToken['sub'] ?? '',
        email: decodedToken['email'] ?? '',
        name: decodedToken['name'] ?? '',
        role: decodedToken['role'] ?? '',
      );
    } catch (e) {
      return null;
    }
  }
}
