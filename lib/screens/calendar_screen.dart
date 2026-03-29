import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'tasks_screen.dart';
import '../models/task.dart';

class CalendarScreen extends StatefulWidget {
  final String nome;

  const CalendarScreen({super.key, required this.nome});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDay = DateTime.now();

  Map<DateTime, List<Task>> tasksPorDia = {};

  DateTime normalize(DateTime d) {
    return DateTime(d.year, d.month, d.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bem-vindo, ${widget.nome}"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          TableCalendar(
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030),
            focusedDay: selectedDay,
            selectedDayPredicate: (day) =>
                isSameDay(day, selectedDay),
            onDaySelected: (selected, focused) {
              setState(() {
                selectedDay = normalize(selected);
              });
            },
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            child: const Text("Ver tarefas do dia"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TasksScreen(
                    selectedDay: normalize(selectedDay),
                    tasksPorDia: tasksPorDia,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}