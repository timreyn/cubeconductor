import 'package:app/util/prefs.dart';
import 'package:app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class SettingsWidget extends StatelessWidget {
  SettingsWidget(
      {@required this.defaultMenuItems,
      @required this.sharedPreferences,
      Key key})
      : _formKey = new GlobalKey(),
        super(key: key);

  void submit() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: buildAppBar(context, defaultMenuItems, "Settings"),
      body: new Container(
        padding: const EdgeInsets.all(8.0),
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
                  setStringPreference(
                      sharedPreferences, Prefs.serverUrl, value);
                },
              ),
              new RaisedButton(
                child: new Text(
                  'Submit',
                  style: new TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: this.submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<MenuItem> defaultMenuItems;
  final SharedPreferences sharedPreferences;
  final GlobalKey<FormState> _formKey;
}
