import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:todonick/helpers/failure.dart';

class StorageService {
  static Future<String> uploadFileAndGetUrl(File file, String fileName) async {
    try {
      StorageReference _storageRef =
          FirebaseStorage.instance.ref().child(fileName);
      final StorageUploadTask uploadTask = _storageRef.putFile(file);
      final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      final String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    } catch (error) {
      throw Failure("file uploading failed");
    }
  }
}
