import 'package:app/util/prefs.dart';
import 'package:app/util/backend_fetcher.dart';
import 'package:flutter/widgets.dart';

mixin SharedApi {
  // Returns the backend fetcher.
  BackendFetcher backendFetcher();

  // Returns the shared preferences.
  Prefs prefs();

  // Sets the function to be called when system back is pressed.
  void onBack(Function() onBack);

  // Complete the login flow.
  void onLoginComplete(List<String> cookie);

  // Log the user out.
  void logOut(BuildContext context);

  // Show a snackbar containing the given widget.
  void showSnackBar(Widget content);
}