import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/services/authenticate_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:flutter/cupertino.dart';

import 'base_model.dart';
class LoginViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final AuthenticateService _authenticateService = locator<AuthenticateService>();

  void navigateToSignUp(){
    _navigationService.navigateTo(SignUpViewRoute);
  }

  Future login ({@required String email,@required String password})async{
    setBusy(true);
    var result=await _authenticateService.loginWithEmail(
      email: email, password: password
      );
      setBusy(false);
      if(result is bool){
        if(result){
          _navigationService.navigateTo(HomeViewRoute);
        }
        else{
          await _dialogService.showDialog(
            title: 'Login Failed',
            description: 'Invalid Username And Password, Please Try Again Later!'
          );
        }
          
      }else{
        await _dialogService.showDialog(
          title: 'Login Failed',
          description: 'No user exist, Please Try Again Later!'
        );
      }
  }
}