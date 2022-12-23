import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:mobile_app/backend/models/EventCategoryModel.dart';
import 'package:mobile_app/backend/models/EventModel.dart';
import 'package:mobile_app/backend/models/MyMoodEventModel.dart';
import 'package:mobile_app/backend/models/MyMoodModel.dart';
import 'package:mobile_app/backend/services/db.dart';
import 'package:mobile_app/backend/models/model.dart';
import 'package:graphic/graphic.dart';

import '../models/MoodModel.dart';

String getTitle({int monthCode = 0, int year = 0}) {
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
  if (monthCode != 0 || year != 0) {
    return "${months[monthCode]}, ${year}";
  }
  var currentMonthCode = DateTime.now().month;
  String currentYear = DateTime.now().year.toString();
  return "${months[currentMonthCode]}, ${currentYear}";
}

List<int> getListOfYear() {
  List<int> years = [];
  for (int i = 2000; i <= DateTime.now().year + 5; i++) {
    years.add(i);
  }
  return years;
}

dynamic getMainData(int monthCode, int year) async {
  //TODO: Временные данные
  // monthCode = 12;
  // year = 2000;
  //

  Map<String, dynamic> data = {
    'graphData': [],
    'eventsCount': {},
    'myMoodList': []
  };

  var selectedMonthFirstDay =
      DateFormat('yyyy-MM-dd').format(DateTime(year, monthCode));
  var selectedMonthLastDay =
      DateFormat('yyyy-MM-dd').format(DateTime(year, monthCode + 1, 0));

  //myMoods
  List myMoodsMaps = await DB.rawQuery(
      "SELECT * FROM ${MyMoodModel.table} WHERE date >= '${selectedMonthFirstDay}' AND date <= '${selectedMonthLastDay}'");
  List myMoodsModels = [];

  if (myMoodsMaps.isEmpty) {
    return null;
  }

  String rawQueryMyMoodsEvents =
      "SELECT * FROM ${MyMoodEventModel.table} WHERE ";
  String optionWhereMyMoodsEvents = "";

  for (var myMood in myMoodsMaps) {
    myMoodsModels.add(MyMoodModel.fromMap(myMood));
    optionWhereMyMoodsEvents =
        optionWhereMyMoodsEvents + "id_my_mood = '${myMood['id']}' OR ";
  }
  optionWhereMyMoodsEvents = optionWhereMyMoodsEvents.substring(
      0, optionWhereMyMoodsEvents.length - 4);
  //myMoods

  //moods
  List moodsMaps = await DB.query(MoodModel.table);
  List moodsModels = [];

  for (var mood in moodsMaps) {
    moodsModels.add(MoodModel.fromMap(mood));
  }
  //moods

  //myMoodsEvents
  List myMoodsEventsMaps =
      await DB.rawQuery(rawQueryMyMoodsEvents + optionWhereMyMoodsEvents);
  List myMoodsEventsModels = [];

  String rawQueryEvents = "SELECT * FROM ${EventModel.table} WHERE ";
  String optionWhereEvents = "";

  for (var myMoodEvent in myMoodsEventsMaps) {
    myMoodsEventsModels.add(MyMoodEventModel.fromMap(myMoodEvent));
    optionWhereEvents =
        optionWhereEvents + "id = '${myMoodEvent['id_event']}' OR ";
  }
  optionWhereEvents =
      optionWhereEvents.substring(0, optionWhereEvents.length - 4);
  //myMoodsEvents

  //events
  List eventsMaps = await DB.rawQuery(rawQueryEvents + optionWhereEvents);
  List eventsMapsEditing = [];
  for(var event in eventsMaps){
    eventsMapsEditing.add(json.decode(json.encode(event)));
  }
  List eventsModels = [];

  for (var event in eventsMapsEditing) {
    if(event['as_deleted'] != null) {
      event['as_deleted'] = DateTime.parse(event['as_deleted']);
    }
    eventsModels.add(EventModel.fromMap(event));
  }
  //events

  //Заполнение data
  Map<dynamic, dynamic> eventsCount = {};

  for (MyMoodEventModel myMoodEvent in myMoodsEventsModels) {
    for (EventModel event in eventsModels) {
      if (myMoodEvent.id_event == event.id) {
        if (eventsCount[event.id] == null) {
          eventsCount[event.id] = {};
          eventsCount[event.id]['title'] = event.title;
          eventsCount[event.id]['path_icon'] = event.path_icon;
          eventsCount[event.id]['count'] = 1;
        } else {
          eventsCount[event.id]['count'] += 1;
        }
        break;
      }
    }
  }

  data['eventsCount'] = eventsCount.entries.toList()
    ..sort((b, a) => a.value['count'].compareTo(b.value['count']));

  Map<DateTime, dynamic> graphData = {};

  for (MyMoodModel myMood in myMoodsModels) {
    if (graphData[myMood.date] == null) {
      graphData[myMood.date] = {};
      graphData[myMood.date]['date'] = myMood.date;
      graphData[myMood.date]['count'] = 1;

      for (MoodModel mood in moodsModels) {
        if (myMood.id_mood == mood.id) {
          graphData[myMood.date]['sumValue'] = mood.value;
          break;
        }
      }
    } else {
      graphData[myMood.date]['count'] += 1;

      for (MoodModel mood in moodsModels) {
        if (myMood.id_mood == mood.id) {
          graphData[myMood.date]['sumValue'] += mood.value;
          break;
        }
      }
    }
  }

  graphData.forEach((key, value) {
    value['avrgValue'] = value['sumValue'] / value['count'];
  });

  List myMoodListOut = [];

  for (var myMood in myMoodsMaps) {
    myMoodListOut.add({});
    myMoodListOut[myMoodListOut.length - 1]['id'] = myMood['id'];
    myMoodListOut[myMoodListOut.length - 1]['id_mood'] = myMood['id_mood'];
    myMoodListOut[myMoodListOut.length - 1]['date'] = myMood['date'];
    myMoodListOut[myMoodListOut.length - 1]['comment'] = myMood['comment'].toString();
    for (MoodModel mood in moodsModels) {
      if (myMood['id_mood'] == mood.id) {
        myMoodListOut[myMoodListOut.length - 1]['title'] = mood.title;
        myMoodListOut[myMoodListOut.length - 1]['path_icon'] = "${mood.path_icon.substring(0, 14)}-selected.svg";
        break;
      }
    }
  }

  data['myMoodList'] = myMoodListOut
    ..sort((a, b) => a['date'].compareTo(b['date']));

  data['graphData'] = graphData.values.toList();
  //Заполнение data

  return data;
}
