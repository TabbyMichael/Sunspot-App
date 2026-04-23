import 'package:equatable/equatable.dart';
import 'package:sunspot/features/products/data/models/product.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final List<String> categories;

  const ProductsLoaded(this.products, this.categories);

  @override
  List<Object?> get props => [products, categories];
}

class ProductDetailsLoaded extends ProductsState {
  final Product product;

  const ProductDetailsLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object?> get props => [message];
}
