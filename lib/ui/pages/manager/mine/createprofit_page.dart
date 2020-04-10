import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'mine_index.dart';
import '../../../../common/component_index.dart';

class CreateProfitPage extends StatefulWidget {
  @override
  State<CreateProfitPage> createState() => _CreateProfitPage();
}

class _CreateProfitPage extends State<CreateProfitPage> {
  bool capshow = false;
  bool cardshow = false;
  var beforInputCtrl = TextEditingController();
  var afterInputCtrl = TextEditingController();
  var cardidInputCtrl = TextEditingController();
  var consumerInputCtrl = TextEditingController();
  var mycardNo;
  List<dynamic> mycards = [];
  double cost = 0;

  void onSelectUserId(userId, name, mycardList) {
    setState(() {
      consumerInputCtrl.text = name;
      capshow = !capshow;
      if (mycardList.isNotEmpty) {
        for (var card in mycardList) {
          Map<String, dynamic> mycard = {
            'name': card['name'],
            'cardNo': card['cardNo']
          };
          if (card['userId'].toString() == userId.toString()) {
            mycards.add(mycard);
          }
        }
      }
    });
  }

  void onSelectCardId(cardNo, bankName) {
    setState(() {
      cardidInputCtrl.text = bankName;
      cardshow = !cardshow;
      mycardNo = cardNo;
    });
  }

