import 'package:open_git/contract/login_contract.dart';
import 'package:open_git/manager/login_manager.dart';

class LoginPresenter extends ILoginPresenter {
  @override
  void login(String name, String password) async {
    if (view != null) {
      view.showLoading();
    }
//    LoginManager.instance.login(name, password, (data) {
//      if (view != null) {
//        view.hideLoading();
//      }
//      if (data != null) {
//        LoginBean loginBean = LoginBean.fromJson(data);
//        if (loginBean != null) {
//          String token = loginBean.token;
//          LoginManager.instance.setToken(token);
//          SharedPrfUtils.saveString(SharedPrfKey.SP_KEY_TOKEN, token);
//
//          //获取自己的用户信息
//          getMyUserInfo();
//        }
//      }
//    }, (code, msg) {
//      if (view != null) {
//        view.hideLoading();
//        view.showToast("code is $code @msg is $msg");
//      }
//    });
    final response = await LoginManager.instance.login(name, password);
    if (view != null) {
      view.hideLoading();
      if (response != null) {
        view.onLoginSuccess();
      }
    }
  }

//  @override
//  void getMyUserInfo() {
//    if (view != null) {
//      view.showLoading();
//    }
//    LoginManager.instance.getMyUserInfo((data) {
//      if (view != null) {
//        view.hideLoading();
//      }
//      if (data != null) {
//        //缓存用户信息
//        SharedPrfUtils.saveString(
//            SharedPrfKey.SP_KEY_USER_INFO, jsonEncode(data));
//        LoginManager.instance.setUserBean(data);
//
//        UserBean userBean = UserBean.fromJson(data);
//        if (userBean != null && view != null) {
//          view.onLoginSuccess();
//        }
//      }
//    }, (code, msg) {
//      if (view != null) {
//        view.hideLoading();
//        view.showToast("code is $code @msg is $msg");
//      }
//    });
//  }
}
