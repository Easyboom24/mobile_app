import 'package:badges/badges.dart' as BadgeWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:mobile_app/backend/controllers/newMyMoodController.dart';

import 'package:mobile_app/backend/services/db.dart';
import 'package:mobile_app/frontend/projectColors.dart';
import 'package:mobile_app/frontend/screens/newEvent.dart';
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

  static PageRouteBuilder getRoute(int id_my_mood) {
    id_my_mood = id_my_mood;

    return PageRouteBuilder(
        transitionsBuilder: (_, animation, secondAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }, pageBuilder: (_, __, ___) {
      return MyMyMoodPage(id_my_mood);
    });
  }

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

  bool initFromData = false;

  String new_title = 'Новое настроение';
  String old_title = 'Настроение';

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

  int? currentMood = null;

  TextEditingController commentController = TextEditingController();
  FocusNode commentFocus = FocusNode();
  String? commentValue = "";
  bool commentError = false;

  List<int> choseEvents = [];

  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    var tempData = getMyMoodData(id_my_mood);
    tempData.then((s) {
      setState(() {
        data = s;
      });
    });
  }

  @override
  void dispose() {
    dateFocus.dispose();
    hourFocus.dispose();
    minuteFocus.dispose();
    commentFocus.dispose();

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
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 24,
              )),
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '${id_my_mood > 0 ? old_title : new_title}',
          style: TextStyle(
            fontSize: 22,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget buildBodyMainPage(BuildContext context) {
    if (id_my_mood > 0 && data != null && initFromData == false) {
      initFromData = true;

      choseEvents = data!['my_mood']['events'];
      currentMood = data!['my_mood']['id_mood'];

      DateTime myMoodDateTime = data!['my_mood']['date'];
      DateTime myMoodDate = DateUtils.dateOnly(myMoodDateTime);

      currentDate = myMoodDate;
      dateController.text = DateFormat('dd.MM.yyyy').format(myMoodDate);

      hourValue = myMoodDateTime.hour.toString();
      hourController.text = myMoodDateTime.hour.toString();

      minuteValue = myMoodDateTime.minute.toString();
      minuteController.text = myMoodDateTime.minute.toString();

      commentValue = data!['my_mood']['comment'];
      commentController.text = data!['my_mood']['comment'];

      setState(() {});
    }

    if (data != null) {
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
                buildChooseDate(),
                buildChooseTime(),
                buildChooseMood(),
                buildComment(),
                buildEvents(),
                buildSaveButton(),
                buildDeleteButton(),
              ],
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: Text(
          'Перезагрузите экран 😣',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
  }

  Widget buildChooseDate() {
    return Container(
      width: 300,
      child: TextField(
        focusNode: dateFocus,
        controller: dateController,
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
        onTap: () {
          dateFocus.requestFocus();
          setState(() {});
        },
        onChanged: (String value) {
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
          ],
        ),
      ),
    );
  }

  Widget buildChooseMood() {
    return Container(
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 14,
        children: [
          Container(
            child: Text(
              "Выберите настроение",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            margin: EdgeInsets.only(
              left: 25,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFf7f2f9),
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Color(0xFFf7f2f9),
            ),
            child: Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: data!['moods']
                  .map(
                    (i) => InkWell(
                      child: Container(
                        child: SvgPicture.asset(
                          currentMood == i['id']
                              ? i['path_icon_selected']
                              : i['path_icon'],
                          width: 55,
                          height: 55,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          currentMood = i['id'];
                        });
                      },
                    ),
                  )
                  .toList()
                  .cast<Widget>(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildComment() {
    return Container(
      width: 300,
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 14,
        children: [
          Container(
            child: Text(
              "Введите свои данные",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            margin: EdgeInsets.only(
              left: 25,
            ),
          ),
          Container(
            width: 300,
            margin: EdgeInsets.only(top: 5, bottom: 5),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFf7f2f9),
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Color(0xFFf7f2f9),
            ),
            child: Container(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: TextField(
                controller: commentController,
                focusNode: commentFocus,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: 'Введите комментарий',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: Color(0xFFE7E0EC),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black38,
                      width: 2,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                ),
                cursorColor: Colors.black,
                cursorWidth: 1,
                onTap: () {
                  commentFocus.requestFocus();
                  setState(() {});
                },
                onChanged: (String value) {
                  commentValue = value;
                  setState(() {});
                },
                onSubmitted: (String value) {
                  commentValue = value;
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEvents() {
    return Container(
      width: 300,
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 14,
        children: [
          Container(
            child: Text(
              "Чем вы занимались?",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            margin: EdgeInsets.only(
              left: 25,
            ),
          ),
          Container(
            child: Wrap(
              spacing: 14,
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: data!['events_by_category']
                  .map(
                    (category) => Container(
                      child: BadgeWidget.Badge(
                        badgeContent: Container(
                          width: 24,
                          height: 24,
                          child: Container(
                            child: InkWell(
                              child: Icon(
                                Icons.add,
                                size: 24,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context, MyEventPage.getRoute(-1));
                              },
                            ),
                          ),
                        ),
                        badgeColor: Color(0xFFe2dde4),
                        position: BadgeWidget.BadgePosition.topEnd(
                          end: 7,
                          top: 10,
                        ),
                        child: Container(
                          width: 300,
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFf7f2f9),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Color(0xFFf7f2f9),
                          ),
                          child: Wrap(
                            direction: Axis.vertical,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            spacing: 5,
                            children: [
                              Text(
                                "${category['title']}",
                                style: TextStyle(
                                  letterSpacing: 0.15,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Wrap(
                                direction: Axis.horizontal,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: 10,
                                children: category['events']
                                    .map(
                                      (event) => InkWell(
                                        child: Wrap(
                                          direction: Axis.vertical,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          spacing: 5,
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: choseEvents
                                                          .contains(event['id'])
                                                      ? Color(0xFF2980B9)
                                                      : Color(0xFFe2dde4),
                                                  width: 1,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100)),
                                                color: choseEvents
                                                        .contains(event['id'])
                                                    ? Color(0xFF2980B9)
                                                    : Color(0xFFe2dde4),
                                              ),
                                              child: Icon(
                                                IconData(
                                                  int.parse(event['path_icon']),
                                                  fontFamily: 'MaterialIcons',
                                                ),
                                                size: 24,
                                                color: choseEvents
                                                        .contains(event['id'])
                                                    ? Color(0xFFFFFFFF)
                                                    : Color(0xFF49454F),
                                              ),
                                            ),
                                            Text(
                                              "${event['title']}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() {
                                            if (choseEvents
                                                .contains(event['id'])) {
                                              choseEvents.remove(event['id']);
                                            } else {
                                              choseEvents.add(event['id']);
                                            }
                                          });
                                        },
                                        onLongPress: () {
                                          Navigator.push(context,
                                              MyEventPage.getRoute(-1));
                                        },
                                      ),
                                    )
                                    .toList()
                                    .cast<Widget>(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList()
                  .cast<Widget>(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSaveButton() {
    return InkWell(
      child: Container(
        width: 270,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFF2ECC71),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          "Сохранить",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ),
      onTap: () async {
        String errorMessage = "";

        if (currentDate == null) {
          errorMessage = "Введите корректную дату";
        } else if (hourValue == null) {
          errorMessage = "Введите корректные часы";
        } else if (minuteValue == null) {
          errorMessage = "Введите корректные минуты";
        } else if (currentMood == null) {
          errorMessage = "Выберите настроение";
        } else if (commentValue == null) {
          errorMessage = "Введите комментарий";
        } else if (choseEvents.length == 0) {
          errorMessage = "Выберите хотя бы одно занятие";
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
          try {
            if (id_my_mood > 0) {
              await updateMyMood(
                  id_my_mood,
                  currentDate!,
                  int.parse(hourValue),
                  int.parse(minuteValue),
                  currentMood!,
                  commentValue!,
                  choseEvents);
            } else {
              await createMyMood(
                  currentDate!,
                  int.parse(hourValue),
                  int.parse(minuteValue),
                  currentMood!,
                  commentValue!,
                  choseEvents);
            }
            Navigator.pop(context, true);
          } catch (e) {
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Проверьте введеные данные, перезайдите на экран.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }

  Widget buildDeleteButton() {
    if (id_my_mood > 0) {
      return InkWell(
        child: Container(
          width: 270,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFFE74C3C),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            "Удалить",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
          ),
        ),
        onTap: () {
          data!['my_mood']['date'] = data!['my_mood']['date'].toString();
          deleteMyMood(data!['my_mood']);
          Navigator.pop(context, 'result');
        },
      );
    } else {
      return Container();
    }
  }
}
