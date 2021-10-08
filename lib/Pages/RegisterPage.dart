import 'package:flutter/material.dart';
import 'package:Elog/Services/globals.dart' as g;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Elog/Services/PermissionChecker.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  void checkRegistered() async {
    final prefs = await SharedPreferences.getInstance();
// Try reading data from the registered key. If it doesn't exist, return 0.
    g.registered = prefs.getBool('registered') ?true: false;
    if (g.registered) {
      g.ns = prefs.getString('ns');
      g.datau[0] = prefs.getString('datau[0]');
      g.datau[1] = prefs.getString('datau[1]');
      g.datau[2] = prefs.getString('datau[2]');
      Navigator.popAndPushNamed(context, '/home', arguments: {});
    }
  }

  void submitfunc() async {
    FocusScope.of(context).nextFocus();



    if (_formKey.currentState.validate()) {
      g.registered = true;
      _formKey.currentState.save();
      final prefs = await SharedPreferences.getInstance();
// set value
      prefs.setString('ns', g.ns);
      prefs.setString('datau[0]', g.datau[0]);
      prefs.setString('datau[1]', g.datau[1]);
      prefs.setString('datau[2]', g.datau[2]);
      prefs.setBool('registered', g.registered);
      Navigator.popAndPushNamed(context, '/home', arguments: {});
      //code here
    }
  }

  void intialfunc() {
    PermissionsService().checkPermissions();
    checkRegistered();
    intialise();
  }

  MediaQueryData queryData;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _placeController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();

  void intialise() {
    _nameController.text = g.datau[0];
    _placeController.text = g.datau[1];
    _phoneController.text = g.datau[2];
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('E-Log'),
            content: new Text('Do you wish to go back?'),
            actions: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new FlatButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text("YES"),
                    ),
                    SizedBox(height: 0, width: 16*g.m),
                    new FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("NO"),
                    ),
                  ])
            ],
          ),
        ) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    intialfunc();
  }





  @override
  Widget build(BuildContext context) {
    
//Fix Screen Rotationa and pixel ratio manually
    queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio; //2.55MiA1
    double width = queryData.size.width; //423.53MiA1
    double height = queryData.size.height; //752.942MiA1
    double m = (devicePixelRatio / 2.55) *
        (width / (423.53 * (devicePixelRatio / 2.55)));
    g.m = m;
    g.h = (height / 752.942);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
///////
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
                "E-Log", //App name
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: g.m* 30.0,
                  wordSpacing: 4.0,
                ),
              ),
            ),
          ),
          body: Container(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Wrap(children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Name*',
                    hintText: 'Your official Name',
                  ),
                  textInputAction: TextInputAction.next,
                  controller: _nameController,
                  //autofocus: true,////////////////////////////////////ON/OFF according to requirement
                  onSaved: (String value) {
                    g.datau[0] = value;
                    g.ns = value[0];
                  },
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).nextFocus();
                  },
                  validator: (String value) {
                    return value.isEmpty ? 'This Field is mandatory' : null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.home),
                    labelText: 'Place*',
                    hintText: 'Where do you live',
                  ),
                  textInputAction: TextInputAction.next,
                  onSaved: (String value) {
                    g.datau[1] = value;
                  },
                  controller: _placeController,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).nextFocus();
                  },
                  validator: (String value) {
                    return value.isEmpty ? 'This Field is mandatory' : null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.phone),
                    labelText: 'Phone*',
                    hintText: 'Your mobile phone number',
                  ),
                  textInputAction: TextInputAction.next,
                  onSaved: (String value) {
                    g.datau[2] = value;
                  },
                  controller: _phoneController,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).nextFocus();
                  },
                  validator: (String value) {
                    String pattern = r'(^[0-9]{10}$)';
                    RegExp regExp = new RegExp(pattern);
                    if (value.length == 0) {
                      return 'This Field is mandatory';
                    } else if (!regExp.hasMatch(value)) {
                      return 'Please enter valid mobile number';
                    }
                    return null;
                  },
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 20.0*g.h),
                          RaisedButton.icon(
                            onPressed: () {
                              submitfunc();
                            },
                            label: Text('Submit',
                                style: TextStyle(
                                  fontSize: g.m* 20.0,
                                  wordSpacing: 2.0,
                                  color: Colors.white,
                                )),
                            color: Colors.blue[500],
                            icon: Icon(
                              Icons.save_alt,
                              color: Colors.white,
                              //size: 45.0,
                            ),
                          ),
                        ]),
                  ),
                )
              ]),
            ),
          )),
        ));
  }
}
