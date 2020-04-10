import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';

class EscrowInformationMiddle extends StatefulWidget {
  EscrowInformationMiddle(
      {Key key,
      this.uid,
      this.name,
      this.delegateCardCount,
      this.totalAccLimit,
      this.icon})
      : super(key: key);
  int uid;
  var name;
  num delegateCardCount;
  num totalAccLimit;
  var icon;

  @override
  State<StatefulWidget> createState() => _EscrowInformationMiddle();
}

class _EscrowInformationMiddle extends State<EscrowInformationMiddle>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int tabIndex = 0; //初始第一个页面
  String dateTime; //时间
  final List<Tab> titleTabs = <Tab>[
    Tab(
      child: Container(
        height: 44,
        child: Text('代管信息'),
      ),
    ),
    Tab(
      child: Container(
        height: 44,
        child: Text('审核信息'),
      ),
    ),
    Tab(
      child: Container(
        height: 44,
        child: Text('查看合同'),
      ),
    ),
  ]; //tab
  TabController tabController;
  DelegateDetailBloc delegateDetailBloc = DelegateDetailBloc();
  bool isFirst = true;

  @override
  void initState() {
    super.initState();

    String condition = {
      '"userId"': widget.uid,
      '"applyStatus"': 1,
    }.toString();

    // 添加监听器
    tabController = TabController(vsync: this, length: titleTabs.length)
      ..addListener(() {
        if (tabController.index.toDouble() == tabController.animation.value) {
          this.setState(() {
            tabIndex = tabController.index;
          });
        }
      });
    // if (isFirst) {
    Future.delayed(new Duration(milliseconds: 500)).then((_) {
      delegateDetailBloc.getExamineDetail(condition);
    });
    //  isFirst = false;
    // }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  bool capshow = false;
  var orderInputCtrl = TextEditingController();
  List orderList = [];
  List myorderList = [];
  int selectOrderId;
  int selectcardId;
  void onSelectCapital(id, name, selectcardId) {
    setState(() {
      orderInputCtrl.text = name;
      capshow = !capshow;
      selectOrderId = id;
      selectcardId = selectcardId;
    });
  }

  @override
  Widget build(BuildContext context) {
    // DelegateDetailBloc delegatedetailBloc =
    //     BlocProvider.of<DelegateDetailBloc>(context);
    delegateDetailBloc.bloccontext = context;

    String condition = {
      '"userId"': widget.uid,
      '"applyStatus"': 1,
    }.toString();

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
      ),
      child: ListView(
        // alignment: FractionalOffset(0, 1.9),
        children: <Widget>[
          //头部用户卡片
          Container(
              height: 145,
              margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 60,
                                height: 60,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                        "assets/images/user/head_default.jpeg",
                                    image: widget.icon,
                                    // image: '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    '${widget.name}',
                                    style: TextStyle(
                                        color: Colours.gray_21, fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '代管卡片：${widget.delegateCardCount}',
                                    style: TextStyle(
                                        color: Colours.gray_21, fontSize: 14),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              child: Text(
                                '一键解除代管',
                                style: TextStyle(
                                    color: Colours.orange_72, fontSize: 14),
                              ),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Center(
                                        child: Container(
                                          height: 228,
                                          width: 280,
                                          decoration: BoxDecoration(
                                            color: Colours.bottom_line,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colours.orange_72,
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    5)),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        '确认一键解除？',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            decoration:
                                                                TextDecoration
                                                                    .none),
                                                      ),
                                                    ],
                                                  )),
                                              Container(
                                                  height: 68,
                                                  width: 240,
                                                  margin: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      top: 10,
                                                      bottom: 25),
                                                  padding: EdgeInsets.only(
                                                      left: 10, right: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        '解除后将看不到该客户的所有信息',
                                                        style: TextStyle(
                                                            color:
                                                                Colours.gray_21,
                                                            fontSize: 14,
                                                            decoration:
                                                                TextDecoration
                                                                    .none),
                                                      ),
                                                    ],
                                                  )),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Container(
                                                    width: 115,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colours.gray_99,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: FlatButton(
                                                        child: Text(
                                                          '取消',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        }),
                                                  ),
                                                  Container(
                                                    width: 115,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colours.orange_72,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: FlatButton(
                                                        child: Text(
                                                          '确认',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16),
                                                        ),
                                                        onPressed: () {
                                                          // Navigator.popUntil(
                                                          //   context,
                                                          //   ModalRoute.withName(
                                                          //       'CustomerIndexPage'),
                                                          // );

                                                          Navigator.pop(context);
                                                          delegateDetailBloc
                                                              .removeAllDelegateAction(
                                                                  widget.uid)
                                                              .then((val) {
                                                            final ApplicationBloc
                                                                applicationBloc =
                                                                BlocProvider.of<
                                                                        ApplicationBloc>(
                                                                    context);
                                                            applicationBloc
                                                                .backType = 1;
                                                          });
                                                        }),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            Text(
                              '信用额度：${widget.totalAccLimit.toStringAsFixed(2)}', //.toStringAsFixed(2)
                              style: TextStyle(
                                  color: Colours.gray_21, fontSize: 14),
                            ),
                          ],
                        )
                      ],
                    ),
                    //订单选择
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            // top:5,
                          ),
                          padding: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colours.orange_72),
                              color: Colors.white),
                          height: 30,
                          width: MediaQuery.of(context).size.width - 160,
                          child: Row(
                            children: <Widget>[
                              // Expanded(
                              // child: Row(
                              //   children: <Widget>[
                              Text(
                                '订单',
                                style: TextStyle(
                                    fontSize: 14, color: Colours.gray_cc),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Container(
                                width: 0.5,
                                height: 20,
                                decoration:
                                    BoxDecoration(color: Colours.gray_cc),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    TextField(
                                      controller: orderInputCtrl,
                                      textAlign: TextAlign.left,
                                      enabled: false,
                                      decoration: InputDecoration(
                                        hintText: '请选择订单',
                                        contentPadding:
                                            EdgeInsets.only(left: 8),
                                        disabledBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                      style: TextStyle(
                                          color: Colours.gray_21, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              //   ],
                              // ),
                              // ),
                              Container(
                                width: 26,
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(
                                    capshow
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    size: 26,
                                    color: Colours.gray_99,
                                  ),
                                  onPressed: () {
                                    capshow = !capshow;
                                    setState(() {
                                      capshow = capshow;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 74,
                          margin: EdgeInsets.only(right: 0),
                          decoration: BoxDecoration(
                              color: Colours.orange_72,
                              borderRadius: BorderRadius.circular(5)),
                          child: MaterialButton(
                            padding: EdgeInsets.all(0),
                            child: Center(
                              child: Text(
                                '解除代管',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Center(
                                      child: Container(
                                        height: 228,
                                        width: 280,
                                        decoration: BoxDecoration(
                                          color: Colours.bottom_line,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: Colours.orange_72,
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              5)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      '确认解除？',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          decoration:
                                                              TextDecoration
                                                                  .none),
                                                    ),
                                                  ],
                                                )),
                                            Container(
                                                height: 68,
                                                width: 240,
                                                margin: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 10,
                                                    bottom: 25),
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      '解除后将看不到该订单的所有信息',
                                                      style: TextStyle(
                                                          color:
                                                              Colours.gray_21,
                                                          fontSize: 14,
                                                          decoration:
                                                              TextDecoration
                                                                  .none),
                                                    ),
                                                  ],
                                                )),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Container(
                                                  width: 115,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colours.gray_99,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: FlatButton(
                                                      child: Text(
                                                        '取消',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      }),
                                                ),
                                                Container(
                                                  width: 115,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colours.orange_72,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: FlatButton(
                                                      child: Text(
                                                        '确认',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        if (selectOrderId ==
                                                            null) {
                                                          delegateDetailBloc
                                                              .showToast(
                                                                  '请选择要解除的订单');
                                                          return;
                                                        }

                                                        if (myorderList
                                                                .length ==
                                                            1) {
                                                          delegateDetailBloc
                                                              .removeAllDelegateAction(
                                                                  widget.uid);
                                                        } else {
                                                          delegateDetailBloc
                                                              .removeDelegateAction(
                                                                  selectOrderId,
                                                                  condition);
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
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),

          //订单下拉
          StreamBuilder<ExamineListModel>(
              stream: delegateDetailBloc.examineStream,
              builder: (BuildContext context,
                  AsyncSnapshot<ExamineListModel> snapshot) {
                List<Widget> orderContainer = [];
                Widget content;

                if (!snapshot.hasData) {
                  return Container();
                }
                List<ExamineItemModel> orderList = snapshot.hasData
                    ? snapshot.data.orderDetailList.cast<ExamineItemModel>()
                    : [];
                myorderList = [];
                for (var list in orderList) {
                  Map<String, dynamic> cplist = {
                    'userId': list.userId,
                    'cardId': list.cardId,
                    'updateTime': list.updateTime,
                    'id': list.id,
                  };
                  myorderList.add(cplist);
                }

                orderContainer.add(
                  //订单下拉选择框
                  OrderList(
                    capshow: capshow,
                    orderList: myorderList,
                    tabIndex: tabIndex,
                    delegatedetailBloc: delegateDetailBloc,
                    callback: (orderId, name, selectcardId) =>
                        onSelectCapital(orderId, name, selectcardId),
                  ),
                );
                content = Column(children: orderContainer);
                return content;
              }),

          //tabs
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
            padding: EdgeInsets.only(top: 5, bottom: 6),
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: TabBar(
              labelStyle: TextStyle(
                fontSize: 16.0,
              ),
              labelColor: Colours.orange_72,
              unselectedLabelColor: Color(0xFF212121),
              indicatorColor: Colours.orange_72,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.only(bottom: 0.0),
              indicatorWeight: 2,
              tabs: titleTabs,
              controller: tabController,
              onTap: (index) {
                if (index == 0) {
                  //代管信息
                  if (selectOrderId != null) {
                    delegateDetailBloc.getDelegateList(selectOrderId);
                  }
                } else if (index == 1) {
                  //审核信息
                  if (selectOrderId != null) {
                    delegateDetailBloc.getOrderDetail(selectOrderId);
                  }
                } else if (index == 2) {
                  //查看合同
                  if (selectOrderId != null) {
                    delegateDetailBloc.getviewContract(selectOrderId);
                  }
                }
              },
            ),
          ),
          //tabview
          Container(
            height: MediaQuery.of(context).size.height - 302,
            margin: const EdgeInsets.only(
              top: 0,
            ),
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                ListView(children: <Widget>[
                  EscrowContent(
                      orderId: selectOrderId,
                      delegateDetailBloc: delegateDetailBloc), //代管信息
                ]),
                ListView(children: <Widget>[
                  ExamineContent(
                      orderId: selectOrderId,
                      delegateDetailBloc: delegateDetailBloc), //审核信息
                ]),
                ListView(children: <Widget>[
                  ContractTab(
                      orderId: selectOrderId,
                      delegateDetailBloc: delegateDetailBloc), //查看合同
                ]),
              ],
            ),
            // ],)
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class OrderList extends StatelessWidget {
  final bool capshow;
  final List orderList;
  final num tabIndex;
  final callback;
  final DelegateDetailBloc delegatedetailBloc;

  const OrderList({
    Key key,
    this.capshow,
    this.orderList,
    this.tabIndex,
    this.delegatedetailBloc,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Offstage(
        offstage: !capshow,
        child: Container(
          height: 125,
          margin: EdgeInsets.only(right: 110, top: 5),
          child: Column(
            children: <Widget>[
              Stack(
                alignment: FractionalOffset(0, -0.01),
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                          width: 193,
                          height: 115,
                          margin: EdgeInsets.only(top: 7, right: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colours.orange_72),
                              color: Colors.white),
                          child: ListView(
                            children: <Widget>[
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: new BouncingScrollPhysics(),
                                  itemCount: orderList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      child: Container(
                                          height: 39,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: Colours.orange_72),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                '${orderList[index]['updateTime']}订单${orderList[index]['id']}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colours.gray_21),
                                              ),
                                            ],
                                          )),
                                      onTap: () {
                                        var selectcapital =
                                            '${orderList[index]['updateTime']}订单${orderList[index]['id']}';
                                        var selectcapitalId =
                                            orderList[index]['id'];
                                        var selectcardId =
                                            orderList[index]['cardId'];
                                        this.callback(selectcapitalId,
                                            selectcapital, selectcardId);
                                        bool isFirst = true;
                                        if (tabIndex == 0) {
                                          //代管信息
                                          Future.delayed(new Duration(
                                                  milliseconds: 500))
                                              .then((_) {
                                            if (selectcapitalId != null) {
                                              delegatedetailBloc
                                                  .getDelegateList(
                                                      selectcapitalId);
                                            }
                                          });
                                        } else if (tabIndex == 1) {
                                          //审核信息
                                          Future.delayed(new Duration(
                                                  milliseconds: 500))
                                              .then((_) {
                                            if (selectcapitalId != null) {
                                              delegatedetailBloc.getOrderDetail(
                                                  selectcapitalId);
                                            }
                                          });
                                        } else if (tabIndex == 2) {
                                          //查看合同
                                          Future.delayed(new Duration(
                                                  milliseconds: 500))
                                              .then((_) {
                                            if (selectcapitalId != null) {
                                              delegatedetailBloc
                                                  .getviewContract(
                                                      selectcapitalId);
                                            }
                                          });
                                        }
                                      },
                                    );
                                  }),
                            ],
                          )),
                    ],
                  ),

                  // ]),
                  // ),
                  Container(
                    padding: EdgeInsets.only(right: 26, top: 2),
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
        ));
  }
}
