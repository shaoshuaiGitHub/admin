import "../../../common/component_index.dart";
import 'package:rxdart/rxdart.dart';


class MyCapitalSideListBloc implements BlocBase {
  BuildContext bloccontext;

  NetRepository netRepository = NetRepository();

  BehaviorSubject<MyCapitalSideListModel> _mycapitalsideController =
      BehaviorSubject<MyCapitalSideListModel>();
  Sink<MyCapitalSideListModel> get _mycapitalsidelistSink => _mycapitalsideController.sink;
  Stream<MyCapitalSideListModel> get mycapitalsidelistStream => _mycapitalsideController.stream;

  MyCapitalSideListBloc();

  Future getCapitalList(int page) async {
    MyCapitalSideReq _myCapitalSideReqReq =
        MyCapitalSideReq(AppInstance.currentUser.token,page);
    XsProgressHud.show(bloccontext);
    return netRepository.getMyCapitalSideReqReq(_myCapitalSideReqReq.toJson()).then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if(resp.data != null)
        _mycapitalsidelistSink.add(MyCapitalSideListModel.fromJson(resp.data));
      } else {
        showToast(resp.msg);
      }
    });
  }

  void showToast(String msg, {int duration, int gravity: 0}) {
    Toast.show(msg, bloccontext, duration: duration, gravity: gravity);
  }

  @override
  void dispose() {
    _mycapitalsideController.close();
  }
}
