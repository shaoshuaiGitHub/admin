import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youxinbao/blocs/bloc_provider.dart';
import 'package:youxinbao/blocs/capital/mine/withdraw_bloc.dart';
import 'package:youxinbao/res/res_index.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ForgetPasswordPage();
}

class _ForgetPasswordPage extends State<ForgetPasswordPage> {
  var codeInputCtrl = TextEditingController();
  var pwdInputCtrl = TextEditingController();
  var pwdNewInputCtrl = TextEditingController();
  WithdrawBloc withdrawBloc = WithdrawBloc();

  @override
  Widget build(BuildContext context) {
    withdrawBloc.bloccontext = context;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9B1A),
        centerTitle: true,
        elevation: 0,
        title: Text(
          '忘记密码',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeights.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocProvider<WithdrawBloc>(
        bloc: WithdrawBloc(),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            //触摸回收键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFF2F2F2),
            ),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Phone(),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.only(
                        top: 10,
                      ),
                      padding: const EdgeInsets.only(
                        left: 17,
                        right: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '输入验证码：',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF4C4C4C),
                              fontWeight: FontWeights.medium,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: TextField(
                                controller: codeInputCtrl,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(6),
                                  WhitelistingTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  hintText: '请输入验证码',
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF999999),
                                    fontWeight: FontWeights.medium,
                                  ),
                                  disabledBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.only(
                        top: 10,
                      ),
                      padding: const EdgeInsets.only(
                        left: 17,
                        right: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '新密码：',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF4C4C4C),
                              fontWeight: FontWeights.medium,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: TextField(
                                controller: pwdInputCtrl,
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(6),
                                  WhitelistingTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  hintText: '请输入新支付密码（只能为6位数字）',
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF999999),
                                    fontWeight: FontWeights.medium,
                                  ),
                                  disabledBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.only(
                        top: 10,
                      ),
                      padding: const EdgeInsets.only(
                        left: 17,
                        right: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '确认密码：',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF4C4C4C),
                              fontWeight: FontWeights.medium,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: TextField(
                                controller: pwdNewInputCtrl,
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(6),
                                  WhitelistingTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  hintText: '请重新输入新支付密码',
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF999999),
                                    fontWeight: FontWeights.medium,
                                  ),
                                  disabledBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: MaterialButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (codeInputCtrl.text.length < 6) {
                            withdrawBloc.showToast("请输入6位短信验证码");
                            return;
                          }
                          if (pwdInputCtrl.text.length < 6) {
                            withdrawBloc.showToast("请输入6位支付密码");
                            return;
                          }
                          if (pwdNewInputCtrl.text.length < 6) {
                            withdrawBloc.showToast("请再次输入6位支付密码");
                            return;
                          }
                          if (pwdInputCtrl.text != pwdNewInputCtrl.text) {
                            withdrawBloc.showToast("两次输入密码不一致");
                            return;
                          }
                          withdrawBloc.forgetPwdAction(
                              codeInputCtrl.text, pwdInputCtrl.text);
                        },
                        minWidth: 0,
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          width: 166,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Color(0xFFFF9B1A),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              '确认',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeights.medium,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  bottom: 64,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Phone extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Phone();
}

class _Phone extends State<Phone> {
  WithdrawBloc withdrawBloc = WithdrawBloc();
  var phoneInputCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    withdrawBloc.bloccontext = context;

    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          //触摸回收键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: 50,
          margin: const EdgeInsets.only(
            top: 10,
          ),
          padding: const EdgeInsets.only(
            left: 17,
            right: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '手机号：',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF4C4C4C),
                ),
              ),
              Expanded(
                child: Container(
                  child: TextField(
                    controller: phoneInputCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(11),
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: '请输入手机号码',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF999999),
                        fontWeight: FontWeights.medium,
                      ),
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              StreamBuilder(
                stream: withdrawBloc.outCounter,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData && snapshot.data > 0) {
                    return Container(
                      padding: const EdgeInsets.only(
                        left: 5,
                        right: 5,
                      ),
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          '${snapshot.data}s后重新发送',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeights.medium,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return MaterialButton(
                      padding: const EdgeInsets.all(0),
                      minWidth: 0,
                      onPressed: () {
                        if (phoneInputCtrl.text.length == 11) {
                          withdrawBloc.decrementCounter.add(null);
                          withdrawBloc.sendCodeAction(phoneInputCtrl.text, 5);
                        } else {
                          FocusScope.of(context).requestFocus(FocusNode());
                          withdrawBloc.showToast("请输入合法的手机号码");
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 5,
                          right: 5,
                        ),
                        height: 30,
                        decoration: BoxDecoration(
                          color: Color(0xFFFF9B1A),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            '获取验证码',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeights.medium,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ));
  }
}
