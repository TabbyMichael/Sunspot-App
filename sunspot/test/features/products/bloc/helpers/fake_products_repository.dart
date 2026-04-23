import 'package:sunspot/features/products/data/models/product.dart';
import 'package:sunspot/features/products/data/products_repository.dart';

class FakeProductsRepository extends ProductsRepository {
  FakeProductsRepository({this.throwOnDetails = false});

  final bool throwOnDetails;

  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Panel Alpha',
      description: 'High efficiency panel',
      price: 100,
      category: 'Solar Panels',
      imageUrl: 'https://example.com/panel.jpg',
    ),
    Product(
      id: '2',
      name: 'Battery Max',
      description: 'Storage for home systems',
      price: 200,
      category: 'Batteries',
      imageUrl: 'https://example.com/battery.jpg',
    ),
  ];

  @override
  Future<List<Product>> fetchProducts() async => _products;

  @override
  Future<Product> getProductById(String id) async {
    if (throwOnDetails) {
      throw StateError('Missing product');
    }
    return _products.firstWhere((p) => p.id == id);
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    return _products.where((p) => p.category == category).toList();
  }

  @override
  Future<List<String>> getCategories() async {
    return _products.map((p) => p.category).toSet().toList();
  }
}
