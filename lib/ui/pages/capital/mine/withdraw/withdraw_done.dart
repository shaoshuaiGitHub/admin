import 'package:flutter/material.dart';
import 'package:youxinbao/blocs/capital/mine/withdraw_bloc.dart';
import 'package:youxinbao/common/component_index.dart';
import 'package:youxinbao/res/res_index.dart';
import 'setpwd_page.dart';
import 'withdrawals_record_page.dart';
import '../../../../widgets/password_field.dart';
import '../../../../widgets/keyboard.dart';

class WithdrawDonePage extends StatefulWidget {
  final int type; //1未设置 2已设置
  final int cardInstId;
  final double money;
  final num maxMoney;
  final callback;
  final callMaxBack;
  WithdrawDonePage({
    Key key,
    @required this.type,
    @required this.cardInstId,
    @required this.money,
    @required this.maxMoney,
    @required this.callback,
    @required this.callMaxBack,
  }) : super(key: key);
  @override
  State<WithdrawDonePage> createState() {
    return _WithdrawDonePage(
      totalMoney: this.money,
    );
  }
}

class _WithdrawDonePage extends State<WithdrawDonePage> {
  bool offStage = false; //菜单默认关闭
  double totalMoney; //提现金额
  /// 用户输入的密码
  String pwdData = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // VoidCallback：没有参数并且不返回数据的回调
  VoidCallback _showBottomSheetCallback;
  bool isOpen = false;
  _WithdrawDonePage({
    Key key,
    @required this.totalMoney,
  });
  WithdrawBloc withdrawBloc = WithdrawBloc();

  /// 密码键盘的整体回调，根据不同的按钮事件来进行相应的逻辑实现
  void _onKeyDown(data) {
    ///如果点击了删除按钮，则将密码进行修改
    if (data.isDelete()) {
      if (pwdData.length > 0) {
        pwdData = pwdData.substring(0, pwdData.length - 1);
        setState(() {
          pwdData = pwdData;
        });
      }
    }
// 点击了确定按钮时
    else if (data.isCommit()) {
      if (pwdData.length > 0 && pwdData.length < 6) {
        withdrawBloc.showToast("密码不足6位，请重试");
        return;
      } else {
        withdrawBloc.withdraw(widget.cardInstId, this.totalMoney, this.pwdData);
        if (isOpen) {
          Navigator.of(context).pop();
        }
      }
    }
//点击了数字按钮时  将密码进行完整的拼接
    else {
      if (pwdData.length < 6) {
        pwdData += data.key;
      }
      setState(() {
        pwdData = pwdData;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _showBottomSheetCallback = _showBottomSheet;
  }

  void _showBottomSheet() {
    if (isOpen) {
      return null;
    } else {
      isOpen = true;
      _scaffoldKey.currentState
          .showBottomSheet<void>((BuildContext context) {
            return Container(
              height: 230,
              child: MyKeyboard(callback: (val) => _onKeyDown(val)),
            );
          })
          .closed
          .whenComplete(() {
            if (mounted) {
              setState(() {
                // re-enable the button  // 重新启用按钮
                isOpen = false;
                _showBottomSheetCallback = _showBottomSheet;
              });
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    withdrawBloc.bloccontext = context;
    return GestureDetector(
      onTap: () {
        if (offStage) {
          setState(() {
            offStage = !offStage;
          });
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color(0xFFFF9B1A),
          centerTitle: true,
          elevation: 0,
          title: Text(
            '提现',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeights.bold,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {
                offStage = !offStage;
                setState(() {
                  offStage = offStage;
                });
              },
            ),
          ],
        ),
        body: BlocProvider<WithdrawBloc>(
          bloc: WithdrawBloc(),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFF2F2F2),
            ),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                        left: 17,
                        right: 17,
                      ),
                      decoration: BoxDecoration(color: Colors.white),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 44,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '提现金额',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF282828),
                                      fontWeight: FontWeights.medium),
                                ),
                                Text(
                                  '预计两小时到账',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF999999),
                                      fontWeight: FontWeights.medium),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 38,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '￥$totalMoney',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeights.medium,
                                color: Color(0xFF282828),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 42,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '当前最大可提现：￥${widget.maxMoney.toDouble()}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF999999),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    this.setState(() {
                                      totalMoney = widget.maxMoney.toDouble();
                                    });
                                    widget.callback(widget.maxMoney);
                                  },
                                  padding: const EdgeInsets.all(0),
                                  minWidth: 0,
                                  child: Text(
                                    '全部提现',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFFFF9B1A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Offstage(
                      offstage: widget.type == 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                              width: 1,
                              color: Color(0xFFFF9B1A),
                              style: BorderStyle.solid,
                            ),
                            bottom: BorderSide(
                              width: 1,
                              color: Color(0xFFFF9B1A),
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 25,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      '取消',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeights.medium,
                                        color: Color(0xFF979797),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 34,
                              alignment: Alignment.center,
                              child: Text(
                                '请输入提现密码',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeights.medium,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 33,
                            ),
                            Container(
                              width: 270,
                              height: 44,
                              child: GestureDetector(
                                child: Container(
                                  width: 250.0,
                                  height: 40.0,
                                  child: CustomJPasswordField(
                                    data: '$pwdData',
                                  ),
                                ), // 用户点击输入框的时候，弹出自定义的键盘
                                onTap: () {
                                  _showBottomSheetCallback();
                                },
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 54,
                    ),
                    Container(
                      width: 150,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Color(0xFFFF9B1A),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: MaterialButton(
                        minWidth: 0,
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          _onKeyDown(KeyEvent('commit'));
                        },
                        child: Center(
                          child: Text(
                            '完成',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  child: MenusWidget(
                    offStage: offStage,
                  ),
                  right: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//导航
class MenusWidget extends StatelessWidget {
  final bool offStage;
  const MenusWidget({Key key, this.offStage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !offStage,
      child: Container(
        width: 118,
        height: 81,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/capital/rect.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 4,
            ),
            Container(
              height: 38,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SetPasswordPage(),
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    '密码设置',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFFFF9B1A),
                      fontWeight: FontWeights.medium,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 38,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Color(0xFFFF9B1A),
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          WithdrawalsRecordPage(),
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    '提现记录',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFFFF9B1A),
                      fontWeight: FontWeights.medium,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
