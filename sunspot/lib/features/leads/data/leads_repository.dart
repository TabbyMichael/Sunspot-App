import 'package:dio/dio.dart';
import 'package:sunspot/core/services/api_service.dart';
import 'package:sunspot/features/leads/data/models/lead.dart';

class LeadsRepository {
  final ApiService _apiService;

  LeadsRepository(this._apiService);

  Future<List<Lead>> fetchLeads() async {
    // Demo mode - return mock data
    try {
      final response = await _apiService.get('/leads');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Lead.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch leads');
      }
    } on DioException catch (_) {
      // Return mock data for demo
      return [
        Lead(
          id: '1',
          customerName: 'John Smith',
          customerEmail: 'john@example.com',
          customerPhone: '+1234567890',
          address: '123 Solar St, Phoenix, AZ',
          status: 'new',
          notes: 'Interested in 5kW system',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          updatedAt: DateTime.now(),
        ),
        Lead(
          id: '2',
          customerName: 'Sarah Johnson',
          customerEmail: 'sarah@example.com',
          customerPhone: '+0987654321',
          address: '456 Energy Ave, Austin, TX',
          status: 'contacted',
          notes: 'Requested quote for commercial installation',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Lead(
          id: '3',
          customerName: 'Mike Davis',
          customerEmail: 'mike@example.com',
          customerPhone: '+1122334455',
          address: '789 Renewable Blvd, Denver, CO',
          status: 'qualified',
          notes: 'Roof inspection completed',
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];
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
      final response = await _apiService.patch(
        '/leads/$id',
        data: {'status': status},
      );

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
      final response = await _apiService.patch(
        '/leads/$id',
        data: {'notes': note},
      );

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
