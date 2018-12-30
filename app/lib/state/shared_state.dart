import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mutex/mutex.dart';

import 'package:app/state/competition_state.dart';
import 'package:app/state/login_state.dart';

class SharedState {
  SharedState() {
    sharedPreferencesMutex = new ReadWriteMutex();

    sharedPreferencesMutex.acquireWrite().then((_) async {
      sharedPreferences = await SharedPreferences.getInstance();

      loginState = new LoginState(sharedPreferences: sharedPreferences);
      competitionState = new CompetitionState(this);

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
  CompetitionState competitionState;
}
