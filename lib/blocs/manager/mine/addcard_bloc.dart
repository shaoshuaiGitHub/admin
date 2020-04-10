import "../../../common/component_index.dart";
import '../../../ui/pages/page_index.dart';
import 'package:permission_handler/permission_handler.dart';
class AddCardBloc implements BlocBase {
  BuildContext bloccontext;

  NetRepository netRepository = NetRepository();

  void loginSwitch() async {
    await PermissionHandler().requestPermissions([PermissionGroup.contacts]);

    int type = int.tryParse(AppInstance.currentUser.roleType);
    Widget mainPage = (type == 4
        ? CapitalMainPage()
        : type == 2 ? ManagerMainPage() : MainPage());
    Navigator.pushAndRemoveUntil(
      bloccontext,
      MaterialPageRoute(
        builder: (BuildContext context) => mainPage,
      ),
      (Route<dynamic> route) => false,
    );
  }

  Future userAuthAction(
      String username, String userid, File fImg, File bImg) async {
    FormData userAuthReq = new FormData.from({
      "token": AppInstance.currentUser.token,
      "fileA": UploadFileInfo(fImg, "idfront.jpg"),
      "fileB": UploadFileInfo(bImg, "idback.jpg"),
      "name": username,
      "id": userid,
    });
    XsProgressHud.show(bloccontext);
    return netRepository.userAuth(userAuthReq).then((resp) {
      XsProgressHud.hide();
      FocusScope.of(bloccontext).requestFocus(FocusNode());
      if (resp.code == Constant.SUCCESS_CODE) {
        showToast("认证成功~");
        loginSwitch();
      } else {
        showToast(resp.msg);
      }
    });
  }

  void showToast(String msg, {int duration, int gravity: 50}) {
    
    Toast.show(msg, bloccontext, duration: duration, gravity: gravity);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
