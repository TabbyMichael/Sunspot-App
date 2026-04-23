import 'package:dio/dio.dart';
import 'package:sunspot/core/services/api_service.dart';
import 'package:sunspot/features/installations/data/models/installation.dart';

class InstallationsRepository {
  final ApiService _apiService;

  InstallationsRepository(this._apiService);

  Future<List<Installation>> fetchInstallations() async {
    try {
      final response = await _apiService.get('/installations');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Installation.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch installations');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to fetch installations');
    }
  }

  Future<Installation> getInstallationById(String id) async {
    try {
      final response = await _apiService.get('/installations/$id');
      
      if (response.statusCode == 200) {
        return Installation.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch installation');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to fetch installation');
    }
  }

  Future<Installation> updateInstallationStep(
    String installationId,
    String stepId,
    String status,
    {String? notes}
  ) async {
    try {
      final response = await _apiService.patch(
        '/installations/$installationId/steps/$stepId',
        data: {
          'status': status,
          if (notes != null) 'notes': notes,
        },
      );
      
      if (response.statusCode == 200) {
        return Installation.fromJson(response.data);
      } else {
        throw Exception('Failed to update installation step');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to update installation step');
    }
  }

  Future<Installation> updateInstallationStatus(
    String id,
    String status,
  ) async {
    try {
      final response = await _apiService.patch('/installations/$id', data: {
        'status': status,
      });
      
      if (response.statusCode == 200) {
        return Installation.fromJson(response.data);
      } else {
        throw Exception('Failed to update installation');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to update installation');
    }
  }
}
