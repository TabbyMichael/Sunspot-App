class InstallationStep {
  final String id;
  final String name;
  final String status; // pending, active, done
  final DateTime? timestamp;
  final String? notes;

  InstallationStep({
    required this.id,
    required this.name,
    required this.status,
    this.timestamp,
    this.notes,
  });

  factory InstallationStep.fromJson(Map<String, dynamic> json) {
    return InstallationStep(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 'pending',
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'timestamp': timestamp?.toIso8601String(),
      'notes': notes,
    };
  }
}

class Installation {
  final String id;
  final String orderId;
  final String customerName;
  final String address;
  final String status;
  final List<InstallationStep> steps;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Installation({
    required this.id,
    required this.orderId,
    required this.customerName,
    required this.address,
    required this.status,
    required this.steps,
    required this.createdAt,
    this.updatedAt,
  });

  factory Installation.fromJson(Map<String, dynamic> json) {
    final List<dynamic> stepsData = json['steps'] ?? [];
    return Installation(
      id: json['id'] ?? '',
      orderId: json['order_id'] ?? '',
      customerName: json['customer_name'] ?? '',
      address: json['address'] ?? '',
      status: json['status'] ?? 'pending',
      steps: stepsData.map((s) => InstallationStep.fromJson(s)).toList(),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'customer_name': customerName,
      'address': address,
      'status': status,
      'steps': steps.map((s) => s.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  static List<InstallationStep> getDefaultSteps() {
    return [
      InstallationStep(
        id: '1',
        name: 'Site Survey',
        status: 'pending',
      ),
      InstallationStep(
        id: '2',
        name: 'Design Approval',
        status: 'pending',
      ),
      InstallationStep(
        id: '3',
        name: 'Installation',
        status: 'pending',
      ),
      InstallationStep(
        id: '4',
        name: 'Testing',
        status: 'pending',
      ),
      InstallationStep(
        id: '5',
        name: 'Completed',
        status: 'pending',
      ),
    ];
  }
}
