import 'dart:io' as io;
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aws_common/vm.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../services/media/media_service_interface.dart';
import '../services/service_locator.dart';
import '../widgets/image_picker_action_sheet.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_round_button.dart';

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
      await uploadIOFile(ioFile);
      safePrint('File uploaded successfully to S3');
    } catch (e) {
      safePrint('Error uploading file to S3: $e');
    }
  }

  Future<void> uploadIOFile(io.File file) async {
    final awsFile = AWSFilePlatform.fromFile(file);
    try {
      final uploadResult = await Amplify.Storage.uploadFile(
        localFile: awsFile,
        key: file.path,
      ).result;
      safePrint('Uploaded file: ${uploadResult.uploadedItem.key}');

      Navigator.pushNamed(context, '/report');
    } on StorageException catch (e) {
      safePrint('Error uploading file: ${e.message}');
      rethrow;
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
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
