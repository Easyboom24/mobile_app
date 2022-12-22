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

class MyEvent extends StatelessWidget {
  int id_event;

  MyEvent(int this.id_event, {super.key});

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
      home: MyEventPage(id_event),
    );
  }
}

class MyEventPage extends StatefulWidget {
  int id_event;

  static PageRouteBuilder getRoute(int id_event) {
    id_event = id_event;

    return PageRouteBuilder(
        transitionsBuilder: (_, animation, secondAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }, pageBuilder: (_, __, ___) {
      return MyEvent(id_event);
    });
  }

  MyEventPage(int this.id_event, {super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyEventPage> createState() => _MyEventPageState(id_event);
}

class _MyEventPageState extends State<MyEventPage> {
  int id_event;

  _MyEventPageState(int this.id_event);

  String new_title = 'Новое Занятие';
  String old_title = 'Занятие';

  var data;

  @override
  void initState() {
    super.initState();
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
          leading: IconButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 24,
              )),
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '${id_event > 0 ? old_title : new_title}',
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
              children: [],
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
}
