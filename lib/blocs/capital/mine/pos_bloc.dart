import 'package:rxdart/rxdart.dart';

import "../../../common/component_index.dart";

class PosBloc implements BlocBase {
  BuildContext bloccontext;
  NetRepository netRepository = NetRepository();
  StreamController<PosListModel> _posController =
      StreamController<PosListModel>();
  Stream<PosListModel> get outPos => _posController.stream;
  StreamSink<PosListModel> get _posInfoSink => _posController.sink;
  //获取我的POS机
  Future getPosList() async {
    TokenReq _getPosListByToken = TokenReq(AppInstance.currentUser.token);
    XsProgressHud.show(bloccontext);
    return netRepository.getMyPosList(_getPosListByToken.toJson()).then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          _posInfoSink.add(PosListModel.fromJson(resp.data));
        }
      } else {
        showToast(resp.msg);
      }
    });
  }

  var typeList; //机名列表
  var posInfoList; //所有机型列表
  var useInfoList; //所属机子机型列表
  //获取可用POS机
  Future getPosInfoList() async {
    TokenReq _getPosInfoListByToken = TokenReq(AppInstance.currentUser.token);
    return netRepository
        .getPosInfoList(_getPosInfoListByToken.toJson())
        .then((resp) {
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          typeList = PosInfoListModel.fromJson(resp.data).typeList;
          posInfoList = PosInfoListModel.fromJson(resp.data).posInfoList;
        }
      } else {
        showToast(resp.msg);
      }
    });
  }

  //选中机型
  BehaviorSubject<dynamic> _posInfoSelectedController =
      BehaviorSubject<dynamic>();
  Stream<dynamic> get outPosInfoSelected => _posInfoSelectedController.stream;
  StreamSink<dynamic> get _posInfoSelectedSink =>
      _posInfoSelectedController.sink;

  StreamController _getPosInfoSelectedActionController = StreamController();
  StreamSink get setSelectedPosInfo => _getPosInfoSelectedActionController.sink;

  //选中机名
  BehaviorSubject<dynamic> _typeController = BehaviorSubject<dynamic>();
  Stream<dynamic> get outTypeSelected => _typeController.stream;
  StreamSink<dynamic> get _typeInfoSelectedSink => _typeController.sink;

  StreamController _getTypeSelectedActionController = StreamController();
  StreamSink get setSelectedType => _getTypeSelectedActionController.sink;

  // 构造器
  PosBloc() {
    //获取选中Pos机型
    _getPosInfoSelectedActionController.stream.listen(_getSelectedPosInfoLogic);

    //获取选中Pos机名
    _getTypeSelectedActionController.stream.listen(_getSelectedTypeLogic);
  }

  void _getSelectedPosInfoLogic(data) {
    _posInfoSelectedSink.add(data);
  }

  void _getSelectedTypeLogic(data) {
    _typeInfoSelectedSink.add(data);
    _posInfoSelectedSink.add(null);
  }

  //添加POS机
  Future addPosTerminals(int posId, int bankNo, var bankName, var alias) async {
    PosTerminalReq _getAddPosListByToken = PosTerminalReq(
        AppInstance.currentUser.token, posId, bankNo, bankName, alias);
    return netRepository
        .addPosTerminal(_getAddPosListByToken.toJson())
        .then((resp) {
      if (resp.code == Constant.SUCCESS_CODE) {
        showToast(resp.msg);
         Future.delayed(new Duration(milliseconds: 100)).then(
                    (_) {
                      Navigator.of(bloccontext).pop();
                    },
                  );
      } else {
        showToast(resp.msg);
      }
    });
  }

  //删除POS机
  Future removesPos(int posInstId) async {
    RemovePosReq _getRemovePosByToken =
        RemovePosReq(AppInstance.currentUser.token, posInstId);
    return netRepository.removePos(_getRemovePosByToken.toJson()).then(
      (resp) {
        if (resp.code == Constant.SUCCESS_CODE) {
          showToast(resp.msg);
        } else {
          showToast(resp.msg);
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

  void showToast(String msg, {int duration, int gravity: 0}) {
    Toast.show(msg, bloccontext, duration: duration, gravity: gravity);
  }

  void dispose() {
    _posController.close();
    _posInfoSelectedController.close();
    _getPosInfoSelectedActionController.close();
    _typeController.close();
    _getTypeSelectedActionController.close();
  }
}
