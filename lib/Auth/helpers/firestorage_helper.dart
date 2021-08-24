import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper {
  FirebaseStorageHelper._();
  static FirebaseStorageHelper firebaseStorageHelper =
      FirebaseStorageHelper._();
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Future<String> uploadImage(File file) async {
    // /android/memory/ahmed/gallery/camera/12-9-2020.jpg
    //1- make a refrence for this file in firebase storage
    String filePath = file.path;
    String fileName = filePath.split('/').last;
    String path = 'images/profiles/$fileName';
    Reference reference = firebaseStorage.ref(path);

    // 2 upload the file to the defined refrence
    await reference.putFile(file);

    //3 get the file url
    String imageUrl = await reference.getDownloadURL();

    return imageUrl;
  }
}