  CreateProfitBloc createProfitBloc = CreateProfitBloc();
  @override
  Widget build(BuildContext context) {
    createProfitBloc.bloccontext = context;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        // backgroundColor: Color.fromARGB(255, 255, 114, 0),
        title: Text(
          '创建提额分润',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          //触摸回收键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: BlocProvider<CreateProfitBloc>(
          bloc: CreateProfitBloc(),
          child: Stack(
            children: <Widget>[
              ListView(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StreamBuilder<GetCreateProfitDataModel>(
                      stream: createProfitBloc.mydataStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<GetCreateProfitDataModel> snapshot) {
                        List<Widget> dataContainer = [];
                        Widget content;

                        if (!snapshot.hasData) {
                          Future.delayed(new Duration(milliseconds: 500))
                              .then((_) {
                            createProfitBloc.getCreateProfitData();
                          });
                          return Container();
                        }

                        double masterRewardScale = snapshot.hasData
                            ? snapshot.data.masterRewardScale
                            : 0.0;
                        List ownerList =
                            snapshot.hasData ? snapshot.data.ownerList : [];
                        List cardList =
                            snapshot.hasData ? snapshot.data.cardList : [];
                        List<dynamic> myownerList = [];
                        List<dynamic> mycardList = [];
                        if (ownerList.isNotEmpty) {
                          for (var list in ownerList) {
                            Map<String, dynamic> mylist = {
                              'name': list.name,
                              'id': list.id
                            };

                            myownerList.add(mylist);
                          }
                        }
                        if (cardList.isNotEmpty) {
                          for (var clist in cardList) {
                            Map<String, dynamic> myclist = {
                              'name': clist.name,
                              'userId': clist.userId,
                              'cardNo': clist.cardNo,
                            };
                            mycardList.add(myclist);
                          }
                        }

                        dataContainer.add(Column(
                          children: <Widget>[
                            Container(
                              margin:
                                  EdgeInsets.only(top: 10, left: 20, right: 20),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 44,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          '代管类型：单次代操',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colours.gray_21),
                                        ),
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
                                                '客户',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colours.gray_21),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                  width: 200,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      TextField(
                                                        controller:
                                                            consumerInputCtrl,
                                                        textAlign:
                                                            TextAlign.left,
                                                        enabled: false,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: '请选择客户',
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          disabledBorder:
                                                              InputBorder.none,
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none,
                                                        ),
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff282828),
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
                                  ConsumerList(
                                    capshow: capshow,
                                    myownerList: myownerList,
                                    callback: (userId, name) => onSelectUserId(
                                        userId, name, mycardList),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
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
                                                '代管卡片',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colours.gray_21),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                  width: 200,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      TextField(
                                                        controller:
                                                            cardidInputCtrl,
                                                        textAlign:
                                                            TextAlign.left,
                                                        enabled: false,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: '请选择代管卡片',
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          disabledBorder:
                                                              InputBorder.none,
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none,
                                                        ),
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff282828),
                                                            fontSize: 13),
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            cardshow
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            size: 30,
                                            color: Colours.gray_66,
                                          ),
                                          onPressed: () {
                                            if (consumerInputCtrl.text.length ==
                                                0) {
                                              createProfitBloc
                                                  .showToast('请先选择客户');
                                              return;
                                            }
                                            cardshow = !cardshow;
                                            setState(() {
                                              cardshow = cardshow;
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  DelegateCardList(
                                    cardshow: cardshow,
                                    mycards: mycards,
                                    mycardList: mycardList,
                                    callback: (cardNo, name) =>
                                        onSelectCardId(cardNo, name),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: 44,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colours
                                                            .bottom_line))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      '提额前额度',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color:
                                                              Colours.gray_21),
                                                    ),
                                                    Container(
                                                      width: 200,
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child: TextField(
                                                          controller:
                                                              beforInputCtrl,
                                                          inputFormatters: [
                                                            WhitelistingTextInputFormatter(
                                                                RegExp(
                                                                    r"^\d+(?:\.\d{0,2})?"))
                                                          ], //保留两位有效数字
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                '请输入提额前卡片额度',
                                                            disabledBorder:
                                                                InputBorder
                                                                    .none,
                                                            focusedBorder:
                                                                InputBorder
                                                                    .none,
                                                            enabledBorder:
                                                                InputBorder
                                                                    .none,
                                                          ),
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colours
                                                                  .gray_99),
                                                          onChanged: (str) {
                                                            setState(() {
                                                              cost = (double.parse(
                                                                          afterInputCtrl
                                                                              .text) -
                                                                      double.parse(
                                                                          beforInputCtrl
                                                                              .text)) *
                                                                  masterRewardScale;
                                                            });
                                                          }),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  '元',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colours.gray_21),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 44,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      '提额后额度',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color:
                                                              Colours.gray_21),
                                                    ),
                                                    Container(
                                                      width: 200,
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child: TextField(
                                                        controller:
                                                            afterInputCtrl,
                                                        inputFormatters: [
                                                          WhitelistingTextInputFormatter(
                                                              RegExp(
                                                                  r"^\d+(?:\.\d{0,2})?"))
                                                        ], //保留两位有效数字
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              '请输入提额后卡片额度',
                                                          disabledBorder:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          enabledBorder:
                                                              InputBorder.none,
                                                        ),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colours
                                                                .gray_99),
                                                        onChanged: (str) {
                                                          setState(() {
                                                            cost = (double.parse(
                                                                        afterInputCtrl
                                                                            .text) -
                                                                    double.parse(
                                                                        beforInputCtrl
                                                                            .text)) *
                                                                masterRewardScale;
                                                          });
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  '元',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colours.gray_21),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              '提额费用',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colours.gray_21),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '￥$cost',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.red),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '创建后将从用户余额直接扣除提额费用',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colours.gray_99),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )

                            //  CreateProfitBottom(),
                            );
                        content = Column(
                          children: dataContainer,
                        );
                        return content;
                      })
                ],
              ),
              Positioned(
                child: Container(
                  margin: EdgeInsets.only(top: 10, left: 16, right: 16),
                  width: 360,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 114, 0),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '创建',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      if (cardidInputCtrl.text.length == 0) {
                        createProfitBloc.showToast('请选择代管卡片');
                        return;
                      }
                      if (beforInputCtrl.text.length == 0) {
                        createProfitBloc.showToast('请输入提额前卡片额度');
                        return;
                      }
                      if (afterInputCtrl.text.length == 0) {
                        createProfitBloc.showToast('请输入提额后卡片额度');
                        return;
                      }
                      if (double.parse(afterInputCtrl.text) <
                          double.parse(beforInputCtrl.text)) {
                        createProfitBloc.showToast('请输入正确的提额后额度');
                        return;
                      }
                      createProfitBloc.createAction(
                          mycardNo, beforInputCtrl.text, afterInputCtrl.text);
                    },
                  ),
                ),
                bottom: 50,
                left: 0,
                right: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConsumerList extends StatelessWidget {
  final bool capshow;
  final List myownerList;
  final callback;
  const ConsumerList({Key key, this.capshow, this.myownerList, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !capshow,
      child: Column(
        children: <Widget>[
          Stack(
            alignment: FractionalOffset(0, -0.07),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 193,
                    margin: EdgeInsets.only(top: 10),
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
                            itemCount: myownerList.length,
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
                                          '${myownerList[index]['name']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colours.gray_21),
                                        ),
                                      ],
                                    )),
                                onTap: () {
                                  var selectUserId =
                                      '${myownerList[index]['id']}';
                                  var name = '${myownerList[index]['name']}';
                                  this.callback(selectUserId, name);
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
                margin: EdgeInsets.only(top: 5),
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
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class DelegateCardList extends StatelessWidget {
  bool cardshow;
  List mycardList;
  List mycards;
  final callback;
  DelegateCardList(
      {Key key, this.cardshow, this.mycards, this.mycardList, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !cardshow,
      child: Column(
        children: <Widget>[
          Stack(
            alignment: FractionalOffset(0, -0.07),
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
                            itemCount: mycards != null ? mycards.length : 0,
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
                                          '${mycards[index]['name']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colours.gray_21),
                                        ),
                                      ],
                                    )),
                                onTap: () {
                                  var name = '${mycards[index]['name']}';
                                  var cardId = '${mycards[index]['cardNo']}';
                                  this.callback(cardId, name);
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
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
