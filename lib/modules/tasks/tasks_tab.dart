import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/task/cubit/task_cubit.dart';
import 'package:todo_app/models/task/cubit/task_states.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final tasksData = BlocProvider.of<TasksCubit>(context, listen: false);
    return BlocConsumer<TasksCubit, TasksStates>(
      listener: (context, tasksState) {},
      builder: (context, tasksState) => tasksState is TasksInitialState
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : tasksData.newTasks.isEmpty
              ? const Center(
                  child: Text(
                    'Start Adding Some New Tasks!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                )
              : ListView.builder(
                  itemCount: tasksData.newTasks.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 32,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(child: Text(tasksData.newTasks[index].time!)),
                        ),
                      ),
                      title: Text(tasksData.newTasks[index].title!),
                      subtitle: Row(
                        children: [
                          Text(tasksData.newTasks[index].date!),
                        ],
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            tasksData.updateTaskState(tasksData.newTasks[index].id!, 'done');
                          },
                          icon: const Icon(Icons.done)),
                    ),
                  ),
                ),
    );
  }
}
