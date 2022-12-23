import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:mobile_app/backend/models/ReminderModel.dart';
import 'package:mobile_app/backend/services/db.dart';


Future<bool> createReminder(int hour, int minute) async {
  String formatedtime = DateFormat('HH:mm')
      .format(DateTime(2000, 1, 1, hour, minute));
  var newIdRaw =
  await DB.rawQuery("SELECT MAX(id)+1 as id FROM ${ReminderModel.table}");
  int new_id_reminder = (newIdRaw.first["id"] != null) ? newIdRaw.first["id"] : 1;


  await DB.rawQuery(
    //При создании нового напоминания оно автоматически становится включенным
      "INSERT INTO ${ReminderModel.table}(id, time, is_use) VALUES(${new_id_reminder}, '${formatedtime}', 1)");

  return true;
}



Future<bool> updateReminder(int id_reminder, int hour, int minute) async {
  String formatedtime = DateFormat('HH:mm')
      .format(DateTime(2000, 1, 1, hour, minute));

  await DB.rawQuery(
      "UPDATE ${ReminderModel.table} SET time = '${formatedtime}' WHERE id=${id_reminder}");

  return true;
}
