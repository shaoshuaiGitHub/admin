import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:youxinbao/blocs/manager/mine/masterhistory_bloc.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/widgets/expansion_panel.dart';
import '../../../../ui/widgets/expand_icon.dart';

class HistoryMiddle extends StatefulWidget {
  @override
  State<HistoryMiddle> createState() => _HistoryMiddle();
}

class _HistoryMiddle extends State<HistoryMiddle> {
  bool isLock = false;
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  num totalRepayMoney = 0;
  num totalPosMoney = 0;
  List myPlanList = List();

  bool isOpen = true;
  int loadType = 0;
  void changeValue(val) {
    this.setState(() {
      isOpen = true;
      loadType = 2;
    });
  }

  void updatePlan(val) {
    this.setState(() {
      isOpen = val;
      loadType = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    MasterHistoryBloc masterHistoryBloc =
        BlocProvider.of<MasterHistoryBloc>(context);
    masterHistoryBloc.bloccontext = context;
    // if (!isLock) {
    //   Future.delayed(new Duration(milliseconds: 500)).then((_) {
    //     masterHistoryBloc.getMasterHistoryDatas(0);
    //   });
    // }
    if (isOpen) {
      Future.delayed(new Duration(milliseconds: 500)).then((_) {
        masterHistoryBloc.getMasterHistoryDatas(loadType);
      });
      isOpen = false;
    }

    return EasyRefresh(
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
            padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            color: Colours.background_f2,
            child: StreamBuilder(
              stream: masterHistoryBloc.myHistoryDataStream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                myPlanList = snapshot.data;
                return MyList(myHistoryList: myPlanList);
              },
            ),
          ),
        ],
      ),
      onRefresh: () async {
        this.setState(() {
          isOpen = true;
          loadType = 2;
        });
      },
      loadMore: () async {
        this.setState(
          () {
            isOpen = true;
            loadType = 1;
          },
        );
      },
      // loadMore: () async {
      //   // await Future.delayed(const Duration(seconds: 1), () {});
      // },
    );
  }
}

class MyList extends StatefulWidget {
  final List myHistoryList;
  MyList({Key key, @required this.myHistoryList}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MyList(); 
}

class _MyList extends State<MyList> {
  Container _expansionPanelList;
  var currentPanelIndex = 0; // -1默认全部闭合
  @override
  Widget build(BuildContext context) {
    return widget.myHistoryList.length > 0
        ? buildPlanOrderList(widget.myHistoryList)
        : Container();
  }

  Widget buildPlanOrderList(List myHistoryList) {
    _expansionPanelList = Container(
      width: Screen.width,
      height: Screen.height - 60 - Screen.bottomTabBarHeight,
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.elliptical(5, 5))),
      child: SingleChildScrollView(
        child: ExpansionPanelCustomList(
          animationDuration: Duration(milliseconds: 500),
          expansionCallback: (panelIndex, isExpanded) {
            setState(() {
              // planBloc.selPanel = true;
              currentPanelIndex =
                  (currentPanelIndex != panelIndex) ? panelIndex : -1;
            });
          },
          parms: {
            'type': 'custom',
            'backgroundcolor': 0xffff7200,
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
          headerBuilder: (context, isExpanded) {
            return Container(
              margin: EdgeInsets.only(left: 20),
              height: 44,
              padding: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  // color: Colours.orange_72,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.elliptical(5, 5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('客户：${dataItem.name}',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                  Row(
                    children: <Widget>[
                      Text('代管类型：${dataItem.delegateType == 1 ? '单次代还' : dataItem.delegateType == 2 ? '精养代操' : dataItem.delegateType == 3 ? '提额代操' : '未代管'}',
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                    ],
                  )
                ],
              ),
            );
          },
          body: Container(
            decoration: BoxDecoration(
              color: Colours.background_f2,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  // color: Colors.white,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0x40FF7200))),
                  // height: 300,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colours.bottom_line))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                                '类型:${dataItem.planType == 1 ? '消费计划' : '还款计划'}',
                                style: TextStyle(
                                    fontSize: 14, color: Colours.gray_66)),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text('${dataItem.start}',
                                    style: TextStyle(
                                        fontSize: 14, color: Colours.gray_21)),
                                Text('${dataItem.end}',
                                    style: TextStyle(
                                        fontSize: 14, color: Colours.gray_21)),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colours.bottom_line))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 20,
                                  height: 20,
                                  margin: EdgeInsets.only(right: 5),
                                 child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                        "assets/images/user/card_default.jpeg",
                                    image: '${dataItem.icon}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${dataItem.bankName}',
                                      style: TextStyle(
                                          fontSize: 12, color: Colours.gray_66),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      '${dataItem.cardNo}',
                                      style: TextStyle(
                                          fontSize: 10, color: Colours.gray_66),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                    '${dataItem.planType == 1 ? '计划消费' : '计划还款'}',
                                    style: TextStyle(
                                        fontSize: 12, color: Colours.gray_66)),
                                SizedBox(
                                  height: 2,
                                ),
                                Text('${dataItem.minMoney.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: 12, color: Colours.gray_21)),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colours.bottom_line))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('${dataItem.planType == 1 ? '消费状态' : '计划状态'}',
                                style: TextStyle(
                                    fontSize: 14, color: Colours.gray_66)),
                            Text('${dataItem.status == 1 ? '待消费' : dataItem.status == 2 ? '待还款' : dataItem.status == 3 ? '待确认' : dataItem.status == 4 ? (dataItem.planType == 1 ? '已消费成功' : '已还款成功') : '问题订单'} ',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.red)),
                            // Text('未还款',
                            //     style:
                            //         TextStyle(fontSize: 12, color: Colours.gray_66)),
                          ],
                        ),
                      ),
                      Offstage(
                        offstage: dataItem.planType != 2,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colours.bottom_line))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('实际还款',
                                  style: TextStyle(
                                      fontSize: 14, color: Colours.gray_66)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                      '${dataItem.realMoney.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colours.gray_21)),
                                  Text('更新时间:${dataItem.updateTime}',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colours.gray_66)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Offstage(
                        offstage: dataItem.planType != 2,
                        child: Container(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('用户扣款金额',
                                  style: TextStyle(
                                      fontSize: 14, color: Colours.gray_66)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text('${dataItem.payment.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colours.gray_21)),
                                  Text('更新时间:${dataItem.updateTime}',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colours.gray_66)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Offstage(
                  offstage: dataItem.planType != 1,
                  child: Container(
                    // margin: EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                      color: Colours.gray_cc,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'POS机名：${dataItem.posName}',
                                style: TextStyle(
                                    fontSize: 14, color: Colours.gray_66),
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    '收款金额：',
                                    style: TextStyle(
                                        fontSize: 14, color: Colours.gray_21),
                                  ),
                                  Text(
                                    '${dataItem.realMoney.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.red),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'POS利率：${dataItem.posRate}%',
                                style: TextStyle(
                                    fontSize: 14, color: Colours.gray_66),
                              ),
                              Text(
                                '收款日期：${dataItem.updateTime}',
                                style: TextStyle(
                                    fontSize: 10, color: Colours.gray_21),
                              ),
                            ],
                          ),
                          Container(
                            height: 1,
                            color: Colours.gray_66,
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: <Widget>[
                          //     Text(
                          //       '对账时间：2019-05-01 15：10',
                          //       style: TextStyle(
                          //           fontSize: 12, color: Colours.gray_21),
                          //     )
                          //   ],
                          // )
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
