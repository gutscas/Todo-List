import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do/features/tasks/domain/models/task.dart';

class TaskRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'tasks';

  TaskRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Task>> getTasks(String userId) {
    final query = _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('dueDate', descending: false);

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> addTask(Task task) async {
    await _firestore.collection(_collection).doc(task.id).set(task.toMap());
  }

  Future<void> updateTask(Task task) async {
    await _firestore.collection(_collection).doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore.collection(_collection).doc(taskId).delete();
  }

  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    await _firestore
        .collection(_collection)
        .doc(taskId)
        .update({'isCompleted': isCompleted});
  }
} 