import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../models/task_model.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskModel task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController titleController;
  late bool isDone;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    isDone = widget.task.isDone;
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  Future<void> saveChanges() async {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      Get.snackbar('Oops', 'Task title cannot be empty');
      return;
    }

    await FirestoreService.updateTask(widget.task.id, title, isDone);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: tudeeAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(16),
            const Text(
              'Edit Task',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const Gap(24),
            TudeeTextField(
              controller: titleController,
              hint: 'What needs to be done?',
              minLines: 3,
              maxLines: 5,
            ),
            const Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDone ? Colors.grey : AppColors.todo,
                  ),
                  onPressed: () => setState(() => isDone = false),
                  child: const Text('To Do', style: TextStyle(color: Colors.white)),
                ),
                const Gap(16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDone ? AppColors.done : Colors.grey,
                  ),
                  onPressed: () => setState(() => isDone = true),
                  child: const Text('Done', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const Gap(16),
            PrimaryButton(label: 'Save changes', onPressed: saveChanges),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: selected ? 1.0 : 0.5,
        child: Container(
          width: 102,
          height: 38,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            border: selected ? Border.all(color: Colors.white, width: 2) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selected) ...[
                Icon(icon, color: Colors.white, size: 16),
                const Gap(4),
              ],
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}