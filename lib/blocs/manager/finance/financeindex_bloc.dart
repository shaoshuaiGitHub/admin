import 'package:youxinbao/ui/pages/page_index.dart';

import "../../../common/component_index.dart";
import 'package:rxdart/rxdart.dart';

class FinanceIndexBloc implements BlocBase {
  BuildContext bloccontext;

  NetRepository netRepository = NetRepository();

  BehaviorSubject<dynamic> _accountController = BehaviorSubject<dynamic>();
  Sink<dynamic> get _accountlistSink => _accountController.sink;
  Stream<dynamic> get accountlistStream => _accountController.stream;

  BehaviorSubject<int> _tabIndexController = BehaviorSubject<int>();
  Sink<int> get tabSink => _tabIndexController.sink;
  Stream<int> get tabStream => _tabIndexController.stream;

  FinanceIndexBloc();

  int currentPage1 = 0;
  Map accountList;
  List addAccountList = List();
  Future getAccountCenterList(int loadType, bool isBack) async {
    if (loadType != 0) {
      if (loadType == 1) {
        currentPage1++;
      } else {
        currentPage1 = 0;
        addAccountList = [];
        accountList = {};
      }
    } else {
      currentPage1 = 0;
      addAccountList = [];
      accountList = {};
    }
    AccountCenterListReq _accountcenterlistReq =
        AccountCenterListReq(AppInstance.currentUser.token, currentPage1);
    if (!isBack) {
      XsProgressHud.show(bloccontext);
    }
    return netRepository
        .getAccountList(_accountcenterlistReq.toJson())
        .then((resp) {
      if (!isBack) {
        XsProgressHud.hide();
      }
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          List accountCheckList =
              AccountCenterListModel.fromJson(resp.data).accountCheckList;
          num notReturned =
              AccountCenterListModel.fromJson(resp.data).notReturned;
          if (accountCheckList.length > 0) {
            addAccountList.addAll(accountCheckList);
            accountList = {
              "accountCheckList": addAccountList,
              "notReturned": notReturned,
            };
            // accountList={"accountCheckList":addAccountList.addAll(accountCheckList),"notReturned":notReturned};
          } else {
            if (notReturned.toString().length != 0) {
              accountList = {
                "accountCheckList": addAccountList,
                "notReturned": notReturned,
              };
            }
            currentPage1--;
          }

          _accountlistSink.add(accountList);
        }
        // _accountlistSink.add(AccountCenterListModel.fromJson(resp.data));
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

//财务管理
  BehaviorSubject<dynamic> _financialListController =
      BehaviorSubject<dynamic>();
  Sink<dynamic> get _financiallistSink => _financialListController.sink;
  Stream<dynamic> get financiallistStream => _financialListController.stream;

  int currentPage2 = 0;
  Map financialList;
  List addFinancialList = List();
  List addfilterFinancialList = List();
  List myfinancialList = List();

  Future getFinancialList(int loadType, String condition, bool isBack) async {
    print(loadType);
    if (loadType != 0) {
      if (loadType == 1) {
        currentPage2++;
      } else {
        currentPage2 = 0;
        addFinancialList = [];
        addfilterFinancialList = [];
      }
    }

    FinancialListReq _accountcenterlistReq = FinancialListReq(
        AppInstance.currentUser.token, currentPage2, condition);
    if (!isBack) {
      XsProgressHud.show(bloccontext);
    }
    return netRepository
        .getFinancialList(_accountcenterlistReq.toJson())
        .then((resp) {
      if (!isBack) {
        XsProgressHud.hide();
      }

      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          // if (condition.isEmpty) {
          List financialCheckList =
              FinancialListModel.fromJson(resp.data).financialList;
          List dataTop = FinancialListModel.fromJson(resp.data).dataTop;
          if (financialCheckList.length > 0 || !condition.isEmpty) {
            if (condition.isEmpty) {
              addFinancialList.addAll(financialCheckList);
            } else {
              addfilterFinancialList.addAll(financialCheckList);
              financialList = {};
            }
            myfinancialList =
                condition.isEmpty ? addFinancialList : addfilterFinancialList;
            financialList = {
              "financialList": myfinancialList,
              "dataTop": dataTop,
            };
          } else {
            currentPage2--;
          }
          _financiallistSink.add(financialList);
          // }

          // Future.delayed(new Duration(milliseconds: 500)).then((_) {
          //   Navigator.of(bloccontext).pop();
          // });
        }
        // _financiallistSink.add(FinancialListModel.fromJson(resp.data));
      } else {
        showToast(resp.msg);
      }
    });
  }

