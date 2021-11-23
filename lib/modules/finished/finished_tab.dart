import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/task/cubit/task_cubit.dart';
import 'package:todo_app/models/task/cubit/task_states.dart';
import 'package:todo_app/shared/components/widgets/tasks_list_item.dart';

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
                  itemBuilder: (context, index) => TasksListItem(
                    taskTitle: tasksData.doneTasks[index].title!,
                    taskDate: tasksData.doneTasks[index].date!,
                    taskId: tasksData.doneTasks[index].id!,
                    taskStatus: tasksData.doneTasks[index].status!,
                    taskTime: tasksData.doneTasks[index].time!,
                    iconData: Icons.archive,
                  ),
                ),
    );
  }
}
