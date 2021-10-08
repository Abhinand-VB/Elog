import 'package:Elog/bloc/log_bloc.dart';
import 'package:Elog/db/database_provider.dart';
import 'package:Elog/events/update_log.dart';
import 'package:Elog/model/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Elog/Services/globals.dart' as g;


class LogForm extends StatefulWidget {
  final Log log;
  final int logIndex;

  LogForm({this.log, this.logIndex});

  @override
  State<StatefulWidget> createState() {
    return LogFormState();
  }
}

class LogFormState extends State<LogForm> {
  String _name;
  String _place;
  String _phone;
  String _time;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  Widget _buildName() {
    return TextFormField(
      initialValue: _name,
      decoration: InputDecoration(labelText: 'Name'),
      maxLength: 50,
      style: TextStyle(fontSize: 20*g.m),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildPlace() {
    return TextFormField(
      initialValue: _place,
      decoration: InputDecoration(labelText: 'Place'),
      maxLength: 100,
      style: TextStyle(fontSize: 20*g.m),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Place is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _place = value;
      },
    );
  }

  Widget _buildPhone() {
    return TextFormField(
      initialValue: _phone,
      decoration: InputDecoration(labelText: 'Phone'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 20*g.m),
      validator: (String value) {
        int calories = int.tryParse(value);

        if (calories == null || calories <= 1000000000||calories >=10000000000) {
          return 'Valid Phone Number is required';
        }

        return null;
      },
      onSaved: (String value) {
        _phone = value;
      },
    );
  }



  @override
  void initState() {
    super.initState();
    if (widget.log!= null) {
      _name = widget.log.name;
      _phone = widget.log.phone;
      _place = widget.log.place;
      _time= widget.log.time;
    }
  }
  void cancelfunc(){
  Navigator.pop(context);
}
void updatefunctionsub(int index,Log log){
  
    DatabaseProvider.db.update(widget.log).then(
          (storedLog) => BlocProvider.of<LogBloc>(context).add(
        UpdateLog(index ,log),
      ),
    );
    Navigator.pop(context);
    Navigator.pop(context);
}
void updatefunctionmain(int index){
    if (!_formKey.currentState.validate()) {
      print("form");
      return;
    }
      _formKey.currentState.save();
    Log log = Log(
      name: _name,
      phone: _phone,
      place: _place,
      time: _time,
    );
  showLogDialog(context, log, index);

}
  showLogDialog(BuildContext context, Log log, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Warning",
        style: TextStyle(
          fontSize: 30.0*g.m,
          color: Colors.red,
        ),),
        content: Container(
          height: 50*g.h,
          child: Text("Once Modified Previous data will be gone",
        style: TextStyle(
          fontSize: 20.0*g.m,
          color: Colors.red,
        ),),
        ),
        actionsPadding: EdgeInsets.all(10.0*g.m),
        buttonPadding: EdgeInsets.all(10.0*g.m),
        actions: <Widget>[
          FlatButton(
            //color: Colors.deepPurple,
            onPressed: () => updatefunctionsub(index,log),
            child: Text("Update",
            style: TextStyle(
              color: Colors.red,
              fontSize: 20*g.m
            ),),
          ),
          SizedBox(width: 10*g.h,),
          FlatButton(
            //color: Colors.deepPurple,
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel",
            style: TextStyle(
              color: Colors.green,
              fontSize: 20*g.m
            ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      appBar: AppBar(
        title: Text("Log Form"),
        backgroundColor:Colors.deepPurple ,
        ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              _buildName(),
              _buildPlace(),
              _buildPhone(),
              SizedBox(height: 60*g.h),
             Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.deepPurple,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Update",
                        style: TextStyle(color: Colors.red, fontSize: 20*g.m),
                      ),
                    ),
                    onPressed: () =>updatefunctionmain(widget.logIndex),
                  ),
                  RaisedButton(
                    color: Colors.deepPurple,
                    child: Padding(
                      padding: EdgeInsets.all(10.0*g.m),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.green, fontSize: 20*g.m),
                      ),
                    ),
                    onPressed: ()=>cancelfunc(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
