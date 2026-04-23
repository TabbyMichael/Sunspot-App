import 'package:flutter_test/flutter_test.dart';
import 'package:sunspot/features/products/bloc/products_bloc.dart';
import 'package:sunspot/features/products/bloc/products_event.dart';
import 'package:sunspot/features/products/bloc/products_state.dart';
import 'helpers/fake_products_repository.dart';

void main() {
  test('emits loading then loaded when fetching all products', () async {
    final bloc = ProductsBloc(FakeProductsRepository());

    final expected = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<ProductsLoading>(),
        isA<ProductsLoaded>()
            .having((state) => state.products.length, 'products.length', 2)
            .having((state) => state.categories.length, 'categories.length', 2),
      ]),
    );

    bloc.add(const FetchProducts());

    await expected;
    await bloc.close();
  });
}
