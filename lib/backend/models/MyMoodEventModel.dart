import 'model.dart';

// await db.execute('''
//         CREATE TABLE my_mood_event (
//           id_my_mood INT NOT NULL,
//           id_event INT NOT NULL,
//           FOREIGN KEY (id_my_mood) REFERENCES my_mood(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
//           FOREIGN KEY (id_event) REFERENCES event(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
//           PRIMARY KEY (id_my_mood, id_event)
//         )''');

class MyMoodEventModel extends Model {
  static String table = 'my_mood_event';

  int id_my_mood;
  int id_event;

  MyMoodEventModel({required this.id_my_mood, required this.id_event});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id_my_mood': id_my_mood,
      'id_event': id_event
    };

    return map;
  }

  static MyMoodEventModel fromMap(Map<String, dynamic> map) {
    return MyMoodEventModel(
        id_my_mood: map['id_my_mood'],
        id_event: map['id_event']
    );
  }
}