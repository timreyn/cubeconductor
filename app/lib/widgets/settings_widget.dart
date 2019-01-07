import 'package:app/util/prefs.dart';
import 'package:app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class SettingsWidget extends StatelessWidget {
  SettingsWidget(
      {@required this.defaultMenuItems,
      @required this.sharedPreferences,
      @required this.logOut,
      @required this.showSnackBar,
      Key key})
      : _formKey = new GlobalKey(),
        super(key: key);

  void submit(BuildContext context) {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      showSnackBar(new Text("Settings updated!"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: const EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            children: <Widget>[
              new TextFormField(
                decoration: const InputDecoration(
                  labelText: "Server URL",
                ),
                initialValue: getPreference(sharedPreferences, Prefs.serverUrl),
                onSaved: (String value) {
                  String oldValue =
                      getPreference(sharedPreferences, Prefs.serverUrl);
                  if (oldValue == value) {
                    return;
                  }
                  setStringPreference(
                      sharedPreferences, Prefs.serverUrl, value);
                  logOut(context);
                },
              ),
              new RaisedButton(
                child: new Text(
                  'Submit',
                  style: new TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: () => this.submit(context),
              ),
            ],
          ),
        ));
  }

  String title() {
    return "Settings";
  }

  final List<MenuItem> defaultMenuItems;
  final SharedPreferences sharedPreferences;
  final GlobalKey<FormState> _formKey;
  final Function logOut;
  final Function showSnackBar;
}
