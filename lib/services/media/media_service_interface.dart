import 'dart:io';

import 'package:flutter/cupertino.dart';
import '../permissions/permission_service.dart';

// Created our own enum to prevent an abstract interface
// from having a dependency on an external package
enum AppImageSource {
  camera,
  gallery,
}

abstract class MediaServiceInterface {
  PermissionService get permissionService;

  Future<File?> uploadImage(
    BuildContext context,
    AppImageSource appImageSource,
  );
}