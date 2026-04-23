import 'package:sunspot/features/products/data/models/product.dart';

class ProductsRepository {
  Future<List<Product>> fetchProducts() async {
    // Demo mode - return mock solar products
    return [
      Product(
        id: '1',
        name: 'Solar Panel 400W Monocrystalline',
        description:
            'High-efficiency monocrystalline solar panel with 400W output. Perfect for residential and commercial installations.',
        price: 45000,
        currency: 'KES',
        category: 'Solar Panels',
        imageUrl:
            'https://images.unsplash.com/photo-1497436072909-60f360e1d4b1?auto=format&fit=crop&w=900&q=80',
        rating: 4.5,
        reviewCount: 128,
        inStock: true,
        stockQuantity: 50,
        features: [
          '400W power output',
          '22% efficiency',
          '25-year warranty',
          'Weather resistant',
        ],
        brand: 'SunPower',
      ),
      Product(
        id: '2',
        name: 'Solar Inverter 5kW Hybrid',
        description:
            'Hybrid inverter with battery support. Compatible with both grid-tied and off-grid systems.',
        price: 85000,
        currency: 'KES',
        category: 'Inverters',
        imageUrl:
            'https://images.unsplash.com/photo-1621905252507-b35492cc74b4?auto=format&fit=crop&w=900&q=80',
        rating: 4.7,
        reviewCount: 89,
        inStock: true,
        stockQuantity: 30,
        features: [
          '5kW capacity',
          'Hybrid functionality',
          'WiFi monitoring',
          'Smart load management',
        ],
        brand: 'Huawei',
      ),
      Product(
        id: '3',
        name: 'Lithium Battery 10kWh',
        description:
            'High-capacity lithium battery for energy storage. Perfect for backup power and off-grid systems.',
        price: 180000,
        currency: 'KES',
        category: 'Batteries',
        imageUrl:
            'https://images.unsplash.com/photo-1617886322168-72b886573c5f?auto=format&fit=crop&w=900&q=80',
        rating: 4.8,
        reviewCount: 156,
        inStock: true,
        stockQuantity: 20,
        features: [
          '10kWh capacity',
          'LiFePO4 technology',
          '10-year lifespan',
          'BMS included',
        ],
        brand: 'Tesla',
      ),
      Product(
        id: '4',
        name: 'Solar Mounting Kit',
        description:
            'Complete mounting kit for roof installation. Includes rails, clamps, and hardware.',
        price: 15000,
        currency: 'KES',
        category: 'Mounting',
        imageUrl:
            'https://images.unsplash.com/photo-1592833159155-c62df1b65634?auto=format&fit=crop&w=900&q=80',
        rating: 4.3,
        reviewCount: 67,
        inStock: true,
        stockQuantity: 100,
        features: [
          'Aluminum rails',
          'Universal clamps',
          'Weather resistant',
          'Easy installation',
        ],
        brand: 'IronRidge',
      ),
      Product(
        id: '5',
        name: 'Solar Charge Controller 60A',
        description:
            'MPPT charge controller for off-grid systems. Maximizes solar panel efficiency.',
        price: 25000,
        currency: 'KES',
        category: 'Controllers',
        imageUrl:
            'https://images.unsplash.com/photo-1581092921461-eab62e97a780?auto=format&fit=crop&w=900&q=80',
        rating: 4.4,
        reviewCount: 45,
        inStock: true,
        stockQuantity: 40,
        features: [
          '60A capacity',
          'MPPT technology',
          'LCD display',
          'Multiple battery types',
        ],
        brand: 'Victron',
      ),
      Product(
        id: '6',
        name: 'Solar Cable 50m Roll',
        description:
            'High-quality solar cable for panel connections. UV and weather resistant.',
        price: 8000,
        currency: 'KES',
        category: 'Cables',
        imageUrl:
            'https://images.unsplash.com/photo-1517420704952-d9f39e95b43e?auto=format&fit=crop&w=900&q=80',
        rating: 4.2,
        reviewCount: 92,
        inStock: true,
        stockQuantity: 200,
        features: [
          '50m length',
          '6mm² cross-section',
          'UV resistant',
          'IP67 rated',
        ],
        brand: 'Phoenix Contact',
      ),
      Product(
        id: '7',
        name: 'Complete 5kW Solar System',
        description:
            'All-in-one solar system kit. Includes panels, inverter, mounting, and installation.',
        price: 450000,
        currency: 'KES',
        category: 'Systems',
        imageUrl:
            'https://images.unsplash.com/photo-1509391366360-2e959784a276?auto=format&fit=crop&w=900&q=80',
        rating: 4.9,
        reviewCount: 234,
        inStock: true,
        stockQuantity: 10,
        features: [
          '5kW output',
          '12 panels included',
          'Installation included',
          '5-year warranty',
        ],
        brand: 'Sunspot',
      ),
      Product(
        id: '8',
        name: 'Solar Monitoring System',
        description:
            'Real-time monitoring system for your solar installation. Track production and consumption.',
        price: 35000,
        currency: 'KES',
        category: 'Monitoring',
        imageUrl:
            'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=900&q=80',
        rating: 4.6,
        reviewCount: 78,
        inStock: true,
        stockQuantity: 35,
        features: [
          'Real-time data',
          'Mobile app',
          'Historical reports',
          'Alert notifications',
        ],
        brand: 'SolarEdge',
      ),
    ];
  }

  Future<Product> getProductById(String id) async {
    final products = await fetchProducts();
    return products.firstWhere((p) => p.id == id);
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    final products = await fetchProducts();
    return products.where((p) => p.category == category).toList();
  }

  Future<List<String>> getCategories() async {
    final products = await fetchProducts();
    return products.map((p) => p.category).toSet().toList();
  }
}
