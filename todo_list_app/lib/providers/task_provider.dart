import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks() async {
    const url = 'https://todolist-prog4-default-rtdb.firebaseio.com/tasks.json';
    final response = await http.get(Uri.parse(url));
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<Task> loadedTasks = [];

    extractedData.forEach((taskId, taskData) {
      loadedTasks.add(Task.fromMap({...taskData, 'id': taskId}));
    });

    _tasks = loadedTasks;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    const url = 'https://todolist-prog4-default-rtdb.firebaseio.com/tasks.json';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(task.toMap()),
    );

    final newTask = Task(
      id: json.decode(response.body)['name'],
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      category: task.category,
    );

    _tasks.add(newTask);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    final url =
        'https://todolist-prog4-default-rtdb.firebaseio.com/tasks/${task.id}.json';
    await http.patch(
      Uri.parse(url),
      body: json.encode(task.toMap()),
    );

    final taskIndex = _tasks.indexWhere((t) => t.id == task.id);
    if (taskIndex >= 0) {
      _tasks[taskIndex] = task;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    final url =
        'https://todolist-prog4-default-rtdb.firebaseio.com/tasks/$id.json';
    await http.delete(Uri.parse(url));

    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}
