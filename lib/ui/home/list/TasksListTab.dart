import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_c11/database/collections/TasksCollection.dart';
import 'package:todo_c11/database/models/Task.dart';
import 'package:todo_c11/providers/AuthProvider.dart';
import 'package:todo_c11/providers/TasksProvider.dart';
import 'package:todo_c11/ui/DialogUtils.dart';
import 'package:todo_c11/ui/home/list/TaskItem.dart';

class TasksListTab extends StatefulWidget {
  const TasksListTab({super.key});

  @override
  State<TasksListTab> createState() => _TasksListTabState();
}

class _TasksListTabState extends State<TasksListTab> {
  List<Task>? tasksList;

  late AppAuthProvider authProvider;

  late TasksProvider tasksProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AppAuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    tasksProvider =  Provider.of<TasksProvider>(context);
    return FutureBuilder<List<Task>>(
      future: tasksProvider.getAllTasks(authProvider.authUser?.uid ?? ''),
      builder: (buildContext, snapshot) {
        if (snapshot.hasError) {
          // handle error
          return Center(
            child: Column(
              children: [
                Text("Something went wrong"),
                ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text("Try again"))
              ],
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          // waiting for future to get data // like await for future
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        // you have data
        var tasksList = snapshot.data;
        return ListView.separated(
            itemBuilder: (context, index) {
              return TaskItem(
                task: tasksList![index],
                onDeleteClick: deleteTask,
              );
            },
            separatorBuilder: (_, __) => Container(
                  height: 24,
                ),
            itemCount: tasksList?.length ?? 0);
      },
    );
  }

  void deleteTask(Task task) async {
    showLoadingDialog(context, message: "please wait...");
    try {
      await tasksProvider.removeTask(authProvider.authUser?.uid ?? "", task);
      hideLoading(context);
      setState(() {});
    } catch (e) {
      showMessageDialog(context,
          message: "Somethin went wrong ${e.toString()}",
          posButtonTitle: "retry", posButtonAction: () {
        deleteTask(task);
      });
    }
  }
}
