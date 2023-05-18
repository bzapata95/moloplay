import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:permission_handler/permission_handler.dart' as perm;

class HandleRequestPermissions {
  static Future<String?> requestOpenPhotoLibrary() async {
    final ImagePicker picker = ImagePicker();
    late PermissionStatus request;
    late String? imagePath;

    if (Platform.isIOS) {
      request = await Permission.storage.request();
    } else {
      request = await Permission.mediaLibrary.request();
    }

    if (request.isGranted) {
      final XFile? image = await picker.pickImage(
          source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
      if (image != null) {
        imagePath = image.path;
      }
    }

    if (request.isDenied) {
      bool isOpened = await openAppSettings();
      print('La configuración de la aplicación está abierta: $isOpened');
    }

    if (request.isPermanentlyDenied) {
      bool isOpened = await openAppSettings();
      print('La configuración de la aplicación está abierta: $isOpened');
    }
    return imagePath;
  }

  static Future<String?> requestOpenCamera() async {
    final ImagePicker picker = ImagePicker();
    final request = await Permission.camera.request();
    late String? imagePath;

    if (request.isGranted) {
      final XFile? image = await picker.pickImage(
          source: ImageSource.camera, maxHeight: 500, maxWidth: 500);
      if (image != null) {
        imagePath = image.path;
      }
    }

    if (request.isDenied) {
      bool isOpened = await openAppSettings();
      print('La configuración de la aplicación está abierta: $isOpened');
    }

    if (request.isPermanentlyDenied) {
      bool isOpened = await openAppSettings();
      print('La configuración de la aplicación está abierta: $isOpened');
    }

    return imagePath;
  }
}
