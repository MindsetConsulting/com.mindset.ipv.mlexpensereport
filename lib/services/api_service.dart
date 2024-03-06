import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xml/xml.dart' as xml;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class ApiService {
  final String? username = dotenv.env['USERNAME'];
  final String? password = dotenv.env['PASSWORD'];

  Future<List<dynamic>> fetchExpenseData() async {
    final headers = {
      'Authorization':
          'Basic ' + base64Encode(utf8.encode('$username:$password')),
      'Content-Type': 'application/json',
      'X-Requested-With': 'false',
    };

    final response = await http.get(
      Uri.parse(
          'https://s4hana2022.mindsetconsulting.com:44300/sap/opu/odata/sap/ZEXPENSE_DEV_API/Expense'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var document = xml.XmlDocument.parse(response.body);
      var entries = document.findAllElements('entry');
      return entries
          .map((node) {
            var contentNodes = node.findAllElements('content');
            if (contentNodes.isEmpty) {
              print('No content found for this entry, skipping');
              return null;
            }
            var propertiesNodes =
                contentNodes.first.findElements('m:properties');
            if (propertiesNodes.isEmpty) {
              print('No properties found for this content, skipping');
              print('Content: ${contentNodes.first.toXmlString()}');
              return null;
            }
            var properties = propertiesNodes.first;

            var employeeId = properties.findElements('d:employeeid').isNotEmpty
                ? properties.findElements('d:employeeid').first.innerText
                : '';
            var expenseReportId = properties
                    .findElements('d:expensereportid')
                    .isNotEmpty
                ? properties.findElements('d:expensereportid').first.innerText
                : '';
            var department = properties.findElements('d:department').isNotEmpty
                ? properties.findElements('d:department').first.innerText
                : '';
            var companyName =
                properties.findElements('d:companyname').isNotEmpty
                    ? properties.findElements('d:companyname').first.innerText
                    : '';
            var dateSubmitted = properties
                    .findElements('d:datesubmitted')
                    .isNotEmpty
                ? DateFormat.yMMMd().format(DateTime.parse(
                    properties.findElements('d:datesubmitted').first.innerText))
                : '';
            var expenseCategory = properties
                    .findElements('d:expensecategory')
                    .isNotEmpty
                ? properties.findElements('d:expensecategory').first.innerText
                : '';
            var amount = properties.findElements('d:amount').isNotEmpty
                ? double.tryParse(
                        properties.findElements('d:amount').first.innerText) ??
                    0.0
                : 0.0;
            var currency = properties.findElements('d:currency').isNotEmpty
                ? properties.findElements('d:currency').first.innerText
                : '';
            var taxInformation = properties
                    .findElements('d:taxinformation')
                    .isNotEmpty
                ? properties.findElements('d:taxinformation').first.innerText
                : '';
            var businessReason = properties
                    .findElements('d:businessreason')
                    .isNotEmpty
                ? properties.findElements('d:businessreason').first.innerText
                : '';
            var projectCode =
                properties.findElements('d:projectcode').isNotEmpty
                    ? properties.findElements('d:projectcode').first.innerText
                    : '';
            var status = properties.findElements('d:status').isNotEmpty
                ? properties.findElements('d:status').first.innerText
                : '';
            var additionalNotes = properties
                    .findElements('d:additionalnotes')
                    .isNotEmpty
                ? properties.findElements('d:additionalnotes').first.innerText
                : '';
            var slug = properties.findElements('d:slug').isNotEmpty
                ? properties.findElements('d:slug').first.innerText
                : '';

            return {
              'employeeid': employeeId,
              'expensereportid': expenseReportId,
              'department': department,
              'companyname': companyName,
              'datesubmitted': dateSubmitted,
              'expensecategory': expenseCategory,
              'amount': amount.toString(),
              'currency': currency,
              'taxinformation': taxInformation,
              'businessreason': businessReason,
              'projectcode': projectCode,
              'status': status,
              'additionalnotes': additionalNotes,
              'slug': slug,
            };
          })
          .where((item) => item != null)
          .toList();
    } else {
      throw Exception('Failed to load expense data');
    }
  }

  Future<http.Response> getPhoto(String slug) async {
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
}
