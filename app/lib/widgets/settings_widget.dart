import 'package:app/api/shared_api.dart';
import 'package:app/util/prefs.dart';
import 'package:flutter/material.dart';

@immutable
class SettingsWidget extends StatelessWidget {
  SettingsWidget(this._sharedApi, {Key key})
      : _formKey = new GlobalKey(),
        super(key: key);

  final SharedApi _sharedApi;
  final GlobalKey<FormState> _formKey;

  void submit(BuildContext context) {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      _sharedApi.showSnackBar(new Text("Settings updated!"));
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
                initialValue: _sharedApi.prefs().getPreference(Prefs.serverUrl),
                onSaved: (String value) {
                  String oldValue =
                      _sharedApi.prefs().getPreference(Prefs.serverUrl);
                  if (oldValue == value) {
                    return;
                  }
                  _sharedApi.prefs().setStringPreference(Prefs.serverUrl, value);
                  _sharedApi.logOut(context);
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
}
