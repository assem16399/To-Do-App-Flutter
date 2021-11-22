import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/task/cubit/task_cubit.dart';
import 'package:todo_app/shared/components/widgets/default_text_field.dart';
import 'package:todo_app/shared/cubit/app_cubit.dart';
import 'package:todo_app/shared/cubit/app_states.dart';

class HomeLayout extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  HomeLayout({Key? key}) : super(key: key);

  Future<TimeOfDay?> displayTimePicker(BuildContext context) async {
    return await showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  Future<DateTime?> displayDatePicker(BuildContext context) async {
    return await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        lastDate: DateTime(2100),
        firstDate: DateTime.now());
  }

  void displayBottomSheet(BuildContext context, AppCubit appData) {
    scaffoldKey.currentState!
        .showBottomSheet(
          (context) => Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultTextField(
                      controller: titleController,
                      label: 'title',
                      preIcon: Icons.title,
                      type: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) return 'Title Must Not be Empty!!';
                        return null;
                      }),
                  DefaultTextField(
                      controller: timeController,
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final selectedTime = await displayTimePicker(context);
                        if (selectedTime != null) {
                          timeController.text = selectedTime.format(context);
                        }
                      },
                      label: 'Time',
                      preIcon: Icons.timelapse,
                      type: TextInputType.datetime,
                      validator: (value) {
                        if (value!.isEmpty) return 'Time Must Not be Empty!!';
                        return null;
                      }),
                  DefaultTextField(
                      controller: dateController,
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final selectedDate = await displayDatePicker(context);
                        if (selectedDate != null) {
                          dateController.text = DateFormat.yMMMd().format(selectedDate);
                        }
                      },
                      label: 'Date',
                      preIcon: Icons.calendar_today,
                      type: TextInputType.datetime,
                      validator: (value) {
                        if (value!.isEmpty) return 'Date Must Not be Empty!!';
                        return null;
                      }),
                ],
              ),
            ),
          ),
          elevation: 15,
        )
        .closed
        .then((_) {
      clearControllers();
      appData.toggleBottomSheet();
    });
  }

  void submitData(BuildContext context, AppCubit appData) async {
    if (formKey.currentState!.validate()) {
      Navigator.of(context).pop();
      clearControllers();
      appData.toggleBottomSheet();
    }
  }

  void clearControllers() {
    titleController.clear();
    timeController.clear();
    dateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final tasksData = BlocProvider.of<TasksCubit>(context, listen: false);
    final appData = BlocProvider.of<AppCubit>(context);

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, appState) {},
      builder: (context, appState) => Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(appData.appBarTitles[appData.currentPageIndex]),
        ),
        body: tasksData.tasks.isEmpty
            ? const Center(
                child: Text(
                  'Start Adding Some Tasks Now...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              )
            : appData.tabs[appData.currentPageIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: appData.currentPageIndex,
          onTap: (index) {
            appData.changeTheTab(index);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
            BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Finished'),
            BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archived'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (appData.isBottomSheetOpened) {
              submitData(context, appData);
            } else {
              displayBottomSheet(context, appData);
              appData.toggleBottomSheet();
            }
          },
          child: Icon(appData.isBottomSheetOpened ? Icons.add_task : Icons.edit),
        ),
      ),
    );
  }
}
