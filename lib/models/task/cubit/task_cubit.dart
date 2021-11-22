import 'package:bloc/bloc.dart';
import 'package:todo_app/models/task/cubit/task_states.dart';
import 'package:todo_app/models/task/task.dart';
import 'package:todo_app/shared/network/local/local_database_helper.dart';

class TasksCubit extends Cubit<TasksStates> {
  TasksCubit() : super(TasksInitialState());

  List<Task> _tasks = [
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

  void addNewTask({required String title, required String time, required String date}) {
    final taskId = DateTime.now().toString();
    _tasks.add(Task(id: taskId, time: time, date: date, title: title, status: 'new'));
    emit(TasksAddNewTaskState());
    LocalDBHelper.insertInDatabase(
        taskId: taskId, taskTitle: title, taskTime: time, taskDate: date);
  }

  void fetchAndSetTasks() async {
    final extractedData = await LocalDBHelper.fetchDataFromDatabase();
    _tasks = extractedData
        .map((loadedTask) => Task(
              id: loadedTask['id'],
              status: loadedTask['status'],
              title: loadedTask['title'],
              date: loadedTask['date'],
              time: loadedTask['time'],
            ))
        .toList();
    emit(TasksFetchState());
  }
}
