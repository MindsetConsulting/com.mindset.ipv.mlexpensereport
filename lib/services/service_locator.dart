import './media/media_service.dart';
import './media/media_service_interface.dart';
import './permissions/permission_handler_permission_service.dart';
import '../services/permissions/permission_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

setupServiceLocator() {
  // Permission service is used in FileUploaderService
  // so it must be located first
  getIt.registerSingleton<PermissionService>(PermissionHandlerPermissionService());

  getIt.registerSingleton<MediaServiceInterface>(MediaService());
}