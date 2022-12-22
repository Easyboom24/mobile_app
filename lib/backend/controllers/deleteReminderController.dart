import 'package:flutter/material.dart';

import '../../frontend/projectColors.dart';

class ReminderCheckBox extends StatefulWidget {
  const ReminderCheckBox({super.key});

  @override
  State<ReminderCheckBox> createState() => _ReminderCheckBoxState();
}

class _ReminderCheckBoxState extends State<ReminderCheckBox> {
  bool isChecked = false;
  bool allCheck = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.focused,
      };
      return Color.fromRGBO(41, 128, 185, 100);
    }

    return Transform.scale(
      scale: 1.5,
      child: Checkbox(
        shape: CircleBorder(),
        checkColor: Colors.white,
        fillColor: MaterialStateProperty.resolveWith(getColor),
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value!;
          });
        },
      ),
    );
  }
}