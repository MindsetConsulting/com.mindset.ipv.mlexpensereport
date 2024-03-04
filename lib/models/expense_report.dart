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
  final String slug;

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
    required this.slug,
  });

  factory ExpenseReport.fromJson(Map<String, dynamic> json) {
    return ExpenseReport(
      employeeId: json['employeeid'] ?? '',
      department: json['department'] ?? '',
      companyName: json['companyname'] ?? '',
      dateSubmitted: json['datesubmitted'] ?? '',
      expenseCategory: json['expensecategory'] ?? '',
      currency: json['currency'] ?? '',
      amount: double.tryParse(json['amount'] ?? '') ?? 0.0,
      taxInformation: json['taxinformation'] ?? '',
      businessReason: json['businessreason'] ?? '',
      projectCode: json['projectcode'] ?? '',
      status: json['status'] ?? '',
      additionalNotes: json['additionalnotes'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}
