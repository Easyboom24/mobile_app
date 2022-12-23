import 'model.dart';

// await db.execute('''
//         CREATE TABLE meditation_sound(
//           id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
//           title STRING NOT NULL,
//           path_sound TEXT NOT NULL,
//           path_icon TEXT NOT NULL
//         )''');

class MeditationModel extends Model {
  static String table = 'meditation_sound';

  int id;
  String title;
  String path_sound;
  String path_icon;

  MeditationModel(
      {required this.id,
      required this.title,
      required this.path_sound,
      required this.path_icon});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'title': title,
      'path_sound': path_sound,
      'path_icon': path_icon,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  static MeditationModel fromMap(Map<String, dynamic> map) {
    return MeditationModel(
      id: map['id'],
      title: map['title'],
      path_sound: map['path_sound'],
      path_icon: map['path_icon'],
    );
  }
}
