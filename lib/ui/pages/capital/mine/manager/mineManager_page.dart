import 'package:flutter/material.dart';
import 'package:youxinbao/blocs/bloc_index.dart';
import 'package:youxinbao/common/component_index.dart';
import 'package:youxinbao/models/model_index.dart';
import 'historyTran_page.dart';
import 'add_pos_page.dart';
import 'manager_info.dart';

class MineManagerPage extends StatefulWidget {
  final int id;
  MineManagerPage({Key key, @required this.id}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MineManagerPage();
}

class _MineManagerPage extends State<MineManagerPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ManagerBloc>(
      bloc: ManagerBloc(),
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          titleSpacing: 0,
          backgroundColor: Color(0xFFFF9B1A),
          centerTitle: true,
          elevation: 0.0,
          leading: MaterialButton(
            minWidth: 0,
            padding: const EdgeInsets.only(left: 7),
            child: Container(
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/capital/arrowmore_wbig_left.png',
                    width: 8,
                    height: 15,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    '返回',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            '我的管理师',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: MyMasterDetailInfo(id: widget.id),
      ),
    );
  }
}

class MyMasterDetailInfo extends StatefulWidget {
  final int id;
  MyMasterDetailInfo({Key key, @required this.id}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MyMasterDetailInfo();
}

class _MyMasterDetailInfo extends State<MyMasterDetailInfo> {
  bool isFirst = true;
  var managerName;
  var account;
  String tips = '';
  int totalRepayCount = 0;
  double totalRepayMoney = 0.0;
  double totalConsumeMoney = 0.0;
  int totalConsumeCount = 0;
  double authMoney = 0.0;
  double usableAuthMoney = 0.0;
  double totalDelegateMoney = 0.0;
  int totalDelegateCount = 0;
  List cardList = [];
  List posList = [];
  String sex = '男';
  String provinces = '福建';
  String city = '福州';
  int UID = 1002;
  var cardId;
  String cardA;
  String cardB;
  int age = 0;
  int workAge = 0;
  int masterLevel = 0;

