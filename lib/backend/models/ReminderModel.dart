import 'model.dart';

// await db.execute('''
//         CREATE TABLE my_mood (
//           id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
//           id_mood INT NOT NULL,
//           date DATETIME NOT NULL,
//           comment STRING,
//           FOREIGN KEY (id_mood) REFERENCES mood(id)
//         )''');

class ReminderModel extends Model {
  static String table = 'reminder';

  int id;
  String time;
  bool is_use;

  ReminderModel({required this.id, required this.time, required this.is_use});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'time': time,
      'is_use': is_use
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  static ReminderModel fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'],
      time: map['time'],
      is_use: (map['is_use'] == 1),
    );
  }
}
