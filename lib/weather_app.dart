
import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:weather_demo_app_01/additionalinfowidget.dart';
import 'package:weather_demo_app_01/fetchweatherdetails.dart';
import 'package:weather_demo_app_01/weatherforecasetwidget.dart';

class WeatherApp extends StatefulWidget {

  const WeatherApp({super.key});

  @override
  // ignore: no_logic_in_create_state
  State<WeatherApp> createState() {
    return _WeatherApp();
  }
}

class _WeatherApp extends State<WeatherApp> {
  late Future<Map<String,dynamic>> weatherState;
  String city="Kolkata";
  final TextEditingController textcontroller=TextEditingController();
  Map<String,dynamic> weatherIcons={
    "Clear":Icons.sunny,
    "Clouds":Icons.cloud,
    "Rain": Icons.water_drop_rounded
  };
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weatherState=FetchCurrentWeather(city).getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    const border= OutlineInputBorder(
                      borderSide: BorderSide(
                      width: 2,
                      style:BorderStyle.solid
                      ), 
                      borderRadius: BorderRadius.all(Radius.circular(45))
                    );

    var textfield=Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: textcontroller,
                  decoration:  InputDecoration(
                    prefixIcon:  const Icon(Icons.location_on) ,
                    hintText: ( city.toUpperCase() ), 
                    hintStyle:  const TextStyle(
                      color: Colors.grey
                    ),
                    filled: true, 
                
                
                    focusedBorder: border,
                          
                    enabledBorder: border
                  ),
                  keyboardType: TextInputType.name,
                ),
              );

    return  Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Weather",
          style: TextStyle(
            color: Colors.white,
            
            fontWeight: FontWeight.bold,
          ),
        ),
        
        elevation: 20,
        actions:  [
          IconButton(onPressed: (){
            setState(() {
              city=textcontroller.text!=""?textcontroller.text:city;
              weatherState=FetchCurrentWeather(city).getCurrentWeather();
            });
          }, 
          icon: const Icon(Icons.replay_outlined)),
          ],
        centerTitle: true ,
      ),
      body:  FutureBuilder(
        future: weatherState,
        builder: (context,snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }

          else if(snapshot.hasError){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(
                
                "OOPS ${snapshot.error.toString()}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30
                ),
              ),
              const SizedBox(height:25),
              const Icon(
                Icons.error_outline,
                size: 25,
              ),
              const SizedBox(height:25),
              textfield
              ]
            );
          }

          final resDecode=snapshot.data!;
          final currentTemp=resDecode['list'][0]['main']['temp'];
          final currentSky=resDecode['list'][0]['weather'][0]['main'];
          final currentHumidity=resDecode['list'][0]['main']['humidity'];
          final currentPressure=resDecode['list'][0]['main']['pressure'];
          final currentWind=resDecode['list'][0]["wind"]["speed"];

          
          return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textfield,
              const SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                child: Card(
                  
                  shape: const RoundedRectangleBorder(
                    borderRadius:  BorderRadius.all(Radius.circular(15))
                  ),
                  elevation: 10,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5,sigmaY: 5),
                      child:  Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [Text(
                              "$currentTemp K",
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 32
                              ),
                            ),
                            Icon(
                              weatherIcons[currentSky],
                              size: 32
                            ),
                            Text(
                              currentSky,
                              style: const TextStyle(fontSize: 22),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                
                ),
                
              ),
              const SizedBox(height: 10,),
              const Text(
                "Hourly Forecast",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                  
                ),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height:130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    final hourlySky=resDecode['list'][index+1]['weather'][0]['main'];
                    return WeatherForecast(time: resDecode['list'][index+1]['dt_txt']?.substring(11,16),
                          icon:(weatherIcons.containsKey(hourlySky)?weatherIcons[hourlySky]:Icons.cloud),
                          temp: resDecode['list'][index+1]['main']['temp'].toString()
                    );
                    
                  } 
                  ),
              ),
              const SizedBox(height: 10,),
                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
              const SizedBox(height: 10,),
              SizedBox(
        
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AddInfoWidget(msg: "Humidity",icon: Icons.water_drop,val: "$currentHumidity"),
                    AddInfoWidget(msg: "Wind Speed",icon: Icons.air,val: "$currentWind"),
                    AddInfoWidget(msg: "Pressure",icon: Icons.beach_access,val: "$currentPressure"),
                    
                  ],
                  
                ),
              ),
              
            ],
          ),
        );
        },
      )
    );
  }
}
/*We use this instead of Listview if there are only a few tabs to show then use SingleChildScrollView
                SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for(int i=0;i<5;i++)
                        WeatherForecast(
                          time: resDecode['list'][i+1]['dt_txt']?.substring(11,16),
                          icon: resDecode['list'][i+1]['weather'][0]['main']=="Clouds"||
                          resDecode['list'][i+1]['weather'][0]['main']=="Rain"?
                          Icons.cloud:Icons.sunny,
                          temp: resDecode['list'][i+1]['main']['temp'].toString()
                        ),
                        
                      ],
                    ),
                  ),
                ),
                
*/