import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../domain/model/todo_model.dart';

///

class HiveDataStore {
  static const boxName = "tasksBox";
  final Box<Task> box = Hive.box<Task>(boxName);
  final _notificationController = StreamController<Task>.broadcast();
  Timer? _notificationTimer;

  Stream<Task> get notificationStream => _notificationController.stream;

  HiveDataStore() {
    _startNotificationTimer();
  }

  void _startNotificationTimer() {
    _notificationTimer?.cancel();
    _notificationTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkDueTasks();
    });
  }

  void _checkDueTasks() {
    final now = DateTime.now();
    final tasks = box.values.where((task) {
      if (task.isCompleted) return false;
      final difference = task.dueDate.difference(now);
      // Notify if task is due within 30 minutes
      return difference.inMinutes <= 30 && difference.inMinutes > 0;
    });

    for (final task in tasks) {
      _notificationController.add(task);
    }
  }

  /// Add new Task
  Future<void> addTask({required Task task}) async {
    await box.put(task.id, task);
  }

  /// Show task
  Future<Task?> getTask({required String id}) async {
    return box.get(id);
  }

  /// Update task
  Future<void> updateTask({required Task task}) async {
    final Box<Task> box = Hive.box<Task>("tasksBox");
    await box.put(task.id, task);
  }

  /// Delete task
  Future<void> dalateTask({required Task task}) async {
    await task.delete();
  }

  ValueListenable<Box<Task>> listenToTask() {
    return box.listenable();
  }
}
