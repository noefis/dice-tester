import 'dart:math';

import 'package:flutter/material.dart';

class BuildPopup extends StatelessWidget {
  BuildPopup(this.data);

  final List<double> data;

  @override
  Widget build(BuildContext context) {
    double size = data[0];
    double sample_mean = data[1] / size;
    double std_dev = data[2];
    double std_mean = data[3];

    double z = zScore(sample_mean, size, std_mean, std_dev);
    double p = pValue(z);

    return new AlertDialog(
      title: const Text('Advanced Stats'),
      insetPadding: EdgeInsets.all(20),
      content: Padding(
          padding: EdgeInsets.only(left: 15, right: 25),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("mean: " + data[2].toString()),
              Text("standard deviation: " + std_dev.toString()),
              Text("sample mean: " + sample_mean.toStringAsFixed(2)),
              Text("Sample size: " + size.toString()),
              Text("Z-Score: " + z.toStringAsFixed(2)),
              Text("P Value: " + p.toStringAsFixed(4)),
              Text("percentile: " + percentile(p).toStringAsFixed(2) + "%"),
              Padding(
                  padding: EdgeInsets.only(
                top: 20,
              )),
              _Text("percentile > 10%: \"not significant\""),
              _Text("percentile <= 10%: \"marginally significant\""),
              _Text("percentile <= 5%: \"significant\""),
              _Text("percentile <= 1%: \"highly significant\""),
            ],
          )),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
              textStyle: TextStyle(color: Colors.blueAccent)),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _Text(text) {
    return Text(text,
        style: TextStyle(
            color: Colors.black54, fontSize: 12, fontStyle: FontStyle.italic));
  }

  double zScore(sample_mean, sample_size, mean, standard_deviation) {
    return (sample_mean - mean) / (standard_deviation / sqrt(sample_size));
  }

  double pValue(zScore) {
    double z = zScore;
    //z == number of standard deviations from the mean

    //if z is greater than 6.5 standard deviations from the mean
    //the number of significant digits will be outside of a reasonable
    //range
    if (z < -6.5) return 0.0;
    if (z > 6.5) return 1.0;

    double factK = 1;
    double sum = 0;
    double term = 1;
    double k = 0;
    double loopStop = exp(-23);
    while (term.abs() > loopStop) {
      term = .3989422804 *
          pow(-1, k) *
          pow(z, k) /
          (2 * k + 1) /
          pow(2, k) *
          pow(z, k + 1) /
          factK;
      sum += term;
      k++;
      factK *= k;
    }
    sum += 0.5;

    return sum;
  }

  double percentile(p) {
    double percent = p * 100;

    if (percent > 50) {
      return 100 - percent;
    }
    return percent;
  }
}
