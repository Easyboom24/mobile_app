import 'dart:convert';

import 'package:mobile_app/backend/models/EventCategoryModel.dart';
import 'package:mobile_app/backend/models/EventModel.dart';
import 'package:mobile_app/backend/models/MoodModel.dart';
import 'package:mobile_app/backend/services/db.dart';

Future<Map<String, dynamic>> getMyMoodData([int? id_my_mood]) async {
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
  data['moods'] = moodsOutput..sort((a, b) => a['value'].compareTo(b['value']));

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

  print(data['events_by_category'][0]['events']);
  return data;
}
