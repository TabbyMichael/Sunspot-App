import 'package:equatable/equatable.dart';

abstract class InstallationsEvent extends Equatable {
  const InstallationsEvent();

  @override
  List<Object?> get props => [];
}

class FetchInstallations extends InstallationsEvent {}

class FetchInstallationDetails extends InstallationsEvent {
  final String installationId;

  const FetchInstallationDetails(this.installationId);

  @override
  List<Object?> get props => [installationId];
}

class UpdateInstallationStep extends InstallationsEvent {
  final String installationId;
  final String stepId;
  final String status;
  final String? notes;

  const UpdateInstallationStep(
    this.installationId,
    this.stepId,
    this.status, {
    this.notes,
  });

  @override
  List<Object?> get props => [installationId, stepId, status, notes];
}

class UpdateInstallationStatus extends InstallationsEvent {
  final String installationId;
  final String status;

  const UpdateInstallationStatus(this.installationId, this.status);

  @override
  List<Object?> get props => [installationId, status];
}
