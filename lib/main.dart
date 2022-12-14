import 'package:badges/badges.dart' as BadgeWidget;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:graphic/graphic.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:mobile_app/backend/controllers/notifications.dart';

import 'package:mobile_app/backend/services/db.dart';
import 'package:mobile_app/frontend/projectColors.dart';
import 'package:mobile_app/frontend/screens/newMyMood.dart';
import 'package:mobile_app/frontend/screens/reminder.dart';
import 'package:sqflite/sqflite.dart';
import '/backend/controllers/mainController.dart';
import '/backend/controllers/newMyMoodController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'frontend/screens/meditation.dart';

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
  static PageRouteBuilder getRoute() {
    return PageRouteBuilder(
        transitionsBuilder: (_, animation, secondAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }, pageBuilder: (_, __, ___) {
      return MyHomePage();
    });
  }

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
    1: '????????????',
    2: '??????????????',
    3: '????????',
    4: '????????????',
    5: '??????',
    6: '????????',
    7: '????????',
    8: '????????????',
    9: '????????????????',
    10: '??????????????',
    11: '????????????',
    12: '??????????????'
  };
  String title = getTitle();
  List<int> years = getListOfYear();
  int selectedMonthCode = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  int tempSelectedMonthCode = DateTime.now().month;
  int tempSelectedYear = DateTime.now().year;

  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    NotificationApi.reminderNotif();
    refreshData();
  }

  void refreshData() {
    var tempData = getMainData(selectedMonthCode, selectedYear);
    tempData.then((s) {
      setState(() {
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
          automaticallyImplyLeading: false,
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
            onPressed: () {
              Navigator.push(context, ReminderPage.getRoute());
            },
            icon: Icon(
              Icons.notifications_none,
              size: 24,
            )),
        InkWell(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 22,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "????????????: ${MediaQuery.of(context).size.width} | ????????????: ${MediaQuery.of(context).size.height}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
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
          '???????????????? ?????????? ?? ??????',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
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
              Navigator.pop(context, '??????????');
            },
            child: Text(
              '??????????',
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
              Navigator.pop(context, '????');
            },
            child: Text(
              '????',
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
              // ???????? ?????????????? ???????????? ???? ????????????
              runAlignment: WrapAlignment.center,
              // ???????? ?????????????? ???????????? ???? ????????????
              crossAxisAlignment: WrapCrossAlignment.center,
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
          '?????? ???????????? ???? ?????????????????? ??????????',
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

    final dateFormat = DateFormat('dd.MM.yyyy HH:mm:ss');
    // return Container();
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 300,
      height: 300,
      child: Chart(
        data: data!['graphData'].cast<Map<dynamic, dynamic>>(),
        variables: {
          'day': Variable(
            accessor: (Map map) => map['day'] as String,
            scale: OrdinalScale(tickCount: 31, inflate: true),
          ),
          'avrgValue': Variable(
            accessor: (Map map) => map['avrgValue'] as num,
            scale:LinearScale(min: -1, max: 6,),
          ),
          'title': Variable(
            accessor: (Map map) => map['title'] as String,
          )
        },
        elements: [
          LineElement(
            position:
            Varset('day') * Varset('avrgValue'),
            shape: ShapeAttr(value: BasicLineShape(smooth: false)),
            selected: {
              'touchMove': {1}
            },
          ),
          PointElement(
            color: ColorAttr(
              variable: 'title',
              values: Defaults.colors10,
              updaters: {
                'groupMouse': {
                  false: (color) => color.withAlpha(100)
                },
                'groupTouch': {
                  false: (color) => color.withAlpha(100)
                },
              },
            ),
          ),
        ],
        coord: RectCoord(color: const Color(0xffdddddd)),
        axes: [
          Defaults.horizontalAxis,
          Defaults.verticalAxis,
        ],
        selections: {
          'touchMove': PointSelection(
            on: {
              GestureType.scaleUpdate,
              GestureType.tapDown,
              GestureType.longPressMoveUpdate
            },
            dim: Dim.x,
          )
        },
        tooltip: TooltipGuide(
          followPointer: [true, true],
          align: Alignment.topLeft,
          offset: const Offset(-20, -20),
          variables: [
            'day',
            'avrgValue',
          ],
        ),
        crosshair: CrosshairGuide(followPointer: [false, true]),
      ),
    );
  }

  Widget buildEventsCount(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "?????????????? ??????????????",
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
            width: 300,
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
              children: data!['eventsCount']
                  .map(
                    (i) => Container(
                      margin: EdgeInsets.only(
                        top: 5,
                        bottom: 5,
                      ),
                      child: (Column(
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
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      )),
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

  Widget buildMyMoodList(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "?????????????? ??????????????????????",
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
              children: data!['myMoodList']
                  .map(
                    (i) => InkWell(
                      onLongPress: () async {
                        await Navigator.push(
                            context, MyMyMoodPage.getRoute(i['id']));
                        refreshData();
                      },
                      child: Container(
                        width: 300,
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
        onTap: (int index) async {
          if (index == 0) {
            if(data != null){
              print(data!['graphData']);
            }
            //TODO: ??????????
          } else if (index == 1) {
            await Navigator.push(context, MyMyMoodPage.getRoute(-1));
          } else if (index == 2) {
            Navigator.push(context, MeditationPage.getRoute());
          }
          refreshData();
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
            label: '????????????????????',
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
            label: '?????????? ????????????????????',
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
            label: '??????????????????',
          ),
        ],
      ),
    );
  }
}
