import 'package:equatable/equatable.dart';
import '../data/models/lead.dart';

abstract class LeadsState extends Equatable {
  const LeadsState();

  @override
  List<Object?> get props => [];
}

class LeadsInitial extends LeadsState {}

class LeadsLoading extends LeadsState {}

class LeadsLoaded extends LeadsState {
  final List<Lead> leads;

  const LeadsLoaded(this.leads);

  @override
  List<Object?> get props => [leads];
}

class LeadDetailsLoaded extends LeadsState {
  final Lead lead;

  const LeadDetailsLoaded(this.lead);

  @override
  List<Object?> get props => [lead];
}

class LeadsError extends LeadsState {
  final String message;

  const LeadsError(this.message);

  @override
  List<Object?> get props => [message];
}
