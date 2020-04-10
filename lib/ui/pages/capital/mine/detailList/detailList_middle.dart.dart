import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:youxinbao/blocs/capital/mine/detail_bloc.dart';
import 'package:youxinbao/common/component_index.dart';
import '../../../../../ui/widgets/expansion_panel.dart';
import '../../../../../ui/widgets/flexible_panel.dart';

class DetailListMiddle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DetailListMiddle();
  }
}

class _DetailListMiddle extends State<DetailListMiddle> {
  List useDetailList = List();
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  //明细head部分
  @override
  bool isFirstClick = false; //是否点击了开始时间
  bool isLastClick = false; //是否点击了结束时间
  DateTime _defaultFirstDateTime = DateTime.now();
  DateTime _defaultLastDateTime = DateTime.now();
  DetailListBloc detailListBloc;
  void chooseDate(detailListBloc) {
    Map newDateTime = {
      '"startTime"':
          '"${_defaultFirstDateTime.toString().substring(0, 11) + '00:00:00'}"',
      '"endTime"':
          '"${_defaultLastDateTime.toString().substring(0, 11) + '23:59:59'}"',
      '"status"': '"$status"',
    };
    dateTime = newDateTime.toString();
    Future.delayed(new Duration(milliseconds: 100)).then((_) {
      detailListBloc.getDetailLists(newDateTime.toString(), 2, true);
    });
  }

  //middle
  String dateTime = '{"status":"0"}';
  bool isOpen = true;
  int status = 0;

