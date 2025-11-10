import 'package:checklist_app/app/config/l10n/l10n.dart';
import 'package:checklist_app/data/repo/checklist_repo.dart';
import 'package:checklist_app/screens/dashboard/widgets/dashboard_empty_state.dart';
import 'package:checklist_app/screens/dashboard/widgets/dashboard_overview_cards.dart';
import 'package:checklist_app/screens/dashboard/widgets/dashboard_section_title.dart';
import 'package:checklist_app/screens/dashboard/widgets/dashboard_welcome_header.dart';
import 'package:checklist_app/screens/home/cubit/checklist_cubit.dart';
import 'package:checklist_app/screens/home/cubit/checklist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:checklist_app/app/config/di/di.dart';
import 'package:checklist_app/app/core/extensions/context_extension.dart';
import 'package:checklist_app/screens/dashboard/widgets/completion_chart.dart';
import 'package:checklist_app/screens/dashboard/widgets/priority_chart.dart';
import 'package:checklist_app/screens/dashboard/widgets/priority_breakdown.dart';
import 'package:checklist_app/app/core/extensions/stats_extensions.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChecklistCubit(getIt<ChecklistRepository>()),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.dashboard)),
      body: BlocBuilder<ChecklistCubit, ChecklistState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!state.hasItems) {
            return const DashboardEmptyState();
          }

          final stats = context.read<ChecklistCubit>().getStatistics();
          final completionRate = context
              .read<ChecklistCubit>()
              .getCompletionRate();

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<ChecklistCubit>().loadItems();
            },
            color: context.colorScheme.primary,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardWelcomeHeader(
                    totalItems: stats.totalItems,
                    completedItems: stats.completedItems,
                  ),
                  const SizedBox(height: 24),

                  DashboardOverviewCards(
                    totalItems: stats.totalItems,
                    completedItems: stats.completedItems,
                    incompleteItems: stats.incompleteItems,
                    completionRate: completionRate,
                  ),
                  const SizedBox(height: 28),

                  DashboardSectionTitle(title: 'Completion Status'),
                  const SizedBox(height: 16),
                  CompletionChart(
                    completed: stats.completedItems,
                    incomplete: stats.incompleteItems,
                  ),
                  const SizedBox(height: 28),

                  DashboardSectionTitle(title: 'Priority Distribution'),
                  const SizedBox(height: 16),
                  PriorityChart(stats: stats),
                  const SizedBox(height: 28),

                  DashboardSectionTitle(title: 'Priority Breakdown'),
                  const SizedBox(height: 16),
                  PriorityBreakdown(stats: stats),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
