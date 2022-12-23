import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:mobile_app/backend/models/ReminderModel.dart';
import 'package:mobile_app/backend/services/db.dart';


void deleteReminder(Map reminder) async {
  ReminderModel myMoodModel = ReminderModel(
      id: reminder['id'],
      time: reminder['time'],
      is_use: reminder['id_mood']);
  await DB.delete(ReminderModel.table, myMoodModel);

  await DB.rawQuery(
      "DELETE FROM ${ReminderModel.table} WHERE id_my_mood=${reminder['id']}");
}

Future<bool> createReminder(int hour, int minute) async {
  String formatedtime = DateFormat('HH:mm')
      .format(DateTime(hour = hour, minute = minute));
  var newIdRaw =
  await DB.rawQuery("SELECT MAX(id) FROM " +ReminderModel.table);
  int new_id_reminder = (newIdRaw == null) ?newIdRaw.first["id"] : 1;

  await DB.rawQuery(
    //При создании нового напоминания оно автоматически становится включенным
      "INSERT INTO ${ReminderModel.table}(id, time, is_use) VALUES(${new_id_reminder}, '${formatedtime}', 1)");

  return true;
}



Future<bool> updateMyMood(int id_reminder, int hour, int minute, bool is_use) async {
  String formatedtime = DateFormat('HH:mm')
      .format(DateTime(hour, minute));

  await DB.rawQuery(
      "UPDATE ${ReminderModel.table} SET time = ${formatedtime}, is_use = '${is_use}' WHERE id=${id_reminder}");

  return true;
}
