import 'package:shared_preferences/shared_preferences.dart';

const String tempUnitKey='tempUnit';
const String timeFormatKey='timeFormat';
const String defaultCityKey= 'defaultCity';

Future<bool>setBool(String key, bool status) async{
  final perf= await SharedPreferences.getInstance();
  return perf.setBool(key, status);
}
Future<bool>gettBool(String key) async{
  final perf= await SharedPreferences.getInstance();
  return perf.getBool(key)?? false;
}

