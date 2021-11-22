import 'package:bloc/bloc.dart';
import 'package:todo_app/models/task/cubit/task_states.dart';
import 'package:todo_app/models/task/task.dart';

class TasksCubit extends Cubit<TaskStates> {
  TasksCubit() : super(TaskInitialState());

  final List<Task> _tasks = [
    // Task(id: 1, title: 'Go To Gym', type: 'new', date: '22 Nov 2021', time: '9.00 AM'),
    // Task(id: 2, title: 'Go To University', type: 'new', date: '22 Nov 2021', time: '12.00 PM'),
    // Task(
    //     id: 3,
    //     title: 'Go To Work Space To Study',
    //     type: 'new',
    //     date: '22 Nov 2021',
    //     time: '5.00 PM'),
  ];

  List<Task> get tasks {
    return [..._tasks];
  }
}
