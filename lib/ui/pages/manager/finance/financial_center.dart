import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_easyrefresh/material_footer.dart';

//对账中心
class ReconciliationCenter extends StatefulWidget {
  final FinanceIndexBloc financeIndexBloc;
  ReconciliationCenter({this.financeIndexBloc});
  @override
  State<StatefulWidget> createState() {
    return _ReconciliationCenter();
  }
}

class _ReconciliationCenter extends State<ReconciliationCenter>
    with AutomaticKeepAliveClientMixin {
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  int loadType = 0;
  num notReturned;
  List<dynamic> mylist = List();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    widget.financeIndexBloc.bloccontext = context;

    return Container(
      // color: Colours.bottom_line,
      // color: Colors.white,
      // padding: EdgeInsets.only(bottom: 80),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: FractionalOffset(0, 0.3),
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 30,
                    color: Colours.orange_72,
                  ),
                  Container(
                    height: 50,
                    // color: Colours.bottom_line,
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colours.orange_72),
                    borderRadius: BorderRadius.circular(5)),
                height: 60,
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('未归还总额', style: TextStyles.text16MediumLabel),
                    StreamBuilder(
                        stream: widget.financeIndexBloc.accountlistStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }
                          notReturned = snapshot.data['notReturned'];

                          return Text(
                              '${notReturned.toStringAsFixed(2)}', //${notReturned.toStringAsFixed(2)}
                              style: TextStyles.text16OrangeMediumLabel);
                        }),
                  ],
                ),
              )
            ],
          ),
          Container(
            height: Screen.height -
                Screen.navigationBarHeight -
                Screen.bottomTabBarHeight -
                60 -
                80 -
                12 -
                8,
            child: EasyRefresh(
              key: _easyRefreshKey,
              refreshHeader: MaterialHeader(
                key: _headerKey,
              ),
              refreshFooter: MaterialFooter(
                key: _footerKey,
              ),
              child: ListView(
                children: <Widget>[
                  StreamBuilder(
                      stream: widget.financeIndexBloc.accountlistStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        List<Widget> customerContainer = List<Widget>();
                        Widget content;
                        if (!snapshot.hasData) {
                          return Container();
                        }

                        mylist = snapshot.data['accountCheckList'];

                        mylist.isNotEmpty
                            ? mylist.forEach(
                                (item) => customerContainer.add(Container(
                                  height: 380,
                                  color: Colors.white,
                                  margin: EdgeInsets.only(top: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: EdgeInsets.all(10),
                                            color: Colours.orange_72,
                                            child: Text('${item.date}',
                                                style: TextStyles
                                                    .text16WhiteMediumLabel),
                                          ),
                                        ],
                                      ),
                                      Table(
                                        //所有列宽
                                        // columnWidths: const {
                                        //   //列宽
                                        //   0: FixedColumnWidth(100.0),
                                        //   1: FixedColumnWidth(160.0),
                                        //   2: FixedColumnWidth(160.0),
                                        // },

                                        children: [
                                          TableRow(
                                              // decoration: BoxDecoration(
                                              //     color: Colours.gray_cc,
                                              //   ),

                                              children: [
                                                Container(
                                                  height: 30.0,
                                                  decoration: BoxDecoration(
                                                      color: Colours.gray_cc,
                                                      border: Border(
                                                          bottom: BorderSide(
                                                        color: Colours.gray_e6,
                                                      ))),
                                                  child: Center(
                                                    child: Text('类型',
                                                        style: TextStyles
                                                            .text14MediumLabel),
                                                  ),
                                                ),
                                                Container(
                                                  height: 30.0,
                                                  decoration: BoxDecoration(
                                                      color: Colours.gray_cc,
                                                      border: Border(
                                                          bottom: BorderSide(
                                                        color: Colours.gray_e6,
                                                      ))),
                                                  child: Center(
                                                    child: Text('还款',
                                                        style: TextStyles
                                                            .text14MediumLabel),
                                                  ),
                                                ),
                                                Container(
                                                  height: 30.0,
                                                  decoration: BoxDecoration(
                                                      color: Colours.gray_cc,
                                                      border: Border(
                                                          bottom: BorderSide(
                                                        color: Colours.gray_e6,
                                                      ))),
                                                  child: Center(
                                                    child: Text('消费',
                                                        style: TextStyles
                                                            .text14MediumLabel),
                                                  ),
                                                ),
                                              ]),
                                          TableRow(
                                              //  decoration: BoxDecoration(
                                              //       border: Border(
                                              //           bottom: BorderSide(
                                              //     color: Colours.bottom_line,
                                              //     width: 1.0,
                                              //     style: BorderStyle.solid,
                                              //   ))),
                                              children: [
                                                Container(
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                    color: Colours.gray_e6,
                                                  ))),
                                                  child: Center(
                                                    child: Text(
                                                      '单次代还',
                                                      style: TextStyles
                                                          .text14MediumLabel,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                    color: Colours.gray_e6,
                                                  ))),
                                                  child: Center(
                                                    child: Text(
                                                        '${item.repay1.toStringAsFixed(2)}',
                                                        style: TextStyles
                                                            .text14MediumLabel),
                                                  ),
                                                ),
                                                Container(
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                    color: Colours.gray_e6,
                                                  ))),
                                                  child: Center(
                                                      child: Text(
                                                          '${item.consume1.toStringAsFixed(2)}',
                                                          style: TextStyles
                                                              .text14MediumLabel)),
                                                ),
                                              ]),
                                          TableRow(children: [
                                            Container(
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                color: Colours.gray_e6,
                                              ))),
                                              child: Center(
                                                child: Text(
                                                  '精养代操',
                                                  style: TextStyles
                                                      .text14MediumLabel,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                color: Colours.gray_e6,
                                              ))),
                                              child: Center(
                                                child: Text(
                                                    '${item.repay2.toStringAsFixed(2)}',
                                                    style: TextStyles
                                                        .text14MediumLabel),
                                              ),
                                            ),
                                            Container(
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                color: Colours.gray_e6,
                                              ))),
                                              child: Center(
                                                  child: Text(
                                                      '${item.consume2.toStringAsFixed(2)}',
                                                      style: TextStyles
                                                          .text14MediumLabel)),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Container(
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                color: Colours.gray_e6,
                                              ))),
                                              child: Center(
                                                child: Text(
                                                  '提额代操',
                                                  style: TextStyles
                                                      .text14MediumLabel,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                color: Colours.gray_e6,
                                              ))),
                                              child: Center(
                                                child: Text(
                                                    '${item.repay3.toStringAsFixed(2)}',
                                                    style: TextStyles
                                                        .text14MediumLabel),
                                              ),
                                            ),
                                            Container(
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                color: Colours.gray_e6,
                                              ))),
                                              child: Center(
                                                  child: Text(
                                                      '${item.consume3.toStringAsFixed(2)}',
                                                      style: TextStyles
                                                          .text14MediumLabel)),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Container(
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                color: Colours.gray_e6,
                                              ))),
                                              child: Center(
                                                child: Text(
                                                  '小计',
                                                  style: TextStyles
                                                      .text14MediumLabel,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                color: Colours.gray_e6,
                                              ))),
                                              child: Center(
                                                child: Text(
                                                    '${(item.repay1 + item.repay2 + item.repay3).toStringAsFixed(2)}',
                                                    style: TextStyles
                                                        .text14MediumLabel),
                                              ),
                                            ),
                                            Container(
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                color: Colours.gray_e6,
                                              ))),
                                              child: Center(
                                                  child: Text(
                                                      '${(item.consume1 + item.consume2 + item.consume3).toStringAsFixed(2)}',
                                                      style: TextStyles
                                                          .text14MediumLabel)),
                                            ),
                                          ]),
                                        ],
                                      ),
                                      Container(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.only(left: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text('收款转资金方总金额：',
                                                style: TextStyles
                                                    .text12MediumLabel),
                                            Text(
                                                '${(item.consume1 + item.consume2 + item.consume3).toStringAsFixed(2)}',
                                                style: TextStyles
                                                    .text12RedMediumLabel),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 15, right: 15),
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colours.orange_72),
                                        child: FlatButton(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text('对账无误',
                                                    style: TextStyles
                                                        .text18WhiteMediumLabel),
                                              ]),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Center(
                                                    child: Container(
                                                      height: 228,
                                                      width: 280,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colours.bottom_line,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Container(
                                                              height: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colours
                                                                    .orange_72,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .vertical(
                                                                            top:
                                                                                Radius.circular(5)),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    '对账无误？',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            20,
                                                                        decoration:
                                                                            TextDecoration.none),
                                                                  ),
                                                                ],
                                                              )),
                                                          Container(
                                                              height: 68,
                                                              width: 240,
                                                              margin: EdgeInsets
                                                                  .all(20),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    '请确认与资金方核对无误？',
                                                                    style: TextStyle(
                                                                        color: Colours
                                                                            .gray_21,
                                                                        fontSize:
                                                                            16,
                                                                        decoration:
                                                                            TextDecoration.none),
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
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colours
                                                                      .gray_99,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                child:
                                                                    FlatButton(
                                                                        child:
                                                                            Text(
                                                                          '取消',
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 16),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        }),
                                                              ),
                                                              Container(
                                                                width: 115,
                                                                height: 50,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colours
                                                                      .orange_72,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                child:
                                                                    FlatButton(
                                                                  child: Text(
                                                                    '确认',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    String
                                                                        condition =
                                                                        '{"time":"${item.date}","status":"2"}';
                                                                    widget
                                                                        .financeIndexBloc
                                                                        .checkAction(
                                                                            condition);
                                                                    widget
                                                                        .financeIndexBloc
                                                                        .getAccountCenterList(
                                                                            2,
                                                                            false);
                                                                  },
                                                                ),
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
                                      )
                                    ],
                                  ),
                                )),
                              )
                            : customerContainer.add(Container());
                        content = Column(children: customerContainer);
                        return content;
                      }),
                ],
              ),
              onRefresh: () async {
                widget.financeIndexBloc.getAccountCenterList(2, false);
              },
              loadMore: () async {
                widget.financeIndexBloc.getAccountCenterList(1, false);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
