import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

class FetchProducts extends ProductsEvent {
  final String? category;

  const FetchProducts({this.category});

  @override
  List<Object?> get props => [category];
}

class FetchProductDetails extends ProductsEvent {
  final String productId;

  const FetchProductDetails(this.productId);

  @override
  List<Object?> get props => [productId];
}

class SearchProducts extends ProductsEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}
