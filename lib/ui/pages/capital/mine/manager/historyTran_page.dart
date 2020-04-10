import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:youxinbao/common/component_index.dart';
import '../../../../../ui/widgets/expansion_panel.dart';

class HistoryTranPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HistoryTranPage();
  }
}

class _HistoryTranPage extends State<HistoryTranPage> {
  var currentPanelIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ManagerBloc>(
      bloc: ManagerBloc(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            '历史往来',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color(0xffff9b1a),
        ),
        body: HistoryMiddle(),
      ),
    );
  }
}

class HistoryMiddle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HistoryMiddle();
}

class _HistoryMiddle extends State<HistoryMiddle> {
  bool isLock = false;
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  List myHistoryList = List();
  @override
  Widget build(BuildContext context) {
    ManagerBloc managerBloc = BlocProvider.of<ManagerBloc>(context);
    managerBloc.bloccontext = context;
    if (!isLock) {
      Future.delayed(new Duration(milliseconds: 100)).then((_) {
        managerBloc.getMasterHistory(true);
      });
      isLock = true;
    } else {
      if (managerBloc.historyDataList.length == 0) {
        Future.delayed(new Duration(milliseconds: 10)).then((_) {
          managerBloc.getMasterHistory(false);
        });
      }
    }

    return Stack(
      children: <Widget>[
        EasyRefresh(
          key: _easyRefreshKey,
          refreshHeader: MaterialHeader(
            key: _headerKey,
          ),
          refreshFooter: MaterialFooter(
            key: _footerKey,
          ),
          child: ListView(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height - 163,
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 10,
                  bottom: 10,
                ),
                color: Color(0xfff2f2f2),
                child: MyList(),
              ),
            ],
          ),
          onRefresh: () async {
            managerBloc.getMasterHistory(true);
          },
          // loadMore: () async {
          //   // await Future.delayed(const Duration(seconds: 1), () {});
          // },
        ),
        Positioned(
          child: Container(
            height: 92,
            color: Color(0xffFF9B1A),
            child: Column(
              children: <Widget>[
                Container(
                  height: 46,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        style: BorderStyle.solid,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 12,
                    bottom: 12,
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '总共还款： ',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff212121)),
                      ),
                      StreamBuilder(
                        stream: managerBloc.repayMoneyStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<num> snapshot) {
                          return Text(
                            '${(snapshot.hasData && snapshot.data != null) ? snapshot.data.toStringAsFixed(2) : '-----'}',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffff0000)),
                          );
                        },
                      ),
                      Text(
                        '元',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff212121)),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 46,
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 12,
                    bottom: 12,
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'POS机总还款： ',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff212121)),
                      ),
                      StreamBuilder(
                        stream: managerBloc.totalPosMoneyStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<num> snapshot) {
                          return Text(
                            '${(snapshot.hasData && snapshot.data != null) ? snapshot.data.toStringAsFixed(2) : '-----'}',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffff0000)),
                          );
                        },
                      ),
                      Text(
                        '元',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff212121)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          left: 0,
          right: 0,
          bottom: 0,
        ),
      ],
    );
  }
}

class MyList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyList();
}

