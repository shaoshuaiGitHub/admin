import "../../../common/component_index.dart";
import '../../../ui/pages/page_index.dart';

class WithdrawBloc implements BlocBase {
  BuildContext bloccontext;
  NetRepository netRepository = NetRepository();
  //提现信息

  //选中银行卡
  StreamController<dynamic> _selectedController =
      StreamController<dynamic>.broadcast();
  StreamSink<dynamic> get _changeBlank => _selectedController.sink;
  Stream<dynamic> get outSelectedBlank => _selectedController.stream;

  StreamController _getCardActionController = StreamController();
  StreamSink get getSelectedCard => _getCardActionController.sink;

  // 构造器
  WithdrawBloc() {
    //获取选中银行卡
    _getCardActionController.stream.listen(_getSelectedCardLogic);
    //倒计时
    _counter = 60;
    _sendCodeActionController.stream.listen(_sendCodeLogic);
  }

  void _getSelectedCardLogic(data) {
    _changeBlank.add(data);
  }

  StreamController<WithdrawModel> _withdrawInfoController =
      StreamController<WithdrawModel>.broadcast();
  Stream<WithdrawModel> get outInfo => _withdrawInfoController.stream;
  StreamSink<WithdrawModel> get _withdrawInfoSink =>
      _withdrawInfoController.sink;

  //获取提现信息 判断是否设置提现密码
  Future getWithdrawInfos() async {
    TokenReq _getWithdrawInfoByToken = TokenReq(AppInstance.currentUser.token);
    return netRepository
        .getWithdrawInfo(_getWithdrawInfoByToken.toJson())
        .then((resp) {
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data['hasWithdrawPwd'] == 0) {
          Navigator.push(
            bloccontext,
            MaterialPageRoute(
              builder: (BuildContext context) => MyWithdrawPage(),
            ),
          );
        } else {
          Navigator.push(
            bloccontext,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  WithdrawMoneyManagerPage(type: 2),
            ),
          );
        }
      } else {
        showToast(resp.msg);
      }
    });
  }

  //获取提现信息
  Future getWithdrawInfo() async {
    TokenReq _getWithdrawInfoByToken = TokenReq(AppInstance.currentUser.token);
    return netRepository
        .getWithdrawInfo(_getWithdrawInfoByToken.toJson())
        .then((resp) {
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          _withdrawInfoSink.add(WithdrawModel.fromJson(resp.data));
        }
      } else {
        showToast(resp.msg);
      }
    });
  }

  //现金提现
  Future withdraw(int cardInstId, double money, String password) async {
    var _withdrawByToken;
    if (password == "") {
      _withdrawByToken =
          WithdrawNoPwdReq(AppInstance.currentUser.token, cardInstId, money);
    } else {
      _withdrawByToken = WithdrawHasPwdReq(
          AppInstance.currentUser.token, cardInstId, money, password);
    }
    return netRepository.withdraw(_withdrawByToken.toJson()).then((resp) {
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

  //设置提现密码
  Future setWithdrawPwd(String password) async {
    WithdrawByPwd _getWithdrawPwdByToken =
        WithdrawByPwd(AppInstance.currentUser.token, password);
    XsProgressHud.show(bloccontext);
    return netRepository
        .setWithdrawPwd(_getWithdrawPwdByToken.toJson())
        .then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        showToast(resp.msg);
        Future.delayed(new Duration(milliseconds: 500)).then((_) {
          Navigator.push(
            bloccontext,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    WithdrawMoneyManagerPage(type: 2)),
          );
        });
      } else {
        showToast(resp.msg);
      }
    });
  }

  //忘记提现密码
  int _counter;
  TimerUtil _timerUtil;
  //发送验证码
  StreamController<int> _counterController = StreamController<int>.broadcast();
  StreamSink<int> get _inMinus => _counterController.sink;
  Stream<int> get outCounter => _counterController.stream;

  StreamController _sendCodeActionController = StreamController();
  StreamSink get decrementCounter => _sendCodeActionController.sink;

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

  //忘记提现密码
  Future forgetPwdAction(String code, String pwd) async {
    ForgetWithdrawPwdReq _forgetPwdReq =
        ForgetWithdrawPwdReq(AppInstance.currentUser.token, pwd, code);
    XsProgressHud.show(bloccontext);
    return netRepository.forgetWithdrawPwd(_forgetPwdReq.toJson()).then((resp) {
      XsProgressHud.hide();
      FocusScope.of(bloccontext).requestFocus(FocusNode());
      if (resp.code == Constant.SUCCESS_CODE) {
        showDialog(
          context: bloccontext,
          builder: (_) => Dialog(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 14,
                    ),
                    Container(
                      height: 36,
                      child: Text(
                        '${resp.msg}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeights.medium,
                          color: Color(0xFF121212),
                        ),
                      ),
                    ),
                    Image(
                      image: AssetImage('assets/images/capital/yes.png'),
                      width: 32,
                      height: 32,
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
        );
      } else {
        showToast(resp.msg);
      }
    });
  }

  //修改提现密码
  Future modifyPwdAction(String pwd) async {
    WithdrawByPwd _modifyPwdReq =
        WithdrawByPwd(AppInstance.currentUser.token, pwd);
    XsProgressHud.show(bloccontext);
    return netRepository.modifyWithdrawPwd(_modifyPwdReq.toJson()).then((resp) {
      XsProgressHud.hide();
      FocusScope.of(bloccontext).requestFocus(FocusNode());
      if (resp.code == Constant.SUCCESS_CODE) {
        showDialog(
          context: bloccontext,
          builder: (_) => Dialog(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 14,
                    ),
                    Container(
                      height: 36,
                      child: Text(
                        '${resp.msg}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeights.medium,
                          color: Color(0xFF121212),
                        ),
                      ),
                    ),
                    Image(
                      image: AssetImage('assets/images/capital/yes.png'),
                      width: 32,
                      height: 32,
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
        );
      } else {
        showToast(resp.msg);
      }
    });
  }

  //获取提现记录
  StreamController<WithdrawLogModel> _logsController =
      StreamController<WithdrawLogModel>();
  Stream<WithdrawLogModel> get outLog => _logsController.stream;
  StreamSink<WithdrawLogModel> get _logInfoSink => _logsController.sink;

  Future getLogs(int page) async {
    LogListReq _getLogListByToken =
        LogListReq(AppInstance.currentUser.token, page);
    XsProgressHud.show(bloccontext);
    return netRepository.getLog(_getLogListByToken.toJson()).then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          _logInfoSink.add(WithdrawLogModel.fromJson(resp.data));
        }
      } else {
        showToast(resp.msg);
      }
    });
  }

  void showToast(String msg, {int duration, int gravity: 0}) {
    Toast.show(msg, bloccontext, duration: duration, gravity: gravity);
  }

  void dispose() {
    if (_timerUtil != null) _timerUtil.cancel();
    _sendCodeActionController.close();
    _counterController.close();
    _logsController.close();
    _selectedController.close();
    _withdrawInfoController.close();
    _getCardActionController.close();
  }
}
