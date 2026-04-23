import 'package:equatable/equatable.dart';

abstract class LeadsEvent extends Equatable {
  const LeadsEvent();

  @override
  List<Object?> get props => [];
}

class FetchLeads extends LeadsEvent {}

class FetchLeadDetails extends LeadsEvent {
  final String leadId;

  const FetchLeadDetails(this.leadId);

  @override
  List<Object?> get props => [leadId];
}

class UpdateLeadStatus extends LeadsEvent {
  final String leadId;
  final String status;

  const UpdateLeadStatus(this.leadId, this.status);

  @override
  List<Object?> get props => [leadId, status];
}

class AddLeadNote extends LeadsEvent {
  final String leadId;
  final String note;

  const AddLeadNote(this.leadId, this.note);

  @override
  List<Object?> get props => [leadId, note];
}
