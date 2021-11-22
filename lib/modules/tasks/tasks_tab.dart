import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/task/cubit/task_cubit.dart';
import 'package:todo_app/models/task/cubit/task_states.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final tasksData = BlocProvider.of<TasksCubit>(context, listen: false);
    return ListView.builder(
      itemCount: tasksData.tasks.length,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: 32,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(child: Text(tasksData.tasks[index].time!)),
            ),
          ),
          title: Text(tasksData.tasks[index].title!),
          subtitle: Row(
            children: [
              Text(tasksData.tasks[index].date!),
            ],
          ),
        ),
      ),
    );
  }
}
