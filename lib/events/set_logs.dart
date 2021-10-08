import 'package:Elog/model/log.dart';

import 'log_event.dart';

class SetLogs extends LogEvent {
  List<Log> logList;

  SetLogs(List<Log> logs) {
    logList = logs;
  }
}
