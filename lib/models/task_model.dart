import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final bool isDone;

  TaskModel({
    required this.id,
    required this.title,
    required this.isDone,
  });

  /// Converts a Firestore document into a TaskModel.
  factory TaskModel.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return TaskModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      isDone: data['isDone'] as bool? ?? false,
    );
  }
}