import 'package:cloudinary_public/cloudinary_public.dart';

class StorageHelper {
  final CloudinaryPublic cloudinary =
      CloudinaryPublic('dej47phgk', 'molopay_app');

  Future<String?> uploadImage(String path) async {
    try {
      final CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(path,
              folder: 'MOLOPAY_APP',
              resourceType: CloudinaryResourceType.Image));

      return response.secureUrl;
    } catch (e) {
      print("$e");
    }
  }
}
