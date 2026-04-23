import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunspot/shared/widgets/badges/status_badge.dart';
import 'package:sunspot/shared/widgets/cards/app_card.dart';
import 'package:sunspot/shared/widgets/layout/screen_wrapper.dart';
import 'package:sunspot/features/installations/bloc/installations_bloc.dart';
import 'package:sunspot/features/installations/bloc/installations_event.dart';
import 'package:sunspot/features/installations/bloc/installations_state.dart';
import 'package:sunspot/features/auth/bloc/auth_bloc.dart';
import 'package:sunspot/features/auth/bloc/auth_state.dart';

class InstallationsListScreen extends StatefulWidget {
  const InstallationsListScreen({super.key});

  @override
  State<InstallationsListScreen> createState() =>
      _InstallationsListScreenState();
}

class _InstallationsListScreenState extends State<InstallationsListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<InstallationsBloc>().add(FetchInstallations());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final userName = authState is AuthAuthenticated
            ? authState.user.name
            : 'Staff';
        final userRole = authState is AuthAuthenticated
            ? authState.user.role
            : 'staff';

        return ScreenWrapper(
          title: 'Installations',
          showDrawer: true,
          userRole: userRole,
          userName: userName,
          child: BlocBuilder<InstallationsBloc, InstallationsState>(
            builder: (context, state) {
              if (state is InstallationsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is InstallationsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<InstallationsBloc>().add(
                            FetchInstallations(),
                          );
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is InstallationsLoaded) {
                if (state.installations.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.build, size: 48, color: Color(0xFF9CA3AF)),
                        SizedBox(height: 16),
                        Text(
                          'No installations found',
                          style: TextStyle(color: Color(0xFF9CA3AF)),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: state.installations.length,
                  itemBuilder: (context, index) {
                    final installation = state.installations[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/installations/${installation.id}',
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  installation.customerName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                StatusBadge(status: installation.status),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              installation.address,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Color(0xFF6B7280),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatDate(installation.createdAt),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildProgressIndicator(installation),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator(dynamic installation) {
    final completedSteps = installation.steps
        .where((s) => s.status == 'done')
        .length;
    final totalSteps = installation.steps.length;
    final progress = completedSteps / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Progress',
              style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
            ),
            Text(
              '$completedSteps/$totalSteps steps',
              style: const TextStyle(fontSize: 12, color: Color(0xFFF59E0B)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFF374151),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
