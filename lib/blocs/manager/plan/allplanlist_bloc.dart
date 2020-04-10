import 'package:youxinbao/ui/pages/page_index.dart';

import "../../../common/component_index.dart";
import 'package:rxdart/rxdart.dart';

class AllPlanListBloc implements BlocBase {
  BuildContext bloccontext;

  NetRepository netRepository = NetRepository();

  int tabIndex = 0;
  bool isWholeOpen = true;
  bool isHistoryOpen = true;
  BehaviorSubject<dynamic> _allplanlistController = BehaviorSubject<dynamic>();
  Sink<dynamic> get _allplanlistSink => _allplanlistController.sink;
  Stream<dynamic> get allplanlistStream => _allplanlistController.stream;

  BehaviorSubject<int> _tabIndexController = BehaviorSubject<int>();
  Sink<int> get tabIndexSink => _tabIndexController.sink;
  Stream<int> get tabIndexStream => _tabIndexController.stream;

  int currentPage1 = 0;
  int currentPage2 = 0;
  List allPlanList = List();
  List historyPlanList = List();

  num planWholeHeight = 0.0;
  int planWholeIndex = 0;
  BehaviorSubject<num> _planWholeHeightController = BehaviorSubject<num>();
  Sink<num> get _planWholeHeightSink => _planWholeHeightController.sink;
  Stream<num> get planWholeHeightStream => _planWholeHeightController.stream;

  num planHistoryHeight = 0.0;
  int planHistoryIndex = 0;
  BehaviorSubject<num> _planHistoryHeightController = BehaviorSubject<num>();
  Sink<num> get _planHistoryHeightSink => _planHistoryHeightController.sink;
  Stream<num> get planHistoryHeightStream =>
      _planHistoryHeightController.stream;

  Future getAllplanList(
      String condition, int loadType, bool isBack, bool isExpanded) async {
    if (loadType != 0) {
      if (loadType == 1) {
        currentPage1++;
      } else {
        currentPage1 = 0;
        allPlanList = [];
      }
    }
    planWholeHeight = 0.0;
    AllPlanListReq _orderReq =
        AllPlanListReq(AppInstance.currentUser.token, currentPage1, condition);
    if (!isBack) {
      XsProgressHud.show(bloccontext);
    }

    return netRepository.getAllPlanList(_orderReq.toJson()).then((resp) {
      if (!isBack) {
        XsProgressHud.hide();
      }

      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          List planDataList = AllPlanListModel.fromJson(resp.data).allplanList;
          if (planDataList.length > 0) {
            allPlanList.addAll(planDataList);
          } else {
            currentPage1--;
            if (loadType == 1) {
              showToast('没有更多数据~');
            }
          }
          planWholeHeight = allPlanList.length * 45 + 200;
          if (allPlanList.length > 0) {
            if (!isExpanded) {
              planWholeHeight += 200;
            }
          }
          _planWholeHeightSink.add(planWholeHeight.toDouble());
          _allplanlistSink.add(allPlanList);
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

  void caculateWholePlanHeight(newIndex) {
    if (newIndex == planWholeIndex) {
      planWholeHeight = planWholeHeight - 200;
      planWholeIndex = -1;
    } else {
      if (planWholeIndex == -1) {
        planWholeHeight = planWholeHeight + 200;
      }
      planWholeIndex = newIndex;
    }
    _planWholeHeightSink.add(planWholeHeight.toDouble());
  }

  void caculateHistoryPlanHeight(newIndex) {
    if (newIndex == planHistoryIndex) {
      planHistoryHeight = planHistoryHeight - 200;
      planHistoryIndex = -1;
    } else {
      if (planHistoryIndex == -1) {
        planHistoryHeight = planHistoryHeight + 200;
      }
      planHistoryIndex = newIndex;
    }
    _planHistoryHeightSink.add(planHistoryHeight.toDouble());
  }

  BehaviorSubject<dynamic> _historyplanlistController =
      BehaviorSubject<dynamic>();
  Sink<dynamic> get _historyplanlistSink => _historyplanlistController.sink;
  Stream<dynamic> get historyplanlistStream =>
      _historyplanlistController.stream;

  Future getHistoryplanList(
      String condition, int loadType, bool isBack, bool isExpanded) async {
    if (loadType != 0) {
      if (loadType == 1) {
        currentPage2++;
      } else {
        currentPage2 = 0;
        historyPlanList = [];
      }
    }
    planHistoryHeight = 0.0;
    AllPlanListReq _orderReq =
        AllPlanListReq(AppInstance.currentUser.token, currentPage2, condition);
    if (!isBack) {
      XsProgressHud.show(bloccontext);
    }

    return netRepository.getAllPlanList(_orderReq.toJson()).then((resp) {
      if (!isBack) {
        XsProgressHud.hide();
      }

      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          List planDataList = AllPlanListModel.fromJson(resp.data).allplanList;
          if (planDataList.length > 0) {
            historyPlanList.addAll(planDataList);
          } else {
            currentPage2--;
            if (loadType == 1) {
              showToast('没有更多数据~');
            }
          }
          planHistoryHeight = allPlanList.length * 45 + 200;
          if (allPlanList.length > 0) {
            if (!isExpanded) {
              planHistoryHeight += 200;
            }
          }
          _planHistoryHeightSink.add(planHistoryHeight.toDouble());
          _historyplanlistSink.add(historyPlanList);
        }
      } else {
        if (resp.code == 50008) {
          Navigator.pushReplacement(bloccontext,
              MaterialPageRoute<void>(builder: (ctx) => LoginPage()));
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
    _allplanlistController.close();
    _historyplanlistController.close();
    _tabIndexController.close();
    _planWholeHeightController.close();
    _planHistoryHeightController.close();
  }
}
