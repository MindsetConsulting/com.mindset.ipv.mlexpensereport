import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_round_button.dart';
import '../widgets/custom_app_bar.dart';

const InputDecoration inputDecoration = InputDecoration(
  border: OutlineInputBorder(),
  contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
  labelStyle: TextStyle(fontSize: 12.0),
);

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    initialValue: 'John Doe',
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Employee Name'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: '00001',
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Employee ID'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: 'Sales',
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Department'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: 'Travel',
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Expense Type'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: '2023-11-11',
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
                          initialValue: '100.00',
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
                    initialValue: 'VAT %20',
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Tax Information'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: 'Business trip',
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Business Reason'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: '123abc',
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
                    initialValue: 'Went on a business trip to New York',
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
