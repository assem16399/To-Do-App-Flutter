import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/modules/archived/archived_tab.dart';
import 'package:todo_app/modules/finished/finished_tab.dart';
import 'package:todo_app/modules/tasks/tasks_tab.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/components/default_text_field.dart';
import 'package:todo_app/shared/network/local/local_database_helper.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  final tabs = <Widget>[
    const TasksTab(),
    const FinishedTab(),
    const ArchivedTab(),
  ];

  final appBarTitles = <String>[
    'Current Tasks',
    'Finished Tasks',
    'Archived Tasks',
  ];

  var currentPageIndex = 0;
  var _isBottomSheetOpened = false;

  Future<TimeOfDay?> displayTimePicker() async {
    return await showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  Future<DateTime?> displayDatePicker() async {
    return await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        lastDate: DateTime(2100),
        firstDate: DateTime.now());
  }

  void displayBottomSheet() {
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
                        final selectedTime = await displayTimePicker();
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
                        final selectedDate = await displayDatePicker();
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
      setState(() {
        _isBottomSheetOpened = false;
      });
    });
  }

  var _isFetchingData = false;
  @override
  void initState() {
    // TODO: implement initState
    _isFetchingData = true;
    LocalDBHelper.fetchDataFromDatabase().then((loadedTasks) {
      setState(() {
        loadedTasks
            .map((loadedTask) => tasks.add(Task(
                  id: loadedTask['id'],
                  title: loadedTask['title'],
                  type: loadedTask['type'],
                  date: loadedTask['date'],
                  time: loadedTask['time'],
                )))
            .toList();
        _isFetchingData = false;
      });
    }).catchError((error) {
      setState(() {
        _isFetchingData = false;
      });
      print(error.toString());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(appBarTitles[currentPageIndex]),
      ),
      body: _isFetchingData
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : tasks.isEmpty
              ? const Center(
                  child: Text('Add Some Todos'),
                )
              : tabs[currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Finished'),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archived'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isBottomSheetOpened) {
            submitData();
          } else {
            displayBottomSheet();
            setState(() {
              _isBottomSheetOpened = !_isBottomSheetOpened;
            });
          }
        },
        child: Icon(_isBottomSheetOpened ? Icons.add_task : Icons.edit),
      ),
    );
  }

  void submitData() async {
    if (formKey.currentState!.validate()) {
      await LocalDBHelper.insertInDatabase(
          taskTitle: titleController.text,
          taskDate: dateController.text,
          taskTime: timeController.text);

      setState(() {
        _isFetchingData = true;
      });
      LocalDBHelper.fetchDataFromDatabase().then((loadedTasks) {
        tasks.clear();
        setState(() {
          loadedTasks
              .map((loadedTask) => tasks.add(Task(
                    id: loadedTask['id'],
                    title: loadedTask['title'],
                    type: loadedTask['type'],
                    date: loadedTask['date'],
                    time: loadedTask['time'],
                  )))
              .toList();
          _isFetchingData = false;
        });
      }).catchError((error) {
        setState(() {
          _isFetchingData = false;
        });
        print(error.toString());
      });
      Navigator.of(context).pop();
      clearControllers();

      setState(() {
        _isBottomSheetOpened = !_isBottomSheetOpened;
      });
    }
  }

  void clearControllers() {
    titleController.clear();
    timeController.clear();
    dateController.clear();
  }
}
