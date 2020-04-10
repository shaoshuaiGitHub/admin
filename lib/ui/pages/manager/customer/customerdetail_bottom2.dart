import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import '../../../../ui/widgets/expansion_panel.dart';
import 'customer_index.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:youxinbao/blocs/bloc_index.dart';

//全部计划
@override
class AllPlanContent extends StatefulWidget {
  AllPlanContent({Key key, this.allPlanListBloc, this.userId})
      : super(key: key);
  final AllPlanListBloc allPlanListBloc;
  final num userId;
  @override
  State<StatefulWidget> createState() {
    return _AllPlanContent();
  }
}

class _AllPlanContent extends State<AllPlanContent>
    with AutomaticKeepAliveClientMixin {
  List myPlanList = List();
  Container _expansionPanelList;
  var currentPanelIndex = 0; // -1默认全部闭合

  bool isOpen = true;
  bool isBack = false;
  int loadType = 0;

  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  void changeValue(val) {
    this.setState(() {
      isOpen = true;
      loadType = 2;
    });
  }

  void initState() {
    super.initState();
    // eventBuses1.on<CustomerOpenPlanEvent>().listen(
    //   (event) {
    //     if (mounted) {
    //       this.setState(
    //         () {
    //           isBack = true;
    //           isOpen = true;
    //           loadType = 2;
    //         },
    //       );
    //     }
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // AllPlanListBloc allPlanListBloc = BlocProvider.of<AllPlanListBloc>(context);
    //BlocProvider.of<AllPlanListBloc>(context);
    widget.allPlanListBloc.bloccontext = context;

    num userId = widget.userId;
    String condition =
        '{"startTime":"${DateTime.now().add(Duration(days: -6)).toString().substring(0, 11)}00:00:00","endTime":"${DateTime.now().toString().substring(0, 11)}23:59:59"},"userId":"$userId"';
    if (isOpen) {
      Future.delayed(new Duration(milliseconds: 500)).then((_) {
        widget.allPlanListBloc
            .getAllplanList(condition, loadType, isBack, true);
      });
      isOpen = false;
    }
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Stack(alignment: FractionalOffset(0, 0), children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                height: 20,
                child: GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '查看历史计划',
                        style:
                            TextStyle(fontSize: 14, color: Colours.orange_72),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CustomerDetailAllplanHistoryPage(
                                    userId: userId)));
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          height: Screen.height -
              200 -
              Screen.navigationBarHeight -
              Screen.bottomSafeHeight,
          margin: EdgeInsets.only(top: 30),
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
                CardPlanList(condition: condition, loadType: loadType),
              ],
            ),
            onRefresh: () async {
              widget.allPlanListBloc.getAllplanList(condition, 2, false, true);
            },
            loadMore: () async {
              widget.allPlanListBloc.getAllplanList(condition, 1, false, true);
            },
          ),
        ),
      ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CardPlanList extends StatefulWidget {
  final String condition;
  final int loadType;
  CardPlanList({Key key, @required this.condition, @required this.loadType})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _CardPlanList();
}

