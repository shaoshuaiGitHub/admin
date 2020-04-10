import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';

class ApplicationHead extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ApplicationHead();
  }
}

class _ApplicationHead extends State<ApplicationHead> {
  var accountInputCtrl = TextEditingController();
  var applyMsgInputCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ApplyCapitalBloc applyCapitalBloc = ApplyCapitalBloc();
    applyCapitalBloc.bloccontext = context;

    return Container(
      color: Colours.bottom_line,
      // margin: EdgeInsets.only(top: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          //触摸回收键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        '*',
                        style:
                            TextStyle(color: Colours.orange_72, fontSize: 20),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '输入资金方账号',
                        style:
                            TextStyle(color: Color(0xff212121), fontSize: 14),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 200,
                        height: 33,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colours.gray_66, width: 1)),
                        child: TextField(
                          controller: accountInputCtrl,
                          // autofocus: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(11),
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            hintText: '请输入资金方账号',
                            contentPadding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          style:
                              TextStyle(fontSize: 14, color: Colours.gray_66),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Text(
                        '*',
                        style:
                            TextStyle(color: Colours.orange_72, fontSize: 20),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '备注',
                        style: TextStyle(fontSize: 14, color: Colours.gray_66),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 335,
                        height: 50,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colours.gray_66, width: 1)),
                        child: TextField(
                          controller: applyMsgInputCtrl,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: '备注',
                            contentPadding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          style:
                              TextStyle(fontSize: 14, color: Colours.gray_99),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.only(
                    // top: MediaQuery.of(context).size.height - 400,
                    left: 20,
                    right: 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 114, 0),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '提交申请',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () {
                    if (accountInputCtrl.text.length == 0) {
                      applyCapitalBloc.showToast('请输入您的实际消费');
                      return;
                    }
                    if (applyMsgInputCtrl.text.length == 0) {
                      applyCapitalBloc.showToast('请输入备注信息');
                      return;
                    }
                    applyCapitalBloc.applyCapitalAction(
                        int.parse(accountInputCtrl.text),
                        applyMsgInputCtrl.text);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
