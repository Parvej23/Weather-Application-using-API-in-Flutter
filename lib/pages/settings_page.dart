import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weathercal/providers/weather_provider.dart';
import 'package:weathercal/utils/weather_preference.dart';
class SettingsPage extends StatefulWidget {
  static const String routeName='/settings';
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isTempUnitSwitchedOn= false;
  bool is24HourFormat= false;
  bool isDefaultCity=false;
  @override
  void initState() {
    gettBool(tempUnitKey).then((value){
      setState(() {
        isTempUnitSwitchedOn=value;
      });
    });
    gettBool(timeFormatKey).then((value){
      setState(() {
        is24HourFormat=value;
      });
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          SwitchListTile(
            value: isTempUnitSwitchedOn,
            onChanged: (value) async {
              setState(() {
                isTempUnitSwitchedOn=value;
              });
              await setBool(tempUnitKey, value);
              Provider.of<WeatherProvider>(context, listen:false ).
              setTemuUnit(value);
            },
            title: Text('Show temperature in Fahrenheit'),
            subtitle: Text('Default is Celsius'),
          ),
          SwitchListTile(
            value: is24HourFormat,
            onChanged: (value) async{
              setState(() {
                is24HourFormat=value;
              });
              await setBool(timeFormatKey, value);
              Provider.of<WeatherProvider>(context, listen:false ).
              setTimePattern(value);
            },
            title: Text('Show time in 24 hour format'),
            subtitle: Text('Default is 12 hour'),
          ),
          SwitchListTile(
            value: isDefaultCity,
            onChanged: (value){
              setState(() {
                isDefaultCity=value;
              });
            },
            title: Text('Set current city as default'),
            subtitle: Text('your location will no longer be detected. Data will be shown based on city location'),
          ),
        ],
      ),
    );
  }
}
