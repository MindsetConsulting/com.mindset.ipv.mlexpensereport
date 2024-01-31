import 'package:flutter/material.dart';

class CustomRoundButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final Color iconColor;
  final Color fillColor;

  CustomRoundButton(
      {required this.onPressed,
      required this.icon,
      required this.iconColor,
      required this.fillColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: Center(
        child: Transform.translate(
          offset: const Offset(0, -25),
          child: RawMaterialButton(
            onPressed: () => onPressed(),
            elevation: 2.0,
            fillColor: fillColor,
            shape: const CircleBorder(),
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
            child: Center(
              child: Icon(
                icon,
                size: 35.0,
                color: iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
