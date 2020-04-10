import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class OrderDetailMiddle extends StatefulWidget {
  OrderDetailMiddle({Key key, this.id, this.applyStatus}) : super(key: key);
  final int id;
  final String applyStatus;

  @override
  State<StatefulWidget> createState() {
    return new OrderDetailState();
  }
}

class OrderDetailState extends State<OrderDetailMiddle> {
  final Map typeMap = {'pass': 1, 'ing': 0, 'refuse': 2, 'submitInfo': 3};
  var msgInputCtrl = TextEditingController();
  var addmsgInputCtrl = TextEditingController();
  String msg;
  bool canclick = true;
  void initState() {
    super.initState();
    Future.delayed(new Duration(milliseconds: 500)).then((_) {
      orderDetailBloc.getOrderDetail(widget.id);
    });
  }

  OrderDetailBloc orderDetailBloc = OrderDetailBloc();
  @override
  Widget build(BuildContext context) {
    final ApplicationBloc applicationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    orderDetailBloc.bloccontext = context;
    applicationBloc.backType = 1;

    return StreamBuilder<OrderDetailModel>(
        stream: orderDetailBloc.orderdetailStream,
        builder:
            (BuildContext context, AsyncSnapshot<OrderDetailModel> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          var name = snapshot.data.name;
          int uid = snapshot.data.uid;
          var icon = snapshot.data.icon;
          var phone = snapshot.data.phone;
          var idCardNO = snapshot.data.idCardNO;
          var creditScore = snapshot.data.creditScore;
          var platformStatus = snapshot.data.platformStatus;
          var idCardImagesA = snapshot.data.idCardImagesA;
          var idCardImagesB = snapshot.data.idCardImagesB;
          var delegateType = snapshot.data.delegateType;
          var delegateCardCount = snapshot.data.delegateCardCount;
          var delegateMoney = snapshot.data.delegateMoney;
          var accLimitMoney = snapshot.data.accLimitMoney;
          var reportImage = snapshot.data.reportImage;
          var updateTime = snapshot.data.updateTime;
          var cardIds = snapshot.data.cardIds;
          List<DelegateCardListModel> delegateCardList =
              snapshot.data.delegateCardList.cast<DelegateCardListModel>();
          // List cardIds = [];
          // if (snapshot.data.cardIds.toString().indexOf(',') != -1) {
          //   cardIds = snapshot.data.cardIds.split(',');
          // } else {
          //   cardIds.add(snapshot.data.cardIds.toString());
          // }
          return Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Column(children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 260,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(5)),
                    ),
                    padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 30,
                                  child: Row(
                                    children: <Widget>[
                                      Text('日期：',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colours.gray_99,
                                          )),
                                      Text('$updateTime',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colours.gray_99,
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(right: 10),
                                        width: 40,
                                        height: 40,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                "assets/images/user/head_default.jpeg",
                                            image: icon,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Text('$name',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colours.gray_21,
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(
                              width: 60,
                              height: 60,
                              child: widget.applyStatus == '待审核'
                                  ? Image.asset(ImgPrefix.manager_prefix +
                                      'toaudited_icon.png')
                                  : widget.applyStatus == '已通过'
                                      ? Image.asset(ImgPrefix.manager_prefix +
                                          'pass_icon.png')
                                      : widget.applyStatus == '已拒绝'
                                          ? Image.asset(
                                              ImgPrefix.manager_prefix +
                                                  'refuse_icon.png')
                                          : Image.asset(
                                              ImgPrefix.manager_prefix +
                                                  'toaudited_icon.png'),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('UID',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colours.gray_21,
                                  )),
                              Text('$uid',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colours.gray_21,
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('手机号码',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colours.gray_21,
                                  )),
                              Text(
                                '$phone',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colours.gray_21,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('身份证号码',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colours.gray_21,
                                  )),
                              Text('$idCardNO',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colours.gray_21,
                                  )),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                width: 181,
                                height: 66,
                                color: Colours.gray_e6,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      width: 84,
                                      height: 60,
                                      
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2.5,
                                          color: Color(0xFFE6E6E6),
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      child: FadeInImage.assetNetwork(
                                        placeholder:
                                            "assets/images/user/card_default.jpeg",
                                        image: idCardImagesA,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      width: 84,
                                      height: 60,
                                   
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2.5,
                                          color: Color(0xFFE6E6E6),
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      child: FadeInImage.assetNetwork(
                                        placeholder:
                                            "assets/images/user/card_default.jpeg",
                                        image: idCardImagesB,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        )
                      ],
                    )),
                Container(
                  height: 60,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(5)),
                  ),
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('风险系数',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colours.gray_21,
                                  )),
                              SizedBox(
                                width: 40,
                              ),
                              Text('$creditScore',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                  )),
                            ],
                          ),
                          GestureDetector(
                            child: Text('查看风控审核',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                )),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          WindControlAuditPage()));
                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('平台审核状态',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colours.gray_21,
                              )),
                          Text('$platformStatus',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colours.gray_21,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colours.orange_72)),
                  child: Column(children: <Widget>[
                    Container(
                      height: 99,
                      color: Colours.orange_72,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 4,
                                height: 20,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('代管信息',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colours.white_color,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('代管类型：$delegateType',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colours.white_color,
                                  )),
                              Text('代管卡片：$delegateCardCount(张）',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colours.white_color,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  '代管总额度：${delegateMoney != null ? delegateMoney.toStringAsFixed(1) : ''}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colours.white_color,
                                  )),
                              Text(
                                  '信用总额度：${accLimitMoney != null ? accLimitMoney.toStringAsFixed(1) : ''}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colours.white_color,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: delegateCardList.map((item) {
                          return Container(
                            height: 53,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 40,
                                      height: 40,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: FadeInImage.assetNetwork(
                                          placeholder:
                                              "assets/images/user/card_default.jpeg",
                                          image: '${item.bankIcon != null ? item.bankIcon : ''}',
                                          // image:
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '${item.bankName != null ? item.bankName : ''}',
                                      style: TextStyles.text15MediumLabel,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '${item.cardNo != null ? item.cardNo : ''}',
                                      style: TextStyles.text14MediumPLabel,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '代管金额',
                                      style: TextStyles.text14MediumPLabel,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      '${item.money != null ? item.money.toStringAsFixed(2) : ''}',
                                      style: TextStyles.text14MediumPLabel,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Colours.orange_72,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: FlatButton(
                            child: Text(
                              '查看卡片信息',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            onPressed: () {
                              if (widget.applyStatus == '已通过') {
                                //跳转到客户详情
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            CustomerDetailPage(
                                              uid: uid,
                                            )));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ViewCardInformationPage(
                                                delegateMoney: delegateMoney,
                                                delegateCardCount:
                                                    delegateCardCount,
                                                accLimitMoney: accLimitMoney,
                                                cardIds: snapshot.data.cardIds
                                                    .toString())));
                              }
                            },
                          ),
                        )),
                    Container(
                      color: Colors.white,
                      height: 181,
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: 4,
                                height: 20,
                                color: Colours.orange_72,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('其他资料',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colours.gray_21,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text('图片资料',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colours.gray_21,
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 84,
                                height: 62,
                                color: Colours.gray_99,
                                margin: EdgeInsets.only(right: 10, top: 10),
                                child: FadeInImage.assetNetwork(
                                  placeholder:
                                      "assets/images/user/card_default.jpeg",
                                  image: reportImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                //底部按钮
                Offstage(
                  offstage: widget.applyStatus == '已通过' ||
                      widget.applyStatus == '已拒绝',
                  child: bottomButton(context, cardIds.toString()),
                ),
              ]));
        });
  }

