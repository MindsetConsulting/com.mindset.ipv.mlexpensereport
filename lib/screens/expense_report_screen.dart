import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_round_button.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_field_container.dart';

const InputDecoration inputDecoration = InputDecoration(
  border: OutlineInputBorder(),
  contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
  labelStyle: TextStyle(fontSize: 12.0),
);

class ExpenseReportScreen extends StatefulWidget {
  const ExpenseReportScreen({Key? key}) : super(key: key);

  @override
  _ExpenseReportScreenState createState() => _ExpenseReportScreenState();
}

class _ExpenseReportScreenState extends State<ExpenseReportScreen> {
  DateTime selectedDate = DateTime.now();
  final Map<String, TextEditingController> controllers = {
    'department': TextEditingController(),
    'companyName': TextEditingController(),
    'expenseType': TextEditingController(),
    'date': TextEditingController(),
    'amount': TextEditingController(),
    'taxInformation': TextEditingController(),
    'businessReason': TextEditingController(),
    'projectCode': TextEditingController(),
    'status': TextEditingController(),
    'additionalNotes': TextEditingController(),
  };

  @override
  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> submitExpenseReport() async {
    final url =
        'https://s4hana2022.mindsetconsulting.com:44300/sap/opu/odata/sap/ZEXPENSE_DEV_API/Expense';
    String? username = dotenv.env['USERNAME'];
    String? password = dotenv.env['PASSWORD'];
    final headers = {
      'Authorization':
          'Basic ' + base64Encode(utf8.encode('$username:$password')),
      'Content-Type': 'application/json',
      'X-Requested-With': 'false',
    };
    final body = json.encode({
      'department': controllers['department']!.text,
      'companyName': controllers['companyName']!.text,
      'expenseType': controllers['expenseType']!.text,
      'date': controllers['date']!.text,
      'amount': controllers['amount']!.text,
      'taxInformation': controllers['taxInformation']!.text,
      'businessReason': controllers['businessReason']!.text,
      'projectCode': controllers['projectCode']!.text,
      'status': controllers['status']!.text,
      'additionalNotes': controllers['additionalNotes']!.text,
    });

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    
    print(response.body);

    if (response.statusCode == 200) {
      print('Expense report sent successfully');
    } else {
      throw Exception('Failed to send expense report');
    }
  }

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
                FieldContainer(
                  fieldName: 'Employee ID',
                  initialValue: '001',
                  readOnly: true,
                ),
                FieldContainer(
                  fieldName: 'Department',
                  controller: controllers['department']!,
                ),
                FieldContainer(
                  fieldName: 'Company Name',
                  controller: controllers['companyName']!,
                ),
                FieldContainer(
                  fieldName: 'Expense Type',
                  controller: controllers['expenseType']!,
                ),
                FieldContainer(
                  fieldName: 'Date',
                  controller: controllers['date']!,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2025),
                    );
                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = picked;
                        controllers['date']?.text =
                            DateFormat.yMd().format(selectedDate);
                      });
                    }
                  },
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FieldContainer(
                        fieldName: 'Currency',
                        initialValue: 'USD',
                        readOnly: true,
                      ),
                    ),
                    Expanded(
                      child: FieldContainer(
                        fieldName: 'Amount',
                        controller: controllers['amount']!,
                      ),
                    ),
                  ],
                ),
                FieldContainer(
                  fieldName: 'Tax Information',
                  controller: controllers['taxInformation']!,
                ),
                FieldContainer(
                  fieldName: 'Business Reason',
                  controller: controllers['businessReason']!,
                ),
                FieldContainer(
                  fieldName: 'Project Code',
                  controller: controllers['projectCode']!,
                ),
                FieldContainer(
                  fieldName: 'Status',
                  initialValue: 'Pending',
                  readOnly: true,
                ),
                FieldContainer(
                  fieldName: 'Additional Notes',
                  controller: controllers['additionalNotes']!,
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
                submitExpenseReport();
                Navigator.pushNamed(context, '/confirmation');
              },
              fillColor: Theme.of(context).colorScheme.primary,
              icon: Icons.check,
              iconColor: Theme.of(context).colorScheme.background),
          CustomRoundButton(
              onPressed: () {
                Navigator.pop(context);
              },
              fillColor: Theme.of(context).colorScheme.background,
              icon: Icons.cancel_outlined,
              iconColor: Theme.of(context).colorScheme.primary),
        ],
      ),
    );
  }
}
