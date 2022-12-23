import 'dart:convert';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/backend/models/EventCategoryModel.dart';
import 'package:mobile_app/backend/models/EventModel.dart';
import 'package:mobile_app/backend/services/db.dart';

Future<Map<String, dynamic>> getMyEventData(int id_event) async {
  Map<String, dynamic> data = {
    'event': {},
    'categories_event': [],
    'categories_event_dropdownvalueModel': <DropDownValueModel>[],
  };
  List categories_event = await DB.query(EventCategoryModel.table);
  List categories_event_output = [];
  for (var category_event in categories_event) {
    categories_event_output.add(json.decode(json.encode(category_event)));
  }

  var sorted_categories_event = categories_event_output
    ..sort((a, b) => a['title'].compareTo(b['title']));
  data['categories_event'] = sorted_categories_event;

  for (var category in sorted_categories_event) {
    data['categories_event_dropdownvalueModel'].add(
        DropDownValueModel(name: category['title'], value: category['id']));
  }
  if (id_event > 0) {
    List event = await DB
        .rawQuery("SELECT * FROM ${EventModel.table} WHERE id=${id_event}");

    data['event'] = event[0];
  }

  return data;
}

void deleteEvent(Map event) async {

  DateTime dateTime = DateTime.now();
  String currentDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);

  await DB.rawQuery(
      "UPDATE ${EventModel.table} SET id_event_category = ${event['id_event_category']}, title = '${event['title']}', path_icon = '${event['path_icon']}', as_deleted = '${currentDate}' WHERE id=${event['id']}");
}

void createEvent(String title, int idEventCategory, int iconValue) async {
  var newIdRaw =
  await DB.rawQuery("SELECT MAX(id)+1 as id FROM ${EventModel.table}");
  int new_id_event = newIdRaw.first["id"];

  await DB.rawQuery(
      "INSERT INTO ${EventModel.table}(id, id_event_category, title, path_icon, as_deleted) VALUES(${new_id_event}, ${idEventCategory}, '${title}', '${iconValue}', null)");

}

void updateEvent(int id_event, String title, int idEventCategory, int iconValue) async {
  await DB.rawQuery(
      "UPDATE ${EventModel.table} SET id_event_category = ${idEventCategory}, title = '${title}', path_icon = '${iconValue}' WHERE id=${id_event}");
}