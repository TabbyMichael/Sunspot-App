import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunspot/features/products/bloc/products_event.dart';
import 'package:sunspot/features/products/bloc/products_state.dart';
import 'package:sunspot/features/products/data/products_repository.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepository _repository;

  ProductsBloc(this._repository) : super(ProductsInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<FetchProductDetails>(_onFetchProductDetails);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<void> _onFetchProducts(
    FetchProducts event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final products = event.category != null
          ? await _repository.getProductsByCategory(event.category!)
          : await _repository.fetchProducts();
      final categories = await _repository.getCategories();
      emit(ProductsLoaded(products, categories));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> _onFetchProductDetails(
    FetchProductDetails event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final product = await _repository.getProductById(event.productId);
      emit(ProductDetailsLoaded(product));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final allProducts = await _repository.fetchProducts();
      final filteredProducts = allProducts
          .where(
            (p) =>
                p.name.toLowerCase().contains(event.query.toLowerCase()) ||
                p.description.toLowerCase().contains(
                  event.query.toLowerCase(),
                ) ||
                p.category.toLowerCase().contains(event.query.toLowerCase()),
          )
          .toList();
      final categories = await _repository.getCategories();
      emit(ProductsLoaded(filteredProducts, categories));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}
