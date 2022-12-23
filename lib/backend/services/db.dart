import 'dart:async';
import '../models/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_svg/svg.dart';

abstract class DB {
  static Database? _db;

  static int get _version => 3;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = '${await getDatabasesPath()}super_good_app';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    //Структура БД

    await db.execute('''
        CREATE TABLE meditation_sound(
          id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
          title STRING NOT NULL,
          path_sound TEXT NOT NULL,
          path_icon TEXT NOT NULL
        )''');

    await db.execute('''
        CREATE TABLE reminder (
          id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
          time TIME NOT NULL,
          is_use BIT NOT NULL DEFAULT 1
        )''');

    // SvgPicture.asset(
    //   'assets/moods/2.svg',
    // ),
    await db.execute('''
        CREATE TABLE mood (
          id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
          title TEXT NOT NULL,
          path_icon TEXT NOT NULL,
          value SMALLINT NOT NULL
        )''');

    await db.execute('''
        CREATE TABLE event_category(
          id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
          title STRING NOT NULL
        )''');

    // IconData(0xf1f3, fontFamily: 'MaterialIcons');
    await db.execute('''
        CREATE TABLE event (
          id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
          id_event_category STRING NOT NULL,
          title STRING NOT NULL,
          path_icon TEXT NOT NULL,
          as_deleted DATETIME,
          FOREIGN KEY (id_event_category) REFERENCES event_category (id)
        )''');

    await db.execute('''
        CREATE TABLE my_mood (
          id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
          id_mood INT NOT NULL,
          date DATETIME NOT NULL,
          comment STRING,
          FOREIGN KEY (id_mood) REFERENCES mood(id)
        )''');

    await db.execute('''
        CREATE TABLE my_mood_event (
          id_my_mood INT NOT NULL,
          id_event INT NOT NULL,
          FOREIGN KEY (id_my_mood) REFERENCES my_mood(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
          FOREIGN KEY (id_event) REFERENCES event(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
          PRIMARY KEY (id_my_mood, id_event)
        )''');

    //Начальные данные
    await db.execute('''
        INSERT INTO event_category(id, title) VALUES(1, "Еда")
        ''');

    await db.execute('''
        INSERT INTO event_category(id, title) VALUES(2, "Хобби")
        ''');

    await db.execute('''
        INSERT INTO event(id, id_event_category, title, path_icon, as_deleted) VALUES(1, 2, "кино", "0xf1f3", null)
        ''');

    await db.execute('''
        INSERT INTO event(id, id_event_category, title, path_icon, as_deleted) VALUES(2, 2, "игры", "0xf48e", null)
        ''');

    await db.execute('''
        INSERT INTO event(id, id_event_category, title, path_icon, as_deleted) VALUES(3, 2, "чтение", "0xf1c2", null)
        ''');

    await db.execute('''
        INSERT INTO event(id, id_event_category, title, path_icon, as_deleted) VALUES(4, 2, "спорт", "0xf405", null)
        ''');

    await db.execute('''
        INSERT INTO event(id, id_event_category, title, path_icon, as_deleted) VALUES(5, 1, "ресторан", "0xe532", null)
        ''');

    await db.execute('''
        INSERT INTO event(id, id_event_category, title, path_icon, as_deleted) VALUES(6, 1, "домашняя", "0xe35e", null)
        ''');

    await db.execute('''
        INSERT INTO event(id, id_event_category, title, path_icon, as_deleted) VALUES(7, 1, "сладкое", "0xef0f", null)
        ''');

    await db.execute('''
        INSERT INTO event(id, id_event_category, title, path_icon, as_deleted) VALUES(8, 1, "фастфуд", "0xf049", null)
        ''');

    await db.execute('''
        INSERT INTO mood(id, title, path_icon, value) VALUES(1, "Отличное", "assets/moods/5.svg", 5)
        ''');

    await db.execute('''
        INSERT INTO mood(id, title, path_icon, value) VALUES(2, "Хорошее", "assets/moods/4.svg", 4)
        ''');

    await db.execute('''
        INSERT INTO mood(id, title, path_icon, value) VALUES(3, "Нейтральное", "assets/moods/3.svg", 3)
        ''');

    await db.execute('''
        INSERT INTO mood(id, title, path_icon, value) VALUES(4, "Плохое", "assets/moods/2.svg", 2)
        ''');

    await db.execute('''
        INSERT INTO mood(id, title, path_icon, value) VALUES(5, "Ужасное", "assets/moods/1.svg", 1)
    ''');

    await db.execute('''
        INSERT INTO  meditation_sound(id, title, path_sound, path_icon) VALUES(1, "Дождь", "rain.mp3", "assets/images/rain.svg")
    ''');

    await db.execute('''
        INSERT INTO  meditation_sound(id, title, path_sound, path_icon) VALUES(2, "Костёр", "fire.mp3", "assets/images/fire.svg")
    ''');

    await db.execute('''
        INSERT INTO  meditation_sound(id, title, path_sound, path_icon) VALUES(3, "Ветер", "wind.mp3", "assets/images/wind.svg")
    ''');

    //Пример данных, как может быть заполнен месяц

    await db.execute('''
        INSERT INTO my_mood(id, id_mood, date, comment) VALUES(1, 1, "2000-12-01 00:00:00", 'Сегодня у меня непонятное настроение, я проснулся и я заснул обратно.')
    ''');

    await db.execute('''
        INSERT INTO my_mood_event(id_my_mood, id_event) VALUES(1, 1)
    ''');

    await db.execute('''
        INSERT INTO my_mood(id, id_mood, date, comment) VALUES(2, 5, "2000-12-01 00:00:00", 'Сегодня у меня непонятное настроение, я проснулся и я заснул обратно.')
    ''');

    await db.execute('''
        INSERT INTO my_mood_event(id_my_mood, id_event) VALUES(2, 1)
    ''');

    await db.execute('''
        INSERT INTO my_mood(id, id_mood, date, comment) VALUES(3, 1, "2000-12-01 00:00:00", 'Сегодня у меня непонятное настроение, я проснулся и я заснул обратно.')
    ''');

    await db.execute('''
        INSERT INTO my_mood_event(id_my_mood, id_event) VALUES(3, 3)
    ''');

    await db.execute('''
        INSERT INTO my_mood(id, id_mood, date, comment) VALUES(4, 1, "2000-12-04 00:00:00", 'Сегодня у меня непонятное настроение, я проснулся и я заснул обратно.')
    ''');

    await db.execute('''
        INSERT INTO my_mood_event(id_my_mood, id_event) VALUES(4, 2)
    ''');

    await db.execute('''
        INSERT INTO my_mood(id, id_mood, date, comment) VALUES(5, 1, "2000-12-07 00:00:00", 'Сегодня у меня непонятное настроение, я проснулся и я заснул обратно.')
    ''');

    await db.execute('''
        INSERT INTO my_mood_event(id_my_mood, id_event) VALUES(5, 4)
    ''');
  }

  static Future<List<Map<String, dynamic>>> query(String table) async {
    return _db!.query(table);
  }

  static Future<List<Map<String, dynamic>>> rawQuery(String query) async {
    return _db!.rawQuery(query);
  }

  static Future<int> insert(String table, Model model) async {
    return await _db!.insert(table, model.toMap());
  }

  static Future<int> update(String table, Model model) async {
    return await _db!
        .update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);
  }

  static Future<int> delete(String table, Model model) async {
    return await _db!.delete(table, where: 'id = ?', whereArgs: [model.id]);
  }
}
