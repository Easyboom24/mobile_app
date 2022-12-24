import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:mobile_app/backend/models/MeditationModel.dart';
import '../projectColors.dart';
import '../../main.dart';
import 'package:mobile_app/backend/models/MeditationModel.dart';
import '../../backend/controllers/meditationController.dart';
import 'package:mobile_app/frontend/screens/newMyMood.dart';
import 'package:mobile_app/frontend/screens/playMeditation.dart';

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
  static PageRouteBuilder getRoute() {
    return PageRouteBuilder(
        transitionsBuilder: (_, animation, secondAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }, pageBuilder: (_, __, ___) {
      return MeditationPage();
    });
  }

  MeditationPage({super.key});

  @override
  State<MeditationPage> createState() => _MeditationPageState();
}

class _MeditationPageState extends State<MeditationPage> {
  _MeditationPageState();
  int seconds = 0;
  int minutes = 0;

  List<MeditationModel> data = List.empty();
  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    var tempData = getMeditationData();
    tempData.then((s) {
      setState(() {
        data = s;
      });
    });
  }

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
          ),
          child: Wrap(
            direction: Axis.vertical,
            spacing: 14,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 50),
                width: MediaQuery.of(context).size.width * 0.93,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                  color: Color(0xFFeee8f4),
                ),
                padding: EdgeInsets.only(
                  top: 12,
                  bottom: 12,
                  left: 12,
                  right: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: Text(
                        "Выберите звук",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: data
                              .map(
                                (i) => Container(
                                  margin: EdgeInsets.only(right: 22),
                                  width:
                                      MediaQuery.of(context).size.width * 0.22,
                                  height: 85,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF2980B9),
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xFF2980B9),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(23),
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    i.path_icon,
                                    // "assets/images/fire.svg",
                                    width: 70,
                                    height: 70,
                                  ),
                                ),
                              )
                              .toList()
                              .cast<Widget>()
                          //[

                          // Container(
                          //   margin: EdgeInsets.only(right: 22),
                          //   width: MediaQuery.of(context).size.width * 0.22,
                          //   height: 85,
                          //   decoration: BoxDecoration(
                          //     color: Color(0xFF2980B9),
                          //     border: Border.all(
                          //       width: 1,
                          //       color: Color(0xFF2980B9),
                          //     ),
                          //     borderRadius: BorderRadius.all(
                          //       Radius.circular(23),
                          //     ),
                          //   ),
                          //   child: SvgPicture.asset(
                          //     "assets/images/fire.svg",
                          //     width: 70,
                          //     height: 70,
                          //   ),
                          // ),
                          // Container(
                          //   margin: EdgeInsets.only(right: 22),
                          //   width: MediaQuery.of(context).size.width * 0.31,
                          //   height: 110,
                          //   decoration: BoxDecoration(
                          //     color: Color(0xFF2980B9),
                          //     border: Border.all(
                          //       width: 1,
                          //       color: Color(0xFF2980B9),
                          //     ),
                          //     borderRadius: BorderRadius.all(
                          //       Radius.circular(23),
                          //     ),
                          //   ),
                          //   child: SvgPicture.asset(
                          //     "assets/images/rain.svg",
                          //     width: 80,
                          //     height: 80,
                          //   ),
                          // ),
                          // Container(
                          //   width: MediaQuery.of(context).size.width * 0.22,
                          //   height: 85,
                          //   decoration: BoxDecoration(
                          //     color: Color(0xFF2980B9),
                          //     border: Border.all(
                          //       width: 1,
                          //       color: Color(0xFF2980B9),
                          //     ),
                          //     borderRadius: BorderRadius.all(
                          //       Radius.circular(23),
                          //     ),
                          //   ),
                          //   child: SvgPicture.asset(
                          //     "assets/images/wind.svg",
                          //     width: 70,
                          //     height: 70,
                          //   ),
                          // ),
                          //],
                          ),
                    ),
                    Container(
                      child: Text(
                        "Дождь",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ],
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
                margin: EdgeInsets.only(top: 30),
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
                      Wrap(
                        spacing: 7,
                        direction: Axis.horizontal,
                        children: [
                          Container(
                            width: 95,
                            height: 95,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                              ],
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              // ignore: prefer_const_constructors
                              style: TextStyle(
                                fontSize: 57,
                                color: Color(0xFF1C1B1F),
                              ),
                              // ignore: prefer_const_constructors
                              decoration: InputDecoration(
                                // ignore: prefer_const_constructors
                                contentPadding: EdgeInsets.only(
                                  bottom: 1,
                                  top: 1,
                                ),
                                filled: true,
                                helperText: "Минуты",
                                helperStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFFBB12),
                                    width: 2,
                                  ),
                                ),
                              ),
                              cursorColor: Color(0xFFFFBB12),
                              onSubmitted: (value) {
                                try {
                                  minutes = int.parse(value);
                                } catch (e) {
                                  minutes = 0;
                                }
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
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                              ],
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              // ignore: prefer_const_constructors
                              style: TextStyle(
                                fontSize: 57,
                                color: Color(0xFF1C1B1F),
                              ),
                              // ignore: prefer_const_constructors
                              decoration: InputDecoration(
                                // ignore: prefer_const_constructors
                                contentPadding: EdgeInsets.only(
                                  bottom: 1,
                                  top: 1,
                                ),
                                filled: true,

                                helperText: "Секунды",
                                helperStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),

                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFFBB12),
                                    width: 2,
                                  ),
                                ),
                              ),
                              cursorColor: Color(0xFFFFBB12),
                              onSubmitted: (value) {
                                try {
                                  if (int.parse(value) > 59) {
                                    minutes = minutes + int.parse(value) ~/ 60;
                                    seconds = (int.parse(value) % 60).toInt();
                                  } else {
                                    seconds = int.parse(value);
                                  }
                                } catch (e) {
                                  seconds = 0;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(100),
                ),
                child: Container(
                  width: 214,
                  height: 64,
                  padding: EdgeInsets.only(
                    top: 12,
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Color(0xFFFFFBFE),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                    color: Color(0xFFeee8f4),
                  ),
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 6),
                          width: 18,
                          height: 18,
                          child: SvgPicture.asset("assets/images/play.svg",
                              width: 18, height: 18),
                        ),
                        Center(
                          child: Text(
                            "Начать",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.1,
                                color: Color(0xFF2980B9)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () async {
                  Navigator.push(context, PlayMeditationPage.getRoute());
                },
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
              Navigator.push(context, MyMyMoodPage.getRoute(-1));
            } else if (index == 0) {
              Navigator.push(context, MyHomePage.getRoute());
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
