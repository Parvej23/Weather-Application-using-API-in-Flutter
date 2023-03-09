import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weathercal/pages/settings_page.dart';
import 'package:weathercal/utils/weather_preference.dart';
import '../utils/constants.dart';
import '../utils/helper_finction.dart';
import 'package:weathercal/providers/weather_provider.dart';
class HomePage extends StatefulWidget {
  static const String routeName='/';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  late WeatherProvider weatherProvider;
  bool calledOnce= true;
  @override
  void dispose() {
    _animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void initState() {
    _animationController=
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    _animation= CurvedAnimation(parent: _animationController, curve:Curves.linear)
      ..addListener(() {
        setState(() {

        });
      })..addStatusListener((animationStatus) {
        if(animationStatus==AnimationStatus.completed){
          _animationController.reset();
          _animationController.forward();
        }
      });
    _animationController.forward();
    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(calledOnce){
      weatherProvider= Provider.of<WeatherProvider>(context);
      _getData();
    }
    calledOnce=false;
    super.didChangeDependencies();
  }

  void _getData() async {
     final position= await _determinePosition();
     weatherProvider.setNewLocation(position.latitude, position.longitude);
     final tempUnitStatus= await gettBool(tempUnitKey);
     final timeFormatStatus= await gettBool(timeFormatKey);
     weatherProvider.setTimePattern(timeFormatStatus);
     weatherProvider.setTemuUnit(tempUnitStatus);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Color(0xFFB121A),
        elevation: 0,
        title: Text('Weather App'),
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.my_location),
          ),
          IconButton(
            onPressed: (){
              showSearch(
                  context: context, 
                  delegate: _CitySearchDelegate(),
              ).then((city){
                if(city!=null && city.isNotEmpty){
                  weatherProvider.convertAddressToLatLng(city);
                }
              });
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: ()=>Navigator.pushNamed(context,SettingsPage.routeName),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body:Stack(
        children: [
          CachedNetworkImage(
            imageUrl: "https://cdn.pixabay.com/photo/2016/05/01/17/32/sky-1365325_960_720.jpg",

            errorWidget: (context, url, error) => Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment:FractionalOffset(_animation.value,0) ,
          ),

          weatherProvider.hasDataLoades? ListView(
            children: [
              _currentWeatherSection(),
              _forecaseWeatherSection(),

            ],
          ): const Center(child: CircularProgressIndicator(color: Colors.white,),),
        ],

      ),
    );
  }


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

 Widget _currentWeatherSection() {
    final current= weatherProvider.currentWeatherResponse;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(getFormattedDate(current!.dt!, pattern: 'MMM dd yyyy'), style: txtNormalWhite16,),
          Text('${current.name}, ${current.sys!.country}', style: txtAddressWhite24),
          Text('${current.main!.temp!.round()} $degree${weatherProvider.tempUnitSymbol}',
              style: txtTempBig80),
          Text('Feels like ${current.main!.feelsLike!.round()} $degree${weatherProvider.tempUnitSymbol}',
              style: txtTempSmall18),
          Image.network('$iconPrefix${current.weather![0].icon}$iconSuffix'),
          Text(current.weather![0].description!, style: txtNormalWhite16,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              children: [
                Text(
                  'Humidity ${current.main!.humidity}% ',
                  style: txtNormalWhite54,
                ),
                Text(
                  'Pressure ${current.main!.pressure}hpa ',
                  style: txtNormalWhite54,
                ),
                Text(
                  'Wind ${current.wind!.speed}m/s ',
                  style: txtNormalWhite54,
                ),
                Text(
                  'Wind degree ${current.wind!.deg}$degree ',
                  style: txtNormalWhite54,
                ),
                Text(
                  'Visibility ${current.visibility} meter ',
                  style: txtNormalWhite54,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              children: [
                Text(
                  'Sunrise ${getFormattedDate(current.sys!.sunrise!, pattern: weatherProvider.timePattern)}% ',
                  style: txtNormalWhite16,
                ),
                Text(
                  'Sunset ${getFormattedDate(current.sys!.sunset!, pattern: weatherProvider.timePattern)}% ',
                  style: txtNormalWhite16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
 }

 Widget _forecaseWeatherSection() {
    final forecastList= weatherProvider.forcastWeatherResponse!.list!;
    return SizedBox(
      height: 150,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: forecastList.length,
        itemBuilder: (context, index){
          final item= forecastList[index];
          return Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(9),
            width: 130,
            height: 200,
            decoration: BoxDecoration(
              borderRadius:BorderRadius.circular(12),
              color: Colors.black26,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(getFormattedDate(item.dt!, pattern: 'EEE ${weatherProvider.timePattern}'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14
                    )
                  ),
                  Image.network('$iconPrefix${item.weather![0].icon}$iconSuffix',
                    width: 40,
                    height: 40,
                  ),
                  Text('${item.main!.tempMax!.round()}/${item.main!.tempMin!.round()}${weatherProvider.tempUnitSymbol}',
                    style: txtNormalWhite16,
                  ),
                  Text(
                    item.weather![0].description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white
                    ),
                  )
                ],
              ),
            ) ,
          );
        },
      ),
    );
 }
}

class _CitySearchDelegate extends SearchDelegate<String>{
  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      IconButton(
          onPressed: (){
            query='';
      },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        close(context, '');
      },
      icon: Icon(Icons.arrow_back),
    );

  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      onTap: (){
        close(context, query);
      },
      title: Text(query),
      leading: Icon(Icons.search),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredList= query.isEmpty? cities:
        cities.where((city) => city.toLowerCase().startsWith(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index){
        final item= filteredList[index];
        return ListTile(
          onTap: (){
            query= item;
            close(context, query);
          },
          title: Text(item),
        );
      },
    );
  }

}