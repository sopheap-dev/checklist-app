import 'package:checklist_app/app/core/utils/errors/failures.dart';
import 'package:checklist_app/app/core/utils/priority_util.dart';
import 'package:checklist_app/screens/home/cubit/checklist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:checklist_app/data/models/checklist_item_model.dart';

class AddEditChecklistDialog extends StatefulWidget {
  final ChecklistItemModel? item;

  const AddEditChecklistDialog({super.key, this.item});

  @override
  State<AddEditChecklistDialog> createState() => _AddEditChecklistDialogState();
}

class _AddEditChecklistDialogState extends State<AddEditChecklistDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late Priority _selectedPriority;
  DateTime? _selectedDueDate;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.item?.description ?? '',
    );
    _selectedPriority = widget.item?.priority ?? Priority.medium;
    _selectedDueDate = widget.item?.dueDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.item != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isEdit ? Icons.edit : Icons.add_circle,
                        color: Theme.of(context).colorScheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isEdit ? 'Edit Item' : 'Add New Item',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title *',
                      hintText: 'Enter item title',
                      prefixIcon: const Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: !isEdit,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter item description (optional)',
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                    maxLength: 1000,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value != null && value.trim().length > 1000) {
                        return 'Description cannot exceed 1000 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Priority *',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: Priority.values.map((priority) {
                      return _buildPriorityChip(priority);
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Due Date',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectDueDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedDueDate == null
                                      ? 'No due date & time'
                                      : DateFormat.yMMMd().format(
                                          _selectedDueDate!,
                                        ),
                                  style: TextStyle(
                                    color: _selectedDueDate == null
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant
                                        : null,
                                    fontWeight: _selectedDueDate == null
                                        ? FontWeight.normal
                                        : FontWeight.w600,
                                  ),
                                ),
                                if (_selectedDueDate != null)
                                  Text(
                                    DateFormat.jm().format(_selectedDueDate!),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (_selectedDueDate != null)
                            IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                setState(() {
                                  _selectedDueDate = null;
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        key: const Key('addEditSubmitButton'),
                        onPressed: _saveItem,
                        icon: Icon(isEdit ? Icons.save : Icons.add),
                        label: Text(isEdit ? 'Save' : 'Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(Priority priority) {
    final isSelected = _selectedPriority == priority;
    final color = PriorityUtils.getPriorityColor(priority);

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            PriorityUtils.getPriorityIcon(priority),
            size: 16,
            color: isSelected ? Colors.white : color,
          ),
          const SizedBox(width: 4),
          Text(priority.displayName),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedPriority = priority;
        });
      },
      selectedColor: color,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : color,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(color: color),
    );
  }

  Future<void> _selectDueDate() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedDueDate != null
            ? TimeOfDay.fromDateTime(_selectedDueDate!)
            : TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cubit = context.read<ChecklistCubit>();

    try {
      if (widget.item == null) {
        await cubit.addItem(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          priority: _selectedPriority,
          dueDate: _selectedDueDate,
        );
      } else {
        final updatedItem = widget.item!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          priority: _selectedPriority,
          dueDate: _selectedDueDate,
        );
        await cubit.updateItem(updatedItem);
      }

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        _showError(context, e);
      }
    }
  }

  void _showError(BuildContext context, dynamic error) {
    String message = 'An error occurred';

    if (error is ValidationFailure) {
      message = error.message;
    } else {
      final errorString = error.toString();
      if (errorString.contains('ValidationFailure')) {
        message = errorString
            .replaceAll('ValidationFailure', '')
            .replaceAll('(', '')
            .replaceAll(')', '')
            .trim();
      } else if (errorString.contains('Exception:')) {
        message = errorString.replaceFirst('Exception:', '').trim();
      } else {
        message = errorString;
      }
    }

    if (message.isEmpty) {
      message = 'An error occurred';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
