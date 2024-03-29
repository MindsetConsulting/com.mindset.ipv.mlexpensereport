import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_round_button.dart';
import '../widgets/custom_app_bar.dart';

const InputDecoration inputDecoration = InputDecoration(
  border: OutlineInputBorder(),
  contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
  labelStyle: TextStyle(fontSize: 12.0),
);

class ConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic> responseData;

  const ConfirmationScreen({Key? key, required this.responseData})
      : super(key: key);

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    apiService.getPhoto(widget.responseData['slug']);
  }

  String formatDate(String? dateStr) {
    if (dateStr == null) {
      return 'Invalid date';
    }
    try {
      final match = RegExp(r'/Date\((\d+)([+-]\d+)?\)/').firstMatch(dateStr);
      if (match != null) {
        final timestamp = int.parse(match.group(1)!);
        final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
        return DateFormat('MMM dd, yyyy').format(date);
      } else {
        return 'Invalid date';
      }
    } catch (e) {
      return 'Invalid date';
    }
  }

  Widget buildFieldContainer(String labelText, dynamic initialValue) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      height: 40,
      child: TextFormField(
        initialValue: initialValue != null ? initialValue.toString() : '',
        readOnly: true,
        decoration: inputDecoration.copyWith(labelText: labelText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Fluttertoast.showToast(
          msg: "Expense report submitted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Theme.of(context).colorScheme.primary,
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
                buildFieldContainer(
                    'Employee ID', widget.responseData['d']['employeeid']),
                buildFieldContainer(
                    'Department', widget.responseData['d']['department']),
                buildFieldContainer(
                    'Company Name', widget.responseData['d']['companyname']),
                buildFieldContainer('Expense Category',
                    widget.responseData['d']['expensecategory']),
                buildFieldContainer('Date',
                    formatDate(widget.responseData['d']['datesubmitted'])),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: buildFieldContainer('Currency', 'USD'),
                    ),
                    Expanded(
                      child: buildFieldContainer(
                          'Amount', widget.responseData['d']['amount']),
                    ),
                  ],
                ),
                buildFieldContainer('Tax Information',
                    widget.responseData['d']['taxinformation']),
                buildFieldContainer(
                    'Project Code', widget.responseData['d']['projectcode']),
                buildFieldContainer('Status', 'Pending'),
                buildFieldContainer('Additional Notes',
                    widget.responseData['d']['additionalnotes']),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 400,
                  child: FutureBuilder<http.Response>(
                    future:
                        apiService.getPhoto(widget.responseData['d']['slug']),
                    builder: (BuildContext context,
                        AsyncSnapshot<http.Response> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return snapshot.data != null &&
                                snapshot.data!.request != null
                            ? Image.network(
                                snapshot.data!.request!.url.toString())
                            : Container();
                      }
                    },
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
