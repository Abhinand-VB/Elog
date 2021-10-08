import 'package:Elog/model/log.dart';

import 'log_event.dart';

class AddLog extends LogEvent {
  Log newLog;

  AddLog(Log log) {
    newLog = log;
  }
}
