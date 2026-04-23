import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/installations_repository.dart';
import '../data/models/installation.dart';
import 'installations_event.dart';
import 'installations_state.dart';

class InstallationsBloc extends Bloc<InstallationsEvent, InstallationsState> {
  final InstallationsRepository _installationsRepository;

  InstallationsBloc(this._installationsRepository) : super(InstallationsInitial()) {
    on<FetchInstallations>(_onFetchInstallations);
    on<FetchInstallationDetails>(_onFetchInstallationDetails);
    on<UpdateInstallationStep>(_onUpdateInstallationStep);
    on<UpdateInstallationStatus>(_onUpdateInstallationStatus);
  }

  Future<void> _onFetchInstallations(
    FetchInstallations event,
    Emitter<InstallationsState> emit,
  ) async {
    emit(InstallationsLoading());
    try {
      final installations = await _installationsRepository.fetchInstallations();
      emit(InstallationsLoaded(installations));
    } catch (e) {
      emit(InstallationsError(e.toString()));
    }
  }

  Future<void> _onFetchInstallationDetails(
    FetchInstallationDetails event,
    Emitter<InstallationsState> emit,
  ) async {
    emit(InstallationsLoading());
    try {
      final installation = await _installationsRepository.getInstallationById(event.installationId);
      emit(InstallationDetailsLoaded(installation));
    } catch (e) {
      emit(InstallationsError(e.toString()));
    }
  }

  Future<void> _onUpdateInstallationStep(
    UpdateInstallationStep event,
    Emitter<InstallationsState> emit,
  ) async {
    try {
      final updatedInstallation = await _installationsRepository.updateInstallationStep(
        event.installationId,
        event.stepId,
        event.status,
        notes: event.notes,
      );
      
      if (state is InstallationDetailsLoaded) {
        emit(InstallationDetailsLoaded(updatedInstallation));
      }
    } catch (e) {
      emit(InstallationsError(e.toString()));
    }
  }

  Future<void> _onUpdateInstallationStatus(
    UpdateInstallationStatus event,
    Emitter<InstallationsState> emit,
  ) async {
    try {
      final updatedInstallation = await _installationsRepository.updateInstallationStatus(
        event.installationId,
        event.status,
      );
      
      if (state is InstallationDetailsLoaded) {
        emit(InstallationDetailsLoaded(updatedInstallation));
      }
    } catch (e) {
      emit(InstallationsError(e.toString()));
    }
  }
}
