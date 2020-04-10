import 'package:rxdart/rxdart.dart';
import 'package:youxinbao/ui/pages/page_index.dart';
import "../../../common/component_index.dart";

class AccountBloc implements BlocBase {
  BuildContext bloccontext;
  NetRepository netRepository = NetRepository();
  int currentPage = 0;
  List accountList = List();
  List<List<bool>> accountToggle = List<List<bool>>();
  BehaviorSubject<dynamic> _accountController = BehaviorSubject<dynamic>();
  Stream<dynamic> get outAccount => _accountController.stream;
  StreamSink<dynamic> get _accountInfoSink => _accountController.sink;

  BehaviorSubject<num> _repayMoneyController = BehaviorSubject<num>();
  Stream<num> get outRepayMoney => _repayMoneyController.stream;
  StreamSink<num> get _repayMoneyInfoSink => _repayMoneyController.sink;

  //对账中心列表
  Future getBanlanceLists(int loadType, bool isBack) async {
    if (loadType != 0) {
      if (loadType == 1) {
        currentPage++;
      } else {
        currentPage = 0;
        accountList = [];
      }
    }
    BanlanceListReq _getBanlanceListByToken =
        BanlanceListReq(AppInstance.currentUser.token, currentPage);
    if (!isBack) {
      XsProgressHud.show(bloccontext);
    }
    return netRepository
        .getBanlanceList(_getBanlanceListByToken.toJson())
        .then((resp) {
      if (!isBack) {
        XsProgressHud.hide();
      }
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          List banlanceList = BanlanceListModel.fromJson(resp.data).dataList;
          num repayMoney = BanlanceListModel.fromJson(resp.data).noRepayMoney;
          if (banlanceList.length > 0) {
            accountList.addAll(banlanceList);
          } else {
            currentPage--;
            if (loadType == 1) {
              showToast('没有更多数据~');
            }
          }
          _accountInfoSink.add(accountList);
          _repayMoneyInfoSink.add(repayMoney);
        }
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

  //对账中心详情
  BehaviorSubject<dynamic> _accountDetailController =
      BehaviorSubject<dynamic>();
  Stream<dynamic> get outAccountDetail => _accountDetailController.stream;
  StreamSink<dynamic> get _accountDetailInfoSink =>
      _accountDetailController.sink;

  Future getBanlanceDetails(
      int delegateType, int masterId, int cardNo, String date) async {
    BanlanceDetailReq _getBanlanceDetailByToken = BanlanceDetailReq(
        AppInstance.currentUser.token, delegateType, masterId, cardNo, date);
    XsProgressHud.show(bloccontext);
    return netRepository
        .getBanlanceDetail(_getBanlanceDetailByToken.toJson())
        .then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          List banlanceDetail =
              BanlanceDetailModel.fromJson(resp.data).dataList;
          _accountDetailInfoSink.add(banlanceDetail);
        }
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

  void dispose() {
    _accountController.close();
    _repayMoneyController.close();
    _accountDetailController.close();
  }
}
