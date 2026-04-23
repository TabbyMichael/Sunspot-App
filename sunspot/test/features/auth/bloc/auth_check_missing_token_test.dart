import 'package:flutter_test/flutter_test.dart';
import 'package:sunspot/core/models/user.dart';
import 'package:sunspot/features/auth/bloc/auth_bloc.dart';
import 'package:sunspot/features/auth/bloc/auth_event.dart';
import 'package:sunspot/features/auth/bloc/auth_state.dart';
import 'helpers/fake_auth_repository.dart';

void main() {
  test('auth check emits loading then unauthenticated when token missing', () async {
    final repo = FakeAuthRepository(
      authenticated: true,
      currentUser: User(
        id: '2',
        email: 'customer@sunspot.com',
        name: 'Customer User',
        role: 'customer',
      ),
      token: null,
    );
    final bloc = AuthBloc(repo);

    final expected = expectLater(
      bloc.stream,
      emitsInOrder([isA<AuthLoading>(), isA<AuthUnauthenticated>()]),
    );

    bloc.add(AuthCheckRequested());

    await expected;
    await bloc.close();
  });
}
