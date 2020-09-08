import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/services/authenticate_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';

class StartUpViewModel extends BaseModel{

  final AuthenticateService _authenticateService=
  locator<AuthenticateService>();
  final NavigationService _navigationService=
  locator<NavigationService>();
  
  Future handleStartUPLogic() async{
    var hasLogged = await _authenticateService.isUserLoggedIn();    
    if(hasLogged){
      _navigationService.navigateTo(LoginViewRoute);
    }else{
      _navigationService.navigateTo(SignUpViewRoute);
    }
  }

}