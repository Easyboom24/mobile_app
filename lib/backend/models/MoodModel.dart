import 'model.dart';

// await db.execute('''
//         CREATE TABLE mood (
//           id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
//           title TEXT NOT NULL,
//           path_icon TEXT NOT NULL,
//           value SMALLINT NOT NULL
//         )''');

class MoodModel extends Model {
  static String table = 'mood';

  int id;
  String title;
  String path_icon;
  int value;

  MoodModel({required this.id, required this.title, required this.path_icon, required this.value});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'title': title,
      'path_icon': path_icon,
      'value': value
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  static MoodModel fromMap(Map<String, dynamic> map) {
    return MoodModel(
      id: map['id'],
      title: map['title'],
      path_icon: map['path_icon'],
      value: map['value']
    );
  }
}
