import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:youxinbao/blocs/bloc_index.dart';
import 'package:youxinbao/blocs/capital/manage/plan_bloc.dart';
import 'package:youxinbao/common/component_index.dart';
import 'package:youxinbao/models/model_index.dart';
import 'package:youxinbao/res/colors.dart';
import 'manage_detail.dart';
import '../../../widgets/expansion_panel.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:event_bus/event_bus.dart';

EventBus eventBus = new EventBus();

class OpenStatusEvent {
  OpenStatusEvent();
}

class AddManageWhole extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddManageWhole();
}

class _AddManageWhole extends State<AddManageWhole>
    with AutomaticKeepAliveClientMixin {
  bool isOpen = true;
  int loadType = 0;
  bool isBack = false;
  DateTime defaultFirstDate = DateTime.now().subtract(Duration(days: 6));
  DateTime defaultLastDate = DateTime.now();
  String dateTime =
      '{"startTime":"${DateTime.now().add(Duration(days: -6)).toString().substring(0, 11)}00:00:00","endTime":"${DateTime.now().toString().substring(0, 11)}23:59:59"}';
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  void updatePlan(val) {
    this.setState(() {
      isOpen = val;
      loadType = 2;
    });
  }

  void initState() {
    super.initState();
    eventBus.on<OpenStatusEvent>().listen(
      (event) {
        if (mounted) {
          this.setState(
            () {
              isBack = true;
              isOpen = true;
              loadType = 2;
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    PlanBloc planBloc = BlocProvider.of<PlanBloc>(context);
    planBloc.bloccontext = context;
    if (isOpen) {
      Future.delayed(new Duration(milliseconds: 100)).then((_) {
        planBloc.getWholePlan(dateTime, loadType, isBack);
      });
      planBloc.selPanel = false;
      isOpen = false;
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
              MyList(
                callback: (val) => updatePlan(val),
              ),
            ],
          ),
          onRefresh: () async {
            planBloc.selPanel = false;
            planBloc.getWholePlan(dateTime, 2, false);
          },
          loadMore: () async {
            planBloc.selPanel = false;
            planBloc.getWholePlan(dateTime, 1, false);
          },
        ),
        Positioned(
          child: Container(
              width: Screen.width,
              height: 23,
              padding: const EdgeInsets.only(
                right: 16,
              ),
              color: Color(0xFFF2F2F2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 23,
                    child: MaterialButton(
                      minWidth: 0,
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        var dateTimeMap = Map();
                        String startTime = "";
                        String endTime = "";
                        DateRagePicker.showDatePicker(
                                context: context,
                                initialFirstDate: defaultFirstDate,
                                initialLastDate: defaultLastDate,
                                firstDate: new DateTime(2015),
                                lastDate: new DateTime(2020))
                            .then(
                          (val) {
                            bool isSame = false;
                            if (val != null) {
                              if (val.length == 1) {
                                planBloc.showToast('请选择一个时间范围');
                                return;
                              } else {
                                DateTime beDate =
                                    DateTime.parse(val[0].toString());
                                DateTime afDate =
                                    DateTime.parse(val[1].toString());
                                isSame = beDate
                                        .difference(afDate)
                                        .toString()
                                        .substring(0, 7) ==
                                    "0:00:00";
                                if (isSame) {
                                  startTime =
                                      beDate.toString().substring(0, 11) +
                                          '00:00:00';
                                  endTime = afDate.toString().substring(0, 11) +
                                      '23:59:59';
                                } else {
                                  startTime =
                                      beDate.toString().substring(0, 11) +
                                          '00:00:00';
                                  endTime = afDate.toString().substring(0, 11) +
                                      '23:59:59';
                                }
                                this.setState(() {
                                  defaultFirstDate = beDate;
                                  defaultLastDate = afDate;
                                });
                              }
                              dateTimeMap.addAll({
                                '"startTime"': '"$startTime"',
                                '"endTime"': '"$endTime"'
                              });
                              String newDateTime = dateTimeMap.toString();
                              dateTime = newDateTime;
                              planBloc.getWholePlan(dateTime, 2, false);
                              planBloc.selPanel = false;
                            }
                          },
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 13,
                            height: 13,
                            child: Center(
                              child: Image(
                                image: AssetImage(
                                    'assets/images/capital/screen.png'),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Container(
                            height: 23,
                            child: Center(
                              child: Text(
                                '筛选',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF212121),
                                  fontWeight: FontWeights.medium,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
          top: 32,
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MyList extends StatefulWidget {
  final callback;
  MyList({
    Key key,
    @required this.callback,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MyList();
}

class _MyList extends State<MyList> {
  List myPlanList = List();
  Container _expansionPanelList;
  var currentPanelIndex = 0; // -1默认全部闭合
  @override
  Widget build(BuildContext context) {
    PlanBloc planBloc = BlocProvider.of<PlanBloc>(context);
    return StreamBuilder(
      stream: planBloc.outWholePlan,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        if (!planBloc.selPanel) {
          myPlanList = snapshot.data;
        }
        return myPlanList.length > 0
            ? buildPlanOrderList(myPlanList, planBloc)
            : Container();
      },
    );
  }

  Widget buildPlanOrderList(List planListData, PlanBloc planBloc) {
    _expansionPanelList = Container(
      margin: const EdgeInsets.fromLTRB(0, 56, 0, 10),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
              planBloc.selPanel = true;
              currentPanelIndex =
                  (currentPanelIndex != panelIndex) ? panelIndex : -1;
            });
          },
          parms: {
            'type': 'custom',
            'backgroundcolor': 0xFFFF9B1A,
            'iconcolor': 0xffffffff,
            'iconsize': 40.0,
          },
          children: buildPlanListView(planListData),
        ),
      ),
    );
    return _expansionPanelList;
  }

  List<ExpansionPanelCustom> buildPlanListView(planListData) {
    List<ExpansionPanelCustom> planList = List<ExpansionPanelCustom>();
    for (int i = 0; i < planListData.length; i++) {
      var dataItem = planListData[i];
      planList.add(
        ExpansionPanelCustom(
          headerBuilder: (context, isExpanded) {
            return Container(
              height: 56,
              padding: const EdgeInsets.fromLTRB(11, 5, 0, 5),
              decoration: BoxDecoration(
                  color: Color(0xFFFF9B1A),
                  borderRadius: BorderRadius.circular(5)),
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '来自管理师：${dataItem.masterName}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '客户：${dataItem.ownerName}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '代管类型：${dataItem.delegateType == 0 ? '未代管' : dataItem.delegateType == 1 ? '单次代还' : dataItem.delegateType == 2 ? '精养代操' : dataItem.delegateType == 3 ? '提额代操' : '未知类型'}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          body: Container(
            child: MyDetail(
              planItem: dataItem,
              callback: widget.callback,
            ),
          ),
          isExpanded: currentPanelIndex == i,
        ),
      );
    }
    return planList;
  }
}

class MyDetail extends StatefulWidget {
  final PlanItemModel planItem;
  final callback;
  MyDetail({
    Key key,
    @required this.planItem,
    @required this.callback,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MyDetail();
}

class _MyDetail extends State<MyDetail> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.white,
      padding: const EdgeInsets.all(0),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                PlanDetail(planItem: widget.planItem),
          ),
        ).then(
          (_) {
            //是否处理订单 处理更新列表
            eventBus.fire(OpenStatusEvent());
          },
        );
      },
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(0, 6, 0, 0),
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${widget.planItem.startTime.substring(0, 16)}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF999999),
                  ),
                ),
                Text(
                  '-${widget.planItem.endTime.substring(0, 16)}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.fromLTRB(10, 0, 50, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '类型：还款计划',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeights.medium,
                    color: Color(0xFF212121),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      '计划还款',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF212121),
                      ),
                    ),
                    Text(
                      '${widget.planItem.repayMinMoney.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              height: 1,
              color: Color(0xFFE5E5E5),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 30,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/user/card_default.jpeg",
                            image: widget.planItem.icon,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${widget.planItem.bankName} ${widget.planItem.cardNo}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 146.0,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                '信用额度',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeights.medium,
                                  color: Color(0xFF212121),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Text(
                                '${widget.planItem.accLimit.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeights.medium,
                                  color: Color(0xFF999999),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                '可用额度',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeights.medium,
                                  color: Color(0xFF212121),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Text(
                                '${widget.planItem.usableMoney.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeights.medium,
                                  color: Color(0xFF999999),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              height: 1,
              color: Color(0xFFE5E5E5),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: <Widget>[
                            Text(
                              '计划状态：',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeights.medium,
                                color: Color(0xFF212121),
                              ),
                            ),
                            Text(
                              '${widget.planItem.status == -1 ? '问题订单' : widget.planItem.status == 4 ? '完成' : '待还款'}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeights.medium,
                                color: Color(0xFFFF0000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 146.0,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '实际还款：',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeights.medium,
                          color: Color(0xFF212121),
                        ),
                      ),
                      Text(
                        '${widget.planItem.status == 4 ? widget.planItem.realMoney.toStringAsFixed(2) : '-'}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeights.medium,
                          color: widget.planItem.status == 4
                              ? Color(0xFFFF0000)
                              : Color(0xFF212121),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Text(
              '更新日期：${widget.planItem.updateTime}',
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                  fontWeight: FontWeights.medium),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              height: 1,
              color: Color(0xFFE5E5E5),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: <Widget>[
                            Text(
                              '扣款情况：',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeights.medium,
                                color: Color(0xFF212121),
                              ),
                            ),
                            Text(
                              '${widget.planItem.isPayment == 0 ? '未扣款' : '已扣款'}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeights.medium,
                                color: Color(0xFFFF0000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 146.0,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '扣款金额：',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeights.medium,
                          color: Color(0xFF212121),
                        ),
                      ),
                      Text(
                        '${widget.planItem.isPayment == 0 ? '-' : widget.planItem.paymentMoney.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeights.medium,
                          color: widget.planItem.isPayment == 0
                              ? Color(0xFF212121)
                              : Color(0xFFFF0000),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
            padding: widget.planItem.isPayment == 0
                ? const EdgeInsets.fromLTRB(0, 0, 114, 6)
                : const EdgeInsets.fromLTRB(0, 0, 10, 6),
            child: Text(
              '扣款日期：${widget.planItem.isPayment == 0 ? '-' : widget.planItem.paymentTime}',
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                  fontWeight: FontWeights.medium),
            ),
          ),
        ],
      ),
    );
  }
}
