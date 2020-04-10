import 'package:rxdart/rxdart.dart';
import 'package:youxinbao/ui/pages/page_index.dart';
import "../../../common/component_index.dart";

class PlanBloc implements BlocBase {
  BuildContext bloccontext;
  NetRepository netRepository = NetRepository();
  int currentPage1 = 0;
  int currentPage2 = 0;
  List planWholeList = List();
  List planHistoryList = List();
  bool selPanel = false;

  BehaviorSubject<dynamic> _planWholeController = BehaviorSubject<dynamic>();
  Stream<dynamic> get outWholePlan => _planWholeController.stream;
  StreamSink<dynamic> get _planWholeInfoSink => _planWholeController.sink;

  BehaviorSubject<dynamic> _planHistoryController = BehaviorSubject<dynamic>();
  Stream<dynamic> get outHistoryPlan => _planHistoryController.stream;
  StreamSink<dynamic> get _planHistoryInfoSink => _planHistoryController.sink;

  //整体计划列表
  Future getWholePlan(String condition, int loadType, bool isBack) async {
    if (loadType != 0) {
      if (loadType == 1) {
        currentPage1++;
      } else {
        currentPage1 = 0;
        planWholeList = [];
      }
    }
    PlanListReq _getPlanListByToken =
        PlanListReq(AppInstance.currentUser.token, currentPage1, condition);
    if (!isBack) {
      XsProgressHud.show(bloccontext);
    }
    return netRepository.getPlanList(_getPlanListByToken.toJson()).then((resp) {
      if (!isBack) {
        XsProgressHud.hide();
      }
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          List planList = PlanListModel.fromJson(resp.data).dataList;
          if (planList.where((item) => item.status == 2).toList().length > 0) {
            planWholeList
                .addAll(planList.where((item) => item.status == 2).toList());
          } else {
            currentPage1--;
          }
          _planWholeInfoSink.add(planWholeList);
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

  //历史计划列表
  Future getHistoryPlan(String condition, int loadType, bool isBack) async {
    if (loadType != 0) {
      if (loadType == 1) {
        currentPage2++;
      } else {
        currentPage2 = 0;
        planHistoryList = [];
      }
    }
    PlanListReq _getPlanListByToken =
        PlanListReq(AppInstance.currentUser.token, currentPage2, condition);
    if (!isBack) {
      XsProgressHud.show(bloccontext);
    }
    return netRepository.getPlanList(_getPlanListByToken.toJson()).then((resp) {
      if (!isBack) {
        XsProgressHud.hide();
      }
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          List planList = PlanListModel.fromJson(resp.data).dataList;
          if (planList
                  .where((item) => item.status == -1 || item.status == 4)
                  .toList()
                  .length >
              0) {
            planHistoryList.addAll(planList
                .where((item) => item.status == -1 || item.status == 4)
                .toList());
          } else {
            currentPage2--;
          }
          _planHistoryInfoSink.add(planHistoryList);
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

  //资金方还款
  Future operatesRepay(int planId, double realMoney) async {
    OperateRepayReq _getOperateByToken =
        OperateRepayReq(AppInstance.currentUser.token, planId, realMoney);
    XsProgressHud.show(bloccontext);
    return netRepository.operateRepay(_getOperateByToken.toJson()).then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        showToast(resp.msg);
        Future.delayed(new Duration(milliseconds: 100)).then((_) {
          Navigator.pop(bloccontext);
        });
      } else {
        showToast(resp.msg);
      }
    });
  }

  //标记问题订单
  Future operateOrderState(int planId, int state, String applyMsg) async {
    OperateOrderStateReq _getOperateStateByToken = OperateOrderStateReq(
        AppInstance.currentUser.token, planId, state, applyMsg);
    XsProgressHud.show(bloccontext);
    return netRepository
        .operateOrderState(_getOperateStateByToken.toJson())
        .then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        showToast(resp.msg);
        Future.delayed(new Duration(milliseconds: 100)).then((_) {
          Navigator.pop(bloccontext);
        });
      } else {
        showToast(resp.msg);
      }
    });
  }

  void showToast(String msg, {int duration, int gravity: 0}) {
    Toast.show(msg, bloccontext, duration: duration, gravity: gravity);
  }

  void dispose() {
    _planWholeController.close();
    _planHistoryController.close();
  }
}
