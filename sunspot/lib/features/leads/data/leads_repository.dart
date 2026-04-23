import 'package:dio/dio.dart';
import 'package:sunspot/core/services/api_service.dart';
import 'package:sunspot/features/leads/data/models/lead.dart';

class LeadsRepository {
  final ApiService _apiService;

  LeadsRepository(this._apiService);

  Future<List<Lead>> fetchLeads() async {
    try {
      final response = await _apiService.get('/leads');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Lead.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch leads');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to fetch leads');
    }
  }

  Future<Lead> getLeadById(String id) async {
    try {
      final response = await _apiService.get('/leads/$id');
      
      if (response.statusCode == 200) {
        return Lead.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch lead');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to fetch lead');
    }
  }

  Future<Lead> updateLeadStatus(String id, String status) async {
    try {
      final response = await _apiService.patch('/leads/$id', data: {
        'status': status,
      });
      
      if (response.statusCode == 200) {
        return Lead.fromJson(response.data);
      } else {
        throw Exception('Failed to update lead');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to update lead');
    }
  }

  Future<Lead> addNoteToLead(String id, String note) async {
    try {
      final response = await _apiService.patch('/leads/$id', data: {
        'notes': note,
      });
      
      if (response.statusCode == 200) {
        return Lead.fromJson(response.data);
      } else {
        throw Exception('Failed to add note');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to add note');
    }
  }
}
