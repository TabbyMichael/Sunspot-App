import 'package:flutter_test/flutter_test.dart';
import 'package:sunspot/features/auth/bloc/auth_bloc.dart';
import 'package:sunspot/features/auth/bloc/auth_event.dart';
import 'package:sunspot/features/auth/bloc/auth_state.dart';
import 'helpers/fake_auth_repository.dart';

void main() {
  test('emits loading then error when login fails', () async {
    final repo = FakeAuthRepository(loginShouldThrow: true);
    final bloc = AuthBloc(repo);

    final expected = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<AuthLoading>(),
        isA<AuthError>().having(
          (state) => state.message,
          'message',
          contains('Invalid credentials'),
        ),
      ]),
    );

    bloc.add(const LoginRequested('bad@user.com', 'wrong'));

    await expected;
    await bloc.close();
  });
}
