import 'package:flutter/material.dart';
import 'package:flutter_application_1/diceSelection.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice Tester',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Color.fromARGB(255, 241, 241, 241),
          appBar: AppBar(
            title: const Text('Dice Tester'),
          ),
          body: FirstRoute(),
        ),
      ),
    );
  }
}