  //对账操作
  StreamController<int> _checkAccountController = StreamController<int>();
  StreamSink<int> get _checkSink => _checkAccountController.sink;
  Stream<int> get checkStream => _checkAccountController.stream;

  Future checkAction(String condition) async {
    CheckActionReq _operationReq =
        CheckActionReq(AppInstance.currentUser.token, condition);
    XsProgressHud.show(bloccontext);
    return netRepository.checkAction(_operationReq.toJson()).then((resp) {
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

//每月的账单
  BehaviorSubject<FinancialMonthListModel> _financialMonthListController =
      BehaviorSubject<FinancialMonthListModel>();
  Sink<FinancialMonthListModel> get _financialMonthlistSink =>
      _financialMonthListController.sink;
  Stream<FinancialMonthListModel> get financialMonthlistStream =>
      _financialMonthListController.stream;

  Future getFinancialMonthList(int page, String condition) async {
    FinancialMonthListReq _monthlistReq =
        FinancialMonthListReq(AppInstance.currentUser.token, page, condition);
    XsProgressHud.show(bloccontext);
    return netRepository
        .getFinancialMonthList(_monthlistReq.toJson())
        .then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null)
          _financialMonthlistSink
              .add(FinancialMonthListModel.fromJson(resp.data));
      } else {
        showToast(resp.msg);
      }
    });
  }

//每日账单
  BehaviorSubject<dynamic> _financialDayListController =
      BehaviorSubject<dynamic>();
  Sink<dynamic> get _financialDaylistSink => _financialDayListController.sink;
  Stream<dynamic> get financialDaylistStream =>
      _financialDayListController.stream;

  int daycurrentPage = 0;
  List addDayFinancialList = List();
  List addfilterDayFinancialList = List();
  Map addList;

  Future getFinancialDayList(int loadType, String condition) async {
    if (loadType != 0) {
      if (loadType == 1) {
        daycurrentPage++;
      } else {
        daycurrentPage = 0;
        addList = {};
      }
    }

    FinancialDayListReq _monthlistReq = FinancialDayListReq(
        AppInstance.currentUser.token, daycurrentPage, condition);
    XsProgressHud.show(bloccontext);
    return netRepository
        .getFinancialDayList(_monthlistReq.toJson())
        .then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          List dayfinancialCheckList =
              FinancialDayListModel.fromJson(resp.data).dataList;
          String dataTime = FinancialDayListModel.fromJson(resp.data).dataTime;
          var account = FinancialDayListModel.fromJson(resp.data).account;
          if (dayfinancialCheckList.length > 0) {
            if (condition.isEmpty) {
              addDayFinancialList.addAll(dayfinancialCheckList);
            } else {
              addfilterDayFinancialList.addAll(dayfinancialCheckList);
            }
            addList = {
              "dataList": condition.isEmpty
                  ? addDayFinancialList
                  : addfilterDayFinancialList,
              "account": account,
              "dataTime": dataTime,
            };
          } else {
            daycurrentPage--;
          }
          _financialDaylistSink.add(addList);
        }
        // _financialDaylistSink.add(FinancialDayListModel.fromJson(resp.data));
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
    _accountController.close();
    _financialListController.close();
    _checkAccountController.close();
    _financialMonthListController.close();
    _financialDayListController.close();
    _tabIndexController.close();
  }
}
