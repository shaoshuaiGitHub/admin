import "../../../common/component_index.dart";
import 'package:rxdart/rxdart.dart';

class CapitalSideListBloc implements BlocBase {
  BuildContext bloccontext;

  NetRepository netRepository = NetRepository();

  BehaviorSubject<CapitalSideListModel> _capitalsideController =
      BehaviorSubject<CapitalSideListModel>();
  Sink<CapitalSideListModel> get _capitalsidelistSink =>
      _capitalsideController.sink;
  Stream<CapitalSideListModel> get capitalsidelistStream =>
      _capitalsideController.stream;

  CapitalSideListBloc();

  Future getCapitalList(int page) async {
    // print(id);
    OrderReq _orderReq = OrderReq(AppInstance.currentUser.token, page);
    XsProgressHud.show(bloccontext);
    return netRepository.getCapital(_orderReq.toJson()).then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null)
          _capitalsidelistSink.add(CapitalSideListModel.fromJson(resp.data));
      } else {
        showToast(resp.msg);
      }
    });
  }

//我的资金方详情
  BehaviorSubject<CapitalSideListDetailModel>
      _mycapitalSideListDetailController =
      BehaviorSubject<CapitalSideListDetailModel>();
  Sink<CapitalSideListDetailModel> get _mycapitalSideListDetailSink =>
      _mycapitalSideListDetailController.sink;
  Stream<CapitalSideListDetailModel> get mycapitalSideListDetailStream =>
      _mycapitalSideListDetailController.stream;

  Future getMyCapitalListDetail(int userId) async {
    print(userId);
    CapitalSideListDetailReq _mycapitalReq =
        CapitalSideListDetailReq(AppInstance.currentUser.token, userId);
    XsProgressHud.show(bloccontext);
    return netRepository
        .getCapitalSideListDetail(_mycapitalReq.toJson())
        .then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null)
          _mycapitalSideListDetailSink
              .add(CapitalSideListDetailModel.fromJson(resp.data));
      } else {
        showToast(resp.msg);
      }
    });
  }

  //解除关系
  StreamController<int> _unApplyInvestorlController = StreamController<int>();
  Sink<int> get _unApplyInvestorSink => _unApplyInvestorlController.sink;
  Stream<int> get unApplyInvestorStream => _unApplyInvestorlController.stream;

  Future unApplyInvestor(int userId) async {
    print(userId);
    CapitalSideListDetailReq _mycapitalReq =
        CapitalSideListDetailReq(AppInstance.currentUser.token, userId);
    XsProgressHud.show(bloccontext);
    return netRepository.unApplyInvestor(_mycapitalReq.toJson()).then((resp) {
      XsProgressHud.hide();
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

//资金方申请列表
  BehaviorSubject<CapitalSideApplyListModel> _capitalsideapplyController =
      BehaviorSubject<CapitalSideApplyListModel>();
  Sink<CapitalSideApplyListModel> get _capitalsideapplylistSink =>
      _capitalsideapplyController.sink;
  Stream<CapitalSideApplyListModel> get capitalsideapplylistStream =>
      _capitalsideapplyController.stream;

  Future getCapitalApplyList(int page) async {
    // print(id);
    OrderReq _orderReq = OrderReq(AppInstance.currentUser.token, page);
    XsProgressHud.show(bloccontext);
    return netRepository
        .getMyApplyInvestorList(_orderReq.toJson())
        .then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null)
          _capitalsideapplylistSink
              .add(CapitalSideApplyListModel.fromJson(resp.data));
      } else {
        showToast(resp.msg);
      }
    });
  }

//撤销申请
  StreamController<int> _removeApplyInvestorlController =
      StreamController<int>();
  Sink<int> get _removeApplyInvestorSink =>
      _removeApplyInvestorlController.sink;
  Stream<int> get removeApplyInvestorStream =>
      _removeApplyInvestorlController.stream;

  Future removeApplyInvestor(int id) async {
    final ApplicationBloc applocationBloc =
        BlocProvider.of<ApplicationBloc>(bloccontext);
    RemoveApplyInvestorReq _mycapitalReq =
        RemoveApplyInvestorReq(AppInstance.currentUser.token, id);
    XsProgressHud.show(bloccontext);
    return netRepository
        .removeApplyInvestor(_mycapitalReq.toJson())
        .then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        applocationBloc.backType = 1;

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
    _capitalsideController.close();
    _mycapitalSideListDetailController.close();
    _unApplyInvestorlController.close();
    _capitalsideapplyController.close();
    _removeApplyInvestorlController.close();
  }
}
