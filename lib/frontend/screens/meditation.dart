import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_color_generator/material_color_generator.dart';
import '../projectColors.dart';
import '../../main.dart';
import '/backend/services/db.dart';
import 'package:mobile_app/frontend/screens/newMyMood.dart';

class Meditation extends StatelessWidget {

  Meditation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(color: Color(0xFFFFFFFF)),
      ),
      home: MeditationPage(),
    );
  }
}

class MeditationPage extends StatefulWidget {
  MeditationPage({super.key});

  @override
  State<MeditationPage> createState() => _MeditationPageState();
}

class _MeditationPageState extends State<MeditationPage> {
  _MeditationPageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          centerTitle: true,
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
    return Text(
      'Медитация',
      style: TextStyle(
        fontSize: 22,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  buildBodyMainPage(BuildContext context) {
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
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
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
                        "Выберите продолжительность",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF49454F),
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w500,
                        ),
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
                  context, MaterialPageRoute(builder: (context) => MyApp()));
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
