import 'dart:async';
import '../models/model.dart';
import 'package:sqflite/sqflite.dart';

abstract class DB {

  static dynamic _db;

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) { return; }

    try {
      String _path = '${await getDatabasesPath()}super_good_app';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    }
    catch(ex){
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    await db.execute(
        '''
        CREATE TABLE meditation_sound(
          id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
          path_sound TEXT NOT NULL,
          path_icon TEXT NOT NULL
        );
        
        CREATE TABLE reminder (
          id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
          time TIME NOT NULL,
          is_use BIT NOT NULL DEFAULT 1
        );
        
        CREATE TABLE mood (
          id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
          title TEXT NOT NULL,
          path_icon TEXT NOT NULL,
          value SMALLINT NOT NULL
        );
        
        CREATE TABLE event_category (
          id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
          title VARCHAR(50) NOT NULL 
        );
        
        CREATE TABLE event (
          id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
          FOREIGN KEY (id_event_category) REFERENCES event_category(id),
          title VARCHAR(50) NOT NULL,
          path_icon TEXT NOT NULL,
          as_deleted DATETIME
        );
        
        CREATE TABLE my_mood (
          id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
          FOREIGN KEY (id_event) REFERENCES event(id),
          date DATETIME NOT NULL,
          comment VARCHAR(200)
        );
        
        CREATE TABLE my_mood_event (
          FOREIGN KEY (id_my_mood) REFERENCES my_mood(id),
          FOREIGN KEY (id_event) RoodEFERENCES event(id),
          PRIMARY KEY (id_my_mood, id_event)
        );
        '''
    );
  }

  static Future<List<Map<String, dynamic>>> query(String table) async => _db.query(table);

  static Future<int> insert(String table, Model model) async =>
      await _db.insert(table, model.toMap());

  static Future<int> update(String table, Model model) async =>
      await _db.update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(String table, Model model) async =>
      await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);
}