  void _filterData(detailListBloc, newDateTime) {
    Future.delayed(new Duration(milliseconds: 100)).then((_) {
      detailListBloc.getDetailLists(newDateTime.toString(), 2, true);
    });
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc applicationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    detailListBloc = BlocProvider.of<DetailListBloc>(context);
    detailListBloc.bloccontext = context;
    if (isOpen) {
      Future.delayed(new Duration(milliseconds: 100)).then((_) {
        detailListBloc.getDetailLists(dateTime, 2, true);
      });
      isOpen = false;
    } else {
      if (detailListBloc.detailList.length == 0) {
        Future.delayed(new Duration(milliseconds: 10)).then((_) {
          detailListBloc.getDetailLists(dateTime, 2, false);
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
            padding: const EdgeInsets.only(
              top: 90,
              bottom: 160,
            ),
            children: <Widget>[
              MyList(detailListBloc: detailListBloc),
            ],
          ),
          onRefresh: () async {
            applicationBloc.expandPanel = false;
            detailListBloc.getDetailLists(dateTime, 2, true);
          },
          loadMore: () async {
            applicationBloc.expandPanel = false;
            detailListBloc.getDetailLists(dateTime, 1, true);
          },
        ),
        Positioned(
          top: 0,
          child: Column(
            children: <Widget>[
              Container(
                //head
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 8,
                ),
                width: Screen.width,
                height: 81,
                color: Color(0xfff2f2f2),
                child: Column(
                  children: <Widget>[
                    Container(
                      //分润-返还POS机费用
                      child: Row(
                        children: <Widget>[
                          StreamBuilder(
                              stream: detailListBloc.activeWardDataStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<bool> snapshot) {
                                if (snapshot.hasData) {
                                  detailListBloc.wardActive = snapshot.data;
                                }
                                return Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: detailListBloc.wardActive
                                          ? AssetImage(
                                              'assets/images/capital/check.png')
                                          : AssetImage(
                                              'assets/images/capital/checkborder.png'),
                                    ),
                                  ),
                                  child: FlatButton(
                                    onPressed: () async {
                                      int useStatus = 0;
                                      Map newDateTime;
                                      if (detailListBloc.posActive) {
                                        if (detailListBloc.wardActive) {
                                          useStatus = 1;
                                        } else {
                                          useStatus = 0;
                                        }
                                      } else {
                                        if (detailListBloc.wardActive) {
                                          useStatus = 3;
                                        } else {
                                          useStatus = 2;
                                        }
                                      }
                                      if (detailListBloc.beginTime != '' &&
                                          detailListBloc.endTime != '') {
                                        newDateTime = {
                                          '"startTime"':
                                              '"${detailListBloc.beginTime.substring(0, 11) + '00:00:00'}"',
                                          '"endTime"':
                                              '"${detailListBloc.endTime.substring(0, 11) + '23:59:59'}"',
                                          '"status"': '"$useStatus"',
                                        };
                                      } else {
                                        newDateTime = {
                                          '"status"': '"$useStatus"',
                                        };
                                      }
                                      detailListBloc.activeWardDataSink
                                          .add(!detailListBloc.wardActive);
                                      _filterData(detailListBloc, newDateTime);
                                      Future.delayed(
                                          Duration(milliseconds: 100),
                                          () async {
                                        applicationBloc.expandPanel = false;
                                      });
                                      status = useStatus;
                                      dateTime = newDateTime.toString();
                                    },
                                    padding: EdgeInsets.all(0),
                                    child: Container(),
                                  ),
                                );
                              }),
                          SizedBox(
                            width: 9,
                          ),
                          Text(
                            '分润',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff212121)),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          StreamBuilder(
                            stream: detailListBloc.activePosDataStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> snapshot) {
                              if (snapshot.hasData) {
                                detailListBloc.posActive = snapshot.data;
                              }
                              return Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: detailListBloc.posActive
                                        ? AssetImage(
                                            'assets/images/capital/check.png')
                                        : AssetImage(
                                            'assets/images/capital/checkborder.png'),
                                  ),
                                ),
                                child: FlatButton(
                                  onPressed: () async {
                                    int useStatus = 0;
                                    Map newDateTime;
                                    if (detailListBloc.wardActive) {
                                      if (detailListBloc.posActive) {
                                        useStatus = 2;
                                      } else {
                                        useStatus = 0;
                                      }
                                    } else {
                                      if (detailListBloc.posActive) {
                                        useStatus = 3;
                                      } else {
                                        useStatus = 1;
                                      }
                                    }
                                    if (detailListBloc.beginTime != '' &&
                                        detailListBloc.endTime != '') {
                                      newDateTime = {
                                        '"startTime"':
                                            '"${detailListBloc.beginTime.substring(0, 11) + '00:00:00'}"',
                                        '"endTime"':
                                            '"${detailListBloc.endTime.substring(0, 11) + '23:59:59'}"',
                                        '"status"': '"$useStatus"',
                                      };
                                    } else {
                                      newDateTime = {
                                        '"status"': '"$useStatus"',
                                      };
                                    }
                                    _filterData(detailListBloc, newDateTime);
                                    Future.delayed(Duration(milliseconds: 100),
                                        () async {
                                      applicationBloc.expandPanel = false;
                                    });
                                    detailListBloc.activePosDataSink
                                        .add(!detailListBloc.posActive);

                                    status = useStatus;
                                    dateTime = newDateTime.toString();
                                  },
                                  padding: EdgeInsets.all(0),
                                  child: Container(),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            width: 9,
                          ),
                          Text(
                            '返还POS机费用',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff212121),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      //时间选择
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 16,
                              height: 17,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/capital/joinday.png'),
                                ),
                              ),
                              child: FlatButton(
                                onPressed: () async {
                                  //时间选择器
                                  final DateTime picked = await showDatePicker(
                                    context: context,
                                    initialDate: _defaultFirstDateTime,
                                    firstDate: new DateTime(2015),
                                    lastDate: new DateTime(2020),
                                  );
                                  if (picked != null) {
                                    isFirstClick = true;
                                    detailListBloc.beginTimeDataSink
                                        .add(picked.toString());
                                    _defaultFirstDateTime = picked;
                                    if (isLastClick) {
                                      if (_defaultLastDateTime
                                          .isBefore(picked)) {
                                        detailListBloc.endTimeDataSink
                                            .add(picked.toString());
                                        _defaultLastDateTime = picked;
                                      }
                                      applicationBloc.expandPanel = false;
                                      chooseDate(detailListBloc);
                                    }
                                  }
                                },
                                child: Container(),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () async {
                                //时间选择器
                                final DateTime picked = await showDatePicker(
                                  context: context,
                                  initialDate: _defaultFirstDateTime,
                                  firstDate: new DateTime(2015),
                                  lastDate: new DateTime(2020),
                                );
                                if (picked != null) {
                                  isFirstClick = true;
                                  detailListBloc.beginTimeDataSink
                                      .add(picked.toString());
                                  _defaultFirstDateTime = picked;
                                  if (isLastClick) {
                                    if (_defaultLastDateTime.isBefore(picked)) {
                                      detailListBloc.endTimeDataSink
                                          .add(picked.toString());
                                      _defaultLastDateTime = picked;
                                    }
                                    applicationBloc.expandPanel = false;
                                    chooseDate(detailListBloc);
                                  }
                                }
                              },
                              child: Container(
                                width: 130,
                                height: 20,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Color(0xff999999),
                                    width: 0.5,
                                    style: BorderStyle.solid,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xFF999999),
                                        offset: Offset(0.5, 0.5),
                                        blurRadius: 0.5)
                                  ],
                                ),
                                child: StreamBuilder(
                                  stream: detailListBloc.beginTimeDataStream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.hasData) {
                                      detailListBloc.beginTime = snapshot.data;
                                    }
                                    return Text(
                                      detailListBloc.beginTime,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff666666),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 20,
                          height: 1,
                          color: Color(0xff999999),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 16,
                              height: 17,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/capital/joinday.png'),
                                ),
                              ),
                              child: FlatButton(
                                onPressed: () async {
                                  //时间选择器
                                  final DateTime picked = await showDatePicker(
                                      context: context,
                                      initialDate: _defaultLastDateTime,
                                      firstDate: new DateTime(2015),
                                      lastDate: new DateTime(2020));
                                  if (picked != null) {
                                    isLastClick = true;
                                    detailListBloc.endTimeDataSink
                                        .add(picked.toString());
                                    _defaultLastDateTime = picked;
                                    if (isFirstClick) {
                                      //判断点击结束时间是否在开始时间之前
                                      if (_defaultFirstDateTime
                                          .isAfter(picked)) {
                                        detailListBloc.beginTimeDataSink
                                            .add(picked.toString());

                                        _defaultFirstDateTime = picked;
                                      }
                                      applicationBloc.expandPanel = false;
                                      chooseDate(detailListBloc);
                                    }
                                  }
                                },
                                child: Container(),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () async {
                                //时间选择器
                                final DateTime picked = await showDatePicker(
                                    context: context,
                                    initialDate: _defaultLastDateTime,
                                    firstDate: new DateTime(2015),
                                    lastDate: new DateTime(2020));
                                if (picked != null) {
                                  isLastClick = true;
                                  detailListBloc.endTimeDataSink
                                      .add(picked.toString());
                                  _defaultLastDateTime = picked;
                                  if (isFirstClick) {
                                    //判断点击结束时间是否在开始时间之前
                                    if (_defaultFirstDateTime.isAfter(picked)) {
                                      detailListBloc.beginTimeDataSink
                                          .add(picked.toString());
                                      _defaultFirstDateTime = picked;
                                    }
                                    applicationBloc.expandPanel = false;
                                    chooseDate(detailListBloc);
                                  }
                                }
                              },
                              child: Container(
                                width: 130,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Color(0xff999999),
                                    width: 0.5,
                                    style: BorderStyle.solid,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xFF999999),
                                        offset: Offset(0.5, 0.5),
                                        blurRadius: 0.5)
                                  ],
                                ),
                                child: StreamBuilder(
                                  stream: detailListBloc.endTimeDataStream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.hasData) {
                                      detailListBloc.endTime = snapshot.data;
                                    }
                                    return Text(
                                      detailListBloc.endTime,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff666666),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyList extends StatefulWidget {
  final DetailListBloc detailListBloc;
  MyList({this.detailListBloc});
  @override
  State<StatefulWidget> createState() => _MyList();
}

