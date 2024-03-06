import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'amplifyconfiguration.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app_theme.dart';
import './services/service_locator.dart';
import './screens/expense_report_list_screen.dart';
import 'screens/upload_file_screen.dart';
import './screens/expense_report_screen.dart';
import './screens/confirmation_screen.dart';
import './screens/expense_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  setupServiceLocator();
  await dotenv.load();
  runApp(MainApp());
}

Future<void> _configureAmplify() async {
  try {
    final auth = AmplifyAuthCognito();
    final storage = AmplifyStorageS3();
    await Amplify.addPlugins([auth, storage]);

    await Amplify.configure(amplifyconfig);
  } on Exception catch (e) {
    safePrint('An error occurred configuring Amplify: $e');
  }
}

const String homeRoute = '/';
const String uploadRoute = '/upload';
const String reportRoute = '/report';
const String confirmationRoute = '/confirmation';
const String detailRoute = '/detail';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case homeRoute:
      return MaterialPageRoute(
          builder: (context) => ExpenseReportListScreen(key: UniqueKey()));
    case uploadRoute:
      return MaterialPageRoute(builder: (context) => UploadFile());
    case reportRoute:
      return MaterialPageRoute(builder: (context) => const ExpenseReportScreen());
    case confirmationRoute:
      final responseData = settings.arguments;
      return MaterialPageRoute(
        builder: (context) => ConfirmationScreen(
          responseData: responseData as Map<String, dynamic>,
        ),
      );
    case detailRoute:
      final expenseReport = settings.arguments;
      return MaterialPageRoute(
        builder: (context) => const ExpenseDetailScreen(),
        settings: RouteSettings(
          arguments: expenseReport,
        ),
      );
    default:
      return MaterialPageRoute(
          builder: (context) => ExpenseReportListScreen(key: UniqueKey()));
  }
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme(),
      initialRoute: homeRoute,
      onGenerateRoute: generateRoute,
    );
  }
}
