import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;

  // مجموعة المهام
  static final tasks = _db.collection('tasks');

  // مستند واحد بنخزن فيه اسم المستخدم
  static final profile = _db.collection('settings').doc('profile');

  // ---------- الاسم ----------

  static Future<String?> getName() async {
    final doc = await profile.get();
    return doc.data()?['name'] as String?;
  }

  static Future<void> saveName(String name) {
    return profile.set({'name': name});
  }

  // ---------- المهام ----------

  /// Live list of tasks (newest first). Updates automatically.
  static Stream<List<TaskModel>> watchTasks() {
    return tasks
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(TaskModel.fromDoc).toList());
  }

  static Future<void> addTask(String title) {
    return tasks.add({
      'title': title,
      'isDone': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> updateTask(String id, String title, bool isDone) {
    return tasks.doc(id).update({'title': title, 'isDone': isDone});
  }
}