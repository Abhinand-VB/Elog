import 'package:Elog/Services/PermissionChecker.dart';
import 'package:Elog/bloc/log_bloc.dart';
import 'package:Elog/db/database_provider.dart';
import 'package:Elog/events/add_log.dart';
import 'package:Elog/model/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:Elog/Services/globals.dart' as g;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String scanResult = '';
  List<Widget> tabs = [];
  int _selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();
  List<String> datal = new List(3); //temporary Customer data
  List<String> datau = new List(3); //temporary User data

  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _placeController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();

  bool _isAuto=false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future scanfunc() async {
    PermissionsService().checkPermissions();
    String cameraScanResult = await scanner.scan();
    setState(() {
      scanResult = cameraScanResult;
      int l=scanResult.length;
      scanResult = scanResult.substring(1, l-1);
      datal=scanResult.split(', ');
      _nameController.text = datal[0];
      _placeController.text = datal[1];
      _phoneController.text = datal[2];
    });
    if (_isAuto){
      submitfunc();
    }
  }
  void start() {
    PermissionsService().checkPermissions();
    //code run at first time
  }

  void submitfunc() {
    PermissionsService().checkPermissions();
    if (!_formKey.currentState.validate()) {
      return;
    }
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    _formKey.currentState.save();
    print(datal);
    Log log = Log(
      name: _nameController.text,
      place:  _placeController.text, 
      phone:  _phoneController.text,
      time: formattedDate,
    );

    DatabaseProvider.db.insert(log).then(
          (storedLog) => BlocProvider.of<LogBloc>(context).add(
        AddLog(storedLog),
      ),
    );
    _nameController.text='';
    _placeController.text='';
    _phoneController.text='';

    showSnackBar();

  }

  void intialfunc() {
    start();
    intialise();
    PermissionsService().checkPermissions();
  }

  void showSnackBar() {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.deepPurple,
      content: Text('Log Saved Successfully'),
      duration: Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: scaffoldKey.currentState.hideCurrentSnackBar,
      ),
    ));
  }

  void intialise() {

    datau = g.datau;
    tabs = [
      Container(
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
                datal[0] = value;
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
              controller: _placeController,
              onSaved: (String value) {
                datal[1] = value;
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
                icon: Icon(Icons.phone),
                labelText: 'Phone*',
                hintText: 'Your mobile phone number',
              ),
              textInputAction: TextInputAction.next,
              controller: _phoneController,
              onSaved: (String value) {
                datal[2] = value;
              },
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
                      RaisedButton.icon(
                        onPressed: () {
                          scanfunc();
                        },
                        label: Text(' Scan ',
                            style: TextStyle(
                              fontSize: 20.0*g.m,
                              wordSpacing: 2.0,
                              color: Colors.white,
                            )),
                        color: Colors.blue[500],
                        icon: Icon(
                          Icons.photo_camera,
                          color: Colors.white,
                          //size: 45.0,
                        ),
                      ),
                      SizedBox(height: 20.0*g.h),
                      RaisedButton.icon(
                        onPressed: () {
                          submitfunc();
                        },
                        label: Text('Submit',
                            style: TextStyle(
                              fontSize: 20.0*g.m,
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
      //////////////////////////////////////////////////////////////////////// Personal
      Padding(
        padding: const EdgeInsets.all(50.0),
        child: Container(
          //color: Colors.blue,
          child: Center(
            child: QrImage(
              data: "$datau",
              version: QrVersions.auto,
              //size: 200.0,
            ),
          ),
        ),
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
                    fontSize: 30.0*g.m,
                    wordSpacing: 4.0,
                  ),
                ),
              ),
            ),
            key: scaffoldKey,
            body: tabs[_selectedIndex],
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          child: Text(
                            g.ns,
                            style: TextStyle(
                              fontSize: 30.0*g.m,
                            ),
                          ),
                          radius: 50.0,
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Edit Profile',
                     // textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0*g.m),
                    ),
                    onTap: () async {
                      g.registered = false;
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool('registered', g.registered);
                      Navigator.popAndPushNamed(context, '/registerpage');
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Reports',
                      //textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0*g.m),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/report');
                    },
                  ),
                  SwitchListTile(
                    title: Text("AutoSubmit",
                     style: TextStyle(fontSize:20.0*g.m),
                     //textAlign: TextAlign.center,
                     ),
                    value: _isAuto,
                    onChanged: (bool newValue) => setState(() {
                      _isAuto = newValue;
                    }),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.business),
                  label: "Business",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label:"Personal",
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.amber[800],
              onTap: _onItemTapped,
            )));
  }
}