class _MyList extends State<MyList> {
  List myHistoryList = List();
  Container _expansionPanelList;
  var currentPanelIndex = 0; // -1默认全部闭合
  @override
  Widget build(BuildContext context) {
    ManagerBloc managerBloc = BlocProvider.of<ManagerBloc>(context);
    return StreamBuilder(
      stream: managerBloc.outMasterHistory,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          myHistoryList = snapshot.data;
        }
        return myHistoryList.length > 0
            ? buildPlanOrderList(myHistoryList)
            : Container();
      },
    );
  }

  Widget buildPlanOrderList(List myHistoryList) {
    _expansionPanelList = Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      child: SingleChildScrollView(
        child: ExpansionPanelCustomList(
          animationDuration: Duration(milliseconds: 100),
          expansionCallback: (panelIndex, isExpanded) {
            setState(() {
              // planBloc.selPanel = true;
              currentPanelIndex =
                  (currentPanelIndex != panelIndex) ? panelIndex : -1;
            });
          },
          parms: {
            'type': 'custom',
            'backgroundcolor': 0xffff9b1a,
            'iconcolor': 0xffffffff
          },
          children: buildPlanListView(myHistoryList),
        ),
      ),
    );
    return _expansionPanelList;
  }

  List<ExpansionPanelCustom> buildPlanListView(myHistoryList) {
    List<ExpansionPanelCustom> planList = List<ExpansionPanelCustom>();
    for (int i = 0; i < myHistoryList.length; i++) {
      var dataItem = myHistoryList[i];
      planList.add(
        ExpansionPanelCustom(
          headerBuilder: (context, isExpended) {
            return Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 10,
                bottom: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '客户: ${dataItem.name}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffffffff)),
                      ),
                      Row(
                        children: <Widget>[
                          Text('代管类型：${dataItem.delegateType == 1 ? '单次代还' : dataItem.delegateType == 2 ? '精养代操' : dataItem.delegateType == 3 ? '提额代操' : '未代管'}',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white)),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            );
          },
          body: Container(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.1,
                      color: Color(0xffff9b1a),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '类型:${dataItem.planType == 1 ? '消费计划' : '还款计划'}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff666666)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${dataItem.start}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff212121),
                                  ),
                                ),
                                Text(
                                  '${dataItem.end}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff212121),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),

                      Container(
                        // height: 52,
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 20,
                                    height: 20,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: FadeInImage.assetNetwork(
                                        placeholder:
                                            "assets/images/user/card_default.jpeg",
                                        image: dataItem.icon,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${dataItem.bankName}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff666666)),
                                      ),
                                      Text(
                                        '${dataItem.bankNo}',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff666666)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  '${dataItem.planType == 1 ? '计划消费' : '计划还款'}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff666666)),
                                ),
                                Text(
                                  '${dataItem.minMoney.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff212121)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Container(
                        height: 50,
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '计划状态',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff666666)),
                            ),
                            Text(
                              '${dataItem.status == 1 ? '待消费' : dataItem.status == 2 ? '待还款' : dataItem.status == 3 ? '待确认' : dataItem.status == 4 ? (dataItem.planType == 1 ? '已消费成功' : '已还款成功') : '问题订单'} ',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffff0000)),
                            )
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Color(0xffE5E5E5),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '${dataItem.planType == 1 ? '实际消费' : '实际还款'}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff666666),
                              ),
                            ),
                            dataItem.planType == 1
                                ? Text(
                                    '${dataItem.realMoney.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff212121),
                                    ),
                                  )
                                : Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          '${dataItem.realMoney.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff212121),
                                          ),
                                        ),
                                        Text(
                                          '更新时间:${dataItem.updateTime}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Offstage(
                        offstage: dataItem.planType != 2,
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    '用户扣费情况:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff666666),
                                    ),
                                  ),
                                  Text(
                                    '${dataItem.paymentStatus == 1 ? '已扣款' : '未扣款'}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xffff0000),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    '用户扣费金额:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff212121),
                                    ),
                                  ),
                                  Text(
                                    '${dataItem.payment.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xffff0000),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ), //L
                    ],
                  ),
                ),
                Offstage(
                  offstage: dataItem.planType != 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xfff2f2f2),
                    ),
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xffcccccc),
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'POS机名:${dataItem.posName}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff666666),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'POS机利率: ${dataItem.posRate}%',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff666666),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '收款金额:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff666666),
                                    ),
                                  ),
                                  Text(
                                    ' ${dataItem.realMoney.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xfff35050),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    '实际收款: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff212121),
                                    ),
                                  ),
                                  Text(
                                    ' ${dataItem.posRealMoney.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xfff35050),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                '返还POS机费用：${dataItem.posPayment.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff212121),
                                ),
                              ),
                            ],
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: <Widget>[
                          //     Text(
                          //       '对账日期：2019-03-21 16:33',
                          //       style: TextStyle(
                          //         fontSize: 10,
                          //         fontWeight: FontWeight.w400,
                          //         color: Color(0xff666666),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 1,
                            color: Color(0xff666666),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'POS机收款卡：${dataItem.cardNo}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff212121),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '收款卡余额：${dataItem.remainMoney.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff212121),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isExpanded: currentPanelIndex == i,
        ),
      );
    }
    return planList;
  }
}
