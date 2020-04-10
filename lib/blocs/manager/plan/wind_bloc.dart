import 'package:rxdart/rxdart.dart';

import "../../../common/component_index.dart";

class WindBloc implements BlocBase {
  BuildContext bloccontext;

  NetRepository netRepository = NetRepository();

  BehaviorSubject<RiskControlModel> _riskController =
      BehaviorSubject<RiskControlModel>();
  Sink<RiskControlModel> get _riskSink => _riskController.sink;
  Stream<RiskControlModel> get riskStream => _riskController.stream;

  Future getRiskControls(int userId) async {
    RiskReq _riskReq = RiskReq(AppInstance.currentUser.token, userId);
    XsProgressHud.show(bloccontext);
    return netRepository.getRiskControl(_riskReq.toJson()).then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null)
          _riskSink.add(RiskControlModel.fromJson(resp.data));
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
    _riskController.close();
  }
}
