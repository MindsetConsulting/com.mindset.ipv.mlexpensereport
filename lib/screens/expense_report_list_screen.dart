import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense_report.dart';
import '../services/api_service.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_round_button.dart';
import '../widgets/main_card.dart';
import '../widgets/custom_tool_bar.dart';

class ExpenseReportListScreen extends StatefulWidget {
  ExpenseReportListScreen({Key? key}) : super(key: key);

  @override
  _ExpenseReportListScreenState createState() =>
      _ExpenseReportListScreenState();
}

class _ExpenseReportListScreenState extends State<ExpenseReportListScreen> {
  List<ExpenseReport> originalData = [];
  List<ExpenseReport> cardData = [];
  final apiService = ApiService();

  @override
  void initState() {
    super.initState();
    apiService.fetchExpenseData().then((data) {
      setState(() {
        originalData = data
            .where((item) => item != null)
            .map((item) => ExpenseReport.fromJson(item!))
            .toList();
        cardData = List.from(originalData);
        cardData.sort((a, b) {
          DateTime dateA = DateFormat('MMM dd, yyyy').parse(a.dateSubmitted);
          DateTime dateB = DateFormat('MMM dd, yyyy').parse(b.dateSubmitted);
          return dateB.compareTo(dateA);
        });
      });
    }).catchError((error) {
      print('Error fetching expense data: $error');
    });
  }

  double calculateTotalAmount() {
    return cardData.fold(
        0, (previousValue, element) => previousValue + element.amount);
  }

  double calculateAmount(String status) {
    return cardData
        .where((element) => element.status == status)
        .fold(0, (previousValue, element) => previousValue + element.amount);
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = calculateTotalAmount();
    double approvedAmount = calculateAmount('approved');
    double pendingAmount = calculateAmount('pending');
    double rejectedAmount = calculateAmount('rejected');

    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          MainCard(
            totalAmount: '\$${totalAmount.toStringAsFixed(2)}',
            approvedAmount: '\$${approvedAmount.toStringAsFixed(2)}',
            pendingAmount: '\$${pendingAmount.toStringAsFixed(2)}',
            rejectedAmount: '\$${rejectedAmount.toStringAsFixed(2)}',
          ),
          CustomToolbar(
            originalData: originalData,
            data: cardData,
            onSort: (sortedData) {
              setState(() {
                cardData = sortedData;
              });
            },
            onSearch: (searchData) {
              setState(() {
                cardData = searchData;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cardData.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: CustomCard(expenseReport: cardData[index]),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        buttons: [
          CustomRoundButton(
            onPressed: () {
              Navigator.pushNamed(context, '/upload');
            },
            fillColor: Theme.of(context).colorScheme.primary,
            icon: Icons.add,
            iconColor: Theme.of(context).colorScheme.background,
          ),
        ],
      ),
    );
  }
}
