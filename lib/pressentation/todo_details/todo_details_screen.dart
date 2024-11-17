import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quicpictodo/application/todo_provider.dart';
import 'package:quicpictodo/core/app_constants.dart';
import 'package:quicpictodo/core/sized_box.dart';
import 'package:quicpictodo/pressentation/widgets/common_widgets.dart';

import '../../core/router.dart';

class TodoDetailsScreen extends StatelessWidget {
  const TodoDetailsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.mainColor,
      appBar: AppBar(
        leading: CommonInkwell(
          onTap: () {
            context.pop();
          },
          child: const Icon(
            Icons.arrow_back,
            size: 30,
            color: AppConstants.whiteColor,
          ),
        ),
        backgroundColor: AppConstants.mainColor,
        title: const CommonTextWidget(
          text: 'Todo Details',
          color: AppConstants.whiteColor,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: AppConstants.whiteColor,
            ),
            onPressed: () {
              context.pushNamed(AppRouter.todoEditScreen,
                  queryParameters: {"isAddTask": "false"});
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<TodoProvider>(
          builder: (context, provider, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextWidget(
                text: provider.selectedTodo?.title ?? "",
                color: AppConstants.whiteColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 16),
              CommonTextWidget(
                text: provider.selectedTodo?.description ?? "",
                fontSize: 16,
                align: TextAlign.start,
                color: AppConstants.whiteColor,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const CommonTextWidget(
                    text: 'Due Date:',
                    color: AppConstants.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizeBoxV(10),
                  CommonTextWidget(
                    text: '${provider.selectedTodo?.dueDate ?? ""}',
                    color: AppConstants.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
