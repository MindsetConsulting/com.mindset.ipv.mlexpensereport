# Expense Report App

This is a Flutter application designed to handle expense reports. The app allows users to submit expense reports and view a confirmation screen with the details of the submitted report as well as a list of all previous submitted expense reports and their status.

This app uses AWS Amplify as an initial framework along with AWS API Gateway, Lambda, and Textract to utilize machine learning in order to automatically extract data from a receipt and populate the expense report form.

[A slide deck detailing the architecture can be found here](https://docs.google.com/presentation/d/1ykc_vBi9wdMwO5IIvithbDmp9xZ1PislZYtcFyqvnQU/edit#slide=id.g2b2c01897e9_0_0)

[A slide deck detailing the whole application can be found here](https://docs.google.com/presentation/d/1fwfpNOB0K46VHdN4PulAzNyKu7Sqc89qN0qbc9VWdsU/edit#slide=id.g114450d563d_2_256)

[A video demo of the application can be found here](https://www.youtube.com/watch?v=-JIDGpYxNHY)

## Features

- Submit expense reports with various details such as employee ID, department, company name, expense category, date, amount, tax information, project code, and additional notes.
- View a confirmation screen with the details of the submitted report.
- View a list of all expense reports as well as the details of an individual expense report.

## Project Structure

The main screens of the app are:

- `ExpenseReportListScreen`: This screen displays a list of all submitted expense reports. Each item in the list provides a brief overview of the report, such as the business the receipt is from, expense type, and amount. Selecting an item from the list navigates to the `ExpenseReportDetailScreen`.
- `ExpenseReportDetailScreen`: This screen displays the full details of a selected expense report. It retrieves the report details from the `responseData` passed from the `ExpenseReportListScreen`. The details include employee ID, department, company name, expense category, date, amount, tax information, project code, and additional notes, as well as an image of the submitted receipt.
- `ExpenseReportScreen`: This screen contains a form for submitting expense reports. When the form is submitted, it calls the `submitExpenseReport` function and navigates to the `ConfirmationScreen`.
- `ConfirmationScreen`: This screen displays the details of the submitted report. It retrieves the report details from the `responseData` passed from the `ExpenseReportScreen`.

## Getting Started

To get started with this project, clone the repository and run `flutter run` in the root directory.

## Dependencies

This project uses the following dependencies:

- Flutter SDK
- Dart
- AWS Amplify
- intl
- get_it
- image_picker
- path
- path_provider
- permission_handler
- http
- flutter_dotenv
- fluttertoast
- xml
- cupertino_icons

## Resources

For help getting started with Flutter, view the [online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.