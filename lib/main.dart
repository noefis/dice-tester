import 'package:flutter/material.dart';
import 'package:flutter_application_1/faceCountSelection.dart';
import 'newDiceSelection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Dice Tester',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Dice Tester'),
            ),
            body: ListView(
              children: [newDiceSection(context)],
            ),
          ),
        ));
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Dice'),
      ),
      body: faceCountSelection(context),
    );
  }
}
