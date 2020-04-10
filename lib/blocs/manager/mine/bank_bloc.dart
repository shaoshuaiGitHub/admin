import 'package:rxdart/rxdart.dart';

import "../../../common/component_index.dart";

class ManagerBankBloc implements BlocBase {
  BuildContext bloccontext;
  NetRepository netRepository = NetRepository();
  StreamController<ReceiveCardListModel> _bankController =
      StreamController<ReceiveCardListModel>();
  Stream<ReceiveCardListModel> get outBank => _bankController.stream;
  StreamSink<ReceiveCardListModel> get _bankInfoSink => _bankController.sink;

  //获取我的收款银行卡列表
  Future getReceiveCardsList() async {
    TokenReq _getReceiveListByToken = TokenReq(AppInstance.currentUser.token);
    XsProgressHud.show(bloccontext);
    return netRepository
        .getReceiveCardList(_getReceiveListByToken.toJson())
        .then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          _bankInfoSink.add(ReceiveCardListModel.fromJson(resp.data));
        }
      } else {
        showToast(resp.msg);
      }
    });
  }

  //删除加载
  Future getReceiveCardsListReLoad() async {
    TokenReq _getReceiveListByToken = TokenReq(AppInstance.currentUser.token);
    return netRepository
        .getReceiveCardList(_getReceiveListByToken.toJson())
        .then((resp) {
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          _bankInfoSink.add(ReceiveCardListModel.fromJson(resp.data));
        }
      } else {
        showToast(resp.msg);
      }
    });
  }

  var bankList;

  //获取可添加收款银行卡列表
  Future getReceiveBanksList() async {
    TokenReq _getBankListByToken = TokenReq(AppInstance.currentUser.token);
    return netRepository
        .getReceiveBankList(_getBankListByToken.toJson())
        .then((resp) {
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          bankList = ReceiveBankListModel.fromJson(resp.data).bankList;
        }
      } else {
        showToast(resp.msg);
      }
    });
  }

//添加收款银行卡
  Future addReceiveCards(
      String name, int cardNo, int bankId, String code, String phone) async {
    AddReceiveCardReq _addBlankCardByToken = AddReceiveCardReq(
        AppInstance.currentUser.token, name, cardNo, bankId, code, phone);
    XsProgressHud.show(bloccontext);
    return netRepository
        .addReceiveCard(_addBlankCardByToken.toJson())
        .then((resp) {
      XsProgressHud.hide();
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

  //移除收款银行卡
  Future removeReceiveCards(int cardInstId) async {
    RemoveReceiveCardReq _removeBlankCardByToken =
        RemoveReceiveCardReq(AppInstance.currentUser.token, cardInstId);
    XsProgressHud.show(bloccontext);
    return netRepository
        .removeReceiveCard(_removeBlankCardByToken.toJson())
        .then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        showToast(resp.msg);
      } else {
        showToast(resp.msg);
      }
    });
  }

  //选中银行
  BehaviorSubject<dynamic> _bankInfoSelectedController =
      BehaviorSubject<dynamic>();
  Stream<dynamic> get outBankSelected => _bankInfoSelectedController.stream;
  StreamSink<dynamic> get _bankSelectedSink => _bankInfoSelectedController.sink;

  StreamController _getBankSelectedActionController = StreamController();
  StreamSink get setSelectedBank => _getBankSelectedActionController.sink;

  int _counter;
  TimerUtil _timerUtil;
  //发送验证码
  StreamController<int> _counterController = StreamController<int>.broadcast();
  StreamSink<int> get _inMinus => _counterController.sink;
  Stream<int> get outCounter => _counterController.stream;

  StreamController _sendCodeActionController = StreamController();
  StreamSink get decrementCounter => _sendCodeActionController.sink;

  // 构造器
  BankBloc() {
    //获取选中选中银行
    _getBankSelectedActionController.stream.listen(_getSelectedBankLogic);
    //倒计时
    _counter = 60;
    _sendCodeActionController.stream.listen(_sendCodeLogic);
  }

  void _sendCodeLogic(data) {
    if (_timerUtil == null) {
      _timerUtil = new TimerUtil(mTotalTime: _counter * 1000);
      _timerUtil.setOnTimerTickCallback((int tick) {
        double _tick = tick / 1000;

        _counter = _counter - 1;
        _inMinus.add(_counter);
        if (_tick == 0 && _timerUtil != null) {
          _timerUtil.cancel();
          _timerUtil = null;
          _counter = 60;
          return;
        }
      });
      _timerUtil.startCountDown();
    }
  }

  //发送验证码
  Future sendCodeAction(String phoneNum, int type) async {
    ValidCodeReq _validCodeReq = ValidCodeReq(phoneNum, type);
    XsProgressHud.show(bloccontext);
    return netRepository.getValidCode(_validCodeReq.toJson()).then((resp) {
      XsProgressHud.hide();
      FocusScope.of(bloccontext).requestFocus(FocusNode());
      if (resp.code == Constant.SUCCESS_CODE) {
        showToast("验证码已发送~");
      } else {
        showToast(resp.msg);
      }
    });
  }

  void _getSelectedBankLogic(data) {
    _bankSelectedSink.add(data);
  }

  void showToast(String msg, {int duration, int gravity: 0}) {
    Toast.show(msg, bloccontext, duration: duration, gravity: gravity);
  }

  void dispose() {
    _bankInfoSelectedController.close();
    _getBankSelectedActionController.close();
    _bankController.close();
    _sendCodeActionController.close();
    _counterController.close();
  }
}
