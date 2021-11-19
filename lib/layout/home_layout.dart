import 'package:flutter/material.dart';
import 'package:todo_app/modules/archived/archived_tab.dart';
import 'package:todo_app/modules/finished/finished_tab.dart';
import 'package:todo_app/modules/tasks/tasks_tab.dart';
import 'package:todo_app/shared/network/local/local_database_helper.dart';

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

  final appBarTitles = <String>[
    'Current Tasks',
    'Finished Tasks',
    'Archived Tasks',
  ];

  var currentPageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LocalDBHelper.createDatabase().then((value) => print('Database is ready for use'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
