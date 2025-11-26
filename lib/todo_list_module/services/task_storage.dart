import 'package:shared_preferences/shared_preferences.dart';
import 'package:things_todo_in_this_weather/todo_list_module/model/task.dart';

class TaskStorage {
  static const String _tasksKey = 'tasks_list_v1';
  late SharedPreferences prefs;

  ///The idea behind this method is to save all the Tasks as a one single Json List of STRINGS
  Future<void> saveTasks(List<Task> tasks) async {
    prefs = await SharedPreferences.getInstance();
    final List<String> jsonStringList = tasks.map((t) => t.toJson()).toList();
    await prefs.setStringList(_tasksKey, jsonStringList);
  }

  ///Reverse action of the aformentioned function:
  Future<List<Task>> loadTasks() async {
    prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_tasksKey) ?? [];
    return jsonList.map((s) => Task.fromJson(s)).toList();
  }

  Future<void> clearAll() async {
  prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tasksKey);
  }
}
