import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_color_generator/material_color_generator.dart';
import '../../backend/controllers/deleteReminderController.dart';
import '../projectColors.dart';
import '/backend/services/db.dart';
import 'newEditReminder.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await DB.init();

  runApp(const DeleteReminder());
}

class DeleteReminder extends StatelessWidget {
  const DeleteReminder({super.key});

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
      home: const DeleteReminderPage(),
    );
  }
}

class DeleteReminderPage extends StatefulWidget {

  static PageRouteBuilder getRoute() {
    return PageRouteBuilder(
        transitionsBuilder: (_, animation, secondAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        }, pageBuilder: (_, __, ___) {
      return DeleteReminderPage();
    });
  }

  const DeleteReminderPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<DeleteReminderPage> createState() => _DeleteReminderPageState();
}

class _DeleteReminderPageState extends State<DeleteReminderPage> {

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
          title: buildAppBarTitleReminderPage(context),
          leading:
          IconButton(
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
  buildAppBarTitleReminderPage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Список напоминаний',
          style: TextStyle(
            fontSize: 22,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        ReminderCheckBox(),
      ],
    );
  }

  buildBodyMainPage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, NewEditReminderPage.getRoute());
      },
      onLongPress: () {
        Navigator.push(
            context, DeleteReminderPage.getRoute());
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 130,
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                  "20:13", //Подстановка из БД
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
              ),
              flex: 2,
            ),
            Expanded(
              child: Text(""),
              flex: 4,
            ),
            Expanded(
              child: ReminderCheckBox(),
              flex: 1,
            ),

          ],
        ),
      ),
    );
  }
}

