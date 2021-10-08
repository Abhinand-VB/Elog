import 'package:Elog/events/add_log.dart';
import 'package:Elog/events/delete_log.dart';
import 'package:Elog/events/log_event.dart';
import 'package:Elog/events/set_logs.dart';
import 'package:Elog/events/update_log.dart';
import 'package:Elog/model/log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogBloc extends Bloc<LogEvent, List<Log>> {
  @override
  List<Log> get initialState => List<Log>();

  @override
  Stream<List<Log>> mapEventToState(LogEvent event) async* {
    if (event is SetLogs) {
      yield event.logList;
    } else if (event is AddLog) {
      List<Log> newState = List.from(state);
      if (event.newLog != null) {
        newState.add(event.newLog);
      }
      yield newState;
    } else if (event is DeleteLog) {
      List<Log> newState = List.from(state);
      newState.removeAt(event.logIndex);
      yield newState;
    } else if (event is UpdateLog) {
      List<Log> newState = List.from(state);
      newState[event.logIndex] = event.newLog;
      yield newState;
    }
  }
}
