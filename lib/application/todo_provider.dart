// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quicpictodo/domain/model/todo_model.dart';
import 'package:quicpictodo/pressentation/widgets/common_widgets.dart';

import '../domain/services/notification.dart';
import '../infrastructure/todo_repository.dart';

class TodoProvider extends ChangeNotifier {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final hiveDataStore = HiveDataStore();
  DateTime? dueDate;
  DateTime? selectedDateTime;

  TimeOfDay? selectedTime;

  Future<void> selectDateFn(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != dueDate) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        dueDate = picked;
        selectedTime = time;
        selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );
      }
      notifyListeners();
    }
  }

  bool isLoading = false;
  Future<void> addTaskFun({required BuildContext ctx}) async {
    if (dueDate == null) {
      toast(title: "Please select due date", backgroundColor: Colors.red);
      return;
    }

    // Set loading state before any async operations
    isLoading = true;
    notifyListeners();

    try {
      var task = Task.create(
          title: titleController.text,
          description: descriptionController.text,
          dueDate: dueDate);

      await hiveDataStore.addTask(task: task);
      log("message 0");
      await NotificationService.instance.scheduleNotification(
        task.id,
        task.title,
        task.description,
        selectedDateTime!,
      );

      await getAllTasks();

      clearControllers();

      // Navigate before setting loading to false
      Navigator.of(ctx).pop();
      ctx.pop();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearControllers() {
    titleController.clear();
    descriptionController.clear();
    dueDate = null;
    notifyListeners();
  }

  List<Task> taskList = [];

  Future<void> getAllTasks() async {
    final Box<Task> boxName = Hive.box<Task>("tasksBox");
    taskList.clear();
    taskList.addAll(boxName.values);
    notifyListeners();
  }

  void toggleTodo(String id) async {
    for (final todo in taskList) {
      if (todo.id == id) {
        todo.isCompleted = !todo.isCompleted;
        log("message ${todo.isCompleted}");
        await hiveDataStore.updateTask(task: todo);
        await getAllTasks();
        notifyListeners();
        break;
      }
    }
  }

  Task? selectedTodo;
  void selectedTodoFun(Task value) {
    selectedTodo = value;
    notifyListeners();
  }

  Future<void> updateTaskFun({required BuildContext context}) async {
    var task = Task(
        id: selectedTodo!.id,
        createdAtDate: selectedTodo!.createdAtDate,
        title: titleController.text,
        description: descriptionController.text,
        isCompleted: selectedTodo!.isCompleted,
        dueDate: dueDate ?? DateTime.now());

    await hiveDataStore.updateTask(task: task);
    await getAllTasks();
    selectedTodoFun(task);
    clearControllers();
    context.pop();
    notifyListeners();
  }

  Future<void> deleteTaskFun(Task value) async {
    await hiveDataStore.dalateTask(task: value);
    await getAllTasks();
    notifyListeners();
  }

  Future<Task?> getTaskFun(String id) async {
    return await hiveDataStore.getTask(id: id);
  }
}
