import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile_app/backend/services/db.dart';
import 'package:mobile_app/frontend/projectColors.dart';
import '/backend/controllers/mainController.dart';

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
        primarySwatch: primarySwatchMaterialColor,
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
  int tempSelectedMonthCode = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  int tempSelectedYear = DateTime.now().year;

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
        preferredSize: Size.fromHeight(64),
        child: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          elevation: 0,
          title: buildAppBarTitleMainPage(context),
        ),
      ),
      body: buildBodyMainPage(),
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
              size: 30,
            )),
        Text(
          title,
          style: TextStyle(
            fontSize: 25,
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
              size: 30,
            ))
      ],
    );
  }

  StatefulBuilder buildAlertDialog(BuildContext context) {
    return StatefulBuilder(builder: (context, _setter){
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(28.0),
          ),
        ),
        title: Text('Выберите месяц и год'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(),
            Container(
              child: Row(
                children: [
                  DropdownButton(
                      value: tempSelectedMonthCode,
                      items: months
                          .map((monthCode, value) {
                        return MapEntry(
                          monthCode,
                          DropdownMenuItem(
                            value: monthCode,
                            child: Text(value),
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
                      value: tempSelectedYear,
                      items: years.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value.toString()),
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
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Назад');
            },
            child: Text(
              'Назад',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                selectedMonthCode = tempSelectedMonthCode;
                selectedYear = tempSelectedYear;
                title = "${months[selectedMonthCode]}, ${selectedYear}";
                //TODO: обновление данных страницы
              });
              Navigator.pop(context, 'ОК');
            },
            child: Text(
              'ОК',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    });
  }

  SingleChildScrollView buildBodyMainPage() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        margin: EdgeInsets.only(top: 16, bottom: 16),
        child: Wrap(
          direction: Axis.vertical,
          spacing: 10,
          children: [
            Container(
                child: Text(
              Uri.base.path,
              style: TextStyle(
                fontSize: 22,
              ),
            )),
            Container(
                child: Text(
              '2',
              style: TextStyle(
                fontSize: 22,
              ),
            )),
            Container(
                child: Text(
              '3',
              style: TextStyle(
                fontSize: 22,
              ),
            )),
          ],
        ),
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
        selectedFontSize: 16,
        selectedItemColor: Color(0xFF000000),
        unselectedFontSize: 16,
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
        items: [
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.only(
                bottom: 4,
              ),
              child: Icon(Icons.insert_chart_outlined, color: Colors.black),
            ),
            label: 'Статистика',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.only(
                bottom: 4,
              ),
              child: Icon(Icons.add_box_outlined),
            ),
            label: 'Новое настроение',
          ),
          BottomNavigationBarItem(
            icon: Container(
                margin: EdgeInsets.only(
                  bottom: 4,
                ),
                child: Icon(Icons.self_improvement_outlined)),
            label: 'Медитация',
          ),
        ],
      ),
    );
  }
}
