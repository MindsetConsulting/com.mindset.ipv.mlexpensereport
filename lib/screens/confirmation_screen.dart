import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_round_button.dart';
import '../widgets/custom_app_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  @override
  void initState() {
    super.initState();
    _getPhoto(widget.responseData['slug']);
  }

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

  String formatDate(String dateStr) {
    final match = RegExp(r'/Date\((\d+)([+-]\d+)?\)/').firstMatch(dateStr);
    if (match != null) {
      final timestamp = int.parse(match.group(1)!);
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
      final adjustedDate = date.add(Duration(days: 1));
      return DateFormat.yMMMd().format(adjustedDate);
    } else {
      return 'Invalid date';
    }
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
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: '001',
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Employee ID'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: widget.responseData['d']['department'],
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Department'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: widget.responseData['d']['companyname'],
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Company Name'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: widget.responseData['d']['expensecategory'],
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Expense Category'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue:
                        formatDate(widget.responseData['d']['datesubmitted']),
                    readOnly: true,
                    decoration: inputDecoration.copyWith(labelText: 'Date'),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        height: 40,
                        child: TextFormField(
                          initialValue: 'USD',
                          readOnly: true,
                          decoration:
                              inputDecoration.copyWith(labelText: 'Currency'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        height: 40,
                        child: TextFormField(
                          initialValue: widget.responseData['d']['amount'],
                          readOnly: true,
                          decoration:
                              inputDecoration.copyWith(labelText: 'Amount'),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: widget.responseData['d']['taxinformation'],
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Tax Information'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: widget.responseData['d']['projectcode'],
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Project Code'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: 'Pending',
                    readOnly: true,
                    decoration: inputDecoration.copyWith(labelText: 'Status'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 40,
                  child: TextFormField(
                    initialValue: widget.responseData['d']['additionalnotes'],
                    readOnly: true,
                    decoration:
                        inputDecoration.copyWith(labelText: 'Additional Notes'),
                    maxLines: null,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 400,
                  child: FutureBuilder<http.Response>(
                    future: _getPhoto(widget.responseData['slug']),
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
