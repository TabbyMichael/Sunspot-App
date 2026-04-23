import 'package:flutter_test/flutter_test.dart';
import 'package:sunspot/features/products/data/models/product.dart';

void main() {
  group('Product model', () {
    test('fromJson maps snake_case payload correctly', () {
      final product = Product.fromJson({
        'id': '10',
        'name': 'Solar Optimizer',
        'description': 'Optimization hardware',
        'price': 12000,
        'currency': 'KES',
        'category': 'Electronics',
        'image_url': 'https://example.com/item.png',
        'rating': 4.6,
        'review_count': 17,
        'in_stock': true,
        'stock_quantity': 44,
        'features': ['MPPT', 'Compact'],
        'brand': 'Sunspot',
      });

      expect(product.id, '10');
      expect(product.imageUrl, 'https://example.com/item.png');
      expect(product.reviewCount, 17);
      expect(product.features, ['MPPT', 'Compact']);
    });

    test('toJson preserves fields for API payloads', () {
      final product = Product(
        id: '11',
        name: 'Inverter X',
        description: 'Hybrid inverter',
        price: 85000,
        category: 'Inverters',
        imageUrl: 'https://example.com/inverter.png',
        rating: 4.8,
        reviewCount: 31,
        inStock: false,
        stockQuantity: 0,
        features: const ['Hybrid', 'WiFi'],
        brand: 'Huawei',
      );

      final json = product.toJson();

      expect(json['image_url'], 'https://example.com/inverter.png');
      expect(json['in_stock'], isFalse);
      expect(json['stock_quantity'], 0);
      expect(json['features'], ['Hybrid', 'WiFi']);
    });
  });
}
