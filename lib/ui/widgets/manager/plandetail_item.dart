import '../../../common/component_index.dart';
import '../../pages/page_index.dart';

Column buildPlantDetailItem(
  BuildContext context,
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
  delegateMoney,
  realMoney,
  accLimitMoney,
  cardNo,
  accDay,
  accDays,
  accPayday,
  accPaydays,
) {
  if (planType == 1) {
    return Column(
      children: <Widget>[
        Container(
          height: 40,
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              color: Colours.orange_72,
              borderRadius: BorderRadius.vertical(top: Radius.circular(5))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '客户：$name',
                      style: TextStyles.text14WhiteMediumLabel,
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Text(
                      '代管类型：$delegateType',
                      style: TextStyles.text14WhiteMediumLabel,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))),
          child: Column(
            children: <Widget>[
              Container(
                height: 1,
                color: Colours.bottom_line,
                margin: EdgeInsets.only(bottom: 5),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        '$startTime - $endTime',
                        style: TextStyle(fontSize: 14, color: Colours.gray_99),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '类型$planType',
                        style: TextStyle(fontSize: 14, color: Colours.gray_21),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '$planType',
                        style: TextStyle(fontSize: 14, color: Colours.gray_21),
                      ),
                      Text(
                        '$minMoney',
                        style: TextStyle(fontSize: 14, color: Colours.gray_99),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                height: 1,
                color: Colours.bottom_line,
                margin: EdgeInsets.only(bottom: 10, top: 10),
              ),
              Row(
                children: <Widget>[
                  Text(
                    '$info',
                    style: TextStyle(fontSize: 12, color: Colours.gray_66),
                  ),
                ],
              ),
              Container(
                height: 1,
                color: Colours.bottom_line,
                margin: EdgeInsets.only(bottom: 5, top: 10),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 30,
                          height: 30,
                          padding: EdgeInsets.all(1),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: FadeInImage.assetNetwork(
                              placeholder:
                                  "assets/images/user/head_default.jpeg",
                              image: icon,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '$bankName',
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
                            '$cardNo',
                            style: new TextStyle(
                              color: Colours.gray_21,
                              fontSize: 15.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            '代管金额 ',
                            style: new TextStyle(
                              color: Colours.gray_21,
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            '$delegateMoney',
                            style: new TextStyle(
                              color: Colours.gray_99,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '可用额度 ',
                            style: new TextStyle(
                              color: Colours.gray_21,
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            '$usableMoney',
                            style: new TextStyle(
                              color: Colours.gray_99,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: 1,
                color: Colours.bottom_line,
                margin: EdgeInsets.only(bottom: 5, top: 5),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Text(
                          '计划状态：',
                          style:
                              TextStyle(fontSize: 14, color: Colours.gray_21),
                        ),
                        Text(
                          '$status',
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '实际消费：-',
                    style: TextStyle(fontSize: 14, color: Colours.gray_21),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  } else {
    return Column(
      children: <Widget>[
        Container(
          height: 40,
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              color: Colours.orange_72,
              borderRadius: BorderRadius.vertical(top: Radius.circular(5))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '客户：$name',
                      style: TextStyles.text14WhiteMediumLabel,
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Text(
                      '代管类型：$delegateType',
                      style: TextStyles.text14WhiteMediumLabel,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(bottom: Radius.elliptical(5, 5)),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '$startTime - $endTime',
                    style: TextStyle(fontSize: 14, color: Colours.gray_99),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '类型：$planType',
                        style: TextStyle(fontSize: 14, color: Colours.gray_21),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '$planType',
                        style: TextStyle(fontSize: 14, color: Colours.gray_21),
                      ),
                      Text(
                        '$minMoney',
                        style: TextStyle(fontSize: 14, color: Colours.gray_99),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                height: 1,
                color: Colours.bottom_line,
                margin: EdgeInsets.only(bottom: 5, top: 10),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 30,
                          height: 30,
                          padding: EdgeInsets.all(1),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: FadeInImage.assetNetwork(
                              placeholder:
                                  "assets/images/user/head_default.jpeg",
                              image: icon,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '$bankName',
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
                            '$cardNo',
                            style: new TextStyle(
                              color: Colours.gray_21,
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
                        '计划状态： ',
                        style: new TextStyle(
                          color: Colours.gray_21,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        '$status',
                        style: new TextStyle(
                          color: Colors.red,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
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
                          '代管金额 ',
                          style:
                              TextStyle(fontSize: 14, color: Colours.gray_21),
                        ),
                        Text(
                          '$delegateMoney',
                          style:
                              TextStyle(fontSize: 14, color: Colours.gray_99),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '近期账单日：$accDay',
                    style: TextStyle(fontSize: 14, color: Colours.gray_21),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    '$accDays天前',
                    style: TextStyle(fontSize: 12, color: Colours.gray_99),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Text(
                          '可用额度 ',
                          style:
                              TextStyle(fontSize: 14, color: Colours.gray_21),
                        ),
                        Text(
                          '$usableMoney',
                          style:
                              TextStyle(fontSize: 14, color: Colours.gray_99),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '近期还款日：每月$accPayday日',
                    style: TextStyle(fontSize: 14, color: Colours.gray_21),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    '$accPaydays天后',
                    style: TextStyle(fontSize: 12, color: Colours.gray_99),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
