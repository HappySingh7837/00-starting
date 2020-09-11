import 'dart:io';
import 'package:compound/models/cloud_storage_result.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class CloudStorageService{

  Future <CloudStorageResult> uploadImg({
    @required File imageToUpload,
    @required String title,
  }) async {    
    var imageFileName = title+DateTime.now().millisecondsSinceEpoch.toString();
    final StorageReference fbStorageReference = FirebaseStorage.instance
    .ref().child(imageFileName);

    StorageUploadTask uploadTask = fbStorageReference.putFile(imageToUpload);

     StorageTaskSnapshot storageTaskSnapshot = await
     uploadTask.onComplete;

      var downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

    if (uploadTask.isComplete) {
      var url = downloadUrl.toString();
      return CloudStorageResult(
        imageUrl: url,
        imageFileName:imageFileName,
      ) ;      
    }
    return null;
  }

  Future deleteImage(String imageFileName) async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(imageFileName);

    try {
      await firebaseStorageRef.delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}

