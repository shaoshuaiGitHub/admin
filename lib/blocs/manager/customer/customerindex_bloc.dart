import 'package:youxinbao/ui/pages/login/login_page.dart';

import "../../../common/component_index.dart";
import 'package:rxdart/rxdart.dart';

class CustomerIndexBloc implements BlocBase {
  BuildContext bloccontext;

  NetRepository netRepository = NetRepository();

  BehaviorSubject<CustomerListModel> _customerController =
      BehaviorSubject<CustomerListModel>();
  Sink<CustomerListModel> get _customerSink => _customerController.sink;
  Stream<CustomerListModel> get customerStream => _customerController.stream;

  CustomerIndexBloc();

  Future getCustomerList(String condition) async {
    CustomerReq _customerReq =
        CustomerReq(AppInstance.currentUser.token, condition);
    XsProgressHud.show(bloccontext);
    return netRepository.getCustomer(_customerReq.toJson()).then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null)
          _customerSink.add(CustomerListModel.fromJson(resp.data));
      } else {
        if (resp.code == 50008) {
          AppInstance.remove("user");
          Navigator.pushAndRemoveUntil(
            bloccontext,
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false,
          );
          AppInstance.putString(Constant.KEY_THEME_COLOR, 'usercolor');
          final ApplicationBloc bloc =
              BlocProvider.of<ApplicationBloc>(bloccontext);
          bloc.sendAppEvent(1);
        }
        showToast(resp.msg);
      }
    });
  }

  void showToast(String msg, {int duration, int gravity: 0}) {
    Toast.show(msg, bloccontext, duration: duration, gravity: gravity);
  }

  @override
  void dispose() {
    _customerController.close();
  }
}
