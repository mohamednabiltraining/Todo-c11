
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_c11/AppDateUtils.dart';
import 'package:todo_c11/database/collections/TasksCollection.dart';
import 'package:todo_c11/database/models/Task.dart';

class TasksProvider extends ChangeNotifier{

  var tasksCollection = TasksCollection();
  Future<List<Task>> getAllTasks(String userId,
      DateTime selectedDate)async{
    var tasksList = await tasksCollection.getAllTasks(userId,
    selectedDate.dateOnly());
    return tasksList;
  }
  Future<void> removeTask(String userId,Task task)async{
    await tasksCollection.removeTask(userId, task);
    notifyListeners();
    return;
  }
  Future<void> addTask(String userId,Task task)async{
    await tasksCollection.createTask(userId, task);
    notifyListeners();
    return;
  }

  static TasksProvider getInstance(BuildContext context,
  {bool listen = true}){
    return Provider.of<TasksProvider> (context,listen: listen);
  }
}