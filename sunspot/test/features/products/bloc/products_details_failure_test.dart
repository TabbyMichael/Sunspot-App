import 'package:flutter_test/flutter_test.dart';
import 'package:sunspot/features/products/bloc/products_bloc.dart';
import 'package:sunspot/features/products/bloc/products_event.dart';
import 'package:sunspot/features/products/bloc/products_state.dart';
import 'helpers/fake_products_repository.dart';

void main() {
  test('emits loading then error when fetching details fails', () async {
    final bloc = ProductsBloc(FakeProductsRepository(throwOnDetails: true));

    final expected = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<ProductsLoading>(),
        isA<ProductsError>().having(
          (state) => state.message,
          'message',
          contains('Missing product'),
        ),
      ]),
    );

    bloc.add(const FetchProductDetails('unknown'));

    await expected;
    await bloc.close();
  });
}
