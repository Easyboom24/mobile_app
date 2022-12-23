import 'package:badges/badges.dart' as BadgeWidget;
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:mobile_app/backend/controllers/newMyMoodController.dart';

import 'package:mobile_app/backend/services/db.dart';
import 'package:mobile_app/frontend/projectColors.dart';
import 'package:sqflite/sqflite.dart';
import '../../backend/controllers/newEventController.dart';
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
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
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

  bool initFromData = false;

  String new_title = 'Новое занятие';
  String old_title = 'Занятие';

  TextEditingController titleController = TextEditingController();
  FocusNode titleFocus = FocusNode();
  String? titleValue = null;
  bool titleError = false;

  SingleValueDropDownController categoryController =
      SingleValueDropDownController();
  FocusNode searchCategoryFocus = FocusNode();
  FocusNode textFieldCategoryFocus = FocusNode();
  int? categoryValue = null;

  List<int> iconsValues = [
    0xf1f3,
    0xf48e,
    0xf1c2,
    0xf405,
    0xe532,
    0xe35e,
    0xef0f,
    0xf049
  ];
  int? iconValue = null;

  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    var tempData = getMyEventData(id_event);
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
    if (id_event > 0 && data != null && initFromData == false) {
      initFromData = true;

      print(data!['event']);

      titleValue = data!['event']['title'];
      titleController.text = data!['event']['title'];

      for (DropDownValueModel category
          in data!['categories_event_dropdownvalueModel']) {
        if (data!['event']['id_event_category'] == category.value) {
          categoryValue = data!['event']['id_event_category'];
          categoryController.dropDownValue = category;
          break;
        }
      }

      iconValue = int.parse(data!['event']['path_icon']);
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
                buildTextFields(),
                buildChoseIcons(),
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

  Widget buildTextFields() {
    double containerWidth = 300;
    return Container(
      width: containerWidth,
      padding: EdgeInsets.only(
        top: 16,
        bottom: 16,
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Color(0xFFf7f2f9),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        color: Color(0xFFf7f2f9),
      ),
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        children: [
          Container(
            width: containerWidth - 20,
            height: 55,
            child: TextField(
              controller: titleController,
              focusNode: titleFocus,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Введите название',
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
              onTap: () {
                titleFocus.requestFocus();
                setState(() {});
              },
              onChanged: (String value) {
                titleValue = value;
                setState(() { });
              },
              onSubmitted: (String value) {
                titleValue = value;
                setState(() { });
              },
            ),
          ),
          Container(
            width: containerWidth - 20,
            height: 55,
            child: DropDownTextField(
              textFieldDecoration: InputDecoration(
                labelText: 'Выберите категорию',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                floatingLabelStyle: TextStyle(
                  color: Color(0xFFFFBB12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFFBB12),
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
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              searchKeyboardType: TextInputType.text,
              searchDecoration: InputDecoration(
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
                labelText: "Название категории",
              ),
              clearOption: false,
              searchFocusNode: searchCategoryFocus,
              textFieldFocusNode: textFieldCategoryFocus,
              enableSearch: true,
              controller: categoryController,
              dropDownItemCount: 6,
              dropDownList: data!['categories_event_dropdownvalueModel'],
              onChanged: (value) {
                DropDownValueModel currentValue = value;
                categoryValue = currentValue.value;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChoseIcons() {
    return Container(
      width: 300,
      child: Wrap(
        direction: Axis.vertical,
        spacing: 14,
        children: [
          Text(
            "Выберите иконку",
            style: TextStyle(
              letterSpacing: 0.15,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            width: 300,
            padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Color(0xFFf7f2f9),
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              color: Color(0xFFf7f2f9),
            ),
            child: Wrap(
              spacing: 10,
              direction: Axis.horizontal,
              children: iconsValues
                  .map((icon) => InkWell(
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: iconValue == icon
                                  ? Color(0xFF2980B9)
                                  : Color(0xFFe2dde4),
                              width: 1,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            color: iconValue == icon
                                ? Color(0xFF2980B9)
                                : Color(0xFFe2dde4),
                          ),
                          child: Icon(
                            IconData(
                              icon,
                              fontFamily: 'MaterialIcons',
                            ),
                            size: 24,
                            color: iconValue == icon
                                ? Color(0xFFFFFFFF)
                                : Color(0xFF49454F),
                          ),
                        ),
                        onTap: () {
                          if (iconValue == icon) {
                            iconValue = null;
                          } else {
                            iconValue = icon;
                          }
                          setState(() {});
                        },
                      ))
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
      onTap: () {
        String errorMessage = "";

        if (titleValue == null || titleValue == "") {
          errorMessage = "Введите корректное название";
        } else if (categoryValue == null) {
          errorMessage = "Выберите категорию";
        } else if (iconValue == null) {
          errorMessage = "Выберите иконку";
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
          try{
            if (id_event > 0) {
              updateEvent(id_event, titleValue!, categoryValue!, iconValue!);
            } else {
              createEvent(titleValue!, categoryValue!, iconValue!);
            }
            Navigator.of(context, rootNavigator: true).pop(context);
          }
          catch(e){
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
    if (id_event > 0) {
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
          deleteEvent(data!['event']);
          Navigator.of(context, rootNavigator: true).pop(context);
        },
      );
    } else {
      return Container();
    }
  }
}
