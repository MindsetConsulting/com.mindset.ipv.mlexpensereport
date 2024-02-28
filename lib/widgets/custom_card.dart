import 'package:flutter/material.dart';
import '../models/expense_report.dart';
import './status_indicator.dart';
import 'package:intl/intl.dart';

class CustomCard extends StatelessWidget {
  final ExpenseReport expenseReport;

  CustomCard({required this.expenseReport});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Expense Report in CustomCard: $expenseReport');
        Navigator.pushNamed(
          context,
          '/detail',
          arguments: expenseReport,
        );
      },
      child: Container(
        width: 375,
        height: 120,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        expenseReport.companyName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expenseReport.dateSubmitted,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            expenseReport.expenseCategory,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${expenseReport.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: StatusIndicator(status: expenseReport.status),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
