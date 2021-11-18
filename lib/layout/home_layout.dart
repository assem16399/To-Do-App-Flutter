import 'package:flutter/material.dart';
import 'package:todo_app/modules/archived/archived_tab.dart';
import 'package:todo_app/modules/finished/finished_tab.dart';
import 'package:todo_app/modules/tasks/tasks_tab.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  final tabs = <Widget>[
    const TasksTab(),
    const FinishedTab(),
    const ArchivedTab(),
  ];

  var currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO App'),
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
    );
  }
}
