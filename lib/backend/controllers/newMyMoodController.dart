import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:mobile_app/backend/models/EventCategoryModel.dart';
import 'package:mobile_app/backend/models/EventModel.dart';
import 'package:mobile_app/backend/models/MoodModel.dart';
import 'package:mobile_app/backend/models/MyMoodEventModel.dart';
import 'package:mobile_app/backend/models/MyMoodModel.dart';
import 'package:mobile_app/backend/services/db.dart';

Future<Map<String, dynamic>> getMyMoodData(int id_my_mood) async {
  Map<String, dynamic> data = {
    'my_mood': {},
    'moods': [],
    'events_by_category': [],
  };

  List moods = await DB.query(MoodModel.table);
  List moodsOutput = [];
  for (var mood in moods) {
    Map newMood = json.decode(json.encode(mood));
    moodsOutput.add(newMood);
    moodsOutput[moodsOutput.length - 1]['path_icon_selected'] =
        "${moodsOutput[moodsOutput.length - 1]['path_icon'].substring(0, 14)}-selected.svg";
  }
  var sortedMoods = moodsOutput..sort((a, b) => a['value'].compareTo(b['value']));
  data['moods'] = sortedMoods;

  List categories = await DB.query(EventCategoryModel.table);
  List events = await DB
      .rawQuery("SELECT * FROM ${EventModel.table} WHERE as_deleted IS NULL");
  List events_by_category = [];
  for (var category in categories) {
    Map newCategory = json.decode(json.encode(category));
    events_by_category.add(newCategory);
    if (events_by_category[events_by_category.length - 1]['events'] == null) {
      events_by_category[events_by_category.length - 1]['events'] = [];
    }
    for (var event in events) {
      if (event['id_event_category'] == category['id']) {
        events_by_category[events_by_category.length - 1]['events'].add(event);
      }
    }
    events_by_category[events_by_category.length - 1]
        ['events'] = events_by_category[events_by_category.length - 1]['events']
      ..sort((a, b) => a['title'].toString().compareTo(b['title'].toString()));
  }
  data['events_by_category'] = events_by_category
    ..sort((a, b) => a['title'].toString().compareTo(b['title'].toString()));

  if (id_my_mood > 0) {
    List myMoodEvents = await DB.rawQuery(
        "SELECT * FROM ${MyMoodEventModel.table} WHERE id_my_mood=${id_my_mood}");

    List myMood = await DB.rawQuery(
        "SELECT * FROM ${MyMoodModel.table} WHERE id='${id_my_mood}'");
    Map newMyMood = json.decode(json.encode(myMood[0]));
    newMyMood['events'] = <int>{};

    for (var myMoodEvent in myMoodEvents) {
      for (var event in events) {
        if (myMoodEvent['id_event'] == event['id']) {
          newMyMood['events'].add(event['id']);
        }
      }
    }

    newMyMood['events'] = newMyMood['events'].toList();

    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dateTime = dateFormat.parse(newMyMood['date']);
    newMyMood['date'] = dateTime;

    data['my_mood'] = newMyMood;
  }

  return data;
}

void deleteMyMood(Map my_mood) async {
  MyMoodModel myMoodModel = MyMoodModel(
      id: my_mood['id'],
      id_mood: my_mood['id_mood'],
      date: DateTime.parse(my_mood['date']),
      comment: my_mood['comment']);
  await DB.delete(MyMoodModel.table, myMoodModel);

  await DB.rawQuery(
      "DELETE FROM ${MyMoodEventModel.table} WHERE id_my_mood=${my_mood['id']}");
}

Future<bool> createMyMood(DateTime date, int hour, int minute, int id_mood,
    String comment, List<int> ids_events) async {
  String formateddatetime = DateFormat('yyyy-MM-dd HH:mm:ss')
      .format(DateTime(date.year, date.month, date.day, hour, minute));

  var newIdRaw =
      await DB.rawQuery("SELECT MAX(id)+1 as id FROM ${MyMoodModel.table}");
  int new_id_my_mood = newIdRaw.first["id"];

  await DB.rawQuery(
      "INSERT INTO ${MyMoodModel.table}(id, id_mood, date, comment) VALUES(${new_id_my_mood}, ${id_mood}, '${formateddatetime}', '${comment}')");

  for (var id_event in ids_events) {
    await DB.rawQuery(
        "INSERT INTO ${MyMoodEventModel.table}(id_my_mood, id_event) VALUES(${new_id_my_mood}, ${id_event})");
  }

  return true;
}

Future<bool> updateMyMood(int id_my_mood, DateTime date, int hour, int minute,
    int id_mood, String comment, List<int> ids_events) async {
  String formateddatetime = DateFormat('yyyy-MM-dd HH:mm:ss')
      .format(DateTime(date.year, date.month, date.day, hour, minute));

  await DB.rawQuery(
      "UPDATE ${MyMoodModel.table} SET id_mood = ${id_mood}, date = '${formateddatetime}', comment = '${comment}' WHERE id=${id_my_mood}");

  var events_db = await DB.rawQuery(
      "SELECT * FROM ${MyMoodEventModel.table} WHERE id_my_mood=${id_my_mood}");

  for (var selected_event in ids_events) {
    var has_in_db_event = false;
    for (var previous_event in events_db) {
      if (!ids_events.contains(previous_event['id_event'])) {
        await DB.rawQuery(
            "DELETE FROM ${MyMoodEventModel.table} WHERE id_my_mood = ${id_my_mood} AND id_event = ${previous_event['id_event']}");
      }
      if (selected_event == previous_event['id_event']) {
        has_in_db_event = true;
        break;
      }
    }
    if (!has_in_db_event) {
      await DB.rawQuery(
          "INSERT INTO ${MyMoodEventModel.table} (id_my_mood, id_event) VALUES (${id_my_mood}, ${selected_event})");
    }
  }

  return true;
}
