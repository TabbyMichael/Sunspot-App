import 'package:flutter_test/flutter_test.dart';
import 'package:sunspot/core/models/user.dart';
import 'package:sunspot/features/auth/bloc/auth_bloc.dart';
import 'package:sunspot/features/auth/bloc/auth_event.dart';
import 'package:sunspot/features/auth/bloc/auth_state.dart';
import 'helpers/fake_auth_repository.dart';

void main() {
  test('auth check emits loading then authenticated when token and user exist', () async {
    final repo = FakeAuthRepository(
      authenticated: true,
      token: 'token-abc',
      currentUser: User(
        id: '2',
        email: 'customer@sunspot.com',
        name: 'Customer User',
        role: 'customer',
      ),
    );
    final bloc = AuthBloc(repo);

    final expected = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<AuthLoading>(),
        isA<AuthAuthenticated>()
            .having((state) => state.user.role, 'user.role', 'customer')
            .having((state) => state.token, 'token', 'token-abc'),
      ]),
    );

    bloc.add(AuthCheckRequested());

    await expected;
    await bloc.close();
  });
}
