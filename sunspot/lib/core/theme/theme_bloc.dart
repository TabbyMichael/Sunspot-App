import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

enum AppThemeMode { light, dark }

class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ToggleTheme extends ThemeEvent {}

class SetTheme extends ThemeEvent {
  final AppThemeMode mode;

  const SetTheme(this.mode);

  @override
  List<Object?> get props => [mode];
}

class ThemeState extends Equatable {
  final AppThemeMode mode;

  const ThemeState({this.mode = AppThemeMode.light});

  ThemeState copyWith({AppThemeMode? mode}) {
    return ThemeState(mode: mode ?? this.mode);
  }

  @override
  List<Object?> get props => [mode];
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ToggleTheme>(_onToggleTheme);
    on<SetTheme>(_onSetTheme);
  }

  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) {
    final newMode = state.mode == AppThemeMode.dark
        ? AppThemeMode.light
        : AppThemeMode.dark;
    print('ToggleTheme: current mode = ${state.mode}, new mode = $newMode');
    emit(state.copyWith(mode: newMode));
  }

  void _onSetTheme(SetTheme event, Emitter<ThemeState> emit) {
    print('SetTheme: ${event.mode}');
    emit(state.copyWith(mode: event.mode));
  }
}
