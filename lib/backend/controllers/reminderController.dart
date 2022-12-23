import 'package:flutter/material.dart';

import '../../frontend/projectColors.dart';
import '../services/db.dart';
import 'package:mobile_app/backend/models/ReminderModel.dart';
class SwitchReminder extends StatefulWidget {
  bool light;
  SwitchReminder(bool this.light, {super.key});

  @override
  State<SwitchReminder> createState() => _SwitchReminderState(light);
}

class _SwitchReminderState extends State<SwitchReminder> {
  bool light;

  _SwitchReminderState(bool this.light);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.5,
      child: Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: Color(thirdColor),
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
          //Здесь поменять состояние в БД
        });
      },
    ),
    );
  }
}


//---------------БД--------------
getReminderData()
async {
  List ReminderMaps = await DB.rawQuery("SELECT * FROM ${ReminderModel.table} ORDER BY time");
  //return ReminderMaps;
  return ReminderMaps.isNotEmpty ? ReminderMaps.map((c) => ReminderModel.fromMap(c)).toList() : [];
}