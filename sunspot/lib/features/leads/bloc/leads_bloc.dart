import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/leads_repository.dart';
import '../data/models/lead.dart';
import 'leads_event.dart';
import 'leads_state.dart';

class LeadsBloc extends Bloc<LeadsEvent, LeadsState> {
  final LeadsRepository _leadsRepository;

  LeadsBloc(this._leadsRepository) : super(LeadsInitial()) {
    on<FetchLeads>(_onFetchLeads);
    on<FetchLeadDetails>(_onFetchLeadDetails);
    on<UpdateLeadStatus>(_onUpdateLeadStatus);
    on<AddLeadNote>(_onAddLeadNote);
  }

  Future<void> _onFetchLeads(
    FetchLeads event,
    Emitter<LeadsState> emit,
  ) async {
    emit(LeadsLoading());
    try {
      final leads = await _leadsRepository.fetchLeads();
      emit(LeadsLoaded(leads));
    } catch (e) {
      emit(LeadsError(e.toString()));
    }
  }

  Future<void> _onFetchLeadDetails(
    FetchLeadDetails event,
    Emitter<LeadsState> emit,
  ) async {
    emit(LeadsLoading());
    try {
      final lead = await _leadsRepository.getLeadById(event.leadId);
      emit(LeadDetailsLoaded(lead));
    } catch (e) {
      emit(LeadsError(e.toString()));
    }
  }

  Future<void> _onUpdateLeadStatus(
    UpdateLeadStatus event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      final updatedLead = await _leadsRepository.updateLeadStatus(
        event.leadId,
        event.status,
      );
      
      if (state is LeadsLoaded) {
        final currentLeads = (state as LeadsLoaded).leads;
        final updatedLeads = currentLeads.map((lead) {
          return lead.id == event.leadId ? updatedLead : lead;
        }).toList();
        emit(LeadsLoaded(updatedLeads));
      }
    } catch (e) {
      emit(LeadsError(e.toString()));
    }
  }

  Future<void> _onAddLeadNote(
    AddLeadNote event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      await _leadsRepository.addNoteToLead(event.leadId, event.note);
      
      if (state is LeadsLoaded) {
        final currentLeads = (state as LeadsLoaded).leads;
        final lead = currentLeads.firstWhere((l) => l.id == event.leadId);
        final updatedLead = Lead(
          id: lead.id,
          customerName: lead.customerName,
          customerEmail: lead.customerEmail,
          customerPhone: lead.customerPhone,
          address: lead.address,
          status: lead.status,
          notes: event.note,
          createdAt: lead.createdAt,
          updatedAt: DateTime.now(),
        );
        
        final updatedLeads = currentLeads.map((l) {
          return l.id == event.leadId ? updatedLead : l;
        }).toList();
        emit(LeadsLoaded(updatedLeads));
      }
    } catch (e) {
      emit(LeadsError(e.toString()));
    }
  }
}
