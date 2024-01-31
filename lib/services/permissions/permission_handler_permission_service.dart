import 'package:flutter/material.dart';
import './permission_service.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerPermissionService implements PermissionService {
  @override
  Future<PermissionStatus> requestCameraPermission() async {
    return await Permission.camera.request();
  }

  @override
  Future<PermissionStatus> requestPhotosPermission() async {
    return await Permission.photos.request();
  }

  @override
  Future<bool> handleCameraPermission(BuildContext context) async {
    // Simulate the granting of camera permission for testing purposes
    return true;
  }

  @override
  Future<bool> handlePhotosPermission(BuildContext context) async {
    // Simulate the granting of photos permission for testing purposes
    return true;
  }
}