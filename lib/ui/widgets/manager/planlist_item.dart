import '../../../common/component_index.dart';
import '../../pages/page_index.dart';

Container buildPlantItem(
  BuildContext context,
  id,
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
  realMoney,
  accLimitMoney,
  cardNo,
  payment,
  updateTime,
  accDay,
  accPayday,
  paymentTime,
  allPlanListBloc,
  condition,
  loadType,
  accDays,
  accPaydays,
  msg,
) {
  final ApplicationBloc applicationBloc =
      BlocProvider.of<ApplicationBloc>(context);

  if (planType == '消费计划') {
    //消费计划
    if (status == '待消费') {
      //1
      return Container(
        padding: EdgeInsets.all(0),
        child: MaterialButton(
          padding: EdgeInsets.all(0),
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Column(
              children: <Widget>[
                Container(
                  height: 1,
                  color: Colours.bottom_line,
                  margin: EdgeInsets.only(bottom: 5),
                ),
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
                          style:
                              TextStyle(fontSize: 13, color: Colours.gray_21),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '计划${planType.substring(0, 2)}',
                          style:
                              TextStyle(fontSize: 14, color: Colours.gray_21),
                        ),
                        Text(
                          '${minMoney != null ? minMoney.toStringAsFixed(2) : ''}',
                          style:
                              TextStyle(fontSize: 14, color: Colours.gray_99),
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
                      '${info != null ? info : ''}',
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
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: FadeInImage.assetNetwork(
                                placeholder:
                                    "assets/images/user/card_default.jpeg",
                                image: icon,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${bankName != null ? bankName : ''}',
                            style: TextStyles.text16BlackMediumLabel,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: 3,
                            ),
                            child: Text(
                              '${cardNo != null ? cardNo : ''}',
                              style: TextStyles.text14BlackMediumLabel,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '信用金额 ',
                              style: new TextStyle(
                                color: Colours.gray_21,
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              '${accLimitMoney != null ? accLimitMoney.toStringAsFixed(2) : ''}',
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
                              '${usableMoney != null ? usableMoney.toStringAsFixed(2) : ''}',
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
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        PlanConsumePage(id: id))).then((_) {
              eventBuses.fire(GetOpen(true));
            });
            eventBuses.fire(GetOpen(false));
            eventBuses.fire(BackControl(true));
          },
        ),
      );
    } else if (status == '完成') {
      //4
      return Container(
        padding: EdgeInsets.all(0),
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Column(
            children: <Widget>[
              Container(
                height: 1,
                color: Colours.bottom_line,
                margin: EdgeInsets.only(bottom: 5),
              ),
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
                        style: TextStyle(fontSize: 13, color: Colours.gray_21),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '计划${planType.substring(0, 2)}',
                        style: TextStyle(fontSize: 14, color: Colours.gray_21),
                      ),
                      Text(
                        '${minMoney != null ? minMoney.toStringAsFixed(2) : ''}',
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
                    '${info != null ? info : ''}',
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: FadeInImage.assetNetwork(
                                placeholder:
                                    "assets/images/user/card_default.jpeg",
                                image: icon,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${bankName != null ? bankName : ''}',
                          style: TextStyles.text16BlackMediumLabel,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 3,
                          ),
                          child: Text(
                            '${cardNo != null ? cardNo : ''}',
                            style: TextStyles.text14BlackMediumLabel,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            '信用金额 ',
                            style: new TextStyle(
                              color: Colours.gray_21,
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            '${accLimitMoney != null ? accLimitMoney.toStringAsFixed(2) : ''}',
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
                            '${usableMoney != null ? usableMoney.toStringAsFixed(2) : ''}',
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
                  Column(
                    children: <Widget>[
                      Text(
                        '实际消费：${realMoney != null ? realMoney.toStringAsFixed(2) : ''}',
                        style: TextStyle(fontSize: 14, color: Colours.gray_21),
                      ),
                      Text(
                        '更新日期：$updateTime',
                        style: TextStyle(fontSize: 12, color: Colours.gray_99),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (status == '问题订单') {
      //-1
      return Container(
        padding: EdgeInsets.all(0),
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Column(
            children: <Widget>[
              Container(
                height: 1,
                color: Colours.bottom_line,
                margin: EdgeInsets.only(bottom: 5),
              ),
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
                        style: TextStyle(fontSize: 13, color: Colours.gray_21),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '计划${planType.substring(0, 2)}',
                        style: TextStyle(fontSize: 14, color: Colours.gray_21),
                      ),
                      Text(
                        '${minMoney != null ? minMoney.toStringAsFixed(2) : ''}',
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
                    '${info != null ? info : ''}',
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: FadeInImage.assetNetwork(
                                placeholder:
                                    "assets/images/user/card_default.jpeg",
                                image: icon,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${bankName != null ? bankName : ''}',
                          style: TextStyles.text16BlackMediumLabel,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 3,
                          ),
                          child: Text(
                            '${cardNo != null ? cardNo : ''}',
                            style: TextStyles.text14BlackMediumLabel,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            '信用金额 ',
                            style: new TextStyle(
                              color: Colours.gray_21,
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            '${accLimitMoney != null ? accLimitMoney.toStringAsFixed(2) : ''}',
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
                            '${usableMoney != null ? usableMoney.toStringAsFixed(2) : ''}',
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
                  Column(
                    children: <Widget>[
                      Text(
                        '实际消费：-',
                        style: TextStyle(fontSize: 14, color: Colours.gray_21),
                      ),
                      Text(
                        '更新日期：$updateTime',
                        style: TextStyle(fontSize: 12, color: Colours.gray_99),
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
                  Container(
                      margin: EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colours.orange_72),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        '问题订单',
                        style:
                            TextStyle(fontSize: 12, color: Colours.orange_72),
                      )),
                  Text('$msg',
                      style: TextStyle(fontSize: 12, color: Colours.gray_99)),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  } else {
    //还款计划
    if (status == '待消费') {
      //1
      return Container(
        child: MaterialButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        RepaymentPlanPage(id: id))).then((_) {
              eventBuses.fire(GetOpen(true));
            });
            eventBuses.fire(GetOpen(false));
            eventBuses.fire(BackControl(true));
          },
          child: Column(
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 16),
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
                          style:
                              TextStyle(fontSize: 13, color: Colours.gray_99),
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
                              style: TextStyle(
                                  fontSize: 14, color: Colours.gray_21),
                            ),
                            // Text(
                            //   '$startTime - $endTime',
                            //   style: TextStyle(
                            //       fontSize: 14, color: Colours.gray_99),
                            // ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '计划${planType.substring(0, 2)}',
                              style: TextStyle(
                                  fontSize: 14, color: Colours.gray_21),
                            ),
                            Text(
                              '${minMoney != null ? minMoney.toStringAsFixed(2) : ''}',
                              style: TextStyle(
                                  fontSize: 14, color: Colours.gray_99),
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
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                 child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: FadeInImage.assetNetwork(
                                placeholder:
                                    "assets/images/user/card_default.jpeg",
                                image: icon,
                                fit: BoxFit.cover,
                              ),
                            ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${bankName != null ? bankName : ''}',
                                style: TextStyles.text16BlackMediumLabel,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  top: 3,
                                ),
                                child: Text(
                                  '${cardNo != null ? cardNo : ''}',
                                  style: TextStyles.text14BlackMediumLabel,
                                ),
                              ),
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
                                style: TextStyle(
                                    fontSize: 14, color: Colours.gray_21),
                              ),
                              Text(
                                '${usableMoney != null ? usableMoney.toStringAsFixed(2) : ''}',
                                style: TextStyle(
                                    fontSize: 14, color: Colours.gray_99),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '近期账单日：$accDay',
                          style:
                              TextStyle(fontSize: 14, color: Colours.gray_21),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          '$accDays天前',
                          style:
                              TextStyle(fontSize: 12, color: Colours.gray_99),
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
                                style: TextStyle(
                                    fontSize: 14, color: Colours.gray_21),
                              ),
                              Text(
                                '${usableMoney != null ? usableMoney.toStringAsFixed(2) : ''}',
                                style: TextStyle(
                                    fontSize: 14, color: Colours.gray_99),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '近期还款日：每月$accPayday 日',
                          style:
                              TextStyle(fontSize: 14, color: Colours.gray_21),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          '$accPaydays 天后',
                          style:
                              TextStyle(fontSize: 12, color: Colours.gray_99),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    } else if (status == '待还款') {
      //2
      return Container(
        padding: EdgeInsets.all(0),
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Column(
            children: <Widget>[
              Container(
                height: 1,
                color: Colours.bottom_line,
                margin: EdgeInsets.only(bottom: 5),
              ),
              Row(
                children: <Widget>[
                  Text(
                    '$startTime - $endTime',
                    style: TextStyle(fontSize: 13, color: Colours.gray_99),
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
                        '计划${planType.substring(0, 2)}',
                        style: TextStyle(fontSize: 14, color: Colours.gray_21),
                      ),
                      Text(
                        '${minMoney != null ? minMoney.toStringAsFixed(2) : ''}',
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
                    '${info != null ? info : ''}',
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                           child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: FadeInImage.assetNetwork(
                                placeholder:
                                    "assets/images/user/card_default.jpeg",
                                image: icon,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${bankName != null ? bankName : ''}',
                          style: TextStyles.text16BlackMediumLabel,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 3,
                          ),
                          child: Text(
                            '${cardNo != null ? cardNo : ''}',
                            style: TextStyles.text14BlackMediumLabel,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            '信用金额 ',
                            style: new TextStyle(
                              color: Colours.gray_21,
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            '${accLimitMoney != null ? accLimitMoney.toStringAsFixed(2) : ''}',
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
                            '${usableMoney != null ? usableMoney.toStringAsFixed(2) : ''}',
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
                  Column(
                    children: <Widget>[
                      Text(
                        '实际还款：-',
                        style: TextStyle(fontSize: 14, color: Colours.gray_21),
                      ),
                      Text(
                        '更新日期：$updateTime',
                        style: TextStyle(fontSize: 12, color: Colours.gray_99),
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
                          '扣款情况：',
                          style:
                              TextStyle(fontSize: 14, color: Colours.gray_21),
                        ),
                        Text(
                          '未扣款',
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            '扣款金额：',
                            style:
                                TextStyle(fontSize: 14, color: Colours.gray_21),
                          ),
                          Text(
                            '$payment',
                            style: TextStyle(fontSize: 14, color: Colors.red),
                          ),
                        ],
                      ),
                      Text(
                        '扣款日期：$updateTime',
                        style: TextStyle(fontSize: 12, color: Colours.gray_99),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else if (status == '完成') {
      //4
      return Container(
        padding: EdgeInsets.all(0),
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Column(
            children: <Widget>[
              Container(
                height: 1,
                color: Colours.bottom_line,
                margin: EdgeInsets.only(bottom: 5),
              ),
              Row(
                children: <Widget>[
                  Text(
                    '$startTime - $endTime',
                    style: TextStyle(fontSize: 13, color: Colours.gray_99),
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
                        '计划${planType.substring(0, 2)}',
                        style: TextStyle(fontSize: 14, color: Colours.gray_21),
                      ),
                      Text(
                        '${minMoney != null ? minMoney.toStringAsFixed(2) : ''}',
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
                    '${info != null ? info : ''}',
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                           child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: FadeInImage.assetNetwork(
                                placeholder:
                                    "assets/images/user/card_default.jpeg",
                                image: icon,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${bankName != null ? bankName : ''}',
                          style: TextStyles.text16BlackMediumLabel,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 3,
                          ),
                          child: Text(
                            '${cardNo != null ? cardNo : ''}',
                            style: TextStyles.text14BlackMediumLabel,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            '信用金额 ',
                            style: new TextStyle(
                              color: Colours.gray_21,
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            '${accLimitMoney != null ? accLimitMoney.toStringAsFixed(2) : ''}',
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
                            '${usableMoney != null ? usableMoney.toStringAsFixed(2) : ''}',
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
                  Column(
                    children: <Widget>[
                      Text(
                        '实际消费：${realMoney != null ? realMoney.toStringAsFixed(2) : ''}',
                        style: TextStyle(fontSize: 14, color: Colours.gray_21),
                      ),
                      Text(
                        '更新日期：$updateTime',
                        style: TextStyle(fontSize: 12, color: Colours.gray_99),
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
                          '扣款情况：',
                          style:
                              TextStyle(fontSize: 14, color: Colours.gray_21),
                        ),
                        Text(
                          '已扣款',
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            '扣款金额：',
                            style:
                                TextStyle(fontSize: 14, color: Colours.gray_21),
                          ),
                          Text(
                            '$payment',
                            style: TextStyle(fontSize: 14, color: Colors.red),
                          ),
                        ],
                      ),
                      Text(
                        '扣款日期：$paymentTime',
                        style: TextStyle(fontSize: 12, color: Colours.gray_99),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else if (status == '问题订单') {
      //-1
      return Container(
        padding: EdgeInsets.all(0),
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Column(
            children: <Widget>[
              Container(
                height: 1,
                color: Colours.bottom_line,
                margin: EdgeInsets.only(bottom: 5),
              ),
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
                        style: TextStyle(fontSize: 13, color: Colours.gray_21),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '计划${planType.substring(0, 2)}',
                        style: TextStyle(fontSize: 14, color: Colours.gray_21),
                      ),
                      Text(
                        '${minMoney != null ? minMoney.toStringAsFixed(2) : ''}',
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
                    '${info != null ? info : ''}',
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                           child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: FadeInImage.assetNetwork(
                                placeholder:
                                    "assets/images/user/card_default.jpeg",
                                image: icon,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${bankName != null ? bankName : ''}',
                          style: TextStyles.text16BlackMediumLabel,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 3,
                          ),
                          child: Text(
                            '${cardNo != null ? cardNo : ''}',
                            style: TextStyles.text14BlackMediumLabel,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            '信用金额 ',
                            style: new TextStyle(
                              color: Colours.gray_21,
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            '${accLimitMoney != null ? accLimitMoney.toStringAsFixed(2) : ''}',
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
                            '${usableMoney != null ? usableMoney.toStringAsFixed(2) : ''}',
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
                  Column(
                    children: <Widget>[
                      Text(
                        '实际消费：-',
                        style: TextStyle(fontSize: 14, color: Colours.gray_21),
                      ),
                      Text(
                        '更新日期：$updateTime',
                        style: TextStyle(fontSize: 12, color: Colours.gray_99),
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
                  Container(
                      padding: EdgeInsets.all(2),
                      margin: EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colours.orange_72),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        '问题订单',
                        style:
                            TextStyle(fontSize: 12, color: Colours.orange_72),
                      )),
                  Text('$msg',
                      style: TextStyle(fontSize: 12, color: Colours.gray_99)),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
