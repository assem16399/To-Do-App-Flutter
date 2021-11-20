import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/modules/archived/archived_tab.dart';
import 'package:todo_app/modules/finished/finished_tab.dart';
import 'package:todo_app/modules/tasks/tasks_tab.dart';
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
  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  void displayBottomSheet() {
    scaffoldKey.currentState!.showBottomSheet(
      (context) => GestureDetector(
        onVerticalDragStart: (_) {},
        onVerticalDragDown: (_) {},
        child: Form(
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
      ),
      elevation: 15,
    );
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LocalDBHelper.createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(appBarTitles[currentPageIndex]),
      ),
      body: tabs[currentPageIndex],
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
      Navigator.of(context).pop();
      timeController.clear();
      titleController.clear();
      dateController.clear();
      setState(() {
        _isBottomSheetOpened = !_isBottomSheetOpened;
      });
    }
  }
}
