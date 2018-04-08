import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mutex/mutex.dart';

import 'login_state.dart';

class SharedState {
  SharedState() {
    sharedPreferencesMutex = new ReadWriteMutex();

    sharedPreferencesMutex.acquireWrite().then((_) async {
      sharedPreferences = await SharedPreferences.getInstance();

      loginState = new LoginState(sharedPreferences: sharedPreferences);

      sharedPreferencesMutex.release();
    });
  }

  Future<void> awaitReady() async {
    await sharedPreferencesMutex.acquireRead();
    sharedPreferencesMutex.release();
  }

  ReadWriteMutex sharedPreferencesMutex;
  SharedPreferences sharedPreferences;
  LoginState loginState;
}