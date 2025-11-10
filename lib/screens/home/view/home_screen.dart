import 'package:checklist_app/app/config/l10n/l10n.dart';
import 'package:checklist_app/data/models/checklist_item_model.dart';
import 'package:checklist_app/data/repo/checklist_repo.dart';
import 'package:checklist_app/screens/home/cubit/checklist_cubit.dart';
import 'package:checklist_app/screens/home/cubit/checklist_state.dart';
import 'package:checklist_app/screens/home/widgets/add_edit_checklist_dialog.dart';
import 'package:checklist_app/screens/home/widgets/checklist_empty_state.dart';
import 'package:checklist_app/screens/home/widgets/checklist_item_card.dart';
import 'package:checklist_app/screens/home/widgets/checklist_item_detail_dialog.dart';
import 'package:checklist_app/screens/home/widgets/checklist_sort_chips.dart';
import 'package:checklist_app/screens/home/widgets/checklist_stats_bar.dart';
import 'package:checklist_app/screens/home/widgets/filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:checklist_app/app/config/di/di.dart';
import 'package:checklist_app/app/config/themes/app_colors.dart';
import 'package:checklist_app/app/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChecklistCubit(getIt<ChecklistRepository>())..loadItems(),
      child: const ChecklistView(),
    );
  }
}

class ChecklistView extends StatelessWidget {
  const ChecklistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
        actions: [
          BlocBuilder<ChecklistCubit, ChecklistState>(
            builder: (context, state) {
              final hasFilters = state.hasActiveFilters;

              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (_) => BlocProvider.value(
                          value: context.read<ChecklistCubit>(),
                          child: const FilterBottomSheet(),
                        ),
                      );
                    },
                  ),
                  if (hasFilters)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              final cubit = context.read<ChecklistCubit>();
              switch (value) {
                case 'delete_completed':
                  _showDeleteCompletedDialog(context, cubit);
                  break;
                case 'delete_all':
                  _showDeleteAllDialog(context, cubit);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete_completed',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, size: 20),
                    SizedBox(width: 12),
                    Text('Delete Completed'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_forever, size: 20, color: AppColors.red),
                    SizedBox(width: 12),
                    Text('Delete All', style: TextStyle(color: AppColors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<ChecklistCubit, ChecklistState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isFailure) {
            return _buildErrorState(context, state);
          }

          return _buildContent(context, state);
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(context),
        backgroundColor: context.colorScheme.primary,
        foregroundColor: AppColors.white,
        elevation: 6,
        icon: const Icon(Icons.add_rounded, size: 24),
        label: const Text(
          'Add Item',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showAddEditDialog(BuildContext context, {ChecklistItemModel? item}) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<ChecklistCubit>(),
        child: AddEditChecklistDialog(item: item),
      ),
    );
  }

  void _showItemDetail(
    BuildContext context, {
    required ChecklistItemModel item,
  }) {
    final cubit = context.read<ChecklistCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: ChecklistItemDetailDialog(
          item: item,
          onEdit: () {
            if (dialogContext.mounted) {
              _showAddEditDialog(context, item: item);
            }
          },
          onToggle: () {
            cubit.toggleCompletion(item).catchError((error) {
              if (dialogContext.mounted) {
                _showErrorSnackBar(context, 'Failed to update item');
              }
            });
          },
          onDelete: () {
            context.pop();
            cubit.deleteItem(item.id).catchError((error) {
              if (dialogContext.mounted) {
                _showErrorSnackBar(context, 'Failed to delete item');
              }
            });
          },
        ),
      ),
    );
  }

  void _showDeleteCompletedDialog(BuildContext context, ChecklistCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Completed Items?'),
        content: const Text(
          'This will permanently delete all completed items.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              context.pop();
              try {
                await cubit.deleteCompletedItems();
              } catch (e) {
                if (context.mounted) {
                  _showErrorSnackBar(
                    context,
                    'Failed to delete completed items',
                  );
                }
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog(BuildContext context, ChecklistCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete All Items?'),
        content: const Text(
          'This will permanently delete ALL checklist items. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              context.pop();
              try {
                await cubit.deleteAllItems();
              } catch (e) {
                if (context.mounted) {
                  _showErrorSnackBar(context, 'Failed to delete all items');
                }
              }
            },
            child: const Text(
              'Delete All',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ChecklistState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              state.errorMessage ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<ChecklistCubit>().loadItems(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ChecklistState state) {
    return RefreshIndicator(
      onRefresh: () => context.read<ChecklistCubit>().loadItems(),
      color: context.colorScheme.primary,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Stats bar - always show
          SliverToBoxAdapter(
            child: ChecklistStatsBar(
              total: state.totalCount,
              completed: state.completedCount,
              pending: state.incompleteCount,
            ),
          ),
          // Sort options - always show
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: ChecklistSortChips(
                currentSort: state.sortType,
                onSortChanged: (sortType) =>
                    context.read<ChecklistCubit>().changeSortType(sortType),
              ),
            ),
          ),
          if (state.hasFilteredItems)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = state.filteredItems[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ChecklistItemCard(
                      item: item,
                      onToggle: () => _handleToggleCompletion(context, item),
                      onEdit: () => _showAddEditDialog(context, item: item),
                      onDelete: () => _handleDeleteItem(context, item.id),
                      onTap: () => _showItemDetail(context, item: item),
                    ),
                  );
                }, childCount: state.filteredItems.length),
              ),
            )
          else
            // Empty state
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: ChecklistEmptyState(
                  hasFilters: state.hasActiveFilters,
                  hasItems: state.hasItems,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleToggleCompletion(BuildContext context, ChecklistItemModel item) {
    context.read<ChecklistCubit>().toggleCompletion(item).catchError((error) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Failed to update item');
      }
    });
  }

  void _handleDeleteItem(BuildContext context, String id) {
    context.read<ChecklistCubit>().deleteItem(id).catchError((error) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Failed to delete item');
      }
    });
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
