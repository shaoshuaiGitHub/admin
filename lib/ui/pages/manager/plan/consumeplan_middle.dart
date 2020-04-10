import 'package:flutter/material.dart';
import 'package:youxinbao/blocs/manager/plan/allplanitemdetail_bloc.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

//计划详情
class PlanConsumeMiddle extends StatefulWidget {
  PlanConsumeMiddle({Key key, this.id}) : super(key: key);
  int id;

  @override
  State<StatefulWidget> createState() => _PlanConsumeMiddle();
}

class _PlanConsumeMiddle extends State<PlanConsumeMiddle>
    with AutomaticKeepAliveClientMixin {
  bool isCheck = false;
  bool capshow = false;
  bool posshow = false;
  bool state = false;
  List<dynamic> mypos = [];
  int pushPosId;

  var consumMoneyInputCtrl = TextEditingController();
  var posInputCtrl = TextEditingController();
  var capitalInputCtrl = TextEditingController();
  var iserrorInputCtrl = TextEditingController();
  var tipsInputCtrl = TextEditingController();

  void onSelectCapital(id, name, investorList) {
    setState(() {
      mypos = [];
      capitalInputCtrl.text = name;
      capshow = !capshow;
      if (investorList.isNotEmpty) {
        for (var user in investorList) {
          if (user.id.toString() == id.toString()) {
            for (var pos in user.posInfoList) {
              Map<String, dynamic> mycard = {
                'name': pos.name,
                'id': pos.id,
                'alias': pos.alias,
              };
              mypos.add(mycard);
            }
          }
        }
      }
    });
  }

  void onSelectPos(id, name) {
    setState(() {
      posInputCtrl.text = name;
      posshow = !posshow;
      pushPosId = id;
    });
  }

  AllPlanItemDetailBloc plandetailBloc = AllPlanItemDetailBloc();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    plandetailBloc.bloccontext = context;
    final ApplicationBloc applicationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    applicationBloc.backType = 1;

    return StreamBuilder<AllplanItemDetailModel>(
        stream: plandetailBloc.plandetailStream,
        builder: (BuildContext context,
            AsyncSnapshot<AllplanItemDetailModel> snapshot) {
          List<Widget> planContainer = [];
          Widget content;

          if (!snapshot.hasData) {
            Future.delayed(new Duration(milliseconds: 500)).then((_) {
              plandetailBloc.getPlanItemDetail(widget.id);
            });
            return Container();
          }

          var name = snapshot.hasData ? snapshot.data.name : ' ';
          var usableMoney = snapshot.hasData ? snapshot.data.usableMoney : 0.00;
          var startTime = snapshot.hasData ? snapshot.data.startTime : '';
          var endTime = snapshot.hasData ? snapshot.data.endTime : '';
          var planType = snapshot.hasData ? snapshot.data.planType : '';
          var delegateType = snapshot.hasData ? snapshot.data.delegateType : '';
          var minMoney = snapshot.hasData ? snapshot.data.minMoney : 0.00;
          var maxMoney = snapshot.hasData ? snapshot.data.maxMoney : 0.00;
          var status = snapshot.hasData ? snapshot.data.status : '';
          var icon = snapshot.hasData ? snapshot.data.icon : '';
          var bankName = snapshot.hasData ? snapshot.data.bankName : '';
          var info = snapshot.hasData ? snapshot.data.info : '';
          var realMoney = snapshot.hasData ? snapshot.data.realMoney : 0.00;
          var accLimitMoney =
              snapshot.hasData ? snapshot.data.accLimitMoney : 0.00;
          var cardNo = snapshot.hasData ? snapshot.data.cardNo : 0;
          var payment = snapshot.data.payment;
          var updateTime = snapshot.data.updateTime;
          var accDay = snapshot.data.accDay;
          var accPayday = snapshot.data.accPayday;
          var accDays = snapshot.data.accDays;
          var accPaydays = snapshot.data.accPaydays;
          var id = snapshot.data.id;

          List investorList =
              snapshot.hasData ? snapshot.data.investorList : [];
          List capitallist = [];
          List poslist = [];
          for (var list in investorList) {
            Map<String, dynamic> cplist = {
              'name': list.name,
              'id': list.id,
            };
            capitallist.add(cplist);
          }

          planContainer.add(
            Container(
              margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      top: 10,
                    ),
                    child: buildPlantDetailItem(
                      context,
                      name,
                      usableMoney,
                      startTime,
                      endTime,
                      planType,
                      delegateType,
                      minMoney,
                      maxMoney,
                      status,
                      bankName,
                      icon,
                      info,
                      accLimitMoney,
                      realMoney,
                      accLimitMoney,
                      cardNo,
                      accDay,
                      accDays,
                      accPayday,
                      accPaydays,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    height: 44,
                    child: Row(
                      children: <Widget>[
                        Text(
                          '实际消费',
                          style:
                              TextStyle(fontSize: 14, color: Colours.gray_21),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            width: 220,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextField(
                                  controller: consumMoneyInputCtrl,
                                  textAlign: TextAlign.left,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: '请输入您的实际消费',
                                    contentPadding: EdgeInsets.only(left: 10),
                                    disabledBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                      color: Color(0xff282828), fontSize: 13),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    height: 44,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Text(
                                '资金方',
                                style: TextStyle(
                                    fontSize: 14, color: Colours.gray_21),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                  width: 200,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      TextField(
                                        controller: capitalInputCtrl,
                                        textAlign: TextAlign.left,
                                        enabled: false,
                                        decoration: InputDecoration(
                                          hintText: '请选择资金方对象',
                                          contentPadding:
                                              EdgeInsets.only(left: 10),
                                          disabledBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                            color: Color(0xff282828),
                                            fontSize: 13),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            capshow
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            size: 30,
                            color: Colours.gray_66,
                          ),
                          onPressed: () {
                            capshow = !capshow;
                            setState(() {
                              capshow = capshow;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CapitalList(
                    capshow: capshow,
                    capitallist: capitallist,
                    callback: (userId, name) =>
                        onSelectCapital(userId, name, investorList),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    height: 44,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Text(
                                '资金方pos机',
                                style: TextStyle(
                                    fontSize: 14, color: Colours.gray_21),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                  width: 160,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      TextField(
                                        controller: posInputCtrl,
                                        textAlign: TextAlign.left,
                                        enabled: false,
                                        decoration: InputDecoration(
                                          hintText: '请选择资金方pos机',
                                          contentPadding:
                                              EdgeInsets.only(left: 10),
                                          disabledBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                            color: Color(0xff282828),
                                            fontSize: 13),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            posshow
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            size: 30,
                            color: Colours.gray_66,
                          ),
                          onPressed: () {
                            if (capitalInputCtrl.text.length == 0) {
                              plandetailBloc.showToast('请先选择资金方对象');
                              return;
                            }
                            posshow = !posshow;
                            setState(() {
                              posshow = posshow;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  PosList(
                    posshow: posshow,
                    poslist: mypos,
                    callback: (id, name) => onSelectPos(id, name),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          setState(() {
                            isCheck = !isCheck;
                          });
                        },
                        child: Container(
                          width: 17,
                          height: 17,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Color(0xFFFF9B1A),
                          ),
                          child: isCheck
                              ? Icon(
                                  Icons.check,
                                  size: 15,
                                  color: Colors.white,
                                )
                              : Icon(
                                  Icons.check_box_outline_blank,
                                  size: 10,
                                  color: Color(0xFFFF9B1A),
                                ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '标记为问题订单',
                        style: TextStyle(fontSize: 14, color: Colours.gray_21),
                      ),
                    ],
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 85,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextField(
                            controller: tipsInputCtrl,
                            textAlign: TextAlign.left,
                            maxLines: 5,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 10, right: 10),
                              disabledBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            style: TextStyle(
                                color: Color(0xff282828), fontSize: 13),
                          ),
                        ],
                      )),
                  StreamBuilder<int>(
                      stream: plandetailBloc.consumplanStream,
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot) {
                        state = snapshot.data == Constant.SUCCESS_CODE
                            ? true
                            : false;

                        return Container(
                            margin: EdgeInsets.only(
                                bottom: 20, left: 20, right: 20, top: 50),
                            decoration: BoxDecoration(
                              color:
                                  state ? Colours.gray_99 : Colours.orange_72,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                                child: FlatButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '标记已消费成功',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                if (!state) {
                                  if (isCheck) {
                                    //是问题订单
                                    if (tipsInputCtrl.text.length == 0) {
                                      plandetailBloc.showToast('请简述问题订单原因');
                                      return;
                                    }
                                    plandetailBloc.operationErrorAction(
                                        widget.id, -1, tipsInputCtrl.text);
                                  } else {
                                    if (consumMoneyInputCtrl.text.length == 0) {
                                      plandetailBloc.showToast('请输入您的实际消费');
                                      return;
                                    }
                                    if (capitalInputCtrl.text.length == 0) {
                                      plandetailBloc.showToast('请选择资金方对象');
                                      return;
                                    }
                                    if (posInputCtrl.text.length == 0) {
                                      plandetailBloc.showToast('请选择资金方pos机');
                                      return;
                                    }

                                    plandetailBloc.operationAction(
                                        consumMoneyInputCtrl.text,
                                        pushPosId,
                                        widget.id);
                                  }
                                }
                              },
                            )));
                      }),
                ],
              ),
            ),
          );
          content = Column(children: planContainer);
          return content;
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class CapitalList extends StatelessWidget {
  final bool capshow;
  final List capitallist;
  final callback;

  const CapitalList({
    Key key,
    this.capshow,
    this.capitallist,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !capshow,
      child: Column(
        children: <Widget>[
          Stack(
            alignment: FractionalOffset(0, -0.06),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                      width: 193,
                      margin: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colours.orange_72),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          ListView.builder(
                              shrinkWrap: true,
                              physics: new BouncingScrollPhysics(),
                              itemCount: capitallist.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  child: Container(
                                      height: 39,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colours.orange_72))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            '${capitallist[index]['name']}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colours.gray_21),
                                          ),
                                        ],
                                      )),
                                  onTap: () {
                                    var selectcapital =
                                        '${capitallist[index]['name']}';
                                    var selectcapitalId =
                                        '${capitallist[index]['id']}';
                                    this.callback(
                                        selectcapitalId, selectcapital);
                                  },
                                );
                              }),
                        ],
                      )),
                ],
              ),
              Container(
                padding: EdgeInsets.only(right: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Image.asset(
                      ImgPrefix.manager_prefix + 'triangle_icon.png',
                      width: 9,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class PosList extends StatelessWidget {
  final bool posshow;
  final List poslist;
  final callback;

  const PosList({
    Key key,
    this.posshow,
    this.poslist,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !posshow,
      child: Column(
        children: <Widget>[
          Stack(
            alignment: FractionalOffset(0, -0.06),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 193,
                    margin: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colours.orange_72),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        ListView.builder(
                            shrinkWrap: true,
                            physics: new BouncingScrollPhysics(),
                            itemCount: poslist.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                child: Container(
                                    height: 39,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colours.orange_72))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '${poslist[index]['alias']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colours.gray_21),
                                        ),
                                      ],
                                    )),
                                onTap: () {
                                  var selectpos = '${poslist[index]['alias']}';
                                  int selectposId = poslist[index]['id'];
                                  this.callback(selectposId, selectpos);
                                },
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(right: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Image.asset(
                      ImgPrefix.manager_prefix + 'triangle_icon.png',
                      width: 9,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
