import 'package:intl/intl.dart';
import 'package:mobile_app/backend/models/EventCategoryModel.dart';
import 'package:mobile_app/backend/models/MyMoodEventModel.dart';
import 'package:mobile_app/backend/models/MyMoodModel.dart';
import 'package:mobile_app/backend/services/db.dart';

String getTitle({int monthCode = 0, int year = 0}) {
  var months = {
    1: 'Январь',
    2: 'Февраль',
    3: 'Март',
    4: 'Апрель',
    5: 'Май',
    6: 'Июнь',
    7: 'Июль',
    8: 'Август',
    9: 'Сентябрь',
    10: 'Октябрь',
    11: 'Ноябрь',
    12: 'Декабрь'
  };
  if(monthCode != 0 || year != 0) {
    return "${months[monthCode]}, ${year}";
  }
  var currentMonthCode = DateTime.now().month;
  String currentYear = DateTime.now().year.toString();
  return "${months[currentMonthCode]}, ${currentYear}";
}

List<int> getListOfYear() {
  List<int> years = [];
  for(int i = 2000; i <= DateTime.now().year + 5; i++){
    years.add(i);
  }
  return years;
}

dynamic getData(int monthCode, int year) async{
  monthCode = 12;
  year = 2000;
  var data = {'graph': {}, 'eventsCount': [], 'myMoodList': []};

  var selectedMonthFirstDay = DateFormat('yyyy-MM-dd').format(DateTime(year, monthCode));
  var selectedMonthLastDay = DateFormat('yyyy-MM-dd').format(DateTime(year, monthCode + 1, 0));
  print(selectedMonthFirstDay);
  print(selectedMonthLastDay);

  List myMoodsMaps = await DB.rawQuery("SELECT * FROM ${MyMoodModel.table} WHERE date >= '${selectedMonthFirstDay}' AND date <= '${selectedMonthLastDay}'");
  List myMoodsModels = [];

  for(var myMood in myMoodsMaps){
    myMoodsModels.add(MyMoodModel.fromMap(myMood));
  }

  String queryEvents = "";

  Map<String, int> graph = {};

  return 1;
}