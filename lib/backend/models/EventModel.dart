import 'model.dart';

// await db.execute('''
//         CREATE TABLE event (
//           id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
//           id_event_category STRING NOT NULL,
//           title STRING NOT NULL,
//           path_icon TEXT NOT NULL,
//           as_deleted DATETIME,
//           FOREIGN KEY (id_event_category) REFERENCES event_category (id)
//         )''');

class EventModel extends Model {
  static String table = 'event';

  int id;
  int id_event_category;
  String title;
  String path_icon;
  DateTime as_deleted;

  EventModel({required this.id, required this.id_event_category, required this.title, required this.path_icon, required this.as_deleted});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'title': title,
      'path_icon': path_icon,
      'as_deleted': as_deleted
    };

    if (id != null) {
      map['id'] = id;
    }

    if (id_event_category != null) {
      map['id_event_category'] = id_event_category;
    }

    return map;
  }

  static EventModel fromMap(Map<String, dynamic> map) {
    // print(map['as_deleted']);
    return EventModel(
        id: map['id'],
        id_event_category: map['id_event_category'],
        title: map['title'],
        path_icon: map['path_icon'],
        as_deleted: map['as_deleted']
    );
  }
}
