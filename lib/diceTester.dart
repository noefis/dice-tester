import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThirdRoute extends StatefulWidget {
  final List<String>? dice;

  ThirdRoute({Key? key, this.dice}) : super(key: key);

  @override
  State<ThirdRoute> createState() => _DiceTesterState();
}

class _DiceTesterState extends State<ThirdRoute> {
  String avg = "0";
  String accuracy = "vacuous";
  String rating = "Insufficient data";
  int dmax = 0;
  int d1 = 0;
  int total = 0;
  int count = 0;

  @override
  void initState() {
    super.initState();
  }

  void throwDice(num) {
    print(num);
    int roll = num;
    int max = int.parse(widget.dice![1].substring(1));
    total++;
    count += roll;
    if (roll == 1) {
      d1++;
    }
    if (roll == max) {
      dmax++;
    }
    avg = (count / total).toStringAsFixed(1);

    if (count / total > (max + 1) / 2) {
      rating = "good";
    } else {
      rating = "bad";
    }
    if (total < max * 3) {
      accuracy = "vacuous";
      rating = "Insufficient data";
    } else if (total < max * 10) {
      accuracy = "bad";
    } else if (total < max * 20) {
      accuracy = "bad to medium";
    } else if (total < max * 40) {
      accuracy = "medium";
    } else if (total < max * 80) {
      accuracy = "medium to good";
    } else {
      accuracy = "good";
    }

    saveValues();
  }

  void saveValues() async {
    final prefs = await SharedPreferences.getInstance();
    String name = widget.dice![0];
    String dice = widget.dice![1];
    prefs.setStringList("dice_" + name + dice, [name, dice, "$avg", rating]);
    prefs.setStringList("stats_" + name + dice, [
      avg,
      accuracy,
      rating,
      dmax.toString(),
      d1.toString(),
      total.toString(),
      count.toString()
    ]);
    setState(() {});
  }

  void loadValues() async {
    final prefs = await SharedPreferences.getInstance();
    String name = widget.dice![0];
    String dice = widget.dice![1];
    List<String>? data = prefs.getStringList("stats_" + name + dice);
    if (avg == "0" && data != null) {
      avg = data![0];
      accuracy = data[1];
      rating = data[2];
      dmax = int.parse(data[3]);
      d1 = int.parse(data[4]);
      total = int.parse(data[5]);
      count = int.parse(data[6]);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    loadValues();
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.dice![1] + " " + widget.dice![0]),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              ),
            )),
        body: Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: ListView(
              children: [diceInfo(widget.dice), NumPad(widget.dice![1])],
            )));
  }

  Widget diceInfo(dice) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: IntrinsicHeight(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Text("rating"),
                  _Text("accuracy"),
                  _Text("${calcDefault(dice[1])} default"),
                  _Text("${dice[1]} throws"),
                  _Text("D1 throws"),
                  _Text("Total throws")
                ],
              ),
              VerticalDivider(
                color: Colors.black,
                thickness: 1,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Text("${rating}"),
                  _Text("${accuracy}"),
                  _Text("${avg} mean value"),
                  _Text("${dmax}"),
                  _Text("${d1}"),
                  _Text("${total}")
                ],
              ),
              Container(
                margin: const EdgeInsets.all(0),
              )
            ])));
  }

  Widget _Text(text) {
    var color = Colors.black;

    if (text == "good") {
      color = Colors.green;
    }
    if (text == "bad") {
      color = Colors.redAccent;
    }
    if (text == "vacuous") {
      color = Colors.redAccent;
    }

    return Padding(
        padding: EdgeInsets.only(top: 2, bottom: 2),
        child: Text(text.toString(),
            style: TextStyle(
              color: color,
              fontSize: 21,
            )));
  }

  String calcDefault(diceCount) {
    int diceNum = int.parse(diceCount.substring(1));

    return ((diceNum + 1) / 2).toStringAsFixed(1);
  }

  Widget NumPad(diceCount) {
    return Container(
        margin: const EdgeInsets.only(top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...numPadArray(diceCount).map((arr) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [...arr.map((e) => _Number(e))]))
          ],
        ));
  }

  Widget _Number(num) {
    return Container(
        margin: const EdgeInsets.all(5),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(80, 60),
            backgroundColor: Colors.white,
          ),
          onPressed: () => {throwDice(num)},
          child: _Text(num),
        ));
  }

  List<List> numPadArray(diceCount) {
    print(diceCount);

    switch (diceCount) {
      case "D4":
        {
          return d4();
        }
      case "D6":
        {
          return d6();
        }
      case "D8":
        {
          return d8();
        }
      case "D10":
        {
          return d10();
        }
      case "D12":
        {
          return d12();
        }
      case "D20":
        {
          return d20();
        }
      default:
        {
          return d4();
        }
    }
  }

  List<List> d4() {
    return [
      [1, 2],
      [3, 4]
    ];
  }

  List<List> d6() {
    return [
      [1, 2],
      [3, 4],
      [5, 6],
    ];
  }

  List<List> d8() {
    return [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8],
    ];
  }

  List<List> d10() {
    return [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
      [10]
    ];
  }

  List<List> d12() {
    return [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
      [10, 11, 12],
    ];
  }

  List<List> d20() {
    return [
      [1, 2, 3, 4],
      [5, 6, 7, 8],
      [9, 10, 11, 12],
      [13, 14, 15, 16],
      [17, 18, 19, 20],
    ];
  }
}