class _CardPlanList extends State<CardPlanList> {
  List myPlanList = List();
  Container _expansionPanelList;
  var currentPanelIndex = 0; // -1默认全部闭合
  @override
  Widget build(BuildContext context) {
    AllPlanListBloc allPlanListBloc = BlocProvider.of<AllPlanListBloc>(context);

    return StreamBuilder(
      stream: allPlanListBloc.allplanlistStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        myPlanList = snapshot.data;
        return myPlanList.length > 0
            ? buildPlanOrderList(
                myPlanList, allPlanListBloc, widget.condition, widget.loadType)
            : Container();
      },
    );
  }

  Widget buildPlanOrderList(
      List planListData, AllPlanListBloc allPlanListBloc, condition, loadType) {
    _expansionPanelList = Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
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

// class _AllPlanContent extends State<AllPlanContent>
//     with AutomaticKeepAliveClientMixin {
//   var currentPanelIndex = 0; // -1默认全部闭合
//   List newlist = List();
//   List<AllplanItemModel> mylist;
//   List<int> mList;

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     // AllPlanListBloc allplanBloc = AllPlanListBloc();
//     widget.allplanBloc.bloccontext = context;
//     num userId = widget.userId;
//     String condition =
//         '{"startTime":"${DateTime.now().add(Duration(days: -6)).toString().substring(0, 11)}00:00:00","endTime":"${DateTime.now().toString().substring(0, 11)}23:59:59"},"userId":"$userId"';

//     return StreamBuilder<AllPlanListModel>(
//         stream: widget.allplanBloc.allplanlistStream,
//         builder:
//             (BuildContext context, AsyncSnapshot<AllPlanListModel> snapshot) {
//           if (!snapshot.hasData) {
//             return Container();
//           }

//           mylist = snapshot.hasData
//               ? snapshot.data.allplanList.cast<AllplanItemModel>().toList()
//               : [];

//           int n = 0;

//           return Container(
//             child: Column(
//               children: <Widget>[
//                 SizedBox(
//                   height: 10,
//                 ),
//                 GestureDetector(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: <Widget>[
//                       Text(
//                         '查看历史计划',
//                         style:
//                             TextStyle(fontSize: 14, color: Colours.orange_72),
//                       ),
//                     ],
//                   ),
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (BuildContext context) =>
//                                 CustomerDetailAllplanHistoryPage(
//                                     userId: userId)));
//                   },
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                       borderRadius:
//                           BorderRadius.vertical(top: Radius.elliptical(5, 5))),
//                   child: SingleChildScrollView(
//                       child: ExpansionPanelCustomList(
//                     animationDuration: Duration(milliseconds: 500),
//                     expansionCallback: (panelIndex, isExpanded) {
//                       setState(() {
//                         currentPanelIndex =
//                             (currentPanelIndex != panelIndex) ? panelIndex : -1;
//                       });
//                     },
//                     parms: {
//                       'type': 'custom',
//                       'backgroundcolor': 0xffffffff,
//                       'iconcolor': 0xfff999999,
//                       'iconsize': 36.0,
//                     },
//                     children: mylist.map((i) {
//                       return ExpansionPanelCustom(
//                           headerBuilder: (context, isExpanded) {
//                             return Container(
//                               margin: EdgeInsets.only(left: 20),
//                               height: 44,
//                               padding: EdgeInsets.only(right: 10),
//                               decoration: BoxDecoration(
//                                   // color: Colours.orange_72,
//                                   borderRadius: BorderRadius.vertical(
//                                       top: Radius.elliptical(5, 5))),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   Expanded(
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: <Widget>[
//                                         Text(
//                                           '代管类型：${i.delegateType}',
//                                           style: TextStyle(
//                                               fontSize: 14,
//                                               color: Colours.gray_21),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                           isExpanded: currentPanelIndex == n++,
//                           body: buildPlantItem(
//                             context,
//                             i.id,
//                             i.name,
//                             i.usableMoney,
//                             i.startTime,
//                             i.endTime,
//                             i.planType,
//                             i.delegateType,
//                             i.minMoney,
//                             i.maxMoney,
//                             i.status,
//                             i.bankName,
//                             i.icon,
//                             i.info,
//                             i.accLimitMoney,
//                             i.realMoney,
//                             i.accLimitMoney,
//                             i.cardNo,
//                             i.payment,
//                             i.updateTime,
//                             i.accDay,
//                             i.accPayday,
//                             i.paymentTime,
//                             widget.allplanBloc,
//                             condition,
//                             2
//                           ));
//                     }).toList(),
//                   )),
//                 )
//               ],
//             ),
//           );
//         });
//   }

//   @override
//   // TODO: implement wantKeepAlive
//   bool get wantKeepAlive => true;
// }
