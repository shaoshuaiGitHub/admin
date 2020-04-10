import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

//计划详情

class RepaymentPlanMiddle extends StatefulWidget {
  RepaymentPlanMiddle({Key key, this.id}) : super(key: key);
  int id;

  @override
  State<StatefulWidget> createState() => _RepaymentPlanMiddle();
}

class _RepaymentPlanMiddle extends State<RepaymentPlanMiddle>
    with AutomaticKeepAliveClientMixin {
  bool isCheck = false;
  bool capshow = false;
  bool state = false;
  bool isFirst = true;
  int capitalId;

  var capitalInputCtrl = TextEditingController();

  void onSelectCapital(capital, capitalid) {
    setState(() {
      capitalInputCtrl.text = capital;
      capitalId = capitalid;
      capshow = !capshow;
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
    if (isFirst) {
      Future.delayed(new Duration(milliseconds: 500)).then((_) {
        plandetailBloc.getPlanItemDetail(widget.id);
      });
      isFirst = false;
    }
    return StreamBuilder<AllplanItemDetailModel>(
        stream: plandetailBloc.plandetailStream,
        builder: (BuildContext context,
            AsyncSnapshot<AllplanItemDetailModel> snapshot) {
          List<Widget> planContainer = [];
          Widget content;
          if (!snapshot.hasData) {
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
          var accDay = snapshot.data.accDay;
          var accPayday = snapshot.data.accPayday;
          var accDays = snapshot.data.accDays;
          var accPaydays = snapshot.data.accPaydays;

          List investorList =
              snapshot.hasData ? snapshot.data.investorList : [];
          List capitallist = [];
          for (var list in investorList) {
            Map<String, dynamic> cplist = {
              'name': list.name,
              'id': list.id,
            };
            capitallist.add(cplist);
          }

          planContainer.add(Container(
            margin: EdgeInsets.only(
              bottom: 20,
              left: 20,
              right: 20,
            ),
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
                          color: Color(0xFFFF7200),
                        ),
                        child: isCheck
                            ? Icon(
                                Icons.check,
                                size: 15,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.check_box_outline_blank,
                                size: 15,
                                color: Color(0xFFFF7200),
                              ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '是否已经确认更新账单后的应还金额',
                      style: TextStyle(fontSize: 14, color: Colours.gray_21),
                    ),
                  ],
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
                                      enabled: false,
                                      controller: capitalInputCtrl,
                                      textAlign: TextAlign.left,
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
                          capshow ? Icons.arrow_drop_up : Icons.arrow_drop_down,
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
                CapitalsList(
                  capshow: capshow,
                  capitallist: capitallist,
                  callback: (capital, capitalid) =>
                      onSelectCapital(capital, capitalid),
                ),
                StreamBuilder<int>(
                    stream: plandetailBloc.repaymentplanStream,
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      state =
                          snapshot.data == Constant.SUCCESS_CODE ? true : false;

                      return Container(
                          margin: EdgeInsets.only(
                              bottom: 20, left: 20, right: 20, top: 200),
                          decoration: BoxDecoration(
                            color: state ? Colours.gray_99 : Colours.orange_72,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                              child: FlatButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '确认此计划',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    if (!state) {
                                      if (!isCheck) {
                                        plandetailBloc
                                            .showToast('请确认更新账单后的应还金额');
                                        return;
                                      }
                                      if (capitalInputCtrl.text.length == 0) {
                                        plandetailBloc.showToast('请选择资金方');
                                        return;
                                      }

                                      plandetailBloc.operationReypayAction(
                                          widget.id, capitalId);
                                    }
                                  })));
                    }),
              ],
            ),
          ));
          content = Column(children: planContainer);
          return content;
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class CapitalsList extends StatelessWidget {
  final bool capshow;
  final List capitallist;
  final callback;

  const CapitalsList({
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
                                    int selectcapitalId =
                                        capitallist[index]['id'];
                                    this.callback(
                                        selectcapital, selectcapitalId);
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
