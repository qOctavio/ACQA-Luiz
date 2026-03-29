import 'package:flutter/material.dart';
import '../models/task.dart';

class TasksScreen extends StatefulWidget {
  final DateTime selectedDay;
  final Map<DateTime, List<Task>> tasksPorDia;

  const TasksScreen({
    super.key,
    required this.selectedDay,
    required this.tasksPorDia,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  DateTime normalize(DateTime d) {
    return DateTime(d.year, d.month, d.day);
  }

  List<Task> get tarefasDoDia {
    return widget.tasksPorDia[normalize(widget.selectedDay)] ?? [];
  }

  void addTask(String title) {
    final key = normalize(widget.selectedDay);

    setState(() {
      widget.tasksPorDia.putIfAbsent(key, () => []);
      widget.tasksPorDia[key]!.add(Task(title: title));
      sortTasks();
    });
  }

  void removeTask(int index) {
    setState(() {
      tarefasDoDia.removeAt(index);
    });
  }

  void toggleTask(int index) {
    setState(() {
      tarefasDoDia[index].isDone = !tarefasDoDia[index].isDone;
      sortTasks();
    });
  }

  void sortTasks() {
    tarefasDoDia.sort((a, b) {
      if (a.isDone != b.isDone) {
        return a.isDone ? 1 : -1;
      }
      return a.title.compareTo(b.title);
    });
  }

  void showAddDialog() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nova tarefa"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              addTask(controller.text);
              Navigator.pop(context);
            },
            child: const Text("Adicionar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tarefas = tarefasDoDia;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tarefas - ${widget.selectedDay.day}/${widget.selectedDay.month}",
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: tarefas.length,
        itemBuilder: (_, index) {
          final task = tarefas[index];

          return ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                decoration:
                    task.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            leading: Checkbox(
              value: task.isDone,
              onChanged: (_) => toggleTask(index),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => removeTask(index),
            ),
          );
        },
      ),
    );
  }
}