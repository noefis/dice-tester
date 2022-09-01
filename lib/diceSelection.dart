import 'package:flutter/material.dart';
import 'package:flutter_application_1/diceTester.dart';
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
      List<String>? dice = prefs.getStringList(key);
      dice?.add(key);
      tmpDices.add(dice);
    });

    if (dices.toString() != tmpDices.toString()) {
      dices = tmpDices;
      setState(() {});
    }
  }

  Future<void> _newDice(name, dice) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        "dice_" + name + dice, [name, dice, "0", "Insufficient data"]);
  }

  Future<void> deleteDice(key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
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
            ...dices.map((dice) => existingDice(dice)),
            newDiceSection()
          ],
        ));
  }

  Widget existingDice(dice) {
    return Dismissible(
        key: Key(dice[4]),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            await deleteDice(dice[4]);
            // Remove the item from the data source.
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Dice ${dice[0]} dismissed'),
              action: SnackBarAction(
                  label: "Undo",
                  textColor: Colors.yellow,
                  onPressed: () {
                    _newDice(dice[0], dice[1]);
                    setState(() {});
                  }),
            ));
          }
        },
        secondaryBackground: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text("Delete",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 21,
                )),
          ),
        ),
        background: Container(color: Colors.white),
        child: Container(
            margin: const EdgeInsets.only(top: 0, right: 0),
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ThirdRoute(dice: dice)),
                  );
                },
                child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        ])))));
  }

  Widget newDiceSection() {
    return Container(
        margin: const EdgeInsets.only(left: 0, right: 0),
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              padding:
                  MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
            ),
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
