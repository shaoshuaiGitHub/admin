import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youxinbao/common/component_index.dart';
import 'package:youxinbao/blocs/capital/mine/withdraw_bloc.dart';

class AddBankCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddBankCard();
}

class _AddBankCard extends State<AddBankCard> {
  //添加银行卡Page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          '添加银行卡',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colours.orange_72,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          //触摸回收键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: BlocProvider<BankBloc>(
          bloc: BankBloc(),
          child: AddBankCardMiddle(),
        ),
      ),
    );
  }
}

//middle
class AddBankCardMiddle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddBankCardMiddle();
}

class _AddBankCardMiddle extends State<AddBankCardMiddle> {
  int bankId = 0; //选中银行id
  String bankName = '请选择银行';
  var nameInputCrl = TextEditingController();
  var idCardInputCrl = TextEditingController();
  var bankCardInputCrl = TextEditingController();
  var phoneInputCtrl = TextEditingController();
  var codeInputCtrl = TextEditingController();
  BankBloc bankBloc = BankBloc();
  @override
  void initState() {
    super.initState();
    Future.delayed(new Duration(milliseconds: 500)).then((_) {
      bankBloc.getReceiveBanksList();
    });
  }

  void selectBank(val) {
    bankId = val;
  }

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc applicationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    bankBloc.bloccontext = context;
    return Container(
      color: Color(0xFFF2F2F2),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 200,
                color: Color(0xffffffff),
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      //姓名
                      padding: EdgeInsets.only(
                        left: 17,
                        right: 17,
                      ),
                      height: 50,
                      decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          border: Border(
                              bottom: BorderSide(
                            width: 1,
                            color: Color(0xffe6e6e6),
                          ))),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 100,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '姓名',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff212121),
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: nameInputCrl,
                              decoration: InputDecoration(
                                hintText: '请输入姓名',
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xff999999),
                                ),
                                contentPadding: EdgeInsets.all(10.0),
                                // fillColor: Colors.white, filled: true,
                                // 以下属性可用来去除TextField的边框
                                disabledBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //身份证
                      padding: EdgeInsets.only(
                        left: 17,
                        right: 17,
                      ),
                      height: 50,
                      decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          border: Border(
                              bottom: BorderSide(
                            width: 1,
                            color: Color(0xffe6e6e6),
                          ))),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 100,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '身份证',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff212121),
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: idCardInputCrl,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(18),
                              ],
                              decoration: InputDecoration(
                                hintText: '请输入身份证',
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xff999999),
                                ),
                                contentPadding: EdgeInsets.all(10.0),
                                // fillColor: Colors.white, filled: true,
                                // 以下属性可用来去除TextField的边框
                                disabledBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //银行卡号
                      padding: EdgeInsets.only(
                        left: 17,
                        right: 17,
                      ),
                      height: 50,
                      decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          border: Border(
                              bottom: BorderSide(
                            width: 1,
                            color: Color(0xffe6e6e6),
                          ))),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 100,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '银行卡号',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff212121),
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: bankCardInputCrl,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                hintText: '请输入银行卡号',
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xff999999),
                                ),
                                contentPadding: EdgeInsets.all(10.0),
                                disabledBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      //银行
                      onTap: () => showModalBottomSheet(
                            context: context,
                            builder: (_) => MBankList(
                                  bankBloc: bankBloc,
                                  callback: (val) => selectBank(val),
                                ),
                          ),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 17,
                          right: 17,
                        ),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            border: Border(
                                bottom: BorderSide(
                              width: 1,
                              color: Color(0xffe6e6e6),
                            ))),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 110,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '银行',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff212121),
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: StreamBuilder(
                                stream: bankBloc.outBankSelected,
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  bankName = snapshot.hasData
                                      ? snapshot.data.name
                                      : '请选择银行';
                                  return Text(
                                    bankName,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: snapshot.hasData
                                          ? Colors.black
                                          : Color(0xff999999),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 50,
                              alignment: Alignment.centerRight,
                              child: Image.asset(
                                'assets/images/capital/arrow.png',
                                width: 6,
                                height: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ), //1
              Container(
                height: 150,
                color: Color(0xffffffff),
                child: Column(
                  children: <Widget>[
                    Container(
                      //手机验证
                      padding: EdgeInsets.only(
                        left: 17,
                        right: 17,
                      ),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xffffffff),
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Color(0xffe6e6e6),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '手机验证',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff212121),
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //账号
                      padding: EdgeInsets.only(
                        left: 17,
                        // right: 17,
                      ),
                      height: 50,
                      decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          border: Border(
                              bottom: BorderSide(
                            width: 1,
                            color: Color(0xffe6e6e6),
                          ))),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 100,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '账号',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff212121),
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: phoneInputCtrl,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(11),
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                hintText: '请输入账号(你的手机号)',
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xff999999),
                                ),
                                contentPadding: EdgeInsets.all(10.0),
                                // fillColor: Colors.white, filled: true,
                                // 以下属性可用来去除TextField的边框
                                disabledBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              right: 17,
                            ),
                            width: 30,
                            alignment: Alignment.centerRight,
                            child: Image.asset(
                              'assets/images/capital/arrow.png',
                              width: 6,
                              height: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //验证
                      padding: EdgeInsets.only(
                        left: 17,
                        right: 10,
                      ),
                      height: 50,
                      decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          border: Border(
                              bottom: BorderSide(
                            width: 1,
                            color: Color(0xffe6e6e6),
                          ))),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 100,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '验证码',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff212121),
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: codeInputCtrl,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6),
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '请输入验证码',
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xff999999),
                                ),
                                contentPadding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 10, right: 10),
                                // fillColor: Colors.white, filled: true,
                                // 以下属性可用来去除TextField的边框
                                disabledBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          // Expanded(
                          //   flex: 1,
                          //   child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              StreamBuilder(
                                stream: bankBloc.outCounter,
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData && snapshot.data > 0) {
                                    return Container(
                                      padding: const EdgeInsets.only(
                                        left: 11,
                                        right: 11,
                                        top: 1,
                                        bottom: 2,
                                      ),
                                      height: 22,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.grey,
                                      ),
                                      child: Text(
                                        '${snapshot.data}s后重新发送',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xfffffefe),
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.none,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      width: 80,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colours.orange_72,
                                      ),
                                      child: MaterialButton(
                                        padding: EdgeInsets.all(0),
                                        minWidth: 0,
                                        child: Text(
                                          '发送验证码',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xfffffefe),
                                            fontWeight: FontWeight.w400,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        onPressed: () {
                                          if (phoneInputCtrl.text.length ==
                                              11) {
                                            bankBloc.decrementCounter.add(null);
                                            bankBloc.sendCodeAction(
                                                phoneInputCtrl.text, 4);
                                          } else {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            bankBloc.showToast("请输入合法的手机号码");
                                          }
                                        },
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            //绑定按钮 定位底部
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colours.orange_72,
              ),
              margin: EdgeInsets.all(16),
              child: FlatButton(
                child: Text(
                  '绑定',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
                onPressed: () {
                  if (nameInputCrl.text.length == 0) {
                    bankBloc.showToast('请输入姓名');
                    return;
                  }
                  if (idCardInputCrl.text.length == 0) {
                    bankBloc.showToast('请输入身份证');
                    return;
                  }
                  if (bankCardInputCrl.text.length == 0) {
                    bankBloc.showToast('请输入银行卡号');
                    return;
                  }
                  if (bankId == 0) {
                    bankBloc.showToast('请选择银行');
                    return;
                  }
                  if (bankId == 0) {
                    bankBloc.showToast('请选择银行');
                    return;
                  }
                  if (phoneInputCtrl.text.length < 11) {
                    bankBloc.showToast('请输入合法的手机号码');
                    return;
                  }
                  if (codeInputCtrl.text.length < 6) {
                    bankBloc.showToast('请输入验证码');
                    return;
                  }
                  applicationBloc.backType = 1;
                  bankBloc.addReceiveCards(
                    nameInputCrl.text,
                    int.parse(bankCardInputCrl.text),
                    bankId,
                    codeInputCtrl.text,
                    phoneInputCtrl.text,
                  );
                },
              ),
            ),
            left: 0,
            right: 0,
            bottom: 0,
          ),
        ],
      ),
    );
  }
}

//银行列表
class MBankList extends StatefulWidget {
  final BankBloc bankBloc;
  final callback;
  MBankList({
    Key key,
    @required this.bankBloc,
    @required this.callback,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MBankList();
}

class _MBankList extends State<MBankList> {
  List<Widget> bankList = [];
  Widget cardListView;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.bankBloc.outBankSelected,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        cardListView = ListView(
          shrinkWrap: true,
          children: bankList,
        );
        widget.bankBloc.bankList.forEach(
          (item) => {
                bankList.add(
                  Container(
                    child: MaterialButton(
                      minWidth: 0,
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        widget.bankBloc.setSelectedBank.add(item);
                        widget.callback(item.id);
                        Navigator.of(widget.bankBloc.bloccontext).pop();
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Color(0xffe6e6e6),
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 32,
                              height: 32,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: FadeInImage.assetNetwork(
                                  placeholder:
                                      "assets/images/user/card_default.jpeg",
                                  image: item.icon,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              '${item.name}（储蓄卡）',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              },
        );
        return Container(
          constraints: BoxConstraints(maxHeight: 318),
          child: cardListView,
        );
      },
    );
  }
}
