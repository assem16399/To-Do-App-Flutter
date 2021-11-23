import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/task/cubit/task_cubit.dart';
import 'package:todo_app/models/task/cubit/task_states.dart';

class FinishedTab extends StatefulWidget {
  const FinishedTab({Key? key}) : super(key: key);

  @override
  _FinishedTabState createState() => _FinishedTabState();
}

class _FinishedTabState extends State<FinishedTab> {
  @override
  Widget build(BuildContext context) {
    final tasksData = BlocProvider.of<TasksCubit>(context, listen: false);
    return BlocConsumer<TasksCubit, TasksStates>(
      listener: (context, tasksState) {},
      builder: (context, tasksState) => tasksState is TasksInitialState
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : tasksData.doneTasks.isEmpty
              ? const Center(
                  child: Text(
                    'You Did Not Finished Any Tasks Yet!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                )
              : ListView.builder(
                  itemCount: tasksData.doneTasks.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 32,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(child: Text(tasksData.doneTasks[index].time!)),
                        ),
                      ),
                      title: Text(tasksData.doneTasks[index].title!),
                      subtitle: Row(
                        children: [
                          Text(tasksData.doneTasks[index].date!),
                        ],
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            tasksData.updateTaskState(tasksData.doneTasks[index].id!, 'archived');
                          },
                          icon: const Icon(Icons.archive)),
                    ),
                  ),
                ),
    );
  }
}
