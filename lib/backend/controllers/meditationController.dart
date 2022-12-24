import 'package:flutter/material.dart';
import '../../frontend/projectColors.dart';
import '../services/db.dart';
import 'package:mobile_app/backend/models/MeditationModel.dart';

getMeditationData() async {
  List MeditationList =
      await DB.rawQuery("SELECT * FROM ${MeditationModel.table}");
  return MeditationList.map((c) => MeditationModel.fromMap(c)).toList();
}
