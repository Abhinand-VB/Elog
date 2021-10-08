import 'package:Elog/log_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Pages/Home.dart';
import 'Pages/RegisterPage.dart';
import 'bloc/log_bloc.dart';
import 'log_list.dart';

void main() => runApp(MaterialApp(initialRoute: '/registerpage', routes: {
      '/registerpage': (context) => RegisterPage(),
      '/home': (context) => Home(),
      '/report': (context) => Report(),
      '/form': (context) => LogForm(),
    }));

class Report extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LogBloc>(
      create: (context) => LogBloc(),
      child:  LogList(),

    );
  }
}