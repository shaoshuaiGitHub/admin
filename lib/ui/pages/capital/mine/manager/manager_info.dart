import 'package:flutter/material.dart';
import 'package:youxinbao/common/screen.dart';
import 'package:youxinbao/res/res_index.dart';

class ManagerInfo extends StatefulWidget {
  var account;
  final String sex;
  final String provinces;
  final String city;
  final int UID;
  var cardId;
  final String tips;
  final int age;
  final int workAge;
  final int masterLevel;
  final String icon;
  final String cardA;
  final String cardB;
  ManagerInfo({
    Key key,
    @required this.account,
    @required this.sex,
    @required this.provinces,
    @required this.city,
    @required this.UID,
    @required this.cardId,
    @required this.tips,
    @required this.age,
    @required this.workAge,
    @required this.masterLevel,
    @required this.icon,
    @required this.cardA,
    @required this.cardB,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ManagerInfo();
}

class _ManagerInfo extends State<ManagerInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.background_color,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colours.capital_color,
        title: Text(
          '管理师个人信息',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeights.bold,
          ),
        ),
      ),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          ManagerHead(
            account: widget.account,
            icon: widget.icon,
          ),
          ManageMiddle(
            account: widget.account,
            tips: widget.tips,
            sex: widget.sex,
            provinces: widget.provinces,
            city: widget.city,
            UID: widget.UID,
            cardId: widget.cardId,
            age: widget.age,
            workAge: widget.workAge,
            masterLevel: widget.masterLevel,
            cardA: widget.cardA,
            cardB: widget.cardB,
          ),
        ],
      ),
    );
  }
}

class ManagerHead extends StatelessWidget {
  var account;
  final String icon;
  ManagerHead({
    Key key,
    @required this.account,
    @required this.icon,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      color: Color(0xFFFF9B1A),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 68,
            height: 68,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: FadeInImage.assetNetwork(
                placeholder: "assets/images/user/head_default.jpeg",
                image: icon,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: 38,
            child: Center(
              child: Text(
                '账号：$account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeights.medium,
                  color: Color(0xFFF2F2F2),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class ManageMiddle extends StatelessWidget {
  var account;
  final String sex;
  final String provinces;
  final String city;
  final int UID;
  var cardId;
  final String tips;
  final int age;
  final int workAge;
  final int masterLevel;
  final String cardA;
  final String cardB;
  ManageMiddle({
    Key key,
    @required this.account,
    @required this.sex,
    @required this.provinces,
    @required this.city,
    @required this.UID,
    @required this.cardId,
    @required this.tips,
    @required this.age,
    @required this.workAge,
    @required this.masterLevel,
    @required this.cardA,
    @required this.cardB,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          MediaQuery.of(context).size.height - 195 - Screen.bottomSafeHeight,
      child: ListView(
        physics: new BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
              top: 10,
            ),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Color(0xFFE6E6E6),
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 17,
                              height: 17,
                              child: Center(
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/capital/sex.png'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 30,
                              child: Center(
                                child: Text(
                                  '性别',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeights.medium,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Center(
                          child: Text(
                            '$sex',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeights.medium,
                              color: Color(0xFF212121),
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
                    left: 16,
                    right: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Color(0xFFE6E6E6),
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 17,
                              height: 17,
                              child: Center(
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/capital/year.png'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 30,
                              child: Center(
                                child: Text(
                                  '年龄',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeights.medium,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Center(
                          child: Text(
                            '$age',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeights.medium,
                              color: Color(0xFF212121),
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
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 17,
                              height: 17,
                              child: Center(
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/capital/position.png'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 30,
                              child: Center(
                                child: Text(
                                  '所在地',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeights.medium,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Center(
                          child: Text(
                            '$provinces $city',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeights.medium,
                              color: Color(0xFF212121),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 10,
            ),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Color(0xFFE6E6E6),
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 17,
                              height: 17,
                              child: Center(
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/capital/name.png'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 30,
                              child: Center(
                                child: Text(
                                  '实名认证',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeights.medium,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Center(
                          child: Text(
                            '$tips',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeights.medium,
                              color: Color(0xFF212121),
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
                    left: 16,
                    right: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Color(0xFFE6E6E6),
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 17,
                              height: 17,
                              child: Center(
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/capital/tel.png'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 30,
                              child: Center(
                                child: Text(
                                  '手机号',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeights.medium,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Center(
                          child: Text(
                            '${account != null ? account : ''}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeights.medium,
                              color: Color(0xFF212121),
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
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 17,
                              height: 17,
                              child: Center(
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/capital/uid.png'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 30,
                              child: Center(
                                child: Text(
                                  'UID',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeights.medium,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Center(
                          child: Text(
                            '$UID',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeights.medium,
                              color: Color(0xFF212121),
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
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 17,
                              height: 17,
                              child: Center(
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/capital/year.png'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 30,
                              child: Center(
                                child: Text(
                                  '工龄',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeights.medium,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Center(
                          child: Text(
                            '$workAge天',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeights.medium,
                              color: Color(0xFF212121),
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
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 17,
                              height: 17,
                              child: Center(
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/capital/level.png'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 30,
                              child: Center(
                                child: Text(
                                  '管理师等级',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeights.medium,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Center(
                          child: Text(
                            '高级管理师',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeights.medium,
                              color: Color(0xFF212121),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 10,
            ),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 17,
                              height: 17,
                              child: Center(
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/capital/card.png'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 30,
                              child: Center(
                                child: Text(
                                  '身份证号',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeights.medium,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Center(
                          child: Text(
                            '${cardId != null ? cardId : ''}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeights.medium,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 143,
            color: Colors.white,
            padding: const EdgeInsets.only(
              left: 16,
            ),
            margin: const EdgeInsets.only(
              top: 10,
              bottom: 20,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: 46,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '身份证正反面',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeights.medium,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 84,
                        height: 60,
                        decoration: BoxDecoration(
                              border: Border.all(
                                width: 2.5,
                                color: Color(0xFFE6E6E6),
                                style: BorderStyle.solid,
                              ),
                            ),
                        // child: ClipRRect(
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/user/card_default.jpeg",
                            image: cardA,
                            fit: BoxFit.cover,
                          ),
                        // ),
                      ),
                      Container(
                        width: 84,
                        height: 60,
                        decoration: BoxDecoration(
                              border: Border.all(
                                width: 2.5,
                                color: Color(0xFFE6E6E6),
                                style: BorderStyle.solid,
                              ),
                            ),
                        // child: ClipRRect(
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/user/card_default.jpeg",
                            image: cardB,
                            fit: BoxFit.cover,
                          ),
                        // ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
