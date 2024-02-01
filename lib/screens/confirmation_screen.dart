import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_round_button.dart';
import '../widgets/custom_app_bar.dart';

const InputDecoration inputDecoration = InputDecoration(
  border: OutlineInputBorder(),
  contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
  labelStyle: TextStyle(fontSize: 12.0),
);

class ConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> responseData;

  const ConfirmationScreen({Key? key, required this.responseData})
      : super(key: key);

  String formatDate(String dateStr) {
    final match = RegExp(r'/Date\((\d+)([+-]\d+)?\)/').firstMatch(dateStr);
    if (match != null) {
      final timestamp = int.parse(match.group(1)!);
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
      final adjustedDate = date.add(Duration(days: 1));
      return DateFormat.yMMMd().format(adjustedDate);
    } else {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Fluttertoast.showToast(
          msg: "Expense report submitted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    });

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: '001',
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Employee ID'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: responseData['d']['department'],
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Department'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: responseData['d']['companyname'],
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Company Name'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: responseData['d']['expensecategory'],
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Expense Category'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue:
                        formatDate(responseData['d']['datesubmitted']),
                    readOnly: true,
                    decoration: inputDecoration.copyWith(labelText: 'Date'),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        height: 40,
                        child: TextFormField(
                          initialValue: 'USD',
                          readOnly: true,
                          decoration:
                              inputDecoration.copyWith(labelText: 'Currency'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        height: 40,
                        child: TextFormField(
                          initialValue: responseData['d']['amount'],
                          readOnly: true,
                          decoration:
                              inputDecoration.copyWith(labelText: 'Amount'),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: responseData['d']['taxinformation'],
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Tax Information'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: responseData['d']['businessreason'],
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Business Reason'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: responseData['d']['projectcode'],
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Project Code'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: 'Pending',
                    readOnly: true,
                    decoration: inputDecoration.copyWith(labelText: 'Status'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: responseData['d']['additionalnotes'],
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Additional Notes'),
                    maxLines: null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        buttons: [
          CustomRoundButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (Route<dynamic> route) => false);
              },
              fillColor: Theme.of(context).colorScheme.primary,
              icon: Icons.home,
              iconColor: Theme.of(context).colorScheme.background),
          CustomRoundButton(
              onPressed: () {
                Navigator.pushNamed(context, '/upload');
              },
              fillColor: Theme.of(context).colorScheme.background,
              icon: Icons.add,
              iconColor: Theme.of(context).colorScheme.primary),
        ],
      ),
    );
  }
}
