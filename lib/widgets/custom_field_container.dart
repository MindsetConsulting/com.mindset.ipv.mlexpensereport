import 'package:flutter/material.dart';

class FieldContainer extends StatelessWidget {
  final String fieldName;
  final TextEditingController? controller;
  final String? initialValue;

  final Function? onTap;
  final bool readOnly;

  FieldContainer({
    required this.fieldName,
    this.controller,
    this.initialValue,
    this.onTap,
    this.readOnly = false,
  });

  static const InputDecoration inputDecoration = InputDecoration(
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
    labelStyle: TextStyle(fontSize: 12.0),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      height: 40,
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        decoration: inputDecoration.copyWith(labelText: fieldName),
        onTap: onTap as void Function()?,
        readOnly: readOnly,
      ),
    );
  }
}
