import 'package:dio/dio.dart';
import 'package:sunspot/core/services/api_service.dart';
import 'package:sunspot/features/orders/data/models/order.dart';

class OrdersRepository {
  final ApiService _apiService;

  OrdersRepository(this._apiService);

  Future<List<Order>> fetchOrders() async {
    // Demo mode - return mock data
    try {
      final response = await _apiService.get('/orders');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch orders');
      }
    } on DioException catch (_) {
      // Return mock data for demo
      return [
        Order(
          id: '1',
          orderId: 'ORD-001',
          customerName: 'John Smith',
          customerEmail: 'john@example.com',
          address: '123 Solar St, Phoenix, AZ',
          status: 'processing',
          totalAmount: 250000,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          estimatedDelivery: DateTime.now().add(const Duration(days: 10)),
          notes: '5kW system with battery storage',
        ),
        Order(
          id: '2',
          orderId: 'ORD-002',
          customerName: 'Sarah Johnson',
          customerEmail: 'sarah@example.com',
          address: '456 Energy Ave, Austin, TX',
          status: 'shipped',
          totalAmount: 450000,
          createdAt: DateTime.now().subtract(const Duration(days: 12)),
          estimatedDelivery: DateTime.now().add(const Duration(days: 3)),
          notes: '10kW commercial system',
        ),
        Order(
          id: '3',
          orderId: 'ORD-003',
          customerName: 'Mike Davis',
          customerEmail: 'mike@example.com',
          address: '789 Renewable Blvd, Denver, CO',
          status: 'delivered',
          totalAmount: 180000,
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
          estimatedDelivery: DateTime.now().subtract(const Duration(days: 5)),
          notes: '3kW system',
        ),
      ];
    }
  }

  Future<Order> getOrderById(String id) async {
    try {
      final response = await _apiService.get('/orders/$id');

      if (response.statusCode == 200) {
        return Order.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch order');
      }
    } on DioException catch (_) {
      // Return mock data for demo
      final mockOrders = [
        Order(
          id: '1',
          orderId: 'ORD-001',
          customerName: 'John Smith',
          customerEmail: 'john@example.com',
          address: '123 Solar St, Phoenix, AZ',
          status: 'processing',
          totalAmount: 250000,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          estimatedDelivery: DateTime.now().add(const Duration(days: 10)),
          notes:
              '5kW system with battery storage. Installation scheduled for next week.',
        ),
        Order(
          id: '2',
          orderId: 'ORD-002',
          customerName: 'Sarah Johnson',
          customerEmail: 'sarah@example.com',
          address: '456 Energy Ave, Austin, TX',
          status: 'shipped',
          totalAmount: 450000,
          createdAt: DateTime.now().subtract(const Duration(days: 12)),
          estimatedDelivery: DateTime.now().add(const Duration(days: 3)),
          notes: '10kW commercial system. Expected delivery by end of week.',
        ),
        Order(
          id: '3',
          orderId: 'ORD-003',
          customerName: 'Mike Davis',
          customerEmail: 'mike@example.com',
          address: '789 Renewable Blvd, Denver, CO',
          status: 'delivered',
          totalAmount: 180000,
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
          estimatedDelivery: DateTime.now().subtract(const Duration(days: 5)),
          notes: '3kW system. Successfully installed and commissioned.',
        ),
      ];

      final order = mockOrders.firstWhere(
        (o) => o.id == id,
        orElse: () => mockOrders.first,
      );

      return order;
    }
  }

  Future<Order> updateOrderStatus(String id, String status) async {
    try {
      final response = await _apiService.patch(
        '/orders/$id',
        data: {'status': status},
      );

      if (response.statusCode == 200) {
        return Order.fromJson(response.data);
      } else {
        throw Exception('Failed to update order');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to update order');
    }
  }
}
