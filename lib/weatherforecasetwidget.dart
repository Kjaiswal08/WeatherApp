import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WeatherForecast extends StatelessWidget{
  String time="3:00";
  var icon=Icons.cloud;
  String temp="300 K";
  // ignore: prefer_const_constructors_in_immutables
  WeatherForecast({required this.temp,required this.icon,required this.time,super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 10,
      child:Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(children: [
          Text(
            time,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            )
          ),
          const SizedBox(height: 15,),
          Icon(icon,size: 20,),
          const SizedBox(height: 15,),
          Text(
            temp,
            style: const TextStyle(
              fontSize: 14
            ),
          ),
        ],
        ),
      ) ,
    );
  }
}