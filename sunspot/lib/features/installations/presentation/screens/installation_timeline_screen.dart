import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunspot/core/theme/app_colors.dart';
import 'package:sunspot/core/theme/app_spacing.dart';
import 'package:sunspot/features/installations/bloc/installations_bloc.dart';
import 'package:sunspot/features/installations/bloc/installations_event.dart';
import 'package:sunspot/features/installations/bloc/installations_state.dart';
import 'package:sunspot/features/installations/data/models/installation.dart';
import 'package:sunspot/shared/widgets/badges/status_badge.dart';
import 'package:sunspot/shared/widgets/buttons/primary_button.dart';
import 'package:sunspot/shared/widgets/cards/app_card.dart';
import 'package:sunspot/shared/widgets/inputs/app_text_field.dart';
import 'package:sunspot/shared/widgets/layout/screen_wrapper.dart';
import 'package:sunspot/shared/widgets/loading/circular_spinner.dart';

class InstallationTimelineScreen extends StatefulWidget {
  final String installationId;

  const InstallationTimelineScreen({super.key, required this.installationId});

  @override
  State<InstallationTimelineScreen> createState() =>
      _InstallationTimelineScreenState();
}

class _InstallationTimelineScreenState
    extends State<InstallationTimelineScreen> {
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<InstallationsBloc>().add(
      FetchInstallationDetails(widget.installationId),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      title: 'Installation Tracker',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            context.read<InstallationsBloc>().add(
              FetchInstallationDetails(widget.installationId),
            );
          },
        ),
      ],
      child: BlocBuilder<InstallationsBloc, InstallationsState>(
        builder: (context, state) {
          if (state is InstallationsLoading) {
            return const Center(child: CircularSpinner());
          }

          if (state is InstallationsError) {
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

          if (state is InstallationDetailsLoaded) {
            final installation = state.installation;
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
                              installation.customerName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            StatusBadge(status: installation.status),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('Order ID', installation.orderId),
                        const SizedBox(height: 8),
                        _buildInfoRow('Address', installation.address),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Installation Progress',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTimeline(installation),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTimeline(Installation installation) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: List.generate(installation.steps.length, (index) {
          final step = installation.steps[index];
          final isLast = index == installation.steps.length - 1;

          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepIcon(step.status),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: step.status == 'done'
                                ? AppColors.success
                                : Colors.white,
                          ),
                        ),
                        if (step.timestamp != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(step.timestamp!),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                        if (step.notes != null && step.notes!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              step.notes!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                        ],
                        if (step.status == 'active') ...[
                          const SizedBox(height: 12),
                          AppTextField(
                            hint: 'Add notes...',
                            controller: _noteController,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 8),
                          PrimaryButton(
                            label: 'Complete Step',
                            onPressed: () {
                              if (_noteController.text.isNotEmpty) {
                                context.read<InstallationsBloc>().add(
                                  UpdateInstallationStep(
                                    widget.installationId,
                                    step.id,
                                    'done',
                                    notes: _noteController.text,
                                  ),
                                );
                                _noteController.clear();
                              } else {
                                context.read<InstallationsBloc>().add(
                                  UpdateInstallationStep(
                                    widget.installationId,
                                    step.id,
                                    'done',
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                        if (step.status == 'pending' && index > 0) ...[
                          const SizedBox(height: 12),
                          PrimaryButton(
                            label: 'Start Step',
                            onPressed: () {
                              context.read<InstallationsBloc>().add(
                                UpdateInstallationStep(
                                  widget.installationId,
                                  step.id,
                                  'active',
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (!isLast)
                _buildConnector(
                  step.status,
                  installation.steps[index + 1].status,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStepIcon(String status) {
    Color color;
    IconData icon;

    switch (status) {
      case 'done':
        color = AppColors.success;
        icon = Icons.check_circle;
        break;
      case 'active':
        color = AppColors.primary;
        icon = Icons.adjust;
        break;
      default:
        color = AppColors.textMuted;
        icon = Icons.circle_outlined;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildConnector(String currentStatus, String nextStatus) {
    final isActive =
        currentStatus == 'done' &&
        (nextStatus == 'active' || nextStatus == 'done');

    return Container(
      margin: const EdgeInsets.only(left: 16),
      height: 40,
      width: 2,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.border,
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
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
