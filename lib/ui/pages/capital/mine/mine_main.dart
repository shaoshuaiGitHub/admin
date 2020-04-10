import 'package:flutter/material.dart';
import 'package:youxinbao/blocs/capital/mine/withdraw_bloc.dart';
import 'package:youxinbao/common/component_index.dart';
import 'personal/personal_page.dart';
import 'detailList/detailList_index.dart';
import 'minePOS/minePOS_index.dart';
import 'mineBankCard/mineBankCard_index.dart';
import 'manager/my_application_page.dart';

class CapitalMineMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CapitalMineMain();
}

class _CapitalMineMain extends State<CapitalMineMain> {
  var authMoneyInputCtrl = TextEditingController();
  var name;
  var account;
  String certificationText = '未实名';
  double money = 0.0;
  double withdraw = 0.0;
  double unavailable = 0.0;
  double myAuthMoney = 0.0;
  double remainAuthMoney = 0.0;
  bool isLock = false;
  WithdrawBloc withdrawBloc = WithdrawBloc();

  _capitalChange(context, basisBloc) {
    final ApplicationBloc applocationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    //修改资金弹窗
    return Dialog(
      elevation: 0,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        width: 300,
        height: 187,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color(0xffffffff),
        ),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                color: Color(0xffff9b1a),
              ),
              height: 43,
              alignment: Alignment.center,
              child: Text(
                '我的资金',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xffffffff),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              height: 75,
              padding: EdgeInsets.only(left: 10, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 234,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Color(0xff999999),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: TextField(
                      controller: authMoneyInputCtrl,
                      inputFormatters: [
                        WhitelistingTextInputFormatter(
                            RegExp(r"^\d+(?:\.\d{0,2})?"))
                      ], //保留两位有效数字
                      // keyboardType: TextInputType.numberWithOptions(signed:true, decimal :true),
                      decoration: InputDecoration(
                        hintText: '请输您的资金金额',
                        hintStyle: TextStyle(
                          fontSize: 14.0,
                          color: Color(0xff999999),
                        ),
                        contentPadding: EdgeInsets.all(10.0),
                        disabledBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff212121),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '元',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff212121),
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colours.gray_cc,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(basisBloc.bloccontext).pop();
                    },
                    child: Center(
                      child: Text(
                        '取消',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xffff9b1a),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: FlatButton(
                    onPressed: () {
                      if (authMoneyInputCtrl.text.length == 0) {
                        basisBloc.showToast('请输入修改金额');
                        return;
                      }
                      applocationBloc.backType = 1;
                      Navigator.of(basisBloc.bloccontext).pop();
                      basisBloc.modifysMyAuthorMoney(
                          double.parse(authMoneyInputCtrl.text));
                    },
                    child: Center(
                      child: Text(
                        '修改',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc applocationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    final BasisBloc basisBloc = BlocProvider.of<BasisBloc>(context);
    basisBloc.bloccontext = context;
    withdrawBloc.bloccontext = context;
    if (!isLock) {
      Future.delayed(new Duration(milliseconds: 100)).then((_) {
        basisBloc.getUserInfo();
      });
      isLock = true;
    } else {
      if (applocationBloc.personalBackType == 1) {
        Future.delayed(new Duration(milliseconds: 10)).then((_) {
          basisBloc.getUserInfo();
        });
      }
    }

    //个人中心 head部分
    return StreamBuilder(
      stream: basisBloc.outUserInfo,
      builder: (BuildContext context, AsyncSnapshot<UserInfoModel> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        UserInfoModel userInfoModel = snapshot.data;
        name = userInfoModel.name;
        account = userInfoModel.phone.toString().replaceRange(3, 9, "******");
        certificationText = userInfoModel.isCertification == 1 ? '已实名' : '未实名';
        money = userInfoModel.money.toDouble();
        withdraw = userInfoModel.withdraw.toDouble();
        unavailable = userInfoModel.unavailable.toDouble();
        myAuthMoney = userInfoModel.myAuthMoney.toDouble();
        remainAuthMoney = userInfoModel.remainAuthMoney.toDouble();
        return Column(
          children: <Widget>[
            Container(
              height: 265,
              padding: EdgeInsets.only(
                top: 50,
                bottom: 6,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/capital/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    //头像-资金方-已实名
                    height: 70,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CapitalPersonalPage(),
                          ),
                        );
                        applocationBloc.personalBackType = 0;
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: 70,
                                height: 70,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                        "assets/images/user/head_default.jpeg",
                                    image: userInfoModel.icon,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ), //头像
                              SizedBox(
                                width: 12,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '${name != null ? name : ''}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xffffffff),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ), //4455
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 6,
                                          right: 6,
                                          top: 2,
                                          bottom: 2,
                                        ),
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(255, 173, 41, 1),
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '资金方',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xffffffff),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ), //资金方
                                    ],
                                  ), //4455-资金方
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      top: 2,
                                      bottom: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 165, 49, 1),
                                      borderRadius: BorderRadius.circular(11),
                                      border: Border.all(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.15),
                                          width: 1,
                                          style: BorderStyle.solid),
                                    ),
                                    child: Text(
                                      '${account != null ? account : ''}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFFFFEFE),
                                        fontWeight: FontWeight.w400,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ), //号码
                                ],
                              ), //资金方- 号码
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 24,
                              right: 11,
                              top: 3,
                              bottom: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 165, 49, 1),
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                  color: Color.fromRGBO(255, 255, 255, 0.1),
                                  width: 1,
                                  style: BorderStyle.solid),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '$certificationText',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFFFFEFE),
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.none,
                                  ),
                                ), //已实名
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width: 6,
                                  height: 9,
                                  child: Image.asset(
                                      'assets/images/capital/arrowmore_wbig.png'),
                                ), //>
                              ],
                            ),
                          ), //right
                        ],
                      ),
                    ),
                  ),
                  Column(
                    //收入余额
                    children: <Widget>[
                      Text(
                        '${money.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 30,
                          color: Color(0xFFffffff),
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Container(
                        // height: 14,
                        alignment: Alignment.center,
                        child: Text(
                          '收入余额(元)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFffffff),
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ), //收入余额
                    ],
                  ), //第二行
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          left: 50,
                          right: 10,
                        ),
                        width: MediaQuery.of(context).size.width / 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '${myAuthMoney.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFffffff),
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '我的资金',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFFffffff),
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  width: 40,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/capital/xiugai.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: MaterialButton(
                                    minWidth: 0,
                                    padding: EdgeInsets.all(0),
                                    child: Text(
                                      '修改',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFff0000),
                                        fontWeight: FontWeight.w400,
                                        decoration: TextDecoration.none,
                                      ),
                                      // textAlign: TextAlign.justify,r
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) =>
                                            _capitalChange(context, basisBloc),
                                      ).then(
                                        (_) {
                                          if (applocationBloc.backType == 1) {
                                            Future.delayed(new Duration(
                                                    milliseconds: 100))
                                                .then((_) {
                                              basisBloc.getUserInfo();
                                            });
                                          }
                                        },
                                      );
                                      applocationBloc.backType = 0;
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 30),
                        width: MediaQuery.of(context).size.width / 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '${remainAuthMoney.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFffffff),
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            Text(
                              '资金余额',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFffffff),
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xfff2f2f2),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    //可提现
                    height: 50,
                    padding: EdgeInsets.only(
                      left: 16,
                      top: 14,
                      bottom: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1.0,
                          style: BorderStyle.solid,
                          color: Color(0xfff2f2f2),
                        ),
                      ),
                      color: Color(0xffffffff),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Image.asset('assets/images/capital/ketixian.png'),
                              SizedBox(
                                width: 11,
                              ),
                              Text(
                                '可提现(元)',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF212121),
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '${withdraw.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF212121),
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              width: 9,
                            ),
                            Container(
                              width: 48,
                              height: 20,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/capital/bg.png"),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                ),
                              ),
                              child: FlatButton(
                                padding: EdgeInsets.all(0),
                                child: Text(
                                  '去提现',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                onPressed: () {
                                  withdrawBloc.getWithdrawInfos();
                                },
                              ),
                            ),
                          ],
                        ),
                        // ),
                      ],
                    ),
                  ), //1
                  Container(
                    //不可提现
                    height: 50,
                    padding: EdgeInsets.only(
                      left: 16,
                      top: 14,
                      bottom: 12,
                      right: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1.0,
                          style: BorderStyle.solid,
                          color: Color(0xfff2f2f2),
                        ),
                      ),
                      color: Color(0xffffffff),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                  'assets/images/capital/jinzhitixian.png'),
                              SizedBox(
                                width: 11,
                              ),
                              Text(
                                '不可提现(元)',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF212121),
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${unavailable.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ), //2
                  Container(
                    //明细
                    height: 50,
                    color: Color(0xffffffff),
                    child: FlatButton(
                      padding: EdgeInsets.only(
                        right: 16,
                        left: 17,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/capital/mingxi.png',
                                width: 20,
                                height: 20,
                              ),
                              SizedBox(
                                width: 13,
                              ),
                              Text(
                                '明细',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF212121),
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 10,
                            height: 17,
                            child: Image.asset(
                                'assets/images/capital/navergitor.png'),
                          )
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => DetailListPage(),
                          ),
                        );
                      },
                    ),
                  ), //3
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    //我的管理师
                    height: 50,
                    color: Color(0xffffffff),
                    child: FlatButton(
                      padding: EdgeInsets.only(
                        right: 16,
                        left: 17,
                      ),
                      onPressed: () {
                        applocationBloc.personalBackType = 0;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                MyApplicationPage(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '我的管理师',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF212121),
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Container(
                            width: 10,
                            height: 17,
                            child: Image.asset(
                                'assets/images/capital/navergitor.png'),
                          ),
                        ],
                      ),
                    ),
                  ), //4
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    //我的POS机
                    height: 50,
                    color: Color(0xffffffff),
                    child: FlatButton(
                      padding: EdgeInsets.only(
                        right: 17,
                        left: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '我的POS机',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF212121),
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Container(
                            width: 10,
                            height: 17,
                            child: Image.asset(
                                'assets/images/capital/navergitor.png'),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => MinePOSPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    //我的银行卡
                    height: 50,
                    color: Color(0xffffffff),
                    child: FlatButton(
                      padding: EdgeInsets.only(
                        left: 17,
                        right: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '我的银行卡',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF212121),
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Container(
                            width: 10,
                            height: 17,
                            child: Image.asset(
                                'assets/images/capital/navergitor.png'),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => MineBankCard(),
                          ),
                        );
                      },
                    ),
                  ), //6
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
