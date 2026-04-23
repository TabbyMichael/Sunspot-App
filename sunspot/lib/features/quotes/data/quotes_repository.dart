import 'package:dio/dio.dart';
import 'package:sunspot/core/services/api_service.dart';
import 'package:sunspot/features/quotes/data/models/quote.dart';

class QuotesRepository {
  final ApiService _apiService;

  QuotesRepository(this._apiService);

  Future<List<Quote>> fetchQuotes() async {
    // Demo mode - return mock data
    try {
      final response = await _apiService.get('/quotes');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Quote.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch quotes');
      }
    } on DioException catch (_) {
      // Return mock data for demo
      return [
        Quote(
          id: '1',
          customerName: 'John Smith',
          customerEmail: 'john@example.com',
          address: '123 Solar St, Phoenix, AZ',
          status: 'pending',
          amount: 250000,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          expiresAt: DateTime.now().add(const Duration(days: 27)),
          notes: '5kW residential system',
        ),
        Quote(
          id: '2',
          customerName: 'Sarah Johnson',
          customerEmail: 'sarah@example.com',
          address: '456 Energy Ave, Austin, TX',
          status: 'approved',
          amount: 450000,
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          expiresAt: DateTime.now().add(const Duration(days: 23)),
          notes: '10kW commercial system',
        ),
        Quote(
          id: '3',
          customerName: 'Mike Davis',
          customerEmail: 'mike@example.com',
          address: '789 Renewable Blvd, Denver, CO',
          status: 'rejected',
          amount: 180000,
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          expiresAt: DateTime.now().add(const Duration(days: 20)),
          notes: '3kW system - roof not suitable',
        ),
      ];
    }
  }

  Future<Quote> getQuoteById(String id) async {
    try {
      final response = await _apiService.get('/quotes/$id');
      
      if (response.statusCode == 200) {
        return Quote.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch quote');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to fetch quote');
    }
  }

  Future<Quote> updateQuoteStatus(String id, String status) async {
    try {
      final response = await _apiService.patch('/quotes/$id', data: {
        'status': status,
      });
      
      if (response.statusCode == 200) {
        return Quote.fromJson(response.data);
      } else {
        throw Exception('Failed to update quote');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to update quote');
    }
  }
}
