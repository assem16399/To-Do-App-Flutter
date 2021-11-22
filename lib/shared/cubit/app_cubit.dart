import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/modules/archived/archived_tab.dart';
import 'package:todo_app/modules/finished/finished_tab.dart';
import 'package:todo_app/modules/tasks/tasks_tab.dart';
import 'package:todo_app/shared/cubit/app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
// Handling Bottom navigation bar states
  var currentPageIndex = 0;

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

  void changeTheTab(int index) {
    currentPageIndex = index;
    emit(AppChangeBottomNavBarState());
  }
  //*******************************************************//

  // handling bottom sheet states

  var _isBottomSheetOpened = false;

  bool get isBottomSheetOpened {
    return _isBottomSheetOpened;
  }

  void toggleBottomSheet() {
    _isBottomSheetOpened = !_isBottomSheetOpened;
    emit(AppChangeBottomSheetState());
  }

  //****************************************************//
  // handling fetching data

  var _isFetchingData = false;
  bool get isFetchingData {
    return _isFetchingData;
  }

  void setFetchingDataState(bool state) {
    _isFetchingData = state;
    emit(AppChangeDataFetchingState());
  }
}
