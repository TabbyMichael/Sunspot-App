import 'package:flutter_test/flutter_test.dart';
import 'package:sunspot/features/auth/bloc/auth_bloc.dart';
import 'package:sunspot/features/auth/bloc/auth_event.dart';
import 'package:sunspot/features/auth/bloc/auth_state.dart';
import 'helpers/fake_auth_repository.dart';

void main() {
  test('emits loading then authenticated when login succeeds', () async {
    final repo = FakeAuthRepository(token: 'token-123');
    final bloc = AuthBloc(repo);

    final expected = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<AuthLoading>(),
        isA<AuthAuthenticated>()
            .having((state) => state.user.email, 'user.email', 'staff@sunspot.com')
            .having((state) => state.token, 'token', 'token-123'),
      ]),
    );

    bloc.add(const LoginRequested('staff@sunspot.com', 'demo123'));

    await expected;
    await bloc.close();
  });
}
