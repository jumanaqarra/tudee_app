import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../models/task_model.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

class HomeScreen extends StatelessWidget {
  final String name;

  const HomeScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: tudeeAppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        onPressed: () => Get.to(() => const AddTaskScreen()),
        child: const Icon(Icons.note_add_outlined, color: Colors.white),
      ),
      body: StreamBuilder<List<TaskModel>>(
        stream: FirestoreService.watchTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data!;
          final done = tasks.where((t) => t.isDone).length;
          final todo = tasks.length - done;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 100),
            children: [
              // كارد الترحيب والعدادات
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome $name', style: const TextStyle(fontSize: 20)),
                    const Gap(8),
                    Row(
                      children: [
                        _counter('Done', done, AppColors.done),
                        const Gap(8),
                        _counter('To-Do', todo, AppColors.todo),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(16),

              // المهام
              if (tasks.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('No tasks for today!', style: TextStyle(fontSize: 16)),
                      Gap(4),
                      Text(
                        'Tap the + button to add your first one.',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                )
              else
                for (final task in tasks) ...[
                  GestureDetector(
                    onTap: () => Get.to(() => EditTaskScreen(task: task)),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: task.isDone
                                  ? AppColors.done
                                  : AppColors.todo,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              task.isDone ? 'Done' : 'TODO',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Gap(12),
                          Text(task.title, style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                  const Gap(12),
                ],
            ],
          );
        },
      ),
    );
  }

  // دالة وحدة بترسم كارد العداد (بتستخدم مرتين: Done و To-Do)
  Widget _counter(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}