import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quicpictodo/application/todo_provider.dart';
import 'package:quicpictodo/core/app_constants.dart';
import 'package:quicpictodo/core/sized_box.dart';

import '../widgets/common_widgets.dart';

class TodoAddAndEditScreen extends StatefulWidget {
  final String isAddTask;

  const TodoAddAndEditScreen({super.key, this.isAddTask = "true"});

  @override
  State<TodoAddAndEditScreen> createState() => _TodoAddAndEditScreenState();
}

class _TodoAddAndEditScreenState extends State<TodoAddAndEditScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.isAddTask == "false") {
      context.read<TodoProvider>().titleController.text =
          context.read<TodoProvider>().selectedTodo!.title;
      context.read<TodoProvider>().descriptionController.text =
          context.read<TodoProvider>().selectedTodo!.description;
      context.read<TodoProvider>().dueDate =
          context.read<TodoProvider>().selectedTodo!.dueDate;
      context.read<TodoProvider>().selectedTime = null;
    }
  }

  final _formKey = GlobalKey<FormState>();
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
        title: CommonTextWidget(
          text: widget.isAddTask == "true" ? "Add Todo" : 'Edit Todo',
          color: AppConstants.whiteColor,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Selector<TodoProvider, bool>(
          selector: (p0, p1) => p1.isLoading,
          builder: (context, isLoading, child) => !isLoading
              ? Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CommonTextWidget(
                        text: "Title",
                        fontSize: 16,
                        letterSpacing: 1.2,
                        color: AppConstants.whiteColor,
                      ),
                      const SizedBox(height: 8),
                      CommonTextFormField(
                          hintText: "Title",
                          bgColor: AppConstants.whiteColor.withOpacity(.1),
                          keyboardType: TextInputType.text,
                          hintTextColor: AppConstants.whiteColor,
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                          controller:
                              context.read<TodoProvider>().titleController),
                      const SizedBox(height: 16),
                      const CommonTextWidget(
                        text: "Description",
                        fontSize: 16,
                        letterSpacing: 1.2,
                        color: AppConstants.whiteColor,
                      ),
                      const SizedBox(height: 8),
                      CommonTextFormField(
                          hintText: "Description",
                          keyboardType: TextInputType.text,
                          bgColor: AppConstants.whiteColor.withOpacity(.1),
                          hintTextColor: AppConstants.whiteColor,
                          maxLines: 5,
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                          controller: context
                              .read<TodoProvider>()
                              .descriptionController),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const CommonTextWidget(
                            text: 'Due Date:',
                            color: AppConstants.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          TextButton(
                            onPressed: () => context
                                .read<TodoProvider>()
                                .selectDateFn(context),
                            child: Selector<TodoProvider, DateTime?>(
                              selector: (p0, p1) => p1.dueDate,
                              builder: (context, dueDate, child) =>
                                  CommonTextWidget(
                                color: AppConstants.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                text: dueDate != null
                                    ? '${dueDate.day}/${dueDate.month}/${dueDate.year}'
                                    : 'Select Date',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      CommonButton(
                        ontap: () {
                          if (_formKey.currentState!.validate()) {
                            if (widget.isAddTask == "true") {
                              context.read<TodoProvider>().addTaskFun(
                                    ctx: context,
                                  );
                            } else {
                              context.read<TodoProvider>().updateTaskFun(
                                    context: context,
                                  );
                            }
                          }
                        },
                        height: 52,
                        text: "Save",
                        bgColor: AppConstants.secondMainColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        textColor: AppConstants.blackColor,
                      ),
                      const SizeBoxH(20)
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
