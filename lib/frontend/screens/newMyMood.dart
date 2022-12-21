import 'package:badges/badges.dart' as BadgeWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:mobile_app/backend/controllers/newMyMoodController.dart';

import 'package:mobile_app/backend/services/db.dart';
import 'package:mobile_app/frontend/projectColors.dart';
import 'package:sqflite/sqflite.dart';
import '../../main.dart';
import '/backend/controllers/mainController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class MyMyMood extends StatelessWidget {
  int id_my_mood;

  MyMyMood(int this.id_my_mood, {super.key});

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
      home: MyMyMoodPage(id_my_mood),
    );
  }
}

class MyMyMoodPage extends StatefulWidget {
  int id_my_mood;

  MyMyMoodPage(int this.id_my_mood, {super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyMyMoodPage> createState() => _MyMyMoodPageState(id_my_mood);
}

class _MyMyMoodPageState extends State<MyMyMoodPage> {
  int id_my_mood;

  _MyMyMoodPageState(int this.id_my_mood);

  String new_title = 'Новое настроение';
  String old_title = 'Настроение';

  var currentDate = null;
  bool dateError = false;

  FocusNode hourFocus = FocusNode();
  var hourValue = null;
  bool isFocusedHour = false;
  bool hourError = false;

  FocusNode minuteFocus = FocusNode();
  var minuteValue = null;
  bool isFocusedMinute = false;
  bool minuteError = false;

  var data;

  @override
  void initState() {
    super.initState();
    setState(() {
      data = getMyMoodData(id_my_mood);
    });

    // dateinput.text = "${DateFormat('dd.MM.yyyy').format(DateTime.now())}";
  }

  @override
  void dispose() {
    hourFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          title: buildAppBarTitleMainPage(context),
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

  Widget buildAppBarTitleMainPage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              size: 24,
            )),
        Text(
          '${id_my_mood > 0 ? old_title : new_title}',
          style: TextStyle(
            fontSize: 22,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.calendar_today_outlined,
            size: 24,
          ),
          color: Color(0x00000000),
        )
      ],
    );
  }

  Widget buildBodyMainPage(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: EdgeInsets.only(
            top: 16,
            bottom: 16,
            left: 16,
            right: 16,
          ),
          child: Wrap(
            direction: Axis.vertical,
            spacing: 14,
            // Весь контент экрана по центру
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                width: 350,
                child: TextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Дата',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    floatingLabelStyle: TextStyle(
                      color: dateError ? Colors.red : Color(0xFFFFBB12),
                    ),
                    helperText: "DD.MM.YYYY",
                    helperStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: dateError ? Colors.red : Color(0xFFFFBB12),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFFFBB12),
                        width: 2,
                      ),
                    ),
                    counterText: dateError ? "Некорректная дата" : "",
                    counterStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                  cursorColor: Color(0xFFFFBB12),
                  onSubmitted: (String value) {
                    RegExp exp = RegExp(r'^[0-9]{2}\.[0-9]{2}\.[0-9]{4}$');

                    if (value.length != 10 || !exp.hasMatch(value)) {
                      dateError = true;
                      currentDate = null;
                    } else {
                      dateError = false;

                      DateFormat format = DateFormat("dd.MM.yyyy");

                      try {
                        currentDate = format.parseStrict(value);
                      } catch (e) {
                        dateError = true;
                        currentDate = null;
                      }
                    }

                    setState(() {});
                  },
                ),
              ),
              Container(
                width: 260,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Color(0xFFFFFBFE),
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
                        "Выберите время настроения",
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
                                  color: hourFocus.hasFocus
                                      ? Colors.red
                                      : Color(0xFFFFBB12),
                                ),
                                helperText: "Часы",
                                helperStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: hourError
                                        ? Colors.red
                                        : Color(0xFFE7E0EC),
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
                                    color: minuteError
                                        ? Colors.red
                                        : Color(0xFFE7E0EC),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
