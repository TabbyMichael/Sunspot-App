import 'package:equatable/equatable.dart';
import '../data/models/installation.dart';

abstract class InstallationsState extends Equatable {
  const InstallationsState();

  @override
  List<Object?> get props => [];
}

class InstallationsInitial extends InstallationsState {}

class InstallationsLoading extends InstallationsState {}

class InstallationsLoaded extends InstallationsState {
  final List<Installation> installations;

  const InstallationsLoaded(this.installations);

  @override
  List<Object?> get props => [installations];
}

class InstallationDetailsLoaded extends InstallationsState {
  final Installation installation;

  const InstallationDetailsLoaded(this.installation);

  @override
  List<Object?> get props => [installation];
}

class InstallationsError extends InstallationsState {
  final String message;

  const InstallationsError(this.message);

  @override
  List<Object?> get props => [message];
}
