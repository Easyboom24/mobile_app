
import 'package:mobile_app/backend/models/MoodModel.dart';
import 'package:mobile_app/backend/services/db.dart';

Future<Map<String, dynamic>> getMyMoodData([int? id_my_mood]) async {
  Map<String, dynamic> data = {
    'my_mood': {},
    'moods': [],
    'event': [],
  };

  List moods = await DB.query(MoodModel.table);
  List moodsOutput = [];
  for(var mood in moods){
      moodsOutput.add(mood);
  }
  data['moods'] = moodsOutput..sort((a, b) => a['value'].compareTo(b['value']));

  // print(data);
  return data;
}