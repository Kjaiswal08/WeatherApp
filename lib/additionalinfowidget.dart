import 'package:flutter/material.dart';


// ignore: must_be_immutable
class AddInfoWidget extends StatelessWidget {
  String msg;
  var icon;
  String val;
  AddInfoWidget({required this.msg,required this.icon,required this.val,super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: 100,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Text(
              msg,
            ),
            const SizedBox(height: 8,),
            Icon(icon,size: 32,),
            const SizedBox(height: 8,),
            Text(
              val,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}