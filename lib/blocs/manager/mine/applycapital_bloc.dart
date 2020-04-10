import "../../../common/component_index.dart";
import '../../../ui/pages/page_index.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../ui/pages/manager/mine/application_head.dart';

class ApplyCapitalBloc implements BlocBase {
  BuildContext bloccontext;

  NetRepository netRepository = NetRepository();

  StreamController<int> _applycapitalController = StreamController<int>();
  StreamSink<int> get _applycapitalSink => _applycapitalController.sink;
  Stream<int> get applycapitalStream => _applycapitalController.stream;

  Future applyCapitalAction(int account, String applyMsg) async {
    final ApplicationBloc applocationBloc =
        BlocProvider.of<ApplicationBloc>(bloccontext);
    ApplyCapitalReq _operationReq =
        ApplyCapitalReq(AppInstance.currentUser.token, account, applyMsg);
    XsProgressHud.show(bloccontext);
    return netRepository.applyCapital(_operationReq.toJson()).then((resp) {
      XsProgressHud.hide();
      FocusScope.of(bloccontext).requestFocus(FocusNode());

      if (resp.code == Constant.SUCCESS_CODE) {
        applocationBloc.backType = 1;
        showToast(resp.msg);
        Future.delayed(new Duration(milliseconds: 500)).then((_) {
          Navigator.of(bloccontext).pop();
          eventApplyRecBus.fire(ReloadApplyRec());
        });
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
    _applycapitalController.close();
  }
}
