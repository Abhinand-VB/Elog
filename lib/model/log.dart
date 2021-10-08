import 'package:Elog/db/database_provider.dart';

class Log{
  int id;
  String name;
  String place;
  String phone;
  String time;


  Log({this.id, this.name, this.place, this.phone, this.time});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_NAME: name,
      DatabaseProvider.COLUMN_PLACE: place,
      DatabaseProvider.COLUMN_PHONE: phone,
      DatabaseProvider.COLUMN_TIME: time,

    };
    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  Log.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    name = map[DatabaseProvider.COLUMN_NAME];
    place = map[DatabaseProvider.COLUMN_PLACE];
    phone = map[DatabaseProvider.COLUMN_PHONE];
    time = map[DatabaseProvider.COLUMN_TIME];
  }
}
