class Quote {
  final String id;
  final String customerName;
  final String customerEmail;
  final String address;
  final String status;
  final double amount;
  final String currency;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String? notes;

  Quote({
    required this.id,
    required this.customerName,
    required this.customerEmail,
    required this.address,
    required this.status,
    required this.amount,
    this.currency = 'KES',
    required this.createdAt,
    this.expiresAt,
    this.notes,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] ?? '',
      customerName: json['customer_name'] ?? '',
      customerEmail: json['customer_email'] ?? '',
      address: json['address'] ?? '',
      status: json['status'] ?? 'pending',
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'KES',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      expiresAt: json['expires_at'] != null 
          ? DateTime.parse(json['expires_at']) 
          : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'address': address,
      'status': status,
      'amount': amount,
      'currency': currency,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'notes': notes,
    };
  }
}
