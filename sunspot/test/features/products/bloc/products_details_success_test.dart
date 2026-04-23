import 'package:flutter_test/flutter_test.dart';
import 'package:sunspot/features/products/bloc/products_bloc.dart';
import 'package:sunspot/features/products/bloc/products_event.dart';
import 'package:sunspot/features/products/bloc/products_state.dart';
import 'helpers/fake_products_repository.dart';

void main() {
  test('emits loading then details loaded for a valid product id', () async {
    final bloc = ProductsBloc(FakeProductsRepository());

    final expected = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<ProductsLoading>(),
        isA<ProductDetailsLoaded>()
            .having((state) => state.product.id, 'product.id', '1'),
      ]),
    );

    bloc.add(const FetchProductDetails('1'));

    await expected;
    await bloc.close();
  });
}
