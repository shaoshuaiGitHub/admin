import 'package:rxdart/rxdart.dart';

import "../../../common/component_index.dart";

class AllPlanItemDetailBloc implements BlocBase {
  BuildContext bloccontext;

  NetRepository netRepository = NetRepository();

  BehaviorSubject<AllplanItemDetailModel> _plandetailController =
      BehaviorSubject<AllplanItemDetailModel>();
  Sink<AllplanItemDetailModel> get _plandetailSink =>
      _plandetailController.sink;
  Stream<AllplanItemDetailModel> get plandetailStream =>
      _plandetailController.stream;

  AllPlanItemDetailBloc();

//获取计划详情
  Future getPlanItemDetail(int id) async {
    PlanDetailReq _planDetailReq =
        PlanDetailReq(AppInstance.currentUser.token, id);
    XsProgressHud.show(bloccontext);
    return netRepository.getPlanDetial(_planDetailReq.toJson()).then((resp) {
      XsProgressHud.hide();
      print(resp.data);
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null)
          _plandetailSink.add(AllplanItemDetailModel.fromJson(resp.data));
      } else {
        showToast(resp.msg);
      }
    });
  }

//消费计划
  BehaviorSubject<int> _consumplanController = BehaviorSubject<int>();
  StreamSink<int> get _consumplanSink => _consumplanController.sink;
  Stream<int> get consumplanStream => _consumplanController.stream;

  Future operationAction(
      String consumMoney, int posId, int planId) async {
    OperationReq _operationReq = OperationReq(
        AppInstance.currentUser.token, consumMoney, posId, planId);
    XsProgressHud.show(bloccontext);
    return netRepository.operation(_operationReq.toJson()).then((resp) {
      XsProgressHud.hide();
      FocusScope.of(bloccontext).requestFocus(FocusNode());

      if (resp.code == Constant.SUCCESS_CODE) {
        showToast(resp.msg);
        Future.delayed(new Duration(milliseconds: 500)).then((_) {
            Navigator.of(bloccontext).pop();
          });
      } else {
        showToast(resp.msg);
      }
    });
  }

  Future operationErrorAction(int planId, int isError, String applyMsg) async {
    OperationErrorReq _operationErrorReq =
        OperationErrorReq(AppInstance.currentUser.token, planId, isError, applyMsg);
    XsProgressHud.show(bloccontext);
    return netRepository
        .operationError(_operationErrorReq.toJson())
        .then((resp) {
      XsProgressHud.hide();
      FocusScope.of(bloccontext).requestFocus(FocusNode());

      if (resp.code == Constant.SUCCESS_CODE) {
        showToast(resp.msg);
        Future.delayed(new Duration(milliseconds: 500)).then((_) {
            Navigator.of(bloccontext).pop();
          });
      } else {
        showToast(resp.msg);
      }
    });
  }

//还款计划
  BehaviorSubject<int> _repaymentplanController = BehaviorSubject<int>();
  StreamSink<int> get _repaymentplanSink => _repaymentplanController.sink;
  Stream<int> get repaymentplanStream => _repaymentplanController.stream;

  Future operationReypayAction(int planId, int investorId) async {
    RepaymentOperationReq _operationReq = RepaymentOperationReq(
        AppInstance.currentUser.token, planId, investorId);
    XsProgressHud.show(bloccontext);
    return netRepository
        .repayMentoperation(_operationReq.toJson())
        .then((resp) {
      XsProgressHud.hide();
      FocusScope.of(bloccontext).requestFocus(FocusNode());

      if (resp.code == Constant.SUCCESS_CODE) {
        // _repaymentplanSink.add(resp.code);
        showToast(resp.msg);
        Future.delayed(new Duration(milliseconds: 500)).then((_) {
            Navigator.of(bloccontext).pop();
          });
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
    _plandetailController.close();
    _consumplanController.close();
  }
}
