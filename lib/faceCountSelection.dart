import 'package:flutter/material.dart';
import 'package:flutter_application_1/diceSelection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
// REMOVE LOG WHEN DONE IMPLEMENTING

class SecondRoute extends StatefulWidget {
  const SecondRoute({super.key});

  @override
  State<SecondRoute> createState() => _FaceCountSelectionState();
}

class _FaceCountSelectionState extends State<SecondRoute> {
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _newDice(name, dice) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        "dice_" + name + dice, [name, dice, "0", "Insufficient data"]);
  }

  Future<bool> _diceExists(name, dice) async {
    final prefs = await SharedPreferences.getInstance();
    developer.log(
        (prefs.getStringList("dice_" + name + dice) != null).toString(),
        name: 'my.app.category');
    return prefs.getStringList("dice_" + name + dice) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Dice'),
      ),
      body: faceCountSelection(context),
    );
  }

  final _formKey = GlobalKey<FormState>();

  Widget faceCountSelection(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
        child: ListView(shrinkWrap: true, children: [
          Container(
            margin: const EdgeInsets.only(bottom: 30),
            child: Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter dice name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please name your dice';
                  }
                  return null;
                },
                controller: myController,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [dice("D4", 4, context), dice("D6", 6, context)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [dice("D8", 8, context), dice("D10", 10, context)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [dice("D12", 12, context), dice("D20", 20, context)],
          ),
        ]));
  }

  Column dice(String label, int num, context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(120, 120),
                primary: Colors.white,
              ),
              onPressed: () async {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  if (await _diceExists(myController.text, label)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Dice already exists")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Created dice: " + myController.text)),
                    );
                    _newDice(myController.text, label);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FirstRoute()));
                  }
                }
              },
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 48,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )),
        )
      ],
    );
  }
}
