import 'package:flutter_test/flutter_test.dart';
import 'package:sunspot/features/auth/bloc/auth_bloc.dart';
import 'package:sunspot/features/auth/bloc/auth_event.dart';
import 'package:sunspot/features/auth/bloc/auth_state.dart';
import 'helpers/fake_auth_repository.dart';

void main() {
  test('emits unauthenticated on logout', () async {
    final repo = FakeAuthRepository();
    final bloc = AuthBloc(repo);

    final expected = expectLater(
      bloc.stream,
      emitsInOrder([isA<AuthUnauthenticated>()]),
    );

    bloc.add(LogoutRequested());

    await expected;
    expect(repo.logoutCalled, isTrue);
    await bloc.close();
  });
}
