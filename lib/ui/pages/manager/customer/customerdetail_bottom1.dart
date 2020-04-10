import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import '../../../../ui/widgets/expansion_panel.dart';
import 'customer_index.dart';

EventBus eventBus3 = new EventBus();

class UpdateManagerProgressEvent {
  UpdateManagerProgressEvent();
}

//卡片管理
class CardManagerContent extends StatefulWidget {
  CardManagerContent(
      {this.customerDetailBloc,
      this.userId,
      this.allplanBloc,
      this.isdelete,
      this.callback});
  final CustomerDetailBloc customerDetailBloc;
  final AllPlanListBloc allplanBloc;
  final int userId;
  final callback;
  final bool isdelete;

  @override
  State<StatefulWidget> createState() {
    return _CardManagerContent();
  }
}

class _CardManagerContent extends State<CardManagerContent>
    with AutomaticKeepAliveClientMixin {
  CreditCardBloc creditCardBloc = CreditCardBloc();
  int showId = 0;
  bool isFirst = true;
  List mylist = List();
  List cardlist = List();
  var dataItem;
  @override
  void initState() {
    eventBus3.on<UpdateManagerProgressEvent>().listen(
      (event) {
        if (mounted) {
          setState(() {});
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    widget.customerDetailBloc.bloccontext = context;
    creditCardBloc.bloccontext = context;
    if (isFirst) {
      Future.delayed(new Duration(milliseconds: 500)).then((_) {
        widget.customerDetailBloc.getCustomerDetail(widget.userId,false);
      });
      isFirst = false;
    } else {
      if (widget.isdelete) {
        Future.delayed(new Duration(milliseconds: 100)).then((_) {
          widget.customerDetailBloc.getCustomerDetail(widget.userId,false);
        });
      }
    }

    return Container(
      child: ListView(
        children: <Widget>[
          StreamBuilder<CustomerDetailModel>(
              stream: widget.customerDetailBloc.customerStream,
              builder: (BuildContext context,
                  AsyncSnapshot<CustomerDetailModel> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                List<Widget> customerdetailContainer = List<Widget>();
                Widget content;
                mylist = snapshot.data.customerDetailList;
                if (creditCardBloc.managerProgressAry.length == 0) {
                  for (int i = 0; i < mylist.length; i++) {
                    List<double> needLists = List<double>();

                    for (int j = 0; j < mylist[i].orderCardsList.length; j++) {
                      needLists.add(0.0);
                    }
                    creditCardBloc.managerProgressAry.add(needLists);
                  }
                }
                for (int index = 0; index < mylist.length; index++) {
                  cardlist = mylist[index].orderCardsList ?? [];
                  var orderName = mylist[index].orderName.toString() ?? '';
                  int cardsCount = mylist[index].cardsCount ?? 0;

                  List<Widget> billContainer = [];
                  for (int i = 0; i < cardlist.length; i++) {
                    dataItem = cardlist[i];
                    double updateManagerProgress =
                        creditCardBloc.managerProgressAry[index][i];
                    billContainer.add(
                      Stack(
                        children: <Widget>[
                          MaterialButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          CustomerCardDetailPage(
                                              cardId: dataItem.cardId,
                                              item: dataItem)));
                            },
                            child: Container(
                              height: 177,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    width: 1, color: Colours.gray_cc),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              margin: EdgeInsets.only(top: 10),
                              padding:
                                  EdgeInsets.only(top: 8, right: 10, left: 10),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        width: 16,
                                        height: 8,
                                        child: MaterialButton(
                                          padding: EdgeInsets.all(0),
                                          onPressed: () {
                                            this.setState(() {
                                              showId = showId == dataItem.cardId
                                                  ? 0
                                                  : dataItem.cardId;
                                            });
                                          },
                                          child: Image.asset(
                                            'assets/images/capital/douhao.png',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: 30,
                                              height: 30,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(40),
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
                                            Text(
                                              '${dataItem.bankName != null ? dataItem.bankName : ''}',
                                              style: new TextStyle(
                                                color: Colours.gray_21,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '${dataItem.cardNo}',
                                              style: new TextStyle(
                                                color: Colours.gray_99,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            '信用额度 ',
                                            style: new TextStyle(
                                              color: Colours.gray_21,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          Text(
                                            '${dataItem.accLimit != null ? dataItem.accLimit.toStringAsFixed(2) : ''}',
                                            style: new TextStyle(
                                              color: Colours.gray_21,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(left: 30),
                                        child: Row(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  '${dataItem.accDays}',
                                                  style: new TextStyle(
                                                    color: Colours.gray_21,
                                                    fontSize: 36.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 7,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      '天前出账',
                                                      style: new TextStyle(
                                                        color: Colours.gray_21,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${dataItem.accDay}',
                                                      style: new TextStyle(
                                                        color: Colours.gray_99,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            '${dataItem.accPaydays}',
                                            style: new TextStyle(
                                              color: Colours.orange_72,
                                              fontSize: 36.0,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 7,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '天后还账',
                                                style: new TextStyle(
                                                  color: Colours.gray_21,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Text(
                                                '每月${dataItem.accPayday}日',
                                                style: new TextStyle(
                                                  color: Colours.gray_99,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '已出账单',
                                              style: new TextStyle(
                                                color: Colours.gray_21,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '${dataItem.usableMoney != null ? dataItem.usableMoney.toStringAsFixed(2) : ''}',
                                              style: new TextStyle(
                                                color: Colours.gray_99,
                                                fontSize: 13.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '还款状态：',
                                            style: new TextStyle(
                                              color: Colours.gray_21,
                                              fontSize: 13.0,
                                            ),
                                          ),
                                          Text(
                                            '${dataItem.payStatus}',
                                            style: new TextStyle(
                                              color: Colors.red,
                                              fontSize: 13.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    color: Colours.bottom_line,
                                    margin:
                                        EdgeInsets.only(top: 12, bottom: 12),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '可用额度',
                                              style: new TextStyle(
                                                color: Colours.gray_21,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '${dataItem.usableMoney != null ? dataItem.usableMoney.toStringAsFixed(2) : ''}',
                                              style: new TextStyle(
                                                color: Colours.gray_99,
                                                fontSize: 13.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            '${dataItem.before}天前网银',
                                            style: new TextStyle(
                                              color: Colours.orange_72,
                                              fontSize: 13.0,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Stack(
                                            children: <Widget>[
                                              GestureDetector(
                                                child: Container(
                                                    width: 75,
                                                    height: 24,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Colours.orange_72,
                                                          width: 0.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              (12.0)),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        '更新账单',
                                                        style: new TextStyle(
                                                          color:
                                                              Colours.orange_72,
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                    )),
                                                onTap: updateManagerProgress ==
                                                        0.0
                                                    ? () {
                                                        print(index);
                                                        creditCardBloc
                                                            .updateBillAction(
                                                                dataItem.cardId,
                                                                dataItem
                                                                    .bankCode,
                                                                0,
                                                                index,
                                                                i);
                                                      }
                                                    : null,
                                              ),
                                              AnimatedOpacity(
                                                opacity: 0.5,
                                                child: Container(
                                                  width: 80 *
                                                      updateManagerProgress,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                      color: Colors.yellow,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  12))),
                                                ),
                                                duration: Duration(seconds: 1),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            child: Container(
                              color: Colors.white,
                              child: DeleteCardWidget(
                                  id: dataItem.cardId,
                                  showId: showId,
                                  userId: widget.userId,
                                  callback: widget.callback,
                                  custoerdetailBloc: widget.customerDetailBloc),
                              margin: const EdgeInsets.only(
                                top: 20,
                              ),
                            ),
                            top: 10,
                            right: 10,
                          ),
                        ],
                      ),
                    );
                  }
                  customerdetailContainer.add(
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '$orderName',
                                style: new TextStyle(
                                  color: Colours.gray_21,
                                ),
                              ),
                              Text(
                                '卡片：$cardsCount',
                                style: new TextStyle(
                                  color: Colours.gray_21,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: billContainer,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                content = Column(children: customerdetailContainer);
                return content;
              }),
          //添加信用卡按钮
          FlatButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          AddCardPage(toUid: widget.userId)));
            },
            padding: EdgeInsets.all(0),
            child: Container(
              height: 33,
              margin: EdgeInsets.only(
                top: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 17.0,
                    height: 17.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colours.orange_72, width: 0.5), // 边色与边宽度
                      color: Colors.transparent, // 底色
                      borderRadius: BorderRadius.circular((90.0)), // 圆角度
                      // borderRadius: new BorderRadius.vertical(top: Radius.elliptical(20, 50)), // 也可控件一边圆角大小
                    ),
                    child: Center(
                      child: Text(
                        '＋',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colours.orange_72,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '请添加信用卡',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colours.orange_72,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

//删除按钮
class DeleteCardWidget extends StatelessWidget {
  //显影效果（删除按钮）
  final int showId;
  final int id;
  final CustomerDetailBloc custoerdetailBloc;
  final num userId;
  final callback;
  const DeleteCardWidget(
      {Key key,
      @required this.id,
      @required this.showId,
      @required this.userId,
      @required this.callback,
      @required this.custoerdetailBloc})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !(showId == id),
      child: Container(
        width: 68,
        height: 27,
        // alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/capital/delete.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: FlatButton(
          padding: EdgeInsets.only(
            top: 4,
            left: 2,
          ),
          child: Text(
            '删除',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xff212121),
              fontWeight: FontWeight.w400,
            ),
          ),
          onPressed: () {
            callback(true);
            custoerdetailBloc.removeCard(id, userId);
            final ApplicationBloc applicationBloc =
                BlocProvider.of<ApplicationBloc>(context);
            applicationBloc.backType = 1;
          },
        ),
      ),
    );
  }
}