  //解除pos确认窗口
  _removePosView(id, context, managerBloc) {
    final ApplicationBloc applocationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Color(0xFFFF9B1A),
              ),
              child: Center(
                child: Text(
                  '解除POS机',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeights.medium,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              child: Text(
                '确定要解除此POS机吗？',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF212121),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 116,
                  height: 44,
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colours.gray_cc,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: MaterialButton(
                    padding: const EdgeInsets.all(0),
                    minWidth: 0,
                    child: Center(
                      child: Text(
                        '取消',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeights.medium,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                  width: 116,
                  height: 44,
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFFF9B1A),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: MaterialButton(
                    padding: const EdgeInsets.all(0),
                    minWidth: 0,
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
                    onPressed: () {
                      managerBloc.removeMastersPos(id, widget.id);
                      applocationBloc.backType = 1;
                      Navigator.of(context).pop();
                    },
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
    final ManagerBloc managerBloc = BlocProvider.of<ManagerBloc>(context);
    managerBloc.bloccontext = context;
    if (isFirst) {
      Future.delayed(new Duration(milliseconds: 100)).then((_) {
        managerBloc.getMyMasterDetail(widget.id);
      });
      isFirst = false;
    }
    return StreamBuilder(
      stream: managerBloc.outMyMasterDetail,
      builder:
          (BuildContext context, AsyncSnapshot<MyMasterDetailModel> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        managerName = snapshot.data.name;
        account = snapshot.data.account;
        tips = snapshot.data.tips;
        totalRepayCount = snapshot.data.totalRepayCount.toInt();
        totalRepayMoney = snapshot.data.totalRepayMoney.toDouble();
        totalConsumeMoney = snapshot.data.totalConsumeMoney.toDouble();
        totalConsumeCount = snapshot.data.totalConsumeCount.toInt();
        authMoney = snapshot.data.authMoney.toDouble();
        usableAuthMoney = snapshot.data.usableAuthMoney.toDouble();
        totalDelegateMoney = snapshot.data.totalDelegateMoney.toDouble();
        totalDelegateCount = snapshot.data.totalDelegateCount.toInt();
        cardList = snapshot.data.cardList;
        posList = snapshot.data.posList;
        sex = snapshot.data.sex;
        provinces = snapshot.data.provinces;
        city = snapshot.data.city;
        UID = snapshot.data.UID;
        cardId = snapshot.data.cardId;
        cardA = snapshot.data.cardA;
        cardB = snapshot.data.cardB;
        age = snapshot.data.age;
        workAge = snapshot.data.workAge;
        masterLevel = snapshot.data.masterLevel;
        String icon = snapshot.data.icon;
        int j = 1; //POS机列表索引
        int i = 1; //卡片列表索引
        List<Widget> posListView = [];
        Widget posContainer; //POS机列表
        posList.forEach(
          (item) => {
            posListView.add(
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffcccccc),
                  borderRadius: j == posList.length
                      ? BorderRadius.only(
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        )
                      : BorderRadius.circular(0),
                ),
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '${item.alias}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff212121),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '利率: ${item.rate}%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff212121),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            height: 20,
                            width: 40,
                            child: FlatButton(
                              onPressed: () {
                                showDialog(
                                        context: context,
                                        builder: (_) => _removePosView(
                                            item.id, context, managerBloc))
                                    .then((val) {
                                  if (applocationBloc.backType == 1) {
                                    managerBloc.getMyMasterDetail(widget.id);
                                  }
                                });
                                applocationBloc.backType = 0;
                              },
                              padding: EdgeInsets.all(0),
                              child: Text(
                                '解除',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffff0000),
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
            ),
            j++
          },
        );
        posContainer = Column(
          children: posListView,
        );

        List<Widget> cardListView = [];
        Widget cardContainer; //卡片列表
        cardList.forEach(
          (item) => {
            cardListView.add(
              Container(
                padding: EdgeInsets.only(
                  top: 15,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: i == cardList.length
                        ? BorderSide.none
                        : BorderSide(
                            width: 1,
                            style: BorderStyle.solid,
                            color: Colors.orange,
                          ),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '客户姓名：${item.name != null ? item.name : '数据暂无'}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff666666),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 40,
                              height: 40,
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
                              width: 10,
                            ),
                            Text(
                              '${item.bankName != null ? item.name : '数据暂无'}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff212121),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${item.cardNo.toString().length > 4 ? item.cardNo.toString().substring(item.cardNo.toString().length - 4) : item.cardNo}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff999999),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              '信用额度：${item.accLimitMoney.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff999999),
                              ),
                            ),
                            Text(
                              '信用额度：${item.usableMoney.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff999999),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            i++
          },
        );
        cardContainer = Column(
          children: cardListView,
        );

        return Container(
          decoration: BoxDecoration(
            color: Color(0xfff2f2f2),
          ),
          child: ListView(
            padding: EdgeInsets.all(15),
            children: <Widget>[
              Container(
                //管理师姓名
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 15,
                  bottom: 15,
                ),
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.orange,
                ),
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 50,
                              height: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: FadeInImage.assetNetwork(
                                  placeholder:
                                      "assets/images/user/head_default.jpeg",
                                  image: icon,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ), //headimage
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${managerName != null ? managerName : ''}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff212121)),
                                ),
                                Text(
                                  '账号:${account != null ? account : ''}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xffffffff)),
                                ),
                              ],
                            ), //textname
                          ],
                        ),
                      ), //left
                      Container(
                        child: Row(
                          children: <Widget>[
                            Text(
                              '$tips',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffff0000)),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Container(
                              width: 7,
                              height: 13,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/capital/navergitor.png'),
                                fit: BoxFit.cover,
                              )),
                            ),
                          ],
                        ),
                      ), //right
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ManagerInfo(
                          tips: tips,
                          account: account,
                          sex: sex,
                          provinces: provinces,
                          city: city,
                          UID: UID,
                          cardId: cardId,
                          age: age,
                          workAge: workAge,
                          masterLevel: masterLevel,
                          icon: icon,
                          cardA: cardA,
                          cardB: cardB,
                        ),
                      ),
                    );
                    applocationBloc.backType = 0;
                  },
                ),
              ), //nameall
              Container(
                //历史往来
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '历史往来',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffff9b1a),
                      ),
                    ), //texthistory
                    Container(
                      child: MaterialButton(
                        minWidth: 0,
                        padding: EdgeInsets.all(0),
                        child: Text(
                          '查看详情',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffff9b1a),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  HistoryTranPage(),
                            ),
                          );
                          applocationBloc.backType = 0;
                        },
                      ),
                    ), //lookbutton
                  ],
                ),
              ), //historyall
              Container(
                //表1
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Color(0xffff9b1a),
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            style: BorderStyle.solid,
                            color: Color(0xffff9b1a),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '还款计划(笔)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff212121),
                            ),
                          ),
                          Text(
                            '$totalRepayCount',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff212121),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            style: BorderStyle.solid,
                            color: Color(0xffff9b1a),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '还款总金额(元)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff212121),
                            ),
                          ),
                          Text(
                            '${totalRepayMoney.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff212121),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            style: BorderStyle.solid,
                            color: Color(0xffff9b1a),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'POS机消费(笔)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff212121),
                            ),
                          ),
                          Text(
                            '$totalConsumeCount',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff212121),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'POS总消费(元)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff212121),
                            ),
                          ),
                          Text(
                            '${totalConsumeMoney.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff212121),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ), //L1
              SizedBox(
                height: 10,
              ),
              Container(
                //表2
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Color(0xffff9b1a),
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            style: BorderStyle.solid,
                            color: Color(0xffff9b1a),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '授信额度',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff212121),
                            ),
                          ),
                          Text(
                            '${authMoney.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff212121),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '可用授信额度',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff212121),
                            ),
                          ),
                          Text(
                            '${usableAuthMoney.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff212121),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ), //L2
              Container(
                //pos机列表
                margin: EdgeInsets.only(
                  right: 10,
                  left: 10,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 40,
                      padding: EdgeInsets.only(
                        left: 8,
                        top: 8,
                        bottom: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffff9b1a),
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            style: BorderStyle.solid,
                            color: Color(0xffff9b1a),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '他的POS机',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffffffff),
                            ),
                          ),
                          MaterialButton(
                            minWidth: 40,
                            padding: const EdgeInsets.all(0),
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/capital/add.png'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<List>(
                                  builder: (BuildContext context) => AddPosPage(
                                    posList: posList,
                                    masterId: widget.id,
                                  ),
                                ),
                              ).then(
                                (_) {
                                  if (applocationBloc.backType == 1) {
                                    isFirst = true;
                                  }
                                },
                              );
                              applocationBloc.backType = 0;
                            },
                          ),
                        ],
                      ),
                    ),
                    posContainer,
                  ],
                ),
              ), //L3
              SizedBox(
                height: 16,
              ),
              Container(
                //卡片列表头部
                height: 73,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(0xffff9b1a),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 20,
                          width: 4,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '他的卡片',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '代管总额度：${totalDelegateMoney.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffffffff),
                          ),
                        ),
                        SizedBox(
                          width: 33,
                        ),
                        Text(
                          '代管卡片(张)：$totalDelegateCount',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                //卡片列表身体
                // height: 296,
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  border: Border.all(
                      width: 1, style: BorderStyle.solid, color: Colors.orange),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: cardContainer,
              ),
            ],
          ),
        );
      },
    );
  }
}
