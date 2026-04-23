import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunspot/shared/widgets/badges/status_badge.dart';
import 'package:sunspot/shared/widgets/buttons/primary_button.dart';
import 'package:sunspot/shared/widgets/cards/app_card.dart';
import 'package:sunspot/shared/widgets/inputs/app_text_field.dart';
import 'package:sunspot/shared/widgets/layout/screen_wrapper.dart';
import 'package:sunspot/core/theme/app_spacing.dart';
import 'package:sunspot/features/leads/bloc/leads_bloc.dart';
import 'package:sunspot/features/leads/bloc/leads_event.dart';
import 'package:sunspot/features/leads/bloc/leads_state.dart';
import 'package:sunspot/features/leads/data/models/lead.dart';

class LeadDetailScreen extends StatefulWidget {
  final String leadId;

  const LeadDetailScreen({super.key, required this.leadId});

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      title: 'Lead Details',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            context.read<LeadsBloc>().add(FetchLeadDetails(widget.leadId));
          },
        ),
      ],
      child: BlocBuilder<LeadsBloc, LeadsState>(
        builder: (context, state) {
          if (state is LeadsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LeadsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }

          if (state is LeadDetailsLoaded) {
            final lead = state.lead;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lead.customerName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            StatusBadge(status: lead.status),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('Email', lead.customerEmail),
                        const SizedBox(height: 8),
                        _buildInfoRow('Phone', lead.customerPhone),
                        const SizedBox(height: 8),
                        _buildInfoRow('Address', lead.address),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          'Created',
                          _formatDate(lead.createdAt),
                        ),
                        if (lead.updatedAt != null) ...[
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Updated',
                            _formatDate(lead.updatedAt!),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Update Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildStatusButton('new', lead.status),
                      _buildStatusButton('contacted', lead.status),
                      _buildStatusButton('qualified', lead.status),
                      _buildStatusButton('converted', lead.status),
                      _buildStatusButton('lost', lead.status),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Notes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (lead.notes != null && lead.notes!.isNotEmpty)
                    AppCard(
                      child: Text(
                        lead.notes!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    )
                  else
                    const AppCard(
                      child: Text(
                        'No notes added',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  AppTextField(
                    hint: 'Add a note...',
                    controller: _noteController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'Add Note',
                    onPressed: () {
                      if (_noteController.text.isNotEmpty) {
                        context.read<LeadsBloc>().add(
                              AddLeadNote(
                                widget.leadId,
                                _noteController.text,
                              ),
                            );
                        _noteController.clear();
                      }
                    },
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusButton(String status, String currentStatus) {
    final isSelected = status == currentStatus;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFFF59E0B) : const Color(0xFF1F2937),
        foregroundColor: isSelected ? Colors.white : const Color(0xFF9CA3AF),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        context.read<LeadsBloc>().add(
              UpdateLeadStatus(widget.leadId, status),
            );
      },
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
