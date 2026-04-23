import 'package:flutter_test/flutter_test.dart';
import 'package:sunspot/features/products/data/products_repository.dart';

void main() {
  group('ProductsRepository', () {
    late ProductsRepository repository;

    setUp(() {
      repository = ProductsRepository();
    });

    test('fetchProducts returns non-empty product catalog', () async {
      final products = await repository.fetchProducts();

      expect(products, isNotEmpty);
      expect(products.length, greaterThanOrEqualTo(8));
    });

    test('getProductById returns the matching product', () async {
      final product = await repository.getProductById('1');

      expect(product.id, '1');
      expect(product.name, contains('Solar Panel'));
    });

    test('getProductsByCategory returns only that category', () async {
      final products = await repository.getProductsByCategory('Batteries');

      expect(products, isNotEmpty);
      expect(products.every((p) => p.category == 'Batteries'), isTrue);
    });

    test('getCategories returns unique categories', () async {
      final categories = await repository.getCategories();

      expect(categories, isNotEmpty);
      expect(categories.length, categories.toSet().length);
      expect(categories, contains('Solar Panels'));
    });
  });
}
