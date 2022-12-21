import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_color_generator/material_color_generator.dart';
import '../projectColors.dart';
import '../../main.dart';
import '/backend/services/db.dart';
import 'package:mobile_app/frontend/screens/newMyMood.dart';

class Meditation extends StatelessWidget {
  int id_meditation;

  Meditation(int this.id_meditation, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(color: Color(0xFFFFFFFF)),
      ),
      home: MeditationPage(id_meditation),
    );
  }
}

class MeditationPage extends StatefulWidget {
  int id_meditation;

  MeditationPage(int this.id_meditation, {super.key});

  @override
  State<MeditationPage> createState() => _MeditationPageState(id_meditation);
}

class _MeditationPageState extends State<MeditationPage> {
  int id_meditation;

  _MeditationPageState(int this.id_meditation);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          elevation: 0,
          title: buildAppBarTitleMaditationPage(context),
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

  buildAppBarTitleMaditationPage(BuildContext context) {
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
          'Медитация',
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

  buildBodyMainPage(BuildContext context) {
    return Text("Hello");
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyMyMood(-1)));
            } else if (index == 0) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyApp(-1)));
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
