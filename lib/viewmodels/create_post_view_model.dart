import 'dart:io';
import 'package:compound/locator.dart';
import 'package:compound/models/cloud_storage_result.dart';
import 'package:compound/models/post.dart';
import 'package:compound/services/cloud_storage_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/utils/image_selector.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:flutter/cupertino.dart';

class CreatePostViewModel extends BaseModel {

  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ImageSelector _imageSelector=locator<ImageSelector>();
  final CloudStorageService _cloudStorageService = 
  locator<CloudStorageService>();

  Post _edittingPost;

  void setEdittingPost(Post post){
    _edittingPost=post;
  }

  bool get _editting => _edittingPost!=null;

  File _selectedImage;
  File get selectedImage => _selectedImage;

  Future addPost({@required String title}) async {
    setBusy(true); 
    CloudStorageResult storageResult;

    if (!_editting) {
      storageResult = await _cloudStorageService.uploadImg(
          imageToUpload: _selectedImage, title: title);
    }
    var result;  

     if (!_editting) {
      result = await _firestoreService
          .addPost(Post(
            title: title,
            userId: currentUser.id,
            imageUrl:  storageResult.imageUrl,
            imageFileName: storageResult.imageFileName
            ));
    } else {
      result = await _firestoreService.updatePost(Post(
        title: title,
        userId: _edittingPost.userId,
        documentId: _edittingPost.documentId,
        imageUrl: _edittingPost.imageUrl,
        imageFileName: _edittingPost.imageFileName,
      ));
    setBusy(false);

    if(result is String){
      await _dialogService.showDialog(
        title: 'Could not add Post',
        description: result,
      );
    }else{
      await _dialogService.showDialog(
        title: 'Post Added Succesfully',
        description: 'Post Added',
      );
    }
    _navigationService.pop();
  }
 }

 Future selectImage() async {
   var tempImg = await _imageSelector.selectImage();
   if(tempImg!=null){
     _selectedImage = tempImg;
     notifyListeners();
   }
 }
}