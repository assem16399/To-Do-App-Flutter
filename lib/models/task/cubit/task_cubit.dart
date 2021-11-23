import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/task/cubit/task_states.dart';
import 'package:todo_app/models/task/task.dart';
import 'package:todo_app/shared/network/local/local_database_helper.dart';

class TasksCubit extends Cubit<TasksStates> {
  TasksCubit() : super(TasksInitialState());

  List<Task> _tasks = [];

  List<Task> get newTasks {
    return _tasks.where((task) => task.status == 'new').toList();
  }

  List<Task> get doneTasks {
    return _tasks.where((task) => task.status == 'done').toList();
  }

  List<Task> get archivedTasks {
    return _tasks.where((task) => task.status == 'archived').toList();
  }

  static TasksCubit get(context) => BlocProvider.of(context);

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

  void updateTaskState(String id, String newStatus) {
    final updatedTaskIndex = _tasks.indexWhere((task) => task.id == id);
    _tasks[updatedTaskIndex] = Task(
        id: id,
        time: _tasks[updatedTaskIndex].time,
        date: _tasks[updatedTaskIndex].date,
        title: _tasks[updatedTaskIndex].title,
        status: newStatus);
    emit(TasksUpdateTaskState());
    LocalDBHelper.updateData(id, newStatus);
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    emit(TasksDeleteTaskState());
    LocalDBHelper.deleteRecord(id);
  }
}
