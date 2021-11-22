import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/home_layout.dart';
import 'package:todo_app/models/task/cubit/task_cubit.dart';

import 'shared/components/bloc_observer.dart';
import 'shared/cubit/app_cubit.dart';

void main() {
  BlocOverrides.runZoned(
    () {
      // Use cubits...
      runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppCubit()),
        BlocProvider(create: (context) => TasksCubit()..fetchAndSetTasks()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Colors.red,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              showSelectedLabels: true),
          primarySwatch: Colors.pink,
        ),
        home: HomeLayout(),
      ),
    );
  }
}
