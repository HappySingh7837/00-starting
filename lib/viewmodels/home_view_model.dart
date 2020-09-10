import 'dart:html';

import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/post.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';

class HomeViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  

  List<Post> _posts;
  List<Post> get posts => _posts;

  Future fetchPosts() async {
    setBusy(true);
    // TODO: Find or Create a TaskType that will automaticall do the setBusy(true/false) when being run.
    var postsResults = await _firestoreService.getPostsOnceOff();
    setBusy(false);

    if (postsResults is List<Post>) {
      _posts = postsResults;
      notifyListeners();
    } else {
      await _dialogService.showDialog(
        title: 'Posts Update Failed',
        description: postsResults,
      );
    }
  }
  
  Future navigateToCreateView() async {
   await _navigationService.navigateTo(CreatePostViewRoute);
   await fetchPosts();
  }

 Future deletePost(int index) async {
   var dialogResponse = await _dialogService.showConfirmationDialog(
     title: 'Are You Sure To Delete Post',
     description: 'Do you want to Delete Post',
     confirmationTitle: 'Yes',
     cancelTitle: 'No',
   );

   if(dialogResponse.confirmed){
     setBusy(true);
     await _firestoreService.deletePost(_posts[index].documentId);
   }
 }

 void editPost(int index){
 _navigationService.navigateTo(CreatePostViewRoute,
 arguments: _posts[index]);
 }
     
}
