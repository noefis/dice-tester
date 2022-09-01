import 'package:flutter/material.dart';
import 'package:flutter_application_1/diceTester.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'faceCountSelection.dart';

class FirstRoute extends StatefulWidget {
  const FirstRoute({super.key});

  @override
  State<FirstRoute> createState() => _DiceSelectionState();
}

class _DiceSelectionState extends State<FirstRoute> {
  var tmpDiceData;
  List<List<String>?> dices = [];

  Future<void> getDices() async {
    final prefs = await SharedPreferences.getInstance();

    Set<String> keys =
        prefs.getKeys().where((element) => element.contains("dice_")).toSet();

    List<List<String>?> tmpDices = [];

    keys.forEach((key) {
      List<String>? dice = prefs.getStringList(key);
      dice?.add(key);
      tmpDices.add(dice);
    });

    tmpDices.sort((a, b) => getDiceCount(a![1]).compareTo(getDiceCount(b![1])));

    if (dices.toString() != tmpDices.toString()) {
      dices = tmpDices;
      setState(() {});
    }
  }

  int getDiceCount(str) {
    return int.parse(str.substring(1));
  }

  Future<void> _restoreDice(name, dice) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("dice_" + name + dice, tmpDiceData);
  }

  Future<void> deleteDice(key) async {
    final prefs = await SharedPreferences.getInstance();
    tmpDiceData = prefs.get(key);
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
              content: Text('Dice ${dice[0]} deleted'),
              action: SnackBarAction(
                  label: "Undo",
                  textColor: Colors.yellow,
                  onPressed: () {
                    _restoreDice(dice[0], dice[1]);
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
            margin: const EdgeInsets.only(bottom: 1, right: 0),
            child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(1),
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
                          Text(dice[1] + ",  " + maxLeghtString(dice[0]),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 21,
                                fontWeight: FontWeight.w400,
                              )),
                          _Text(dice[2] + " avg"),
                          _Text(dice[3])
                        ])))));
  }

  String maxLeghtString(str) {
    if (str.length > 10) {
      return str.substring(0, 9) + "...";
    }
    return str;
  }

  Widget _Text(text) {
    var color = Colors.black;
    if (text == "good") {
      color = Colors.green;
    }
    if (text == "bad") {
      color = Colors.redAccent;
    }
    if (text == "Insufficient data") {
      color = Colors.redAccent;
    }
    return Text(text,
        style: TextStyle(
          color: color,
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ));
  }

  Widget newDiceSection() {
    return Container(
        margin: const EdgeInsets.only(left: 0, right: 0),
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              elevation: MaterialStateProperty.all(1),
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
