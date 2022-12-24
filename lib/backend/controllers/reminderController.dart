import 'package:flutter/material.dart';
import 'package:mobile_app/backend/controllers/notifications.dart';

import '../../frontend/projectColors.dart';
import '../services/db.dart';
import 'package:mobile_app/backend/models/ReminderModel.dart';
class SwitchReminder extends StatefulWidget {
  bool light;
  int id;
  SwitchReminder(bool this.light, int this.id, {super.key});

  @override
  State<SwitchReminder> createState() => _SwitchReminderState(light, id);
}

class _SwitchReminderState extends State<SwitchReminder> {
  bool light;
  int id;

  _SwitchReminderState(bool this.light, int this.id);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.5,
      child: Switch(
        // This bool value toggles the switch.
        value: light,
        activeColor: Color(thirdColor),
        onChanged: (bool value) {
          changeUse(id, value);
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
  NotificationApi.reminderNotif();
  List ReminderMaps = await DB.rawQuery("SELECT * FROM ${ReminderModel.table} ORDER BY time");
  //return ReminderMaps;
  return ReminderMaps.isNotEmpty ? ReminderMaps.map((c) => ReminderModel.fromMap(c)).toList() : [];
}
  void changeUse(int id, bool value) async{
    var useQuery = value ? 1 : 0;
    await DB.rawQuery("UPDATE ${ReminderModel.table} SET is_use = '${useQuery}' WHERE id=${id}");
}