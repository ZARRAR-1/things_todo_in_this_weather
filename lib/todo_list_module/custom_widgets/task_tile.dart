import 'package:flutter/material.dart';
import 'package:things_todo_in_this_weather/todo_list_module/model/task.dart';

///Function types as aliasis:
typedef OnToggle = void Function(Task task, bool newValue);
typedef OnDelete = void Function(Task task);
typedef OnEdit = void Function(Task task);

class TaskTile extends StatelessWidget {
  final Task task;
  final OnToggle onToggle;
  final OnDelete onDelete;
  final OnEdit onEdit;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: () {
         onEdit(task);
        },
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (v) {
            if (v == null) return;
            onToggle(task, v);
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration:
                task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: task.description.isNotEmpty ? Text(task.description) : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => onDelete(task),
        ),
      ),
    );
  }
}
