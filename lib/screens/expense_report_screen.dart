import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  String backendDate = '';
  String? slug;
  final Map<String, TextEditingController> controllers = {
    'department': TextEditingController(text: 'Solutions'),
    'companyname': TextEditingController(),
    'expensecategory': TextEditingController(),
    'datesubmitted': TextEditingController(),
    'amount': TextEditingController(),
    'taxinformation': TextEditingController(),
    'projectcode': TextEditingController(),
    'status': TextEditingController(),
    'additionalnotes': TextEditingController(),
  };

  @override
  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final displayFormat = DateFormat('MMM dd, yyyy');
    final formattedDateForDisplay = displayFormat.format(selectedDate);
    final backendFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
    backendDate = backendFormat.format(selectedDate);
    controllers['datesubmitted']?.text = formattedDateForDisplay;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is Map<String, dynamic>) {
      slug = arguments['slug'];
      final total = arguments['total'];
      final companyName = arguments['companyName'];
      if (total != null) {
        controllers['amount']?.text = total;
      }
      if (companyName != null) {
        controllers['companyname']?.text = companyName;
      }
      if (arguments['slug'] != null) {
        print('Slug argument: $slug');
      }
    }
  }

  String generateRandomString(int length) {
    const _randomChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    const _charsLength = _randomChars.length;

    final rand = Random();
    final codeUnits = List.generate(length, (index) {
      int randIndex = rand.nextInt(_charsLength);
      return _randomChars.codeUnitAt(randIndex);
    });

    return String.fromCharCodes(codeUnits);
  }

  Future<Map<String, dynamic>> submitExpenseReport() async {
    const url =
        'https://s4hana2022.mindsetconsulting.com:44300/sap/opu/odata/sap/ZEXPENSE_DEV_API/Expense';
    String? username = dotenv.env['USERNAME'];
    String? password = dotenv.env['PASSWORD'];
    final headers = {
      'Authorization':
          'Basic ' + base64Encode(utf8.encode('$username:$password')),
      'Content-Type': 'application/json',
      'X-Requested-With': 'false',
    };

    String uniqueKey = generateRandomString(6);

    final body = json.encode({
      'expensereportid': uniqueKey,
      'employeeid': '001 - Curtis Kettler',
      'department': controllers['department']?.text ?? '',
      'companyname': controllers['companyname']?.text ?? '',
      'expensecategory': controllers['expensecategory']?.text ?? '',
      'datesubmitted': backendDate,
      'amount': controllers['amount']?.text.replaceAll(',', '') ?? '',
      'taxinformation': controllers['taxinformation']?.text ?? '',
      'projectcode': controllers['projectcode']?.text ?? '',
      'status': 'pending',
      'additionalnotes': controllers['additionalnotes']?.text ?? '',
      'slug': slug ?? '',
    });

    HttpClient client = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', headers['Authorization'] ?? '');
    request.headers.set('X-Requested-With', headers['X-Requested-With'] ?? '');
    request.headers.set('Accept', 'application/json');
    request.add(utf8.encode(body));

    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();

    Map<String, dynamic> responseData = jsonDecode(reply);

    print('ResponseData: $responseData');
    return responseData;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                FieldContainer(
                  fieldName: 'Employee ID/Name',
                  initialValue: '001 - Curtis Kettler',
                  readOnly: true,
                ),
                FieldContainer(
                  fieldName: 'Department',
                  controller: controllers['department']!,
                  isRequired: true,
                ),
                FieldContainer(
                  fieldName: 'Company Name',
                  controller: controllers['companyname']!,
                  isRequired: true,
                ),
                Container(
                  width: 340,
                  child: DropdownButtonFormField<String>(
                    value: null,
                    decoration: FieldContainer.inputDecoration
                        .copyWith(labelText: 'Expense Category'),
                    onChanged: (String? newValue) {
                      controllers['expensecategory']?.text = newValue ?? '';
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                    items: <String>[
                      'Travel',
                      'Office',
                      'Personal Development',
                      'Training'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()
                      ..add(DropdownMenuItem(
                          value: null, child: Text('Please select'))),
                  ),
                ),
                FieldContainer(
                  fieldName: 'Date',
                  controller: controllers['datesubmitted']!,
                  isRequired: true,
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
                        final displayFormat = DateFormat('MMM dd, yyyy');
                        final formattedDateForDisplay =
                            displayFormat.format(selectedDate);

                        final backendFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
                        backendDate = backendFormat.format(selectedDate);

                        controllers['datesubmitted']?.text =
                            formattedDateForDisplay;
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
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                FieldContainer(
                  fieldName: 'Tax Information',
                  controller: controllers['taxinformation']!,
                ),
                FieldContainer(
                  fieldName: 'Project Code',
                  controller: controllers['projectcode']!,
                ),
                FieldContainer(
                  fieldName: 'Status',
                  initialValue: 'Pending',
                  readOnly: true,
                ),
                FieldContainer(
                  fieldName: 'Additional Notes',
                  controller: controllers['additionalnotes']!,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        buttons: [
          CustomRoundButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Map<String, dynamic> responseData =
                      await submitExpenseReport();
                  responseData['slug'] = slug;
                  Navigator.pushNamed(
                    context,
                    '/confirmation',
                    arguments: responseData,
                  );
                }
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
