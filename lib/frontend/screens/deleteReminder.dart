import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:mobile_app/backend/controllers/newEditReminderController.dart';
import '../../backend/controllers/deleteReminderController.dart';
import '../../backend/models/ReminderModel.dart';
import '../projectColors.dart';
import '/backend/services/db.dart';
import 'newEditReminder.dart';

List<int> deleteItems = [];

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

  List<ReminderModel>? data;
  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    var tempData = getReminderData();
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
          title: buildAppBarTitleReminderPage(context),
          leading:
          IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: Icon(
                Icons.close,
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
      bottomNavigationBar: buildBottomNavigationBar(context),
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
        ReminderCheckBox(-1),
      ],
    );
  }

  buildBodyMainPage(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: 100,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                      data![index].time, //Подстановка из БД
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold)
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Text(""),
                  flex: 4,
                ),
                Expanded(
                  child: ReminderCheckBox(data![index].id),
                  flex: 1,
                ),

              ],
            ),
          ),
        );
      },
      itemCount: data?.length??0,
    );
  }

  buildBottomNavigationBar(BuildContext context) {
    return InkWell(
      onTap: () {
        print(deleteItems.toString());
        deleteReminder(deleteItems);
        Navigator.pop(context, true);
      },
      child:
        Container(
            color: Color(0xFFFFFBFE),
            height: 70,
            padding: EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Icon(
                  Icons.delete,
                  color: Color(0xFFE74C3C),
                  size: 24,
                ),
                Text(
                  "Удалить",
                  style: TextStyle(
                    color: Color(0xFFE74C3C),
                  ),
                ),
              ],
            ),

          ),
        );
  }


}

class ReminderCheckBox extends StatefulWidget {
  int id;
  ReminderCheckBox(int this.id, {super.key});

  @override
  State<ReminderCheckBox> createState() => _ReminderCheckBoxState(id);
}

class _ReminderCheckBoxState extends State<ReminderCheckBox> {
  bool isChecked = false;
  bool allCheck = false;
  int id;

  _ReminderCheckBoxState(int this.id);


  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.focused,
      };
      return Color.fromRGBO(41, 128, 185, 100);
    }

    return Transform.scale(
      scale: 1.5,
      child: Checkbox(
        shape: CircleBorder(),
        checkColor: Colors.white,
        fillColor: MaterialStateProperty.resolveWith(getColor),
        value: isChecked,
        onChanged: (bool? value) {
          changeArray(id, value);
          setState(() {
            isChecked = value!;
          });
        },
      ),
    );
  }

  void changeArray(int id, bool? value) {
    if (value!){
      deleteItems.add(id);
    }
    else{
      deleteItems.remove(id);
    }
  }
}

