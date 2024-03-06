import 'package:flutter/material.dart';
import '../models/expense_report.dart';
import '../services/api_service.dart';
import '../widgets/status_indicator.dart';
import 'package:http/http.dart' as http;

const TextStyle headerStyle =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
const TextStyle contentStyle = TextStyle(fontSize: 14);

class ExpenseDetailScreen extends StatelessWidget {
  ExpenseDetailScreen({Key? key}) : super(key: key);

  final apiService = ApiService();

  Widget _buildInfo(String header, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(header, style: headerStyle),
        const SizedBox(height: 5),
        Text(content, style: contentStyle),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    final ExpenseReport expenseReport = arguments as ExpenseReport;
    final slug = expenseReport.slug;

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Detail for ${expenseReport.companyName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 40.0, 25.0, 25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildInfo('Employee ID', expenseReport.employeeId),
              _buildInfo('Department', expenseReport.department),
              _buildInfo('Company Name', expenseReport.companyName),
              _buildInfo('Date Submitted', expenseReport.dateSubmitted),
              _buildInfo('Expense Category', expenseReport.expenseCategory),
              Row(
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
              const SizedBox(height: 15),
              _buildInfo('Tax Information', expenseReport.taxInformation),
              _buildInfo('Project Code', expenseReport.projectCode),
              const Text('Status', style: headerStyle),
              const SizedBox(height: 5),
              StatusIndicator(status: expenseReport.status),
              const SizedBox(height: 20),
              _buildInfo('Additional Notes', expenseReport.additionalNotes),
              Container(
                margin: const EdgeInsets.all(10.0),
                height: 400,
                child: FutureBuilder<http.Response>(
                  future: apiService.getPhoto(slug),
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
