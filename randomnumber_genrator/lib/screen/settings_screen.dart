import 'dart:math';

import 'package:flutter/material.dart';
import 'package:randomnumber_genrator/component/number_row.dart';
import 'package:randomnumber_genrator/constant/color.dart';

class SettingsScreen extends StatefulWidget {
  final int maxnumber;
  const SettingsScreen({
    required this.maxnumber,
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double maxNumber = 1000;

  @override
  void initState() {
    super.initState();

    maxNumber = widget.maxnumber.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: PRIMARY_COLOR,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _Body(maxNumber: maxNumber),
                _Footer(
                  maxNumber: maxNumber,
                  onSlideChanged: onSliderChanged,
                  onButtonPressed: onButtonPressed,
                ),
              ],
            ),
          ),
        ));
  }

  void onButtonPressed() {
    Navigator.of(context).pop(maxNumber.toInt());
  }

  void onSliderChanged(double val) {
    setState(() {
      maxNumber = val;
    });
  }
}

class _Body extends StatelessWidget {
  final double maxNumber;
  const _Body({required this.maxNumber, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: NumberRow(
      number: maxNumber.toInt(),
    ));
  }
}

class _Footer extends StatelessWidget {
  final double maxNumber;
  final ValueChanged<double>? onSlideChanged;
  final VoidCallback onButtonPressed;
  const _Footer({
    required this.maxNumber,
    required this.onSlideChanged,
    required this.onButtonPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
            value: maxNumber,
            min: 1000,
            max: 100000,
            onChanged: onSlideChanged),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: RED_COLOR,
                ),
                onPressed: onButtonPressed,
                child: Text('저장'),
              ),
            ),
          ],
        )
      ],
    );
  }
}
