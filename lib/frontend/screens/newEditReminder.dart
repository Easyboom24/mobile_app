import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_color_generator/material_color_generator.dart';
import '../../backend/controllers/newEditReminderController.dart';
import '../../backend/controllers/reminderController.dart';
import '../projectColors.dart';
import '/backend/services/db.dart';

class EditReminder extends StatelessWidget {
  int id_my_mood;
  String time;

  EditReminder(int this.id_my_mood, String this.time, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: generateMaterialColor(color: Color(0xFFFFFFFF)),
      ),
      home: NewEditReminderPage(id_my_mood, time),
    );
  }
}

class NewEditReminderPage extends StatefulWidget {
  int id_my_mood;
  String time;

  static PageRouteBuilder getRoute(int id_my_mood, String time) {
    id_my_mood = id_my_mood;
    time = time;
    return PageRouteBuilder(
        transitionsBuilder: (_, animation, secondAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        }, pageBuilder: (_, __, ___) {
      return NewEditReminderPage(id_my_mood, time);
    });
  }

  NewEditReminderPage(int this.id_my_mood, String this.time, {super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<NewEditReminderPage> createState() => _NewEditReminderPageState(id_my_mood, time);
}

class _NewEditReminderPageState extends State<NewEditReminderPage> {

  int id_reminder;
  String time;
  var timeArray;


  _NewEditReminderPageState(int this.id_reminder, String this.time);

  bool initFromData = false;

  String new_title = 'Новое напоминание';
  String old_title = 'Редактирование напоминания';

  TextEditingController dateController = TextEditingController();
  FocusNode dateFocus = FocusNode();
  DateTime? currentDate = null;
  bool dateError = false;

  TextEditingController hourController = TextEditingController();
  FocusNode hourFocus = FocusNode();
  var hourValue = null;
  bool hourError = false;

  TextEditingController minuteController = TextEditingController();
  FocusNode minuteFocus = FocusNode();
  var minuteValue = null;
  bool minuteError = false;


  @override
  Widget build(BuildContext context) {
    if (initFromData == false){
      initFromData = true;
      timeArray = time.split(':');
      hourValue =  timeArray[0];
      hourController.text = timeArray[0];
      minuteValue =  timeArray[1];
      minuteController.text = timeArray[1];
      setState(() {});
    }

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          elevation: 0,
          leading:
          IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 24,
              )),
          title: buildAppBarTitleReminderPage(context),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(firstColor),
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
      ),
      backgroundColor: Color(firstColor),
      body: buildBodyMainPage(context),
    );
  }

  buildAppBarTitleReminderPage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          (id_reminder < 0) ? new_title : old_title,
          style: TextStyle(
            fontSize: (id_reminder < 0) ? 22 : 18,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  buildBodyMainPage(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 100),
      child: buildChooseTime(),
    );
  }

  Widget buildChooseTime() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Color(0xFFeee8f4),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(28),
        ),
        color: Color(0xFFeee8f4),
      ),
      padding: EdgeInsets.only(
        top: 24,
        bottom: 24,
        left: 24,
        right: 24,
      ),
      child: Container(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          direction: Axis.vertical,
          spacing: 20,
          children: [
            Text(
              "Выберите время напоминания",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF49454F),
                letterSpacing: 0.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            Wrap(
              spacing: 7,
              direction: Axis.horizontal,
              children: [
                Container(
                  width: 95,
                  height: 95,
                  child: TextField(

                    controller: hourController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2),
                    ],
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 57,
                      color: Color(0xFF1C1B1F),
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                        bottom: 1,
                        top: 1,
                      ),
                      filled: true,
                      fillColor: hourFocus.hasFocus
                          ? Color(0xFFFFECBD)
                          : Color(0xFFE7E0EC),
                      floatingLabelStyle: TextStyle(
                        color:
                        hourFocus.hasFocus ? Colors.red : Color(0xFFFFBB12),
                      ),
                      helperText: "Часы",
                      helperStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: hourError ? Colors.red : Color(0xFFE7E0EC),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFFBB12),
                          width: 2,
                        ),
                      ),
                    ),
                    cursorColor: Color(0xFFFFBB12),
                    focusNode: hourFocus,
                    onTap: () {
                      hourFocus.requestFocus();
                      setState(() {});
                    },
                    onChanged: (String value) {
                      try {
                        int currentValue = int.parse(value);
                        if (currentValue >= 0 && currentValue <= 23) {
                          hourError = false;
                          hourValue = value;
                        } else {
                          throw Error();
                        }
                      } catch (e) {
                        hourError = true;
                        hourValue = null;
                      }
                      setState(() {});
                    },
                    onSubmitted: (String value) {
                      try {
                        int currentValue = int.parse(value);
                        if (currentValue >= 0 && currentValue <= 23) {
                          hourError = false;
                          hourValue = value;
                        } else {
                          throw Error();
                        }
                      } catch (e) {
                        hourError = true;
                        hourValue = null;
                      }
                      setState(() {});
                    },
                  ),
                ),
                Text(
                  ":",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 57,
                  ),
                ),
                Container(
                  width: 95,
                  height: 95,
                  child: TextField(
                    controller: minuteController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2),
                    ],
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 57,
                      color: Color(0xFF1C1B1F),
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                        bottom: 1,
                        top: 1,
                      ),
                      filled: true,
                      fillColor: minuteFocus.hasFocus
                          ? Color(0xFFFFECBD)
                          : Color(0xFFE7E0EC),
                      floatingLabelStyle: TextStyle(
                        color: minuteFocus.hasFocus
                            ? Colors.red
                            : Color(0xFFFFBB12),
                      ),
                      helperText: "Минуты",
                      helperStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: minuteError ? Colors.red : Color(0xFFE7E0EC),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFFBB12),
                          width: 2,
                        ),
                      ),
                    ),
                    cursorColor: Color(0xFFFFBB12),
                    focusNode: minuteFocus,
                    onTap: () {
                      minuteFocus.requestFocus();
                      setState(() {});
                    },
                    onChanged: (String value) {
                      try {
                        int currentValue = int.parse(value);
                        if (currentValue >= 0 && currentValue <= 59) {
                          minuteError = false;
                          minuteValue = value;
                        } else {
                          throw Error();
                        }
                      } catch (e) {
                        minuteError = true;
                        minuteValue = null;
                      }
                      setState(() {});
                    },
                    onSubmitted: (String value) {
                      try {
                        int currentValue = int.parse(value);
                        if (currentValue >= 0 && currentValue <= 59) {
                          minuteError = false;
                          minuteValue = value;
                        } else {
                          throw Error();
                        }
                      } catch (e) {
                        minuteError = true;
                        minuteValue = null;
                      }
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            Wrap(
              spacing: 7,
              alignment: WrapAlignment.center,
              direction: Axis.horizontal,
              children: [
                Container(
                  width: 95,
                  height: 32,
                  alignment: Alignment.topLeft,
                  child: TextButton(
                      style: ButtonStyle(),
                      onPressed: () {},
                      child: Text(
                        "Назад",
                        style: TextStyle(
                            color: Color(thirdColor)
                        ),
                      ),
                  ),
                ),

                Container(
                  width: 95,
                  height: 32,
                  child: TextButton(
                      style: ButtonStyle(),
                      onPressed: () async {
                        String errorMessage = "";
                        if (hourValue == null) {
                        errorMessage = "Введите корректные часы";
                        } else if (minuteValue == null) {
                          errorMessage = "Введите корректные минуты";
                        }
                        if (errorMessage.length != 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${errorMessage}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  ),
                                ),
                            ),
                          );
                          } else {
                          if (id_reminder < 0){
                            await createReminder(int.parse(hourValue), int.parse(minuteValue));
                            Navigator.pop(context, true);
                          }
                          else{
                            await updateReminder(id_reminder, int.parse(hourValue), int.parse(minuteValue));
                            Navigator.pop(context, true);
                          }
                        }
                      },

                      child: Text(
                        "Сохранить",
                        style: TextStyle(
                          color: Color(thirdColor)
                        ),
                      ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}