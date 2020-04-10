import "../../../common/component_index.dart";
import 'package:rxdart/rxdart.dart';


class CapitalListBloc implements BlocBase {
  BuildContext bloccontext;

  NetRepository netRepository = NetRepository();

  BehaviorSubject<CapitalListModel> _capitalController =
      BehaviorSubject<CapitalListModel>();
  Sink<CapitalListModel> get _orderdetailSink => _capitalController.sink;
  Stream<CapitalListModel> get orderdetailStream => _capitalController.stream;

  CapitalListBloc();

  Future getCapitalList(int id) async {
    // print(id);
    CapitalReq _capitalReq =
        CapitalReq(AppInstance.currentUser.token,id);
    XsProgressHud.show(bloccontext);
    return netRepository.getNewOrders(_capitalReq.toJson()).then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if(resp.data != null)
        _capitalController.add(CapitalListModel.fromJson(resp.data));
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
    _capitalController.close();
  }
}
