import 'package:flutter_test/flutter_test.dart';
import 'package:sunspot/features/products/bloc/products_bloc.dart';
import 'package:sunspot/features/products/bloc/products_event.dart';
import 'package:sunspot/features/products/bloc/products_state.dart';
import 'helpers/fake_products_repository.dart';

void main() {
  test('emits matching products when searching by query', () async {
    final bloc = ProductsBloc(FakeProductsRepository());

    final expected = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<ProductsLoading>(),
        isA<ProductsLoaded>()
            .having((state) => state.products.length, 'products.length', 1)
            .having((state) => state.products.first.name, 'first.name', 'Battery Max'),
      ]),
    );

    bloc.add(const SearchProducts('storage'));

    await expected;
    await bloc.close();
  });
}
