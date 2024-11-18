import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quicpictodo/core/router.dart';
import 'package:quicpictodo/infrastructure/todo_repository.dart';
import 'package:quicpictodo/pressentation/widgets/common_widgets.dart';

import '../../application/todo_provider.dart';
import '../../core/app_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  late HiveDataStore _taskService;
  @override
  void initState() {
    super.initState();
    _taskService = HiveDataStore();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodoProvider>().getAllTasks();
    });
    _listenToNotifications();
  }

  void _listenToNotifications() {
    _taskService.notificationStream.listen((task) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Task "${task.title}" is due soon!'),
          duration: const Duration(seconds: 5),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      backgroundColor: AppConstants.mainColor,
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        title: const CommonTextWidget(
          text: 'QuicPicTodo',
          color: AppConstants.whiteColor,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<TodoProvider>(
          builder: (context, provider, child) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  provider.taskList.length, // Replace with actual todos length
              itemBuilder: (context, index) {
                final todo = provider.taskList[index];
                return Card(
                  color: AppConstants.secondMainColor,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    onTap: () {
                      context.read<TodoProvider>().selectedTodoFun(todo);
                      context.pushNamed(AppRouter.todoDetailsScreen);
                    },
                    leading: Checkbox(
                      activeColor: Colors.black,
                      value: todo.isCompleted,
                      onChanged: (value) {
                        context.read<TodoProvider>().toggleTodo(todo.id);
                      },
                    ),
                    title: CommonTextWidget(
                      text: todo.title,
                      color: AppConstants.mainColor,
                      align: TextAlign.start,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      overFlow: TextOverflow.ellipsis,
                    ),
                    subtitle: CommonTextWidget(
                      text:
                          'Due on ${todo.dueDate.day}/${todo.dueDate.month}/${todo.dueDate.year}',
                      color: AppConstants.mainColor,
                      align: TextAlign.start,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      overFlow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Color.fromARGB(255, 249, 7, 7),
                      ),
                      onPressed: () {
                        context.read<TodoProvider>().deleteTaskFun(todo);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConstants.secondMainColor,
        onPressed: () {
          context.pushNamed(AppRouter.todoEditScreen,
              queryParameters: {"isAddTask": "true"});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
