import 'package:badges/badges.dart' as BadgeWidget;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:graphic/graphic.dart';
import 'package:material_color_generator/material_color_generator.dart';

import 'package:mobile_app/backend/services/db.dart';
import 'package:mobile_app/frontend/projectColors.dart';
import 'package:mobile_app/frontend/screens/newMyMood.dart';
import 'package:sqflite/sqflite.dart';
import '/backend/controllers/mainController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DB.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var months = {
    1: 'Январь',
    2: 'Февраль',
    3: 'Март',
    4: 'Апрель',
    5: 'Май',
    6: 'Июнь',
    7: 'Июль',
    8: 'Август',
    9: 'Сентябрь',
    10: 'Октябрь',
    11: 'Ноябрь',
    12: 'Декабрь'
  };
  String title = getTitle();
  List<int> years = getListOfYear();
  int selectedMonthCode = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  int tempSelectedMonthCode = DateTime.now().month;
  int tempSelectedYear = DateTime.now().year;

  var data;

  @override
  void initState() {
    super.initState();
    var tempData = getMainData(selectedMonthCode, selectedYear);
    setState(() {
      tempData.then((s) {
        data = s;
      });
    });
  }

  void refreshData() {
    setState(() {
      var tempData = getMainData(selectedMonthCode, selectedYear);
      tempData.then((s) {
        data = s;
      });
    });
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
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildAppBarTitleMainPage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none,
              size: 24,
            )),
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return buildAlertDialog(context);
                  });
            },
            icon: Icon(
              Icons.calendar_today_outlined,
              size: 24,
            ))
      ],
    );
  }

  Widget buildAlertDialog(BuildContext context) {
    return StatefulBuilder(builder: (context, _setter) {
      return AlertDialog(
        backgroundColor: Color(0xFFFFFBFE),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(28.0),
          ),
        ),
        title: Text(
          'Выберите месяц и год',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
        ),
        content: Container(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF6750A4),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButton(
                        menuMaxHeight: 250,
                        value: tempSelectedMonthCode,
                        items: months
                            .map((monthCode, value) {
                              return MapEntry(
                                monthCode,
                                DropdownMenuItem(
                                  value: monthCode,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              );
                            })
                            .values
                            .toList(),
                        onChanged: (value) {
                          _setter(() {
                            tempSelectedMonthCode = value!;
                          });
                        }),
                    DropdownButton(
                        menuMaxHeight: 250,
                        value: tempSelectedYear,
                        items: years.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(
                              value.toString(),
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          _setter(() {
                            tempSelectedYear = value!;
                          });
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Назад');
            },
            child: Text(
              'Назад',
              style: TextStyle(
                color: Color(0xFF6750A4),
                fontSize: 14,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                selectedMonthCode = tempSelectedMonthCode;
                selectedYear = tempSelectedYear;
                title = "${months[selectedMonthCode]}, ${selectedYear}";

                var tempData = getMainData(selectedMonthCode, selectedYear);
                tempData.then((s) {
                  setState(() {
                    data = s;
                  });
                });
              });
              Navigator.pop(context, 'ОК');
            },
            child: Text(
              'ОК',
              style: TextStyle(
                color: Color(0xFF6750A4),
                fontSize: 14,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget buildBodyMainPage(BuildContext context) {
    // print('_________________________________________________________________');
    //
    // print(data);
    // print('_________________________________________________________________');
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
              spacing: 10,
              // Весь контент экрана по центру
              runAlignment: WrapAlignment.center,
              children: [
                buildGraph(context),
                buildEventsCount(context),
                buildMyMoodList(context),
              ],
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: Text(
          'Нет данных за выбранный месяц',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
  }

  Widget buildGraph(BuildContext context) {
    // print(data);
    return Container();
    // return Container(
    //   child: Chart(
    //     data: data['graphData'].cast(List<Map<String, dynamic>>),
    //     variables: {
    //       'argValue': Variable(
    //         accessor: (Map map) =>
    //             map['avrgValue'] as num,
    //       ),
    //     },
    //     elements: [IntervalElement()],
    //     axes: [
    //       Defaults.horizontalAxis,
    //       Defaults.verticalAxis,
    //     ],
    //   ),
    // );
  }

  Widget buildEventsCount(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "Счетчик занятий",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            margin: EdgeInsets.only(
              left: 50,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 16,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            padding: EdgeInsets.only(
              top: 16,
              bottom: 16,
              left: 10,
              right: 10,
            ),
            width: 350,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Color(0xFFCAC4D0),
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              color: Color(0xFFFFFBFE),
            ),
            child: Wrap(
              spacing: 10,
              children: data['eventsCount']
                  .map(
                    (i) => (Column(
                      children: [
                        BadgeWidget.Badge(
                          badgeContent: Text(
                            "${i.value['count']}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                          badgeColor: Color(0xFFB3261E),
                          position: BadgeWidget.BadgePosition.topEnd(end: -7),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFe9e4e8),
                                width: 8,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                              color: Color(0xFFe9e4e8),
                            ),
                            child: Icon(
                              IconData(int.parse(i.value['path_icon']),
                                  fontFamily: 'MaterialIcons'),
                              color: Color(0xFF49454F),
                              size: 22,
                            ),
                          ),
                        ),
                        Text(
                          '${i.value['title']}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              letterSpacing: 0.5),
                        ),
                      ],
                    )),
                  )
                  .toList()
                  .cast<Widget>(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMyMoodList(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "Дневник напоминаний",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            margin: EdgeInsets.only(
              left: 50,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 16,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            padding: EdgeInsets.only(
              top: 16,
              bottom: 16,
              left: 10,
              right: 10,
            ),
            child: Wrap(
              direction: Axis.vertical,
              spacing: 16,
              children: data['myMoodList']
                  .map(
                    (i) => InkWell(
                      onLongPress: (){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => MyMyMood(i['id'])));
                      },
                      child: Container(
                        width: 350,
                        height: 90,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Color(0xFFCAC4D0),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Wrap(
                          direction: Axis.horizontal,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          children: [
                            SvgPicture.asset(
                              i['path_icon'],
                              width: 40,
                              height: 40,
                            ),
                            Container(
                              width: 190,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${i['title']} ${DateFormat('dd.MM.yyyy').format(DateTime.parse(i['date']))}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.5,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '${i['comment'].length > 51 ? i['comment'].substring(0, 51) + '...' : i['comment']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                deleteMyMood(i);
                                refreshData();
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xFFE74C3C),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(2.0),
                                  ),
                                ),
                                child: Icon(
                                  Icons.delete,
                                  color: Color(0xFFE74C3C),
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
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

  Widget buildBottomNavigationBar() {
    return Container(
      color: Color(0xFFf3edf7),
      padding: EdgeInsets.only(
        top: 12,
        bottom: 16,
      ),
      child: BottomNavigationBar(
        backgroundColor: Color(0xFFf3edf7),
        selectedFontSize: 12,
        selectedItemColor: Color(0xFF000000),
        unselectedFontSize: 12,
        unselectedItemColor: Color(0xFF000000),
        selectedLabelStyle: TextStyle(
          fontStyle: FontStyle.normal,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: TextStyle(
          fontStyle: FontStyle.normal,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        elevation: 0,
        iconSize: 30,
        onTap: (int index) {
          setState(() {
            if (index == 1) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyMyMood(-1)));
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.only(
                bottom: 4,
              ),
              child: Icon(
                Icons.insert_chart_outlined,
                color: Colors.black,
                size: 24,
              ),
            ),
            label: 'Статистика',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.only(
                bottom: 4,
              ),
              child: Icon(
                Icons.add_box_outlined,
                color: Colors.black,
                size: 24,
              ),
            ),
            label: 'Новое настроение',
          ),
          BottomNavigationBarItem(
            icon: Container(
                margin: EdgeInsets.only(
                  bottom: 4,
                ),
                child: Icon(
                  Icons.self_improvement_outlined,
                  color: Colors.black,
                  size: 24,
                )),
            label: 'Медитация',
          ),
        ],
      ),
    );
  }
}
