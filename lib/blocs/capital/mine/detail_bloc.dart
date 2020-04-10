import "../../../common/component_index.dart";
import 'package:rxdart/rxdart.dart';

class DetailListBloc implements BlocBase {
  BuildContext bloccontext;

  NetRepository netRepository = NetRepository();

  bool selPanel = false;
  bool wardActive = true;
  bool posActive = true;
  String beginTime = '';
  String endTime = '';
  //开始时间
  BehaviorSubject<String> _beginDateController = BehaviorSubject<String>();
  Sink<String> get beginTimeDataSink => _beginDateController.sink;
  Stream<String> get beginTimeDataStream => _beginDateController.stream;

  //结束时间
  BehaviorSubject<String> _endDateController = BehaviorSubject<String>();
  Sink<String> get endTimeDataSink => _endDateController.sink;
  Stream<String> get endTimeDataStream => _endDateController.stream;

  //选中分润
  BehaviorSubject<bool> _activeWardController = BehaviorSubject<bool>();
  Sink<bool> get activeWardDataSink => _activeWardController.sink;
  Stream<bool> get activeWardDataStream => _activeWardController.stream;

  //选中pos费用
  BehaviorSubject<bool> _activePosController = BehaviorSubject<bool>();
  Sink<bool> get activePosDataSink => _activePosController.sink;
  Stream<bool> get activePosDataStream => _activePosController.stream;

  //明细列表
  BehaviorSubject<dynamic> _getDetailListController =
      BehaviorSubject<dynamic>();
  Sink<dynamic> get _detailListDataSink => _getDetailListController.sink;
  Stream<dynamic> get detailListDataStream => _getDetailListController.stream;

  //总分润
  BehaviorSubject<num> _totalWardMoneyController = BehaviorSubject<num>();
  Sink<num> get _totalWardMoneySink => _totalWardMoneyController.sink;
  Stream<num> get totalWardMoneyStream => _totalWardMoneyController.stream;

  //分润
  BehaviorSubject<num> _wardMoneyController = BehaviorSubject<num>();
  Sink<num> get _wardMoneySink => _wardMoneyController.sink;
  Stream<num> get wardMoneyStream => _wardMoneyController.stream;

  //pos机返还费用
  BehaviorSubject<num> _totalPosMoneyController = BehaviorSubject<num>();
  Sink<num> get _totalPosMoneySink => _totalPosMoneyController.sink;
  Stream<num> get totalPosMoneyStream => _totalPosMoneyController.stream;

  int currentPage = 0;
  List detailList = List();
  num totalWardMoney = 0.0;
  num wardMoney = 0.0;
  num totalPosMoney = 0.0;
  Future getDetailLists(String condition, int loadType, bool isLoad) async {
    if (loadType != 0) {
      if (loadType == 1) {
        currentPage++;
      } else {
        currentPage = 0;
        detailList = List();
        totalWardMoney = 0.0;
        wardMoney = 0.0;
        totalPosMoney = 0.0;
      }
    }
    PlanListReq _getDetailListReq =
        PlanListReq(AppInstance.currentUser.token, currentPage, condition);
    if (isLoad) {
      XsProgressHud.show(bloccontext);
    }
    return netRepository.getDetailList(_getDetailListReq.toJson()).then((resp) {
      if (isLoad) {
        XsProgressHud.hide();
      }
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          List detailDataList = DetailListModel.fromJson(resp.data).dataList;
          num totalWardDataMoney =
              DetailListModel.fromJson(resp.data).totalWardMoney;
          num wardDataMoney = DetailListModel.fromJson(resp.data).wardMoney;
          num totalDataPosMoney =
              DetailListModel.fromJson(resp.data).totalPosMoney;
          if (loadType == 1) {
            if (totalWardDataMoney != null) {
              totalWardMoney += totalWardDataMoney.toDouble();
            }
            if (wardDataMoney != null) {
              wardMoney += wardDataMoney.toDouble();
            }
            if (totalDataPosMoney != null) {
              totalPosMoney += totalDataPosMoney.toDouble();
            }
          } else {
            if (totalWardDataMoney != null) {
              totalWardMoney = totalWardDataMoney.toDouble();
            }
            if (wardDataMoney != null) {
              wardMoney = wardDataMoney.toDouble();
            }
            if (totalDataPosMoney != null) {
              totalPosMoney = totalDataPosMoney.toDouble();
            }
          }
          if (detailDataList.length > 0) {
            detailList.addAll(detailDataList);
          } else {
            if (loadType == 1) {
              showToast('没有更多数据~');
            }
            currentPage--;
          }
          _detailListDataSink.add(detailList);
          _totalWardMoneySink.add(totalWardMoney);
          _wardMoneySink.add(wardMoney);
          _totalPosMoneySink.add(totalPosMoney);
        }
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
    _getDetailListController.close();
    _totalWardMoneyController.close();
    _wardMoneyController.close();
    _totalPosMoneyController.close();
    _activeWardController.close();
    _activePosController.close();
    _beginDateController.close();
    _endDateController.close();
  }
}
