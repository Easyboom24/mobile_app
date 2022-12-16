import 'model.dart';

// await db.execute('''
//         CREATE TABLE my_mood (
//           id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
//           id_mood INT NOT NULL,
//           date DATETIME NOT NULL,
//           comment STRING,
//           FOREIGN KEY (id_mood) REFERENCES mood(id)
//         )''');

class MyMoodModel extends Model {
  static String table = 'my_mood';

  int id;
  int id_mood;
  String date;
  String comment;

  MyMoodModel({required this.id, required this.id_mood, required this.date, required this.comment});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'date': date,
      'comment': comment
    };

    if (id != null) {
      map['id'] = id;
    }

    if (id_mood != null) {
      map['id_mood'] = id_mood;
    }

    return map;
  }

  static MyMoodModel fromMap(Map<String, dynamic> map) {
    return MyMoodModel(
        id: map['id'],
        id_mood: map['id_mood'],
        date: map['date'],
        comment: map['comment']
    );
  }
}
