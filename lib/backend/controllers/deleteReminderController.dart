import 'package:flutter/material.dart';

import '../../frontend/projectColors.dart';
import '../models/ReminderModel.dart';
import '../services/db.dart';



//---------------БД--------------
getReminderData()
async {
  List ReminderMaps = await DB.rawQuery("SELECT * FROM ${ReminderModel.table} ORDER BY time");
  //return ReminderMaps;
  return ReminderMaps.isNotEmpty ? ReminderMaps.map((c) => ReminderModel.fromMap(c)).toList() : [];
}

void deleteReminder(List<int> id) {
  String idQuery = "(";
  for (var elem in id){
    idQuery += elem.toString() + ", ";
  }
  idQuery = idQuery.substring(0, idQuery.length - 2) + ")";
  DB.rawQuery(
      "DELETE FROM ${ReminderModel.table} WHERE id IN ${idQuery}");
}