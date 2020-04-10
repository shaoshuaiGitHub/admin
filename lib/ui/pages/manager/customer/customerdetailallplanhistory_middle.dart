import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import '../../../../ui/widgets/expansion_panel.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';

class CustomerDetailAllplanHistoryMiddle extends StatefulWidget {
  CustomerDetailAllplanHistoryMiddle({this.userId, this.cardId});
  final int userId;
  final int cardId;
  @override
  State<StatefulWidget> createState() {
    return _CustomerDetailAllplanHistoryMiddle(userId: userId, cardId: cardId);
  }
}

class _CustomerDetailAllplanHistoryMiddle
    extends State<CustomerDetailAllplanHistoryMiddle> {
  _CustomerDetailAllplanHistoryMiddle({this.userId, this.cardId});
  // AllPlanListBloc allplanBloc = AllPlanListBloc();
  final num userId;
  final num cardId;
  String condition;

  // void initState() {
  //   super.initState();

  // Future.delayed(new Duration(milliseconds: 100)).then((_) {
  //   allplanBloc.getHistoryplanList(0, condition);
  // });
  // }

  @override
  Widget build(BuildContext context) {
    AllPlanListBloc allplanBloc = BlocProvider.of<AllPlanListBloc>(context);
    allplanBloc.bloccontext = context;

    condition =
        '{"startTime":"${DateTime.now().add(Duration(days: -6)).toString().substring(0, 11)}00:00:00","endTime":"${DateTime.now().toString().substring(0, 11)}23:59:59","status":[4,-1],"userId":$userId,"cardId":$cardId}';

    // Future.delayed(new Duration(milliseconds: 100)).then((_) {
    //   allplanBloc.getHistoryplanList(condition, 2, false);
    // });

    String planOrder = "DESC";
    void changeValue(val) {
      condition = val;
    }

    return Container(
      height: Screen.height,
      padding: EdgeInsets.only(left: 0, right: 0),
      child: Column(
        children: <Widget>[
          //历史计划头部
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    height: 32,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: '搜索',
                            contentPadding: EdgeInsets.only(left: 10),
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          textInputAction: TextInputAction.search,
                          onSubmitted: (str) {
                            String searchCondition =
                                '{"startTime":"${DateTime.now().add(Duration(days: -6)).toString().substring(0, 11)}00:00:00","endTime":"${DateTime.now().toString().substring(0, 11)}23:59:59","status":[4,-1],"userId":$userId,"cardId":$cardId,"searchStr":"$str"}';
                            Future.delayed(new Duration(milliseconds: 100))
                                .then((_) {
                              allplanBloc.getHistoryplanList(
                                  searchCondition, 2, false, true);
                            });
                          },
                          style:
                              TextStyle(color: Colours.gray_66, fontSize: 16),
                        ),
                      ],
                    )),
                Row(
                  children: <Widget>[
                    Container(
                      width: 55,
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        child: Row(
                          children: <Widget>[
                            Image.asset('assets/images/user/order_icon.png',
                                width: 18, height: 15),
                            SizedBox(
                              width: 7,
                            ),
                            Text('排序', style: TextStyles.text13MediumLabel),
                          ],
                        ),
                        onPressed: () {
                          if (planOrder == "DESC") {
                            planOrder = "ASC";
                          } else {
                            planOrder = "DESC";
                          }
                          String ordercondition =
                              '{"startTime":"${DateTime.now().add(Duration(days: -6)).toString().substring(0, 11)}00:00:00","endTime":"${DateTime.now().toString().substring(0, 11)}23:59:59","status":[4,-1],"userId":$userId,"cardId":$cardId,"order":"$planOrder"}';

                          Future.delayed(new Duration(milliseconds: 100))
                              .then((_) {
                            allplanBloc.getHistoryplanList(
                                ordercondition, 2, false, true);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 55,
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        child: Row(
                          children: <Widget>[
                            Image.asset('assets/images/user/filtrate_icon.png',
                                width: 17, height: 17),
                            SizedBox(
                              width: 7,
                            ),
                            Text('筛选', style: TextStyles.text13MediumLabel),
                          ],
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PlanFilterDateAlert(
                                  tabIndex: 1,
                                  allplanBloc: allplanBloc,
                                  userId: widget.userId,
                                  cardId: widget.cardId,
                                  callback: (val) => changeValue(val));
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          //历史计划内容
          // ListView(
          //   children: <Widget>[
          CustomerHistoryPlanContent(
              condition: condition, allPlanListBloc: allplanBloc),
          //   ],
          // ),
        ],
      ),
    );
  }
}

//历史计划内容
class CustomerHistoryPlanContent extends StatefulWidget {
  CustomerHistoryPlanContent({this.condition, this.allPlanListBloc});
  final String condition;
  final AllPlanListBloc allPlanListBloc;

  @override
  State<StatefulWidget> createState() {
    return _CustomerHistoryPlanContent();
  }
}

class _CustomerHistoryPlanContent extends State<CustomerHistoryPlanContent>
    with AutomaticKeepAliveClientMixin {
  bool isOpen = true;
  int loadType = 0;
  // String condition =
  //     '{"startTime":"${DateTime.now().add(Duration(days: -6)).toString().substring(0, 11)}00:00:00","endTime":"${DateTime.now().toString().substring(0, 11)}23:59:59","status":[4,-1]}';
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  @override
  Widget build(BuildContext context) {
    // print(widget.condition);
    super.build(context);
    // AllPlanListBloc allPlanListBloc = BlocProvider.of<AllPlanListBloc>(context);
    widget.allPlanListBloc.bloccontext = context;
    if (isOpen) {
      Future.delayed(new Duration(milliseconds: 500)).then((_) {
        widget.allPlanListBloc
            .getHistoryplanList(widget.condition, loadType, false, true);
      });
      isOpen = false;
    }
    return Container(
      height: Screen.height - 144,
      // padding: EdgeInsets.only(bottom: 50),
      child: EasyRefresh(
        key: _easyRefreshKey,
        refreshHeader: MaterialHeader(
          key: _headerKey,
        ),
        refreshFooter: MaterialFooter(
          key: _footerKey,
        ),
        child: ListView(
          children: <Widget>[
            MyCustomerHistoryList(
                condition: widget.condition,
                loadType: loadType,
                allPlanListBloc: widget.allPlanListBloc),
          ],
        ),
        // ),
        onRefresh: () async {
          widget.allPlanListBloc
              .getHistoryplanList(widget.condition, 2, false, true);
        },
        loadMore: () async {
          widget.allPlanListBloc
              .getHistoryplanList(widget.condition, 1, false, true);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MyCustomerHistoryList extends StatefulWidget {
  final String condition;
  final int loadType;
  final AllPlanListBloc allPlanListBloc;
  MyCustomerHistoryList(
      {Key key,
      @required this.condition,
      @required this.loadType,
      this.allPlanListBloc})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _MyCustomerHistoryList();
}

class _MyCustomerHistoryList extends State<MyCustomerHistoryList> {
  List myPlanList = List();
  Container _expansionPanelList;
  var currentPanelIndex = 0; // -1默认全部闭合
  @override
  Widget build(BuildContext context) {
    // AllPlanListBloc allPlanListBloc = BlocProvider.of<AllPlanListBloc>(context);
    return StreamBuilder(
      stream: widget.allPlanListBloc.historyplanlistStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        myPlanList = snapshot.data;
        return myPlanList.length > 0
            ? buildPlanOrderList(myPlanList, widget.allPlanListBloc,
                widget.condition, widget.loadType)
            : Container();
      },
    );
  }

  Widget buildPlanOrderList(
      List planListData, AllPlanListBloc allPlanListBloc, condition, loadType) {
    _expansionPanelList = Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.elliptical(5, 5))),
      child: SingleChildScrollView(
        child: ExpansionPanelCustomList(
          animationDuration: Duration(milliseconds: 500),
          expansionCallback: (panelIndex, isExpanded) {
            setState(() {
              currentPanelIndex =
                  (currentPanelIndex != panelIndex) ? panelIndex : -1;
            });
          },
          parms: {
            'type': 'custom',
            'backgroundcolor': 0xffffffff,
            'iconcolor': 0xfff999999,
            'iconsize': 36.0,
          },
          children: buildPlanListView(
              planListData, allPlanListBloc, condition, loadType),
        ),
      ),
    );
    return _expansionPanelList;
  }

  List<ExpansionPanelCustom> buildPlanListView(
      planListData, AllPlanListBloc allPlanListBloc, condition, loadType) {
    List<ExpansionPanelCustom> planList = List<ExpansionPanelCustom>();
    for (int i = 0; i < planListData.length; i++) {
      var dataItem = planListData[i];
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '代管类型：${dataItem.delegateType}',
                          style:
                              TextStyle(fontSize: 14, color: Colours.gray_21),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          body: buildPlantItem(
            context,
            dataItem.id,
            dataItem.name,
            dataItem.usableMoney,
            dataItem.startTime,
            dataItem.endTime,
            dataItem.planType,
            dataItem.delegateType,
            dataItem.minMoney,
            dataItem.maxMoney,
            dataItem.status,
            dataItem.bankName,
            dataItem.icon,
            dataItem.info,
            dataItem.realMoney,
            dataItem.accLimitMoney,
            dataItem.cardNo,
            dataItem.payment,
            dataItem.updateTime,
            dataItem.accDay,
            dataItem.accPayday,
            dataItem.paymentTime,
            allPlanListBloc,
            condition,
            loadType,
            dataItem.accDays,
            dataItem.accPaydays,
            dataItem.msg,
          ),
          isExpanded: currentPanelIndex == i,
        ),
      );
    }
    return planList;
  }
}
