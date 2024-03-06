import 'package:flutter/material.dart';
import '../models/expense_report.dart';
import '../widgets/status_indicator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

const TextStyle headerStyle =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
const TextStyle contentStyle = TextStyle(fontSize: 14);

class ExpenseDetailScreen extends StatelessWidget {
  const ExpenseDetailScreen({Key? key}) : super(key: key);

  Future<http.Response> _getPhoto(String slug) async {
    dotenv.load();
    String? username = dotenv.env['USERNAME'];
    String? password = dotenv.env['PASSWORD'];
    String url =
        'https://s4hana2022.mindsetconsulting.com:44300/sap/opu/odata/sap/ZIMAGE_SRV/zimageSet(Mandt=\'100\',Filename=\'$slug\')/\$value';
    Map<String, String> headers = {
      'Authorization':
          'Basic ' + base64Encode(utf8.encode('$username:$password')),
      'X-Requested-With': 'false',
    };
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print('Response status code: ${response.statusCode}');
      return response;
    } catch (e) {
      print('Error making GET request: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    final ExpenseReport expenseReport = arguments as ExpenseReport;
    final slug = expenseReport.slug;

    if (arguments == null) {
      return Scaffold(
        body: Center(child: Text('No arguments received')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Detail for ${expenseReport.companyName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 40.0, 25.0, 25.0),
        child: SingleChildScrollView(
          // Add this
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Employee ID',
                style: headerStyle,
              ),
              const SizedBox(height: 5),
              Text(expenseReport.employeeId, style: contentStyle),
              const SizedBox(height: 15),
              const Text(
                'Department',
                style: headerStyle,
              ),
              const SizedBox(height: 5),
              Text(expenseReport.department, style: contentStyle),
              const SizedBox(height: 15),
              const Text(
                'Company Name',
                style: headerStyle,
              ),
              const SizedBox(height: 5),
              Text(expenseReport.companyName, style: contentStyle),
              const SizedBox(height: 15),
              const Text(
                'Date Submitted',
                style: headerStyle,
              ),
              const SizedBox(height: 5),
              Text(
                expenseReport.dateSubmitted,
                style: contentStyle,
              ),
              const SizedBox(height: 15),
              const Text(
                'Expense Category',
                style: headerStyle,
              ),
              const SizedBox(height: 5),
              Text(expenseReport.expenseCategory, style: contentStyle),
              const SizedBox(height: 15),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Currency',
                          style: headerStyle,
                        ),
                        SizedBox(height: 5),
                        Text("USD", style: contentStyle),
                      ],
                    ),
                    const SizedBox(width: 50),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Amount',
                          style: headerStyle,
                        ),
                        const SizedBox(height: 5),
                        Text('\$${expenseReport.amount.toStringAsFixed(2)}',
                            style: contentStyle),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Tax Information',
                style: headerStyle,
              ),
              const SizedBox(height: 5),
              Text(expenseReport.taxInformation, style: contentStyle),
              const SizedBox(height: 15),
              const Text(
                'Project Code',
                style: headerStyle,
              ),
              const SizedBox(height: 5),
              Text(expenseReport.projectCode, style: contentStyle),
              const SizedBox(height: 15),
              const Text(
                'Status',
                style: headerStyle,
              ),
              const SizedBox(height: 5),
              StatusIndicator(status: expenseReport.status),
              const SizedBox(height: 20),
              const Text(
                'Additional Notes',
                style: headerStyle,
              ),
              const SizedBox(height: 5),
              Text(expenseReport.additionalNotes, style: contentStyle),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.all(10.0),
                height: 400,
                child: FutureBuilder<http.Response>(
                  future: _getPhoto(slug),
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
    );
  }
}
