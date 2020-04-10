import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';

class CustomerCardDetailHead extends StatefulWidget {
  CustomerCardDetailHead({this.item});
  final CustomerDetailItemModel item;
  @override
  State<StatefulWidget> createState() {
    return _CustomerCardDetailHead();
  }
}

class _CustomerCardDetailHead extends State<CustomerCardDetailHead> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 165,
      decoration: BoxDecoration(
        color: Colours.blue_bg,
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                        borderRadius: BorderRadius.circular(40),
                        child: FadeInImage.assetNetwork(
                          placeholder: "assets/images/user/card_default.jpeg",
                          image: widget.item.icon,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${widget.item.bankName}',
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
                        '${widget.item.cardNo}', //
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
                    '${widget.item.accLimit}', //
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 30),
                child: Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '${widget.item.accDays}', //
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
                              '${widget.item.accDay}', //
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '${widget.item.accPaydays}', //
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 33.0,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        '天后还账',
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${widget.item.accPayday}', //
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
            height: 5,
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
                        '${widget.item.usableMoney}', //
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
                    '还款状态：',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 13.0,
                    ),
                  ),
                  Text(
                    '${widget.item.payStatus}', //
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
            height: 10,
          ),
          Container(
            height: 1,
            color: Colours.bottom_line,
            margin: EdgeInsets.only(top: 5, bottom: 8),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '可用额度',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${widget.item.usableMoney}', //
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    '免息期50天',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 13.0,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '积分：--',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
