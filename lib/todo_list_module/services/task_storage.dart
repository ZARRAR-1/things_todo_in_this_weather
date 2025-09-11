import 'package:shared_preferences/shared_preferences.dart';
import 'package:things_todo_in_this_weather/todo_list_module/model/task.dart';

class TaskStorage {
  static const String _tasksKey = 'tasks_list_v1';
  
  ///The idea behind this method is to save all the Tasks as a one single Json List of STRINGS
  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList = tasks.map((t) => t.toJson()).toList();
    await prefs.setStringList(_tasksKey, jsonList);
  }

  ///Reverse action of the aformentioned function:
  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_tasksKey) ?? [];
    return jsonList.map((s) => Task.fromJson(s)).toList();
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tasksKey);
  }
}
