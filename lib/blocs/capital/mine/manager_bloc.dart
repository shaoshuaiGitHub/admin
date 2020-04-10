import 'package:rxdart/rxdart.dart';

import "../../../common/component_index.dart";

class ManagerBloc implements BlocBase {
  BuildContext bloccontext;
  NetRepository netRepository = NetRepository();

  //我的管理师列表
  int masterCurrentPage = 0;
  List myMasterList = List();
  BehaviorSubject<dynamic> _managerController = BehaviorSubject<dynamic>();
  Stream<dynamic> get outManager => _managerController.stream;
  StreamSink<dynamic> get _managerInfoSink => _managerController.sink;

  //我的管理师列表
  Future getManagerList(int loadType, bool isBack) async {
    if (loadType != 0) {
      if (loadType == 1) {
        masterCurrentPage++;
      } else {
        masterCurrentPage = 0;
        myMasterList = [];
      }
    }
    MyMasterListReq _getManngerListByToken =
        MyMasterListReq(AppInstance.currentUser.token, masterCurrentPage);
    if (!isBack) {
      XsProgressHud.show(bloccontext);
    }

    return netRepository
        .getMyMasterList(_getManngerListByToken.toJson())
        .then((resp) {
      if (!isBack) {
        XsProgressHud.hide();
      }

      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          if (ManagerListModel.fromJson(resp.data).managerList.length > 0) {
            myMasterList
                .addAll(ManagerListModel.fromJson(resp.data).managerList);
          } else {
            masterCurrentPage--;
          }
          _managerInfoSink.add(myMasterList);
        }
      } else {
        showToast(resp.msg);
      }
    });
  }

  //获取申请数
  BehaviorSubject<int> _applyCountController = BehaviorSubject<int>();
  Stream<int> get outApplyCount => _applyCountController.stream;
  StreamSink<int> get _applyCountInfoSink => _applyCountController.sink;
  Future getApplyCount(int page) async {
    MyMasterListReq _getMasterApplyListByToken =
        MyMasterListReq(AppInstance.currentUser.token, page);
    return netRepository
        .getMasterApplyList(_getMasterApplyListByToken.toJson())
        .then((resp) {
      if (resp.code == Constant.SUCCESS_CODE) {
        _applyCountInfoSink.add(MasterApplyListModel.fromJson(resp.data)
            .masterApplyList
            .where((model) => model.applyStatus == 0 || model.applyStatus == -1)
            .toList()
            .length);
      } else {
        showToast(resp.msg);
      }
    });
  }

  //取新申请条数

  //管理师申请列表
  //解除申请数量

  BehaviorSubject<int> _removeCountController = BehaviorSubject<int>();
  Stream<int> get outIntApplyCount => _removeCountController.stream;
  StreamSink<int> get _outIntApplyCountSink => _removeCountController.sink;

  int currentPage1 = 0;
  int currentPage2 = 0;
  List escrowList = List();
  List removeList = List();
  BehaviorSubject<dynamic> _escrowController = BehaviorSubject<dynamic>();
  Stream<dynamic> get outEscrow => _escrowController.stream;
  StreamSink<dynamic> get _escrowInfoSink => _escrowController.sink;

  BehaviorSubject<dynamic> _removeController = BehaviorSubject<dynamic>();
  Stream<dynamic> get outRemove => _removeController.stream;
  StreamSink<dynamic> get _removeInfoSink => _removeController.sink;

  //获取申请解除待同意数量
  Future getWaitApplyList() async {
    MyMasterListReq _getMasterApplyListByToken =
        MyMasterListReq(AppInstance.currentUser.token, 0);
    XsProgressHud.show(bloccontext);
    return netRepository
        .getMasterApplyList(_getMasterApplyListByToken.toJson())
        .then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          List applyData =
              MasterApplyListModel.fromJson(resp.data).masterApplyList;
          _outIntApplyCountSink.add(applyData
              .where((model) => model.applyStatus == -1)
              .toList()
              .length);
        }
      } else {
        showToast(resp.msg);
      }
    });
  }

  //获取绑定申请
  Future getMasterApplyList(int loadType, bool isBack) async {
    if (loadType != 0) {
      if (loadType == 1) {
        currentPage1++;
      } else {
        currentPage1 = 0;
        escrowList = [];
      }
    }
    MyMasterListReq _getMasterApplyListByToken =
        MyMasterListReq(AppInstance.currentUser.token, currentPage1);
    if (!isBack) {
      XsProgressHud.show(bloccontext);
    }
    return netRepository
        .getMasterApplyList(_getMasterApplyListByToken.toJson())
        .then(
      (resp) {
        if (!isBack) {
          XsProgressHud.hide();
        }
        if (resp.code == Constant.SUCCESS_CODE) {
          if (resp.data != null) {
            List applyData =
                MasterApplyListModel.fromJson(resp.data).masterApplyList;
            if (applyData
                    .where((model) =>
                        model.applyStatus == 0 ||
                        model.applyStatus == 1 ||
                        model.applyStatus == 2)
                    .toList()
                    .length >
                0) {
              escrowList.addAll(applyData
                  .where((model) =>
                      model.applyStatus == 0 ||
                      model.applyStatus == 1 ||
                      model.applyStatus == 2)
                  .toList());
            } else {
              currentPage1--;
            }
            _escrowInfoSink.add(escrowList);
          }
        } else {
          showToast(resp.msg);
        }
      },
    );
  }

  //获取解除申请
  Future getRemoveApplyList(int loadType, bool isBack) async {
    if (loadType != 0) {
      if (loadType == 1) {
        currentPage2++;
      } else {
        currentPage2 = 0;
        removeList = [];
      }
    }
    MyMasterListReq _getMasterApplyListByToken =
        MyMasterListReq(AppInstance.currentUser.token, currentPage2);
    if (!isBack) {
      XsProgressHud.show(bloccontext);
    }

    return netRepository
        .getMasterApplyList(_getMasterApplyListByToken.toJson())
        .then((resp) {
      if (!isBack) {
        XsProgressHud.hide();
      }

      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          List applyData =
              MasterApplyListModel.fromJson(resp.data).masterApplyList;
          if (applyData
                  .where((model) =>
                      model.applyStatus == -1 ||
                      model.applyStatus == -2 ||
                      model.applyStatus == -3)
                  .toList()
                  .length >
              0) {
            removeList.addAll(applyData
                .where((model) =>
                    model.applyStatus == -1 ||
                    model.applyStatus == -2 ||
                    model.applyStatus == -3)
                .toList());
          } else {
            currentPage2--;
          }
          _removeInfoSink.add(removeList);
        }
      } else {
        showToast(resp.msg);
      }
    });
  }

  //管理师申请详情
  StreamController<MasterApplyDetailModel> _masterDetailController =
      StreamController<MasterApplyDetailModel>();
  Stream<MasterApplyDetailModel> get outMasterDetail =>
      _masterDetailController.stream;
  StreamSink<MasterApplyDetailModel> get _masterDetailInfoSink =>
      _masterDetailController.sink;

  Future getMasterDetail(int applyId) async {
    MasterDetailReq _getMasterDetailByToken =
        MasterDetailReq(AppInstance.currentUser.token, applyId);
    XsProgressHud.show(bloccontext);
    return netRepository
        .getMasterApplyDetail(_getMasterDetailByToken.toJson())
        .then(
      (resp) {
        XsProgressHud.hide();
        if (resp.code == Constant.SUCCESS_CODE) {
          if (resp.data != null) {
            _masterDetailInfoSink
                .add(MasterApplyDetailModel.fromJson(resp.data));
          }
        } else {
          showToast(resp.msg);
        }
      },
    );
  }

  //申请操作
  int id = 0;
  Future operationMasterApply(
      int applyId, String applyMsg, int applyState) async {
    OperationApplyReq _operationByToken = OperationApplyReq(
        AppInstance.currentUser.token, applyId, applyMsg, applyState);
    var editInputMoneyCtrl = TextEditingController();
    return netRepository.operateMasterApply(_operationByToken.toJson()).then(
      (resp) {
        if (resp.code == Constant.SUCCESS_CODE) {
          //拒绝时调用
          showToast(resp.msg);
          // if (applyState == 2 || applyState == -1) {
          //   showToast(resp.msg);
          // } 
          // else {
          //   if (resp.data != null) {
          //     id = MasterPassIdModel.fromJson(resp.data).id;
          //     showDialog(
          //       context: bloccontext,
          //       builder: (_) => Dialog(
          //         elevation: 0,
          //         backgroundColor: Colors.white,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(5),
          //         ),
          //         child: Container(
          //           child: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             children: <Widget>[
          //               Container(
          //                 height: 45,
          //                 decoration: BoxDecoration(
          //                   color: Color(0xFFFF9B1A),
          //                 ),
          //                 child: Center(
          //                   child: Text(
          //                     '授信额度',
          //                     style: TextStyle(
          //                       fontSize: 16,
          //                       color: Colors.white,
          //                       fontWeight: FontWeights.medium,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(
          //                 height: 20,
          //               ),
          //               Container(
          //                 height: 50,
          //                 child: Row(
          //                   children: <Widget>[
          //                     SizedBox(
          //                       width: 10,
          //                     ),
          //                     Expanded(
          //                       child: Container(
          //                         height: 50,
          //                         decoration: BoxDecoration(
          //                           color: Color(0xFFE6E6E6),
          //                           borderRadius: BorderRadius.circular(5),
          //                         ),
          //                         child: TextField(
          //                           controller: editInputMoneyCtrl,
          //                           style: TextStyle(
          //                             fontSize: 15,
          //                             fontWeight: FontWeights.medium,
          //                           ),
          //                           keyboardType: TextInputType.number,
          //                           inputFormatters: [
          //                             WhitelistingTextInputFormatter(
          //                                 RegExp(r"^\d+(?:\.\d{0,2})?"))
          //                           ], //保留两位有效数字
          //                           decoration: InputDecoration(
          //                             contentPadding: EdgeInsets.only(
          //                               left: 11,
          //                               top: 14,
          //                               right: 11,
          //                             ),
          //                             hintText: '请输入授信的额度',
          //                             hintStyle: TextStyle(
          //                               fontSize: 15,
          //                               color: Color(0xFF999999),
          //                               fontWeight: FontWeights.medium,
          //                             ),
          //                             disabledBorder: InputBorder.none,
          //                             enabledBorder: InputBorder.none,
          //                             focusedBorder: InputBorder.none,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                     SizedBox(
          //                       width: 9,
          //                     ),
          //                     Container(
          //                       height: 50,
          //                       child: Center(
          //                         child: Text(
          //                           '元',
          //                           style: TextStyle(
          //                             fontSize: 16,
          //                             color: Color(0xFF212121),
          //                             fontWeight: FontWeights.medium,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                     SizedBox(
          //                       width: 26,
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               Container(
          //                 width: 116,
          //                 height: 44,
          //                 margin: const EdgeInsets.only(
          //                   top: 20,
          //                   bottom: 20,
          //                 ),
          //                 decoration: BoxDecoration(
          //                   color: Color(0xFFFF9B1A),
          //                   borderRadius: BorderRadius.circular(5),
          //                 ),
          //                 child: MaterialButton(
          //                   padding: const EdgeInsets.all(0),
          //                   minWidth: 0,
          //                   child: Center(
          //                     child: Text(
          //                       '确认',
          //                       style: TextStyle(
          //                         fontSize: 16,
          //                         color: Colors.white,
          //                         fontWeight: FontWeights.medium,
          //                       ),
          //                     ),
          //                   ),
          //                   onPressed: () {
          //                     if (editInputMoneyCtrl.text.length == 0) {
          //                       showToast('请输入授信额度');
          //                       return;
          //                     }
          //                     Navigator.of(bloccontext).pop();
          //                     modifyAuthsMoney(
          //                         id, double.parse(editInputMoneyCtrl.text));
          //                     Future.delayed(new Duration(milliseconds: 500))
          //                         .then(
          //                       (_) {
          //                         Navigator.pop(bloccontext);
          //                       },
          //                     );
          //                   },
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     );
          //   } else {
          //     showToast(resp.msg);
          //   }
          // }
        } else {
          showToast(resp.msg);
        }
      },
    );
  }

  //获取管理师详细信息
  BehaviorSubject<MyMasterDetailModel> _myMasterDetailController =
      BehaviorSubject<MyMasterDetailModel>();
  Stream<MyMasterDetailModel> get outMyMasterDetail =>
      _myMasterDetailController.stream;
  StreamSink<MyMasterDetailModel> get _myMasterInfoSink =>
      _myMasterDetailController.sink;

  Future getMyMasterDetail(int masterId) async {
    MyMasterDetailReq _getMasterDetailByToken =
        MyMasterDetailReq(AppInstance.currentUser.token, masterId);
    XsProgressHud.show(bloccontext);
    return netRepository
        .getMyMasterDetail(_getMasterDetailByToken.toJson())
        .then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          _myMasterInfoSink.add(MyMasterDetailModel.fromJson(resp.data));
        }
      } else {
        showToast(resp.msg);
      }
    });
  }

  //修改授信金额

  Future modifyAuthsMoney(int id, double authMoney) async {
    ModifyAuthMoney _modifyAuthMoneyByToken =
        ModifyAuthMoney(AppInstance.currentUser.token, id, authMoney);
    return netRepository.modifyAuthMoney(_modifyAuthMoneyByToken.toJson()).then(
      (resp) {
        if (resp.code == Constant.SUCCESS_CODE) {
          showToast(resp.msg);
        } else {
          showToast("您的资金不足");
        }
      },
    );
  }

  //添加管理师POS机

  Future addMasterPos(int posId, int masterId) async {
    MasterPosReq _addPosByToken =
        MasterPosReq(AppInstance.currentUser.token, posId, masterId);
    return netRepository.addPos(_addPosByToken.toJson()).then(
      (resp) {
        if (resp.code == Constant.SUCCESS_CODE) {
          showToast(resp.msg);
        } else {
          showToast(resp.msg);
        }
      },
    );
  }

  //移除管理师POS机

  Future removeMastersPos(int posId, int masterId) async {
    MasterPosReq _removePosByToken =
        MasterPosReq(AppInstance.currentUser.token, posId, masterId);
    return netRepository.removeMasterPos(_removePosByToken.toJson()).then(
      (resp) {
        if (resp.code == Constant.SUCCESS_CODE) {
          showToast(resp.msg);
        } else {
          showToast(resp.msg);
        }
      },
    );
  }

  //总共还款
  BehaviorSubject<num> _repayMoneyController = BehaviorSubject<num>();
  Sink<num> get _repayMoneySink => _repayMoneyController.sink;
  Stream<num> get repayMoneyStream => _repayMoneyController.stream;

  //pos机总还款
  BehaviorSubject<num> _totalPosMoneyController = BehaviorSubject<num>();
  Sink<num> get _totalPosMoneySink => _totalPosMoneyController.sink;
  Stream<num> get totalPosMoneyStream => _totalPosMoneyController.stream;

  num repayMoney = 0.0;
  num totalPosMoney = 0.0;
  List historyDataList = List();
  //获取历史往来
  BehaviorSubject<dynamic> _masterHistoryController =
      BehaviorSubject<dynamic>();
  Stream<dynamic> get outMasterHistory => _masterHistoryController.stream;
  StreamSink<dynamic> get _myMasterHistoryInfoSink =>
      _masterHistoryController.sink;

  Future getMasterHistory(bool isLoad) async {
    historyDataList = List();
    TokenReq _getHistoryListByToken = TokenReq(AppInstance.currentUser.token);
    if (isLoad) {
      XsProgressHud.show(bloccontext);
    }
    return netRepository.getHistoryList(_getHistoryListByToken.toJson()).then(
      (resp) {
        if (isLoad) {
          XsProgressHud.hide();
        }
        if (resp.code == Constant.SUCCESS_CODE) {
          if (resp.data != null) {
            List historyData = MasterHistoryModel.fromJson(resp.data).dataList;
            num repayDataMoney =
                MasterHistoryModel.fromJson(resp.data).totalRepayMoney;
            num totalDataPosMoney =
                MasterHistoryModel.fromJson(resp.data).totalPosMoney;
            // if (repayDataMoney != null) {
            //   repayMoney += repayDataMoney.toDouble();
            // }
            // if (totalDataPosMoney != null) {
            //   totalPosMoney += totalDataPosMoney.toDouble();
            // }
            if (historyData.length > 0) {
              historyDataList.addAll(historyData);
            } else {
              // showToast('没有更多数据~');
              // currentPage--;
            }
            _repayMoneySink.add(repayDataMoney);
            _totalPosMoneySink.add(totalDataPosMoney);
            _myMasterHistoryInfoSink.add(historyDataList);
          }
        } else {
          showToast(resp.msg);
        }
      },
    );
  }

  void showToast(String msg, {int duration, int gravity: 0}) {
    Toast.show(msg, bloccontext, duration: duration, gravity: gravity);
  }

  void dispose() {
    _managerController.close();
    _masterDetailController.close();
    _applyCountController.close();
    _myMasterDetailController.close();
    _masterHistoryController.close();
    _escrowController.close();
    _removeController.close();
    _removeCountController.close();
    _repayMoneyController.close();
    _totalPosMoneyController.close();
  }
}
