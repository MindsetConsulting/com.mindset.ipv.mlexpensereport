import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomToolbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        width: 350.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: CupertinoSegmentedControl<int>(
                children: {
                  0: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Month',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  1: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Quarter',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  2: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Year',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                },
                onValueChanged: (int? newValue) {
                  // Add code here
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.sort, color: Theme.of(context).colorScheme.primary),
              onPressed: () {
                // Add your code here
              },
            ),
          ],
        ),
      ),
    );
  }
}
