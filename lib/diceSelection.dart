import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

import 'faceCountSelection.dart';
// REMOVE LOG WHEN DONE IMPLEMENTING

class FirstRoute extends StatefulWidget {
  const FirstRoute({super.key});

  @override
  State<FirstRoute> createState() => _DiceSelectionState();
}

class _DiceSelectionState extends State<FirstRoute> {
  Set<List<String>?> dices = new Set();

  Future<void> getDices() async {
    final prefs = await SharedPreferences.getInstance();
    developer.log(prefs.getKeys().toString());

    Set<String> keys =
        prefs.getKeys().where((element) => element.contains("dice_")).toSet();

    Set<List<String>?> tmpDices = new Set();

    keys.forEach((key) {
      tmpDices.add(prefs.getStringList(key));
    });

    if (dices.toString() != tmpDices.toString()) {
      dices = tmpDices;
      setState(() {});
    }
  }

  Future<void> deleteDices() async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    keys.forEach((key) {
      prefs.remove(key);
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getDices();
    return Container(
        margin: const EdgeInsets.only(top: 30),
        child: ListView(
          children: [
            clearAll(),
            ...dices.map((dice) => existingDice(dice)),
            newDiceSection()
          ],
        ));
  }

  Widget existingDice(dice) {
    return Container(
        margin: const EdgeInsets.only(top: 0, right: 0),
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ))),
            onPressed: () {},
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(dice[1],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 21,
                        fontWeight: FontWeight.w400,
                      )),
                  Text(dice[0],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      )),
                  Text(dice[2] + " avg",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      )),
                  Text(dice[3],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ))
                ])));
  }

  Widget clearAll() {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.redAccent)),
        child: Text("Delete all dices"),
        onPressed: () => {deleteDices()});
  }

  Widget newDiceSection() {
    return Container(
        margin: const EdgeInsets.only(left: 0, right: 0),
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
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
}
