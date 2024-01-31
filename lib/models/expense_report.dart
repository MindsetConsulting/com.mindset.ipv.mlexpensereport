class ExpenseReport {
  final String employeeId;
  final String department;
  final String companyName;
  final String dateSubmitted;
  final String expenseCategory;
  final String currency;
  final double amount;
  final String taxInformation;
  final String businessReason;
  final String projectCode;
  final String status;
  final String additionalNotes;

  ExpenseReport({
    required this.employeeId,
    required this.department,
    required this.companyName,
    required this.dateSubmitted,
    required this.expenseCategory,
    required this.currency,
    required this.amount,
    required this.taxInformation,
    required this.businessReason,
    required this.projectCode,
    required this.status,
    required this.additionalNotes,
  });
}