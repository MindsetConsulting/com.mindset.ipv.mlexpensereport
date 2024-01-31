import 'package:flutter/material.dart';
import './status_indicator.dart';

class MainCard extends StatelessWidget {
  final String totalAmount;
  final String approvedAmount;
  final String pendingAmount;
  final String rejectedAmount;

  MainCard({
    required this.totalAmount,
    required this.approvedAmount,
    required this.pendingAmount,
    required this.rejectedAmount,
  }); 

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 175,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text(
                        'TOTAL',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        totalAmount,
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const StatusIndicator(status: 'approved'),
                      const SizedBox(height: 5.0),
                      Text(approvedAmount),
                    ],
                  ),
                  Column(
                    children: [
                      const StatusIndicator(status: 'pending'),
                      const SizedBox(height: 5.0),
                      Text(pendingAmount),
                    ],
                  ),
                  Column(
                    children: [
                      const StatusIndicator(status: 'rejected'),
                      const SizedBox(height: 5.0),
                      Text(rejectedAmount),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
