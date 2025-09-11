import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../custom_widgets/task_tile.dart';
import '../model/task.dart';
import '../services/task_storage.dart';

class ToDoHomeScreen extends StatefulWidget {
  const ToDoHomeScreen({super.key});

  @override
  State<ToDoHomeScreen> createState() => _ToDoHomeScreenState();
}

class _ToDoHomeScreenState extends State<ToDoHomeScreen> {
  final TaskStorage _storage = TaskStorage();
  final List<Task> _tasks = [];
  bool _isLoading = true;
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final loaded = await _storage.loadTasks();
    setState(() {
      _tasks.clear();
      _tasks.addAll(loaded);
      _isLoading = false;
    });
  }

  Future<void> _persist() async {
    await _storage.saveTasks(_tasks);
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _addTaskDialog() async {
    final result = await showDialog<_TaskInputResult>(
      context: context,
      builder: (_) => _TaskDialog(),
    );

    if (result != null) {
      final newTask = Task(
        id: _uuid.v4(),
        title: result.title,
        description: result.description,
        isCompleted: false,
      );
      setState(() => _tasks.insert(0, newTask));
      await _persist();
      _showSnack('Task added');
    }
  }

  Future<void> _editTaskDialog(Task task) async {
    final result = await showDialog<_TaskInputResult>(
      context: context,
      builder: (_) => _TaskDialog(
        initialTitle: task.title,
        initialDescription: task.description,
      ),
    );

    if (result != null) {
      final edited = task.copyWith(
        title: result.title,
        description: result.description,
      );
      setState(() {
        final idx = _tasks.indexWhere((t) => t.id == task.id);
        if (idx >= 0) _tasks[idx] = edited;
      });
      await _persist();
      _showSnack('Task edited');
    }
  }

  Future<void> _deleteTask(Task task) async {
    setState(() => _tasks.removeWhere((t) => t.id == task.id));
    await _persist();
    _showSnack('Task deleted');
  }

  Future<void> _toggleTask(Task task, bool newValue) async {
    final updated = task.copyWith(isCompleted: newValue);
    setState(() {
      final idx = _tasks.indexWhere((t) => t.id == task.id);
      if (idx >= 0) _tasks[idx] = updated;
    });
    await _persist();
    if (newValue) {
      _showSnack('Task marked completed');
    }
  }

  Future<void> _clearAllDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear all tasks?'),
          content: const Text('This will remove all tasks permanently.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
            ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Clear')),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() => _tasks.clear());
      await _storage.clearAll();
      _showSnack('All tasks cleared');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('ToDo'),
      actions: [
        IconButton(
          tooltip: 'Clear all tasks',
          icon: const Icon(Icons.delete_sweep),
          onPressed: _tasks.isEmpty ? null : _clearAllDialog,
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? const Center(child: Text('No tasks yet — add one!'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _tasks.length,
                  itemBuilder: (context, idx) {
                    final task = _tasks[idx];
                    return TaskTile(
                      task: task,
                      onToggle: (t, v) => _toggleTask(t, v),
                      onDelete: (t) => _deleteTask(t),
                      onEdit: (t) => _editTaskDialog(t),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTaskDialog,
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskInputResult {
  final String title;
  final String description;

  _TaskInputResult(this.title, this.description);
}

class _TaskDialog extends StatefulWidget {
  final String? initialTitle;
  final String? initialDescription;

  const _TaskDialog({this.initialTitle, this.initialDescription});

  @override
  State<_TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<_TaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initialTitle ?? '');
    _descCtrl = TextEditingController(text: widget.initialDescription ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final result = _TaskInputResult(_titleCtrl.text.trim(), _descCtrl.text.trim());
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialTitle != null || widget.initialDescription != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit Task' : 'New Task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Title required' : null,
              autofocus: true,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Description (optional)'),
              minLines: 1,
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
