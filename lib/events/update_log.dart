import 'package:Elog/model/log.dart';

import 'log_event.dart';

class UpdateLog extends LogEvent {
  Log newLog;
  int logIndex;

  UpdateLog(int index, Log log) {
    newLog = log;
    logIndex = index;
  }
}
