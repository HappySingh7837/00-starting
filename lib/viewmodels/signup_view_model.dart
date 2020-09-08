import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/services/authenticate_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:flutter/cupertino.dart';

import 'base_model.dart';
class SignUpViewModel extends BaseModel {
  final AuthenticateService _authenticateService = locator<AuthenticateService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future signUp({@required String email,@required String password})async
  {
    setBusy(true);
    var result= await _authenticateService.signUpWithEmail(
      email: email, password: password);
      setBusy(false);
      if(result is bool){
        if(result){
          _navigationService.navigateTo(HomeViewRoute);
        }
        else{
          await _dialogService.showDialog(
            title: 'Sign Up Fail',
            description: 'Please try Again',
          );
        }
      }else{
        await _dialogService.showDialog(
            title: 'Sign Up Fail',
            description: result,
        );
      }
  }
}