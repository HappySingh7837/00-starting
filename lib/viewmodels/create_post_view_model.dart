import 'package:compound/locator.dart';
import 'package:compound/models/post.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:flutter/cupertino.dart';

class CreatePostViewModel extends BaseModel {

  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future addPost({@required String title}) async {
    setBusy(true);    
    var result= await _firestoreService.addPost(
      Post(userId: currentUser.id, title: title)
    );
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
