import 'package:flutter/material.dart';
import 'main.dart';

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
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter dice name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please name your dice';
                }
                return null;
              },
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
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
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
