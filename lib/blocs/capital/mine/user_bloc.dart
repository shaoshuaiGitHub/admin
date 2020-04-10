import 'package:rxdart/rxdart.dart';
import 'package:youxinbao/ui/pages/page_index.dart';

import "../../../common/component_index.dart";

class UserBloc implements BlocBase {
  BuildContext bloccontext;
  NetRepository netRepository = NetRepository();

  BehaviorSubject<UserInfoModel> _userController =
      BehaviorSubject<UserInfoModel>();
  Stream<UserInfoModel> get outUserInfo => _userController.stream;
  StreamSink<UserInfoModel> get _userInfoSink => _userController.sink;

  Future getUserInfo() async {
    TokenReq _getUserInfoByToken = TokenReq(AppInstance.currentUser.token);
    XsProgressHud.show(bloccontext);
    return netRepository.userInfo(_getUserInfoByToken.toJson()).then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          _userInfoSink.add(UserInfoModel.fromJson(resp.data));
        }
      } else {
        if (resp.code == 50008) {
          AppInstance.remove("user");
          Navigator.pushAndRemoveUntil(
            bloccontext,
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false,
          );
          AppInstance.putString(Constant.KEY_THEME_COLOR, 'usercolor');
          final ApplicationBloc bloc =
              BlocProvider.of<ApplicationBloc>(bloccontext);
          bloc.sendAppEvent(1);
        }
        showToast(resp.msg);
      }
    });
  }

  void showToast(String msg, {int duration, int gravity: 0}) {
    Toast.show(msg, bloccontext, duration: duration, gravity: gravity);
  }

  void dispose() {
    _userController.close();
  }
}
