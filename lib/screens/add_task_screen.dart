import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../services/firestore_service.dart';
import '../theme/app_theme.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final titleController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  Future<void> saveTask() async {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      Get.snackbar('Oops', 'Please describe your task');
      return;
    }

    await FirestoreService.addTask(title);
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Task',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                Icon(Icons.note_add_outlined, color: AppColors.textDark),
              ],
            ),
            const Gap(24),
            TudeeTextField(
              controller: titleController,
              hint: 'What needs to be done?',
              minLines: 2,
              maxLines: 4,
            ),
            const Gap(16),
            PrimaryButton(label: 'Save', onPressed: saveTask),
          ],
        ),
      ),
    );
  }
}