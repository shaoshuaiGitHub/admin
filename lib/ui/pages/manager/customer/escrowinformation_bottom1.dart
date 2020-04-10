import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';

//代管信息
class EscrowContent extends StatefulWidget {
  EscrowContent({Key key, this.orderId, this.delegateDetailBloc})
      : super(key: key);
  final int orderId;
  final DelegateDetailBloc delegateDetailBloc;
  @override
  State<StatefulWidget> createState() => _EscrowContent();
}

class _EscrowContent extends State<EscrowContent>
    with AutomaticKeepAliveClientMixin {
  // DelegateDetailBloc delegatedetailBloc = DelegateDetailBloc();

  void initState() {
    super.initState();
    Future.delayed(new Duration(milliseconds: 100)).then((_) {
      if (widget.orderId != null) {
        widget.delegateDetailBloc.getDelegateList(widget.orderId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // DelegateDetailBloc delegateDetailBloc =
    //     BlocProvider.of<DelegateDetailBloc>(context);
    widget.delegateDetailBloc.bloccontext = context;

    final CreditCardBloc creditCardBloc = CreditCardBloc();

    return Container(
      padding: EdgeInsets.only(bottom: 10),
      margin: EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
      ),
      child: Column(
        children: <Widget>[
          StreamBuilder<DelegateDetailListModel>(
              stream: widget.delegateDetailBloc.delegateStream,
              builder: (BuildContext context,
                  AsyncSnapshot<DelegateDetailListModel> snapshot) {
                List<Widget> cardContainer = [];
                Widget content;

                if (!snapshot.hasData) {
                  // Future.delayed(new Duration(milliseconds: 10)).then((_) {
                  //   if (widget.orderId != null) {
                  //     delegatedetailBloc.getDelegateList(widget.orderId);
                  //   }
                  // });
                  return Container();
                }

                List<DelegateDetailItemModel> cardList = snapshot
                    .data.delegateDetailList
                    .cast<DelegateDetailItemModel>();
                cardList.forEach((item) => cardContainer.add(
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 40,
                              padding: EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colours.bottom_line),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Text('代管类型：',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colours.gray_21,
                                      )),
                                  Text('${item.delegateType}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colours.gray_21,
                                      ))
                                ],
                              ),
                            ),
                            Container(
                              height: 165,
                              decoration: BoxDecoration(
                                color: Colours.blue_bg,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              padding: EdgeInsets.all(10),
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
                                                color: Colors.white,
                                                fontSize: 15.0,
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
                                                  color: Colors.white,
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
                                            '信用额度 ',
                                            style: new TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          Text(
                                            '${item.accLimit.toStringAsFixed(2)}',
                                            style: new TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
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
                                                    color: Colors.white,
                                                    fontSize: 33.0,
                                                  ),
                                                ),
                                                Column(
                                                  children: <Widget>[
                                                    Text(
                                                      '天前出账',
                                                      style: new TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${item.accDay}',
                                                      style: new TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
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
                                              color: Colors.white,
                                              fontSize: 33.0,
                                            ),
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                '天前出账',
                                                style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                '每月${item.accPayday}日',
                                                style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              '已出账单',
                                              style: new TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 6),
                                              child: Text(
                                                '${item.accLimitCost.toStringAsFixed(2)}',
                                                style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '可用额度：',
                                            style: new TextStyle(
                                              color: Colors.white,
                                              fontSize: 13.0,
                                            ),
                                          ),
                                          Text(
                                            '${item.usableMoney.toStringAsFixed(2)}',
                                            style: new TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Container(
                                            width: 75,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colours.orange_72,
                                                  width: 0.5),
                                              borderRadius:
                                                  BorderRadius.circular((12.0)),
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
                                          // creditCardBloc.updateBillAction(item.cardId, item.bankCode);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
                content = Column(
                  children: cardContainer,
                );
                return content;
              }),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
