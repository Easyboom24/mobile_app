import 'model.dart';

// await db.execute('''
//         CREATE TABLE event_category(
//           id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
//           title STRING NOT NULL
//         )''');

class EventCategoryModel extends Model {
  static String table = 'event_category';

  int id;
  String title;

  EventCategoryModel({required this.id, required this.title});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'title': title,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  static EventCategoryModel fromMap(Map<String, dynamic> map) {
    return EventCategoryModel(
      id: map['id'],
      title: map['title'],
    );
  }
}
