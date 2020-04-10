import "../../../common/component_index.dart";
import 'package:rxdart/rxdart.dart';

class CustomerDetailBloc implements BlocBase {
  BuildContext bloccontext;

  NetRepository netRepository = NetRepository();

  BehaviorSubject<CustomerDetailModel> _customerdetailController =
      BehaviorSubject<CustomerDetailModel>();
  Sink<CustomerDetailModel> get _customerSink => _customerdetailController.sink;
  Stream<CustomerDetailModel> get customerStream =>
      _customerdetailController.stream;

  CustomerDetailBloc();

  Future getCustomerDetail(int userId, bool isReload) async {
    CustomerDetailReq _customerReq =
        CustomerDetailReq(AppInstance.currentUser.token, userId);
    if (isReload) {
      XsProgressHud.show(bloccontext);
    }
    return netRepository.getCustomerDetail(_customerReq.toJson()).then((resp) {
      if (isReload) {
        XsProgressHud.hide();
      }
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          _customerSink.add(CustomerDetailModel.fromJson(resp.data));
        }
      } else {
        showToast(resp.msg);
      }
    });
  }

  BehaviorSubject<BillListModel> _billListController =
      BehaviorSubject<BillListModel>();
  Sink<BillListModel> get _billListSink => _billListController.sink;
  Stream<BillListModel> get billListStream => _billListController.stream;

  Future getCustomerBill(int cardId) async {
    CustomerDetailBillReq _customerReq =
        CustomerDetailBillReq(AppInstance.currentUser.token, cardId);
    XsProgressHud.show(bloccontext);
    return netRepository.getBillList(_customerReq.toJson()).then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          _billListSink.add(BillListModel.fromJson(resp.data));
        }
      } else {
        showToast(resp.msg);
      }
    });
  }

//移除卡片
  Future removeCard(num cardId, num userId) {
    RemoveCardReq _removeCardReq =
        RemoveCardReq(AppInstance.currentUser.token, cardId);
    XsProgressHud.show(bloccontext);

    return netRepository.removeCard(_removeCardReq.toJson()).then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        showToast(resp.msg);
        getCustomerDetail(userId,false);
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
    _customerdetailController.close();
    _billListController.close();
  }
}
