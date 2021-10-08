import 'package:Elog/db/database_provider.dart';
import 'package:Elog/events/delete_log.dart';
import 'package:Elog/events/set_logs.dart';
import 'package:Elog/log_form.dart';
import 'package:Elog/model/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Elog/Services/globals.dart' as g;

import 'bloc/log_bloc.dart';

class LogList extends StatefulWidget {
  const LogList({Key key}) : super(key: key);

  @override
  _LogListState createState() => _LogListState();
}

class _LogListState extends State<LogList> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getLogs().then(
      (logList) {
        BlocProvider.of<LogBloc>(context).add(SetLogs(logList));
      },
    );
  }

  void deleteFunction(int index, Log log){
    DatabaseProvider.db.delete(log.id).then((_) {
              BlocProvider.of<LogBloc>(context).add(
                DeleteLog(index),
              );
              Navigator.pop(context);
              Navigator.pop(context);
            });
  }

  void updateFunction(int index,Log log){
    Navigator.pushReplacement(
              context,
              MaterialPageRoute<LogBloc>(
                    builder: (_) => BlocProvider.value(
                    value: BlocProvider.of<LogBloc>(context),
                    child: LogForm(log: log, logIndex: index),
                    )
              ),
            );
  }
  showLogDialog(BuildContext context, Log log, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(log.name,
        style: TextStyle(
          fontSize: 30.0*g.m,
          color: Colors.deepPurple,
        ),),
        content: Container(
          height: 70*g.h,
          child: Column(
            children: [
              Text("Phone: ${log.phone}",
                style: TextStyle(
                  fontSize: 20.0*g.m
                  ),),
              Text("Time: ${log.time}",
                  style: TextStyle(
                   fontSize: 20.0*g.m
                  ),),
            ],
          ),
        ),
        actionsPadding: EdgeInsets.all(10.0*g.m),
        buttonPadding: EdgeInsets.all(10.0*g.m),
        actions: <Widget>[
          FlatButton(
            //color: Colors.deepPurple,
            onPressed: () => updateFunction(index,log),
            child: Text("Update",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20*g.m
            ),),
          ),
          FlatButton(
            //color: Colors.deepPurple,
            onPressed: () {
              showLogDialogwarning(context,log,index);
              
            },
            child: Text("Delete",
            style: TextStyle(
              color: Colors.red,
              fontSize: 20*g.m
            ),),
          ),
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
  showLogDialogwarning(BuildContext context, Log log, int index) {
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
          child: Text("Once Deleted   data will be gone",
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
            onPressed: () => deleteFunction(index,log),
            child: Text("Delete",
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
    print("Building entire log list scaffold");
    return Scaffold(
      appBar: AppBar(title: Text("Reports"),
      backgroundColor: Colors.deepPurple,),
      body: Container(
        child: BlocConsumer<LogBloc, List<Log>>(
          builder: (context, logList) {
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                print("logList: $logList");

                Log log = logList[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10.0,5.0 , 10.0, 5.0),
                  child: Card(
                    child: ListTile(
                        title: Text(log.name, style: TextStyle(fontSize: 30)),
                        subtitle: Text(
                          "Phone: ${log.phone}\nTime: ${log.time}",
                          style: TextStyle(fontSize: 20),
                        ),
                        onTap: () => showLogDialog(context, log, index)),
                  ),
                );
              },
              itemCount: logList.length,
              separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black),
            );
          },
          listener: (BuildContext context, logList) {},
        ),
      ),
    );
  }
}
