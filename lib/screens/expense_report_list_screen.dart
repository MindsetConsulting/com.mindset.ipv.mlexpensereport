import 'package:flutter/material.dart';
import '../models/expense_report.dart';
import '../expense_data.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_round_button.dart';
import '../widgets/main_card.dart';
import '../widgets/custom_tool_bar.dart';

class ExpenseReportListScreen extends StatelessWidget {
  ExpenseReportListScreen({Key? key}) : super(key: key);

  final List<ExpenseReport> cardData = getExpenseData();

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
          CustomToolbar(),
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
