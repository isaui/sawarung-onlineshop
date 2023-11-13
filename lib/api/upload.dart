import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String?> uploadImageToFirebase(File imageFile) async {
  try {
    final Reference storageReference = FirebaseStorage.instance.ref().child('images/' + DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');
    final UploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask.whenComplete(() {});

    final String imageUrl = await storageReference.getDownloadURL();
    return imageUrl;
  } catch (error) {
    print('Error saat mengupload gambar: $error');
    return null;
  }
}

Future<String?> uploadImageToFirebaseWeb(Uint8List uint8list) async {
  try {
    final Reference storageReference = FirebaseStorage.instance.ref().child('images/' + DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');
    final UploadTask uploadTask = storageReference.putData(uint8list);
    await uploadTask.whenComplete(() {});

    final String imageUrl = await storageReference.getDownloadURL();
    print(imageUrl);
    return imageUrl;
  } catch (error) {
    print('Error saat mengupload gambar: $error');
    return null;
  }
}

