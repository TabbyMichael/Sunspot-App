class Order {
  final String id;
  final String orderId;
  final String customerName;
  final String customerEmail;
  final String address;
  final String status;
  final double totalAmount;
  final String currency;
  final DateTime createdAt;
  final DateTime? estimatedDelivery;
  final String? notes;

  Order({
    required this.id,
    required this.orderId,
    required this.customerName,
    required this.customerEmail,
    required this.address,
    required this.status,
    required this.totalAmount,
    this.currency = 'KES',
    required this.createdAt,
    this.estimatedDelivery,
    this.notes,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      orderId: json['order_id'] ?? '',
      customerName: json['customer_name'] ?? '',
      customerEmail: json['customer_email'] ?? '',
      address: json['address'] ?? '',
      status: json['status'] ?? 'pending',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'KES',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      estimatedDelivery: json['estimated_delivery'] != null 
          ? DateTime.parse(json['estimated_delivery']) 
          : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'address': address,
      'status': status,
      'total_amount': totalAmount,
      'currency': currency,
      'created_at': createdAt.toIso8601String(),
      'estimated_delivery': estimatedDelivery?.toIso8601String(),
      'notes': notes,
    };
  }
}
