import "../../../common/component_index.dart";
import 'package:rxdart/rxdart.dart';


class NewOrdersBloc implements BlocBase {
  BuildContext bloccontext;

  NetRepository netRepository = NetRepository();

  BehaviorSubject<OrderListModel> _orderController =
      BehaviorSubject<OrderListModel>();
  Sink<OrderListModel> get _orderlistSink => _orderController.sink;
  Stream<OrderListModel> get orderlistStream => _orderController.stream;

  NewOrdersBloc();

  Future getOrderList(int page) async {
    OrderReq _orderReq =
        OrderReq(AppInstance.currentUser.token,page);
    XsProgressHud.show(bloccontext);
    return netRepository.getNewOrders(_orderReq.toJson()).then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if(resp.data != null)
        _orderlistSink.add(OrderListModel.fromJson(resp.data));
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
    _orderController.close();
  }
}
