import 'package:flutter_test/flutter_test.dart';
import 'package:sunspot/core/models/user.dart';

void main() {
  group('User model', () {
    test('fromJson maps expected fields', () {
      final user = User.fromJson({
        'id': 'u1',
        'email': 'staff@sunspot.com',
        'name': 'Staff User',
        'role': 'staff',
        'phone': '+1234567890',
      });

      expect(user.id, 'u1');
      expect(user.email, 'staff@sunspot.com');
      expect(user.role, 'staff');
      expect(user.phone, '+1234567890');
    });

    test('toJson includes nullable fields', () {
      final user = User(
        id: 'u2',
        email: 'customer@sunspot.com',
        name: 'Customer User',
        role: 'customer',
      );

      final json = user.toJson();

      expect(json['id'], 'u2');
      expect(json['email'], 'customer@sunspot.com');
      expect(json['phone'], isNull);
    });
  });
}
