import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/task/cubit/task_cubit.dart';
import 'package:todo_app/models/task/cubit/task_states.dart';

class ArchivedTab extends StatefulWidget {
  const ArchivedTab({Key? key}) : super(key: key);

  @override
  _ArchivedTabState createState() => _ArchivedTabState();
}

class _ArchivedTabState extends State<ArchivedTab> {
  @override
  Widget build(BuildContext context) {
    final tasksData = BlocProvider.of<TasksCubit>(context, listen: false);
    return BlocConsumer<TasksCubit, TasksStates>(
      listener: (context, tasksState) {},
      builder: (context, tasksState) => tasksState is TasksInitialState
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : tasksData.archivedTasks.isEmpty
              ? const Center(
                  child: Text(
                    'You Did Not Archived Any Tasks Yet!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                )
              : ListView.builder(
                  itemCount: tasksData.archivedTasks.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 32,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(child: Text(tasksData.archivedTasks[index].time!)),
                        ),
                      ),
                      title: Text(tasksData.archivedTasks[index].title!),
                      subtitle: Row(
                        children: [
                          Text(tasksData.archivedTasks[index].date!),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
