import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunspot/shared/widgets/cards/stat_card.dart';
import 'package:sunspot/shared/widgets/layout/screen_wrapper.dart';
import 'package:sunspot/features/auth/bloc/auth_bloc.dart';
import 'package:sunspot/features/auth/bloc/auth_state.dart';

class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final userName = authState is AuthAuthenticated
            ? authState.user.name
            : 'Staff';

        return ScreenWrapper(
          title: 'Staff Dashboard',
          showDrawer: true,
          userRole: 'staff',
          userName: userName,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $userName 👋',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: const [
                  StatCard(
                    title: 'New Leads',
                    value: '12',
                    icon: Icons.person_add,
                  ),
                  StatCard(
                    title: 'Pending Quotes',
                    value: '8',
                    icon: Icons.description,
                  ),
                  StatCard(
                    title: 'Active Installations',
                    value: '5',
                    icon: Icons.build,
                  ),
                  StatCard(
                    title: 'Completed Today',
                    value: '3',
                    icon: Icons.check_circle,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Today\'s Tasks',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildTaskItem('Site survey - John Doe', '9:00 AM'),
              _buildTaskItem('Installation - Mary Smith', '11:00 AM'),
              _buildTaskItem('Quote review - ACME Corp', '2:00 PM'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaskItem(String title, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF0EA5E9),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
