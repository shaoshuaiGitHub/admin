import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class ViewCardInformationMiddle extends StatefulWidget {
  ViewCardInformationMiddle(
      {this.delegateMoney,
      this.delegateCardCount,
      this.accLimitMoney,
      this.cardIds});
  final String cardIds;
  final num delegateCardCount;
  final num delegateMoney;
  final num accLimitMoney;

  @override
  State<StatefulWidget> createState() {
    return _ViewCardInformationMiddle();
  }
}

class _ViewCardInformationMiddle extends State<ViewCardInformationMiddle> {
  @override
  Widget build(BuildContext context) {
    print(widget.delegateMoney);
    return Container(
      // margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: <Widget>[
          ViewCardInformationHead(
            delegateMoney: widget.delegateMoney,
            delegateCardCount: widget.delegateCardCount,
            accLimitMoney: widget.accLimitMoney,
          ),
          ViewCardInformationContentMiddle(cardIds: widget.cardIds),
          // ViewCardInformationContentBottom(),
        ],
      ),
    );
  }
}

class ViewCardInformationHead extends StatelessWidget {
  ViewCardInformationHead(
      {this.delegateMoney, this.delegateCardCount, this.accLimitMoney});
  final num delegateCardCount;
  final num delegateMoney;
  final num accLimitMoney;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Stack(
                alignment: FractionalOffset(0.5, 2.1),
                children: <Widget>[
                  Container(
                    color: Colours.orange_72,
                    height: 116,
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              '$delegateCardCount',
                              style: new TextStyle(
                                color: Colours.white_color,
                                fontSize: 15.0,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '卡数(张)',
                              style: new TextStyle(
                                color: Colours.white_color,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              '${accLimitMoney.toStringAsFixed(2)}',
                              style: new TextStyle(
                                color: Colours.white_color,
                                fontSize: 15.0,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '总额度(元)',
                              style: new TextStyle(
                                color: Colours.white_color,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              '${delegateMoney.toStringAsFixed(2)}',
                              style: new TextStyle(
                                color: Colours.white_color,
                                fontSize: 15.0,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '托管额度(元)',
                              style: new TextStyle(
                                color: Colours.white_color,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //     margin: EdgeInsets.only(left: 20, right: 20),
                  //     child: Stack(
                  //       alignment: FractionalOffset(0, 0.5),
                  //       children: <Widget>[
                  //         Container(
                  //           decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(5)),
                  //           width: Screen.width,
                  //           child: Image.asset(
                  //             ImgPrefix.manager_prefix + 'viewtop_bg1.png',
                  //             fit: BoxFit.fitWidth,
                  //           ),
                  //         ),
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //           children: <Widget>[
                  //             Column(
                  //               children: <Widget>[
                  //                 Text(
                  //                   '1',
                  //                   style: new TextStyle(
                  //                     color: Colours.white_color,
                  //                     fontSize: 15.0,
                  //                   ),
                  //                 ),
                  //                 SizedBox(
                  //                   height: 10,
                  //                 ),
                  //                 Text(
                  //                   '七日内应还',
                  //                   style: new TextStyle(
                  //                     color: Colours.white_color,
                  //                     fontSize: 14.0,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //             Column(
                  //               children: <Widget>[
                  //                 Text(
                  //                   '1000.00',
                  //                   style: new TextStyle(
                  //                     color: Colours.white_color,
                  //                     fontSize: 15.0,
                  //                   ),
                  //                 ),
                  //                 SizedBox(
                  //                   height: 10,
                  //                 ),
                  //                 Text(
                  //                   '可用额度(元）',
                  //                   style: new TextStyle(
                  //                     color: Colours.white_color,
                  //                     fontSize: 14.0,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //             Column(
                  //               children: <Widget>[
                  //                 Text(
                  //                   '100.00',
                  //                   style: new TextStyle(
                  //                     color: Colours.white_color,
                  //                     fontSize: 15.0,
                  //                   ),
                  //                 ),
                  //                 SizedBox(
                  //                   height: 10,
                  //                 ),
                  //                 Text(
                  //                   '托管额度(元）',
                  //                   style: new TextStyle(
                  //                     color: Colours.white_color,
                  //                     fontSize: 14.0,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         )
                  //       ],
                  //     )),
                ],
              ))
        ],
      ),
    );
  }
}

class ViewCardInformationContentMiddle extends StatefulWidget {
  ViewCardInformationContentMiddle({this.cardIds});
  final String cardIds;

  @override
  State<StatefulWidget> createState() {
    return _ViewCardInformationContentMiddle();
  }
}

class _ViewCardInformationContentMiddle
    extends State<ViewCardInformationContentMiddle> {
  int showId = 0;
  bool isFirst = true;
  List<CustomerDetailItemModel> mylist;
  @override
  Widget build(BuildContext context) {
    final OrderDetailBloc orderDetailBloc = OrderDetailBloc();
    // super.build(context);

    if (isFirst) {
      Future.delayed(new Duration(milliseconds: 100)).then((_) {
        orderDetailBloc.getOrderCardList(widget.cardIds);
      });
      isFirst = false;
    }
    final CreditCardBloc creditCardBloc = CreditCardBloc();
    creditCardBloc.bloccontext = context;
    return Container(
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Column(
        children: <Widget>[
          StreamBuilder<OrderCardListModel>(
              stream: orderDetailBloc.ordercardListStream,
              builder: (BuildContext context,
                  AsyncSnapshot<OrderCardListModel> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                List<Widget> customerdetailContainer = List<Widget>();
                Widget content;
                mylist = snapshot.hasData
                    ? snapshot.data.dataList.cast<CustomerDetailItemModel>()
                    : [];

                mylist.forEach((item) => customerdetailContainer.add(Stack(
                      children: <Widget>[
                        MaterialButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          CustomerCardDetailPage(
                                              cardId: item.cardId,
                                              item: item)));
                            },
                            child: Container(
                              height: 177,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              margin: EdgeInsets.only(top: 10),
                              padding:
                                  EdgeInsets.only(top: 8, right: 10, left: 10),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                               child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            child: FadeInImage.assetNetwork(
                                              placeholder:
                                                  "assets/images/user/card_default.jpeg",
                                              image: item.icon,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '${item.bankName}',
                                              style: new TextStyle(
                                                color: Colours.gray_21,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 6),
                                              child: Text(
                                                '${item.cardNo}',
                                                style: new TextStyle(
                                                  color: Colours.gray_99,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '信用额度',
                                            style: new TextStyle(
                                              color: Colours.gray_21,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          Text(
                                            '${item.accLimit.toStringAsFixed(2)}',
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
                                                  '${item.accDays}',
                                                  style: new TextStyle(
                                                    color: Colours.gray_21,
                                                    fontSize: 36.0,
                                                  ),
                                                ),
                                                Column(
                                                  children: <Widget>[
                                                    Text(
                                                      '天前出账',
                                                      style: new TextStyle(
                                                        color: Colours.gray_21,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${item.accDay}',
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
                                            '${item.accPaydays}',
                                            style: new TextStyle(
                                              color: Colours.orange_72,
                                              fontSize: 36.0,
                                            ),
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                '天后还账',
                                                style: new TextStyle(
                                                  color: Colours.gray_21,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Text(
                                                '${item.accPayday}',
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
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
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
                                            Container(
                                              margin: EdgeInsets.only(top: 6),
                                              child: Text(
                                                '${item.usableMoney.toStringAsFixed(2)}',
                                                style: new TextStyle(
                                                  color: Colours.gray_99,
                                                  fontSize: 13.0,
                                                ),
                                              ),
                                            )
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
                                            '${item.payStatus}',
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
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
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
                                            Container(
                                              margin: EdgeInsets.only(top: 6),
                                              child: Text(
                                                '${item.usableMoney.toStringAsFixed(2)}',
                                                style: new TextStyle(
                                                  color: Colours.gray_99,
                                                  fontSize: 13.0,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '${item.updateTime}天网银',
                                            style: new TextStyle(
                                              color: Colours.orange_72,
                                              fontSize: 13.0,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                            child: Container(
                                                width: 75,
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colours.orange_72,
                                                      width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          (12.0)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '更新账单',
                                                    style: new TextStyle(
                                                      color: Colours.orange_72,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                )),
                                            onTap: () {
                                              creditCardBloc.updateBillAction(
                                                  item.cardId,
                                                  item.bankCode,
                                                  3,
                                                  0,
                                                  0);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ],
                    )));
                content = Column(children: customerdetailContainer);
                return content;
              }),
        ],
      ),
    );
  }
}

//删除按钮
class CustomerDeleteCardWidget extends StatelessWidget {
  //显影效果（删除按钮）
  final int showId;
  final int id;
  final OrderDetailBloc orderDetailBloc;
  const CustomerDeleteCardWidget(
      {Key key,
      @required this.id,
      @required this.showId,
      @required this.orderDetailBloc})
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
            orderDetailBloc.removeCard(id.toString());
          },
        ),
      ),
    );
  }
}
