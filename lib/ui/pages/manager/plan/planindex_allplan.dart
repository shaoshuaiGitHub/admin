import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import 'package:youxinbao/blocs/bloc_provider.dart';
import '../../../../ui/widgets/expansion_panel.dart';

import 'package:event_bus/event_bus.dart';

EventBus eventBuses = new EventBus();

class WholeExpanded {
  bool isExpanded;
  WholeExpanded(this.isExpanded);
}

class WholePanel {
  bool setPanel;
  WholePanel(this.setPanel);
}

class BackControl {
  bool isBack;
  BackControl(this.isBack);
}

//整体计划
class AllPlanIndexContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AllPlanIndexContent();
  }
}

class _AllPlanIndexContent extends State<AllPlanIndexContent>
    with AutomaticKeepAliveClientMixin {
  bool isBack = false;
  bool inPage = true;
  bool isWholeExpanded = false;
  int loadType = 0;
  bool isWholeOpen = true;
  String condition =
      '{"startTime":"${DateTime.now().add(Duration(days: -6)).toString().substring(0, 11)}00:00:00","endTime":"${DateTime.now().toString().substring(0, 11)}23:59:59"}';

  void changeValue(val) {
    condition = val;
  }

  void initState() {
    super.initState();
    eventBuses.on<WholeExpanded>().listen(
      (event) {
        if (mounted) {
          isWholeExpanded = event.isExpanded;
        }
      },
    );

    eventBuses.on<GetOpen>().listen(
      (event) {
        if (mounted) {
          isWholeOpen = event.isOpen;
        }
      },
    );

    eventBuses.on<BackControl>().listen(
      (event) {
        if (mounted) {
          isBack = event.isBack;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    AllPlanListBloc allPlanListBloc = BlocProvider.of<AllPlanListBloc>(context);
    allPlanListBloc.bloccontext = context;
    if (isWholeOpen) {
      Future.delayed(new Duration(milliseconds: 500)).then((_) {
        allPlanListBloc.getAllplanList(
            condition, loadType, isBack, isWholeExpanded);
      });
      isWholeOpen = false;
    }
    return Container(
      padding: EdgeInsets.only(bottom: 50),
      child: Stack(
        children: <Widget>[
          MyWholeList(condition: condition, loadType: loadType),
          Positioned(
            child: GestureDetector(
              child: Container(
                width: Screen.width,
                height: 28,
                color: Color(0xFFF2F2F2),
                padding: const EdgeInsets.only(
                  right: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 16,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/manager/filtrate_icon.png',
                            width: 13,
                            height: 13,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('筛选', style: TextStyles.text13MediumLabel),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PlanFilterDateAlert(
                      tabIndex: 0,
                      allplanBloc: allPlanListBloc,
                      callback: (val) => changeValue(val),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MyWholeList extends StatefulWidget {
  final String condition;
  final int loadType;
  MyWholeList({Key key, @required this.condition, @required this.loadType})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _MyWholeList();
}

class _MyWholeList extends State<MyWholeList> {
  bool isHwolePanel = false;
  bool isAllExpanded = false;
  List myPlanList = List();
  Container _expansionPanelList;
  var currentPanelIndex = 0; // -1默认全部闭合

  void initState() {
    super.initState();
    eventBuses.on<WholePanel>().listen((event) {
      isHwolePanel = event.setPanel;
    });
  }

  @override
  Widget build(BuildContext context) {
    AllPlanListBloc allPlanListBloc = BlocProvider.of<AllPlanListBloc>(context);
    return StreamBuilder(
      stream: allPlanListBloc.allplanlistStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData && !isHwolePanel) {
          return Container();
        }
        myPlanList = snapshot.data;
        return NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollEndNotification) {
              if (notification.metrics.extentAfter == 0.0 &&
                  myPlanList.length >= 10 &&
                  allPlanListBloc.tabIndex == 0) {
                allPlanListBloc.getAllplanList(
                    widget.condition, 1, false, isAllExpanded);
                eventBuses.fire(WholePanel(false));
              }
            }
            return false;
          },
          child: ListView(
            padding: const EdgeInsets.only(
              bottom: 20,
            ),
            children: <Widget>[
              myPlanList.length > 0
                  ? buildPlanOrderList(myPlanList, allPlanListBloc,
                      widget.condition, widget.loadType)
                  : Container(),
            ],
          ),
        );
      },
    );
  }

  Widget buildPlanOrderList(
      List planListData, AllPlanListBloc allPlanListBloc, condition, loadType) {
    _expansionPanelList = Container(
      margin: const EdgeInsets.fromLTRB(0, 36, 0, 10),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.elliptical(5, 5))),
      child: SingleChildScrollView(
        child: ExpansionPanelCustomList(
          animationDuration: Duration(milliseconds: 500),
          expansionCallback: (panelIndex, isExpanded) {
            allPlanListBloc.caculateWholePlanHeight(panelIndex);
            isAllExpanded = isExpanded;
            eventBuses.fire(WholeExpanded(isExpanded));
            setState(() {
              isHwolePanel = true;
              currentPanelIndex =
                  (currentPanelIndex != panelIndex) ? panelIndex : -1;
            });
          },
          parms: {
            'type': 'custom',
            'backgroundcolor': 0xffff7200,
            'iconcolor': 0xffffffff
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
                          '客户：${dataItem.name}',
                          style: TextStyle(
                              fontSize: 14, color: Colours.white_color),
                        ),
                        Text(
                          '代管类型：${dataItem.delegateType}',
                          style: TextStyle(
                              fontSize: 14, color: Colours.white_color),
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
