import 'package:flutter/material.dart';
import 'main.dart';

Widget newDiceSection(BuildContext context) {
  return Container(
      margin: const EdgeInsets.all(30),
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              padding:
                  MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ))),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecondRoute()),
            );
          },
          child: Icon(
            Icons.add,
            color: Colors.black,
          )));
}
