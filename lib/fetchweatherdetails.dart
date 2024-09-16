import 'package:http/http.dart' as http;

import 'dart:convert';
class FetchCurrentWeather {
  String city="Kolkata";
    String apikey="Add_API_Key_Here";
    FetchCurrentWeather(this.city);
    Future<Map<String,dynamic>> getCurrentWeather() async{
    try {
      final res=await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$apikey"
        )
      );
      final resDecode=jsonDecode(res.body);
      if(resDecode["cod"]!="200"){
          throw resDecode['message'];
      }
      return resDecode; 
    } on Exception catch (e) {
      throw e.toString();
    }
  }
}
