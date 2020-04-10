import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youxinbao/blocs/bloc_provider.dart';
import 'package:youxinbao/blocs/manager/mine/withdraw_bloc.dart';
import 'package:youxinbao/res/res_index.dart';

class EditPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EditPasswordPage();
}

class _EditPasswordPage extends State<EditPasswordPage> {
  var pwdInputCtrl = TextEditingController();
  var pwdNewInputCtrl = TextEditingController();
  WithdrawBloc withdrawBloc = WithdrawBloc();

  @override
  Widget build(BuildContext context) {
    withdrawBloc.bloccontext = context;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colours.orange_72,
        centerTitle: true,
        elevation: 0,
        title: Text(
          '修改密码',
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
            // 触摸收起键盘
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
                            '原密码：',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF4C4C4C),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(6),
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  hintText: '请输入原支付密码',
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
                                  WhitelistingTextInputFormatter.digitsOnly
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
                                  WhitelistingTextInputFormatter.digitsOnly
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
                      child: Container(
                        width: 166,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colours.orange_72,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
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
                            withdrawBloc.modifyPwdAction(pwdInputCtrl.text);
                         
                          },
                          minWidth: 0,
                          padding: const EdgeInsets.all(0),
                          child: Center(
                            child: Text(
                              '确认修改',
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
