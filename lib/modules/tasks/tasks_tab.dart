import 'package:flutter/material.dart';
import 'package:todo_app/shared/components/constants.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: 32,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(child: Text(tasks[index].time!)),
            ),
          ),
          title: Text(tasks[index].title!),
          subtitle: Row(
            children: [
              Text(tasks[index].date!),
            ],
          ),
        ),
      ),
    );
  }
}
