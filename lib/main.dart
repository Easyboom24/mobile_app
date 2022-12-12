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
  int _counter = 0;
  var title = getTitle();

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
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
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: buildAppBarTitleMainPage(context),
      ),
      body: buildBodyMainPage(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildAppBarTitleMainPage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none)),
        Text(title),
        IconButton(onPressed: () {}, icon: Icon(Icons.calendar_today_outlined))
      ],
    );
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
            Container(child: Text(Uri.base.path, style: TextStyle(fontSize: 22,),)),
            Container(child: Text('2', style: TextStyle(fontSize: 22,),)),
            Container(child: Text('3', style: TextStyle(fontSize: 22,),)),
          ],
        ),
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Color(0xFFD6D6D6),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.insert_chart_outlined, color: Colors.black), label: 'Статистика',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined), label: 'Новое настроение'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement_outlined), label: 'Медитация'
        ),
      ],
    );
  }

}
