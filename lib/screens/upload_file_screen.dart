import 'dart:io' as io;
import 'dart:math';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/media/media_service_interface.dart';
import '../services/service_locator.dart';
import '../widgets/image_picker_action_sheet.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_round_button.dart';
import '../screens/expense_report_screen.dart';

class UploadFile extends StatefulWidget {
  @override
  _UploadFileState createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  final MediaServiceInterface _mediaService = getIt<MediaServiceInterface>();

  // File? uploadedFile;
  bool _isLoadingGettingFile = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pickFileSource();
    });
  }

  Future<AppImageSource?> pickFileSource() async {
    AppImageSource? appFileSource = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => ImagePickerActionSheet(),
    );
    if (appFileSource != null) {
      _getFile(appFileSource);
    }
    return appFileSource;
  }

  Future _getFile(AppImageSource appFileSource) async {
    setState(() => _isLoadingGettingFile = true);
    final pickedImageFile =
        await _mediaService.uploadImage(context, appFileSource);
    setState(() => _isLoadingGettingFile = false);

    if (pickedImageFile == null) {
      safePrint('No file selected.');
      return;
    }

    try {
      final ioFile = io.File(pickedImageFile.path);
      final slug = _generateSlug();
      await uploadIOFile(ioFile, slug);
      final sapUrl =
          'https://s4hana2022.mindsetconsulting.com:44300/sap/opu/odata/sap/ZIMAGE_SRV/zimageSet';
      dotenv.load();
      String? username = dotenv.env['USERNAME'];
      String? password = dotenv.env['PASSWORD'];
      final sapHeaders = {
        'Content-Type': 'image/jpeg',
        'Accept': 'application/json',
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$username:$password')),
        'SLUG': slug,
        'X-Requested-With': 'false',
      };

      var imageBytes = await io.File(pickedImageFile.path).readAsBytes();
      safePrint('Slug: $slug');
      var response;
      try {
        response = await http.post(
          Uri.parse(sapUrl),
          headers: sapHeaders,
          body: imageBytes,
        );
      } catch (e) {
        safePrint('Error making POST request: $e');
        return null;
      }
    } catch (e) {
      safePrint('Error picking file: $e');
    }
  }

  Future<void> uploadIOFile(io.File file, String slug) async {
    const url =
        'https://7kfj895ua0.execute-api.us-east-2.amazonaws.com/default/mlExpenseReportLambda';

    setState(() {
      _isLoadingGettingFile = true;
    });

    try {
      var bytes = await file.readAsBytes();
      var base64File = base64Encode(bytes);
      var response = await http.post(
        Uri.parse(url),
        headers: {
          "x-api-key": "IJQRAuOTg6amZayPdbeXdUxI8m5Rdqf8NcmTreOe",
          "Content-Type": "application/json"
        },
        body: json.encode({"Image": base64File}),
      );

      if (response.statusCode == 200) {
        safePrint('AWS Uploaded file: ${file.path}');
        safePrint('AWS Response body: ${response.body}');
        final responseBody = jsonDecode(response.body);
        final total = responseBody['Total'];
        final companyName = responseBody['CompanyName'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExpenseReportScreen(),
            settings: RouteSettings(
              arguments: {'companyName': companyName, 'total': total, 'slug': slug,},
            ),
          ),
        );
      } else {
        safePrint('Error uploading file: ${response.statusCode}');
        safePrint('Response body: ${response.body}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'No text found in file. Please try again with a different file'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (Route<dynamic> route) => false);
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      safePrint('Error uploading file: ${e.toString()}');
      rethrow;
    } finally {
      setState(() {
        _isLoadingGettingFile = false;
      });
    }
  }

  String _generateSlug() {
    final random = Random.secure();
    final codeUnits = List.generate(8, (index) {
      return random.nextInt(26) + 65;
    });

    return String.fromCharCodes(codeUnits);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _isLoadingGettingFile
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: SizedBox(),
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
