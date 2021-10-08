import 'log_event.dart';

class DeleteLog extends LogEvent {
  int logIndex;

  DeleteLog(int index) {
    logIndex = index;
  }
}
