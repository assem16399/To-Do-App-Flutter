import 'package:flutter/material.dart';

class TasksTab extends StatefulWidget {
  const TasksTab({Key? key}) : super(key: key);

  @override
  _TasksTabState createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Tasks'),
    );
  }
}
