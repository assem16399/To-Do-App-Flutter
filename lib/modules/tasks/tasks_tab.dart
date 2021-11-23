import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/task/cubit/task_cubit.dart';
import 'package:todo_app/models/task/cubit/task_states.dart';
import 'package:todo_app/shared/components/widgets/tasks_list_item.dart';

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
                  itemBuilder: (context, index) => TasksListItem(
                    taskTitle: tasksData.newTasks[index].title!,
                    taskDate: tasksData.newTasks[index].date!,
                    taskId: tasksData.newTasks[index].id!,
                    taskStatus: tasksData.newTasks[index].status!,
                    taskTime: tasksData.newTasks[index].time!,
                    iconData: Icons.done,
                  ),
                ),
    );
  }
}
