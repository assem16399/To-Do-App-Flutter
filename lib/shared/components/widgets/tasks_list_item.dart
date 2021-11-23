import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/task/cubit/task_cubit.dart';

class TasksListItem extends StatelessWidget {
  const TasksListItem({
    Key? key,
    required this.taskId,
    required this.taskTitle,
    required this.taskTime,
    required this.taskDate,
    required this.taskStatus,
    this.iconData,
  }) : super(key: key);

  final String taskId;
  final String taskTitle;
  final String taskTime;
  final String taskDate;
  final String taskStatus;
  final IconData? iconData;

  Future<bool> alert(BuildContext context) async => await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Are you Sure?'),
            content: const Text('Do you want to delete this task from the list?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('NO'),
              ),
            ],
          ));
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(taskId),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Delete the task
          BlocProvider.of<TasksCubit>(context, listen: false).deleteTask(taskId);
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await alert(context);
        }
      },
      background: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2), color: Theme.of(context).errorColor),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(20),
        ),
      ),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: CircleAvatar(
            radius: 32,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(child: Text(taskTime)),
            ),
          ),
          title: Text(taskTitle),
          subtitle: Row(
            children: [
              Text(taskDate),
            ],
          ),
          trailing: iconData == null
              ? null
              : IconButton(
                  onPressed: () {
                    BlocProvider.of<TasksCubit>(context, listen: false)
                        .updateTaskState(taskId, taskStatus == 'new' ? 'done' : 'archived');
                  },
                  icon: Icon(iconData)),
        ),
      ),
    );
  }
}
