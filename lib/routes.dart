
import 'package:balloonradar_flutter/pages/checkLogin.dart';
import 'package:balloonradar_flutter/pages/chooseBalloon.dart';
import 'package:balloonradar_flutter/pages/setupUser.dart';

final routes = {
  '/': (context) => CheckLogin(),
/*  '/map': (context) => FlutterReduxApp(store: Store<AppState>(
      appReducers, initialState: AppState.initialState()), title: "Redux Map"),*/
  '/setupUser': (context) => SetupUser(),
  '/chooseBalloon': (context) => ChooseBalloon(),
};
