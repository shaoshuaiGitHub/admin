import 'package:rxdart/rxdart.dart';

import "../../../common/component_index.dart";

class OrderDetailBloc implements BlocBase {
  BuildContext bloccontext;

  NetRepository netRepository = NetRepository();

  BehaviorSubject<OrderDetailModel> _orderdetailController =
      BehaviorSubject<OrderDetailModel>();
  Sink<OrderDetailModel> get _orderdetailSink => _orderdetailController.sink;
  Stream<OrderDetailModel> get orderdetailStream =>
      _orderdetailController.stream;

  OrderDetailBloc();

  Future getOrderDetail(int id) async {
    // print(id);
    OrderDetailReq _orderDetailReq =
        OrderDetailReq(AppInstance.currentUser.token, id);
    XsProgressHud.show(bloccontext);
    return netRepository.getOrderDetial(_orderDetailReq.toJson()).then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null)
          _orderdetailSink.add(OrderDetailModel.fromJson(resp.data));
      } else {
        showToast(resp.msg);
      }
    });
  }

  //订单操作
  BehaviorSubject<String> _orderpassController = BehaviorSubject<String>();
  StreamSink<String> get _orderpassSink => _orderpassController.sink;
  Stream<String> get orderpassStream => _orderpassController.stream;

  Future operationOrderAction(
      int orderInstId, int type, String cardIds, String applyMsg) async {
    OrderOperationReq _operationReq = OrderOperationReq(
        AppInstance.currentUser.token, orderInstId, type, applyMsg);
    XsProgressHud.show(bloccontext);
    return netRepository.passOperation(_operationReq.toJson()).then((resp) {
      XsProgressHud.hide();
      FocusScope.of(bloccontext).requestFocus(FocusNode());

      if (resp.code == Constant.SUCCESS_CODE) {
        showToast(resp.msg);
        if (type == 1) {
          //通过
          addPlanAction(cardIds);
        } else {
          Navigator.of(bloccontext).pop();
        }
        Future.delayed(new Duration(milliseconds: 500)).then((_) {
          Navigator.of(bloccontext).pop();
        });
      } else {
        showToast(resp.msg);
      }
    });
  }

//生成计划
  StreamController<int> _addPlanController = StreamController<int>();
  StreamSink<int> get _addPlanSink => _addPlanController.sink;
  Stream<int> get addPlanStream => _addPlanController.stream;

  Future addPlanAction(String cardInstId) async {
    AddPlanReq _operationReq =
        AddPlanReq(AppInstance.currentUser.token, cardInstId);
    XsProgressHud.show(bloccontext);
    return netRepository.genPlanList(_operationReq.toJson()).then((resp) {
      XsProgressHud.hide();
      FocusScope.of(bloccontext).requestFocus(FocusNode());

      if (resp.code == Constant.SUCCESS_CODE) {
        // _addPlanSink.add(resp.code);

      } else {
        showToast(resp.msg);
      }
    });
  }

//订单详情查看卡片信息
  BehaviorSubject<OrderCardListModel> _ordercardListController =
      BehaviorSubject<OrderCardListModel>();
  Sink<OrderCardListModel> get _ordercardListSink =>
      _ordercardListController.sink;
  Stream<OrderCardListModel> get ordercardListStream =>
      _ordercardListController.stream;

  Future getOrderCardList(String cardIds) async {
    OrderCardListReq _ordercardListReq =
        OrderCardListReq(AppInstance.currentUser.token, cardIds);
    XsProgressHud.show(bloccontext);
    return netRepository
        .getOrderCardsList(_ordercardListReq.toJson())
        .then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null)
          _ordercardListSink.add(OrderCardListModel.fromJson(resp.data));
      } else {
        showToast(resp.msg);
      }
    });
  }

//移除卡片
  Future removeCard(String cardId) {
    RemoveCardReq _removeCardReq =
        RemoveCardReq(AppInstance.currentUser.token, int.parse(cardId));
    XsProgressHud.show(bloccontext);

    return netRepository.removeCard(_removeCardReq.toJson()).then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        showToast(resp.msg);
        getOrderCardList(cardId);
      } else {
        // if (resp.code == 50008) {
        // Navigator.pushReplacement(bloccontext,
        //     MaterialPageRoute<void>(builder: (ctx) => LoginPage()));
        // }
        showToast(resp.msg);
      }
    });
  }

  void showToast(String msg, {int duration, int gravity: 0}) {
    Toast.show(msg, bloccontext, duration: duration, gravity: gravity);
  }

  @override
  void dispose() {
    _orderdetailController.close();
    _orderpassController.close();
    _ordercardListController.close();
  }
}
