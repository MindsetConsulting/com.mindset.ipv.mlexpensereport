import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final List<Widget> buttons;

  CustomBottomNavigationBar({this.buttons = const []});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons,
      ),
    );
  }
}