class _MyList extends State<MyList> {
  List detailList = List();
  Container _expansionPanelList;

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc applicationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    return StreamBuilder(
      stream: widget.detailListBloc.detailListDataStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        List<Widget> planList = [];
        if (!snapshot.hasData) {
          return Container();
        }
        if (!applicationBloc.expandPanel) {
          detailList = snapshot.data;
        }
        return detailList.length > 0
            ? buildPlanOrderList(detailList, applicationBloc, planList)
            : Container();
      },
    );
  }

  Widget buildPlanOrderList(
      List detailList, ApplicationBloc applicationBloc, List<Widget> planList) {
    _expansionPanelList = Container(
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Column(
        children: bulidPlanListView(detailList, planList),
      ),
    );
    return _expansionPanelList;
  }

  List<Widget> bulidPlanListView(detailList, planList) {
    for (int i = 0; i < detailList.length; i++) {
      var dataItem = detailList[i];
      planList.add(
        FlexiblePanel(
          headerBuilder: Container(
            decoration: BoxDecoration(
              color: Colours.capital_color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
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
          ),
          index: i,
          itemCount: detailList.length,
          body: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.1,
                    color: Color(0xFFFF7200),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  color: Colors.white,
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
                                      image: '${dataItem.icon}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${dataItem.bankName}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff666666)),
                                    ),
                                    Text(
                                      '${dataItem.planCardNo.toString()}',
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
                          ),
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                      child: Column(
                        children: <Widget>[
                          Container(
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
                                      '${dataItem.paymentStatus == 1 ? dataItem.payment.toStringAsFixed(2) : '_'}',
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
                          Container(
                            padding: EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: 0.5,
                                  color: Color(0xffe5e5e5),
                                ),
                              ),
                            ),
                            alignment: Alignment.centerRight,
                            child: Text(
                              '分润金额：${dataItem.paymentStatus == 1 ? dataItem.payment : '_'}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffff9b1a),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ), //L
                  ],
                ),
              ),
              Offstage(
                //TODO
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
                              '返还POS机费用：',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff666666),
                              ),
                            ),
                            Text(
                              '${dataItem.posPayment}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffff0000),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'POS机利率: ${dataItem.posRate}%',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff666666),
                              ),
                            ),
                            Text(
                              '扣款日期： - ',
                              // '扣款日期：${dataItem.isPayment == 0 ? '-' : dataItem.paymentTime}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff212121),
                              ),
                            ),
                            // Row(
                            //   children: <Widget>[
                            //     Text(
                            //       '收款金额:',
                            //       style: TextStyle(
                            //         fontSize: 14,
                            //         fontWeight: FontWeight.w400,
                            //         color: Color(0xff212121),
                            //       ),
                            //     ),
                            //     Text(
                            //       ' ${dataItem.posPayment}',
                            //       style: TextStyle(
                            //         fontSize: 14,
                            //         fontWeight: FontWeight.w400,
                            //         color: Color(0xffff0000),
                            //       ),
                            //     ),
                            //   ],
                            // )
                          ],
                        ),
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '对账日期： - ',
                              style: TextStyle(
                                fontSize: 12,
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
              SizedBox(height: 10),
            ],
          ),
        ),
      );
    }
    return planList;
  }
}
