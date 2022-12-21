import 'package:flutter/material.dart';

import '../../frontend/projectColors.dart';

class SwitchReminder extends StatefulWidget {
  const SwitchReminder({super.key});

  @override
  State<SwitchReminder> createState() => _SwitchReminderState();
}

class _SwitchReminderState extends State<SwitchReminder> {
  bool light = true;
  int id = 1; //Здесь указат id из БД

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