//底部按钮
  Widget bottomButton(
    BuildContext context,
    String cardIds,
  ) {
    return //底部按钮
        StreamBuilder<String>(
            stream: orderDetailBloc.orderpassStream,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              // if( !snapshot.hasData){
              //   return Container();
              // }
              msg = snapshot.data;

              return Container(
                margin: EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colours.orange_72,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: FlatButton(
                        child: Text(
                          '通过',
                          style: TextStyles.text15WhiteMediumLabel,
                        ),
                        onPressed: () {
                          if (canclick) {
                            canclick = false;
                            orderDetailBloc.operationOrderAction(
                                widget.id, typeMap['pass'], cardIds, '');

                            Future.delayed(new Duration(milliseconds: 500))
                                .then((_) {
                              canclick = true;
                              // Navigator.pop(context);
                            });
                          }
                        },
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colours.orange_72,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: FlatButton(
                          child: Text(
                            '拒绝',
                            style: TextStyles.text15WhiteMediumLabel,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: Container(
                                      height: 230,
                                      width: 343,
                                      decoration: BoxDecoration(
                                        color: Colours.white_color,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                              height: 45,
                                              decoration: BoxDecoration(
                                                color: Colours.orange_72,
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top:
                                                            Radius.circular(5)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    '备注',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        decoration:
                                                            TextDecoration
                                                                .none),
                                                  ),
                                                ],
                                              )),
                                          Container(
                                              height: 91,
                                              width: 323,
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 20, 10, 15),
                                              decoration: BoxDecoration(
                                                  color: Colours.gray_e6,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Scaffold(
                                                resizeToAvoidBottomInset: false,
                                                backgroundColor:
                                                    Colours.gray_e6,
                                                body: TextField(
                                                  controller: msgInputCtrl,
                                                  textAlign: TextAlign.left,
                                                  maxLines: 4,
                                                  decoration: InputDecoration(
                                                    hintText: '请输入拒绝的理由',
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            top: 6,
                                                            right: 10,
                                                            left: 10,
                                                            bottom: 10),
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                  ),
                                                  style: TextStyle(
                                                      // color: Colours.gray_99,
                                                      fontSize: 15),
                                                ),
                                              )),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Container(
                                                width: 115,
                                                height: 44,
                                                decoration: BoxDecoration(
                                                  color: Colours.orange_72,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: FlatButton(
                                                    child: Text(
                                                      '确认',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16),
                                                    ),
                                                    onPressed: () {
                                                      if (canclick) {
                                                        canclick = false;
                                                        orderDetailBloc
                                                            .operationOrderAction(
                                                                widget.id,
                                                                typeMap[
                                                                    'refuse'],
                                                                cardIds,
                                                                msgInputCtrl
                                                                    .text);
                                                        Future.delayed(
                                                                new Duration(
                                                                    milliseconds:
                                                                        500))
                                                            .then((_) {
                                                          canclick = true;
                                                          // Navigator.pop(
                                                          //     context);
                                                        });
                                                      }
                                                    }),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }),
                    ),
                    Container(
                      width: 100,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colours.orange_72,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: FlatButton(
                          child: Text(
                            '补充资料',
                            style: TextStyles.text15WhiteMediumLabel,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: Container(
                                      height: 230,
                                      width: 343,
                                      decoration: BoxDecoration(
                                        color: Colours.white_color,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                              height: 45,
                                              decoration: BoxDecoration(
                                                color: Colours.orange_72,
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top:
                                                            Radius.circular(5)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    '补充说明',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        decoration:
                                                            TextDecoration
                                                                .none),
                                                  ),
                                                ],
                                              )),
                                          Container(
                                              height: 91,
                                              width: 323,
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 20, 10, 15),
                                              decoration: BoxDecoration(
                                                  color: Colours.gray_e6,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Scaffold(
                                                resizeToAvoidBottomInset: false,
                                                backgroundColor:
                                                    Colours.gray_e6,
                                                body: TextField(
                                                  controller: addmsgInputCtrl,
                                                  textAlign: TextAlign.left,
                                                  maxLines: 4,
                                                  decoration: InputDecoration(
                                                    hintText: '信用卡有贷款和分期/请补充资料',
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            top: 6,
                                                            right: 10,
                                                            left: 10,
                                                            bottom: 10),
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                  ),
                                                  style: TextStyle(
                                                      color: Colours.gray_99,
                                                      fontSize: 15),
                                                ),
                                              )),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Container(
                                                width: 115,
                                                height: 44,
                                                decoration: BoxDecoration(
                                                  color: Colours.orange_72,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: FlatButton(
                                                    child: Text(
                                                      '确认',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16),
                                                    ),
                                                    onPressed: () {
                                                      if (canclick) {
                                                        canclick = false;
                                                        orderDetailBloc
                                                            .operationOrderAction(
                                                                widget.id,
                                                                typeMap[
                                                                    'submitInfo'],
                                                                cardIds,
                                                                addmsgInputCtrl
                                                                    .text);

                                                        Future.delayed(
                                                                new Duration(
                                                                    milliseconds:
                                                                        500))
                                                            .then((_) {
                                                          canclick = true;
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      }
                                                    }),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }),
                    )
                  ],
                ),
              );
            });
  }
}
