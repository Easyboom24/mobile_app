
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