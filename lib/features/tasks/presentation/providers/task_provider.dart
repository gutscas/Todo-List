import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do/features/tasks/data/repositories/task_repository.dart';
import 'package:to_do/features/tasks/domain/models/task.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

final tasksProvider = StreamProvider.family<List<Task>, String>((ref, userId) {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.getTasks(userId);
});

final taskProvider = StateNotifierProvider<TaskNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskNotifier(repository);
});

class TaskNotifier extends StateNotifier<AsyncValue<void>> {
  final TaskRepository _repository;

  TaskNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> addTask(Task task) async {
    state = const AsyncValue.loading();
    try {
      await _repository.addTask(task);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateTask(Task task) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateTask(task);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteTask(String taskId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteTask(taskId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    state = const AsyncValue.loading();
    try {
      await _repository.toggleTaskCompletion(taskId, isCompleted);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
} 