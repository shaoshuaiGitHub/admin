import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_easyrefresh/material_footer.dart';

class DayCostDetailMiddle extends StatefulWidget {
  DayCostDetailMiddle({Key key, this.condition}) : super(key: key);
  final String condition;
  @override
  State<StatefulWidget> createState() {
    return _DayCostDetailMiddle();
  }
}

class _DayCostDetailMiddle extends State<DayCostDetailMiddle> {
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  bool isFirst = true;
  bool isOpen = true;
  int loadType = 0;
  void changeValue(val) {
    this.setState(() {
      isOpen = true;
      loadType = 2;
    });
  }

  void updatePlan(val) {
    this.setState(() {
      isOpen = val;
      loadType = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    FinanceIndexBloc financeIndexBloc =
        BlocProvider.of<FinanceIndexBloc>(context);
    financeIndexBloc.bloccontext = context;

    if (isOpen) {
      Future.delayed(new Duration(milliseconds: 500)).then((_) {
        financeIndexBloc.getFinancialDayList(loadType, widget.condition);
      });
      isOpen = false;
    }
    List<dynamic> mylist = List();
    num account;
    return Container(
      child: Column(children: <Widget>[
        StreamBuilder(
            stream: financeIndexBloc.financialDaylistStream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                print(321);
                return Container();
              }
              account = snapshot.data['account'];
              return Container(
                height: 44,
                color: Colors.white,
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('${widget.condition.substring(9, 19)}',
                        style: TextStyles.listContent),
                    Row(
                      children: <Widget>[
                        Text('总费用', style: TextStyles.listContent),
                        SizedBox(
                          width: 5,
                        ),
                        Text('${account.toStringAsFixed(2)}',
                            style: TextStyles.listContent),
                      ],
                    )
                  ],
                ),
              )
                  // ,
                  ;
            }),
        Container(
          margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
          padding: EdgeInsets.only(left: 15, right: 15),
          color: Colours.white_color,
          child: Column(
            children: <Widget>[
              Container(
                child: Table(children: [
                  TableRow(children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   children: <Widget>[
                    SizedBox(
                      height: 50,
                      child: Center(
                          child: Text(
                        '时间',
                        style: TextStyles.text16MediumLabel,
                      )),
                    ),
                    SizedBox(
                      height: 50,
                      child: Center(
                          child: Text(
                        '客户',
                        style: TextStyles.text16MediumLabel,
                      )),
                    ),
                    SizedBox(
                      height: 50,
                      // child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '类型',
                                  style: TextStyles.text16MediumLabel,
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 20,
                                  color: Colours.gray_66,
                                ),
                              ],
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 114,
                                          width: 120,
                                          color: Colors.white,
                                          margin: EdgeInsets.only(
                                              top: 160, left: 90),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                  height: 38,
                                                  margin: EdgeInsets.only(
                                                      left: 10, right: 10),
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: Colours
                                                                  .bottom_line))),
                                                  child: FlatButton(
                                                    child: Text(
                                                      '提额代操',
                                                      style: TextStyles
                                                          .text15MediumLabel,
                                                    ),
                                                    onPressed: () {
                                                      financeIndexBloc
                                                              .addfilterDayFinancialList =
                                                          List();
                                                      Navigator.pop(context);
                                                      String newcondition =
                                                          '${widget.condition.substring(0, widget.condition.length - 1)}' +
                                                              ',"type":"3"}';
                                                      financeIndexBloc
                                                          .getFinancialDayList(
                                                              loadType,
                                                              newcondition);
                                                    },
                                                  )),
                                              Container(
                                                  height: 38,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: Colours
                                                                  .bottom_line))),
                                                  child: FlatButton(
                                                    child: Text(
                                                      '单次代还',
                                                      style: TextStyles
                                                          .text15MediumLabel,
                                                    ),
                                                    onPressed: () {
                                                      financeIndexBloc
                                                              .addfilterDayFinancialList =
                                                          List();
                                                      Navigator.pop(context);
                                                      String newcondition =
                                                          '${widget.condition.substring(0, widget.condition.length - 1)}' +
                                                              ',"type":"1"}';
                                                      financeIndexBloc
                                                          .getFinancialDayList(
                                                              loadType,
                                                              newcondition);
                                                    },
                                                  )),
                                              Container(
                                                  height: 38,
                                                  child: FlatButton(
                                                    child: Text(
                                                      '精养代操',
                                                      style: TextStyles
                                                          .text15MediumLabel,
                                                    ),
                                                    onPressed: () {
                                                      financeIndexBloc
                                                              .addfilterDayFinancialList =
                                                          List();
                                                      Navigator.pop(context);
                                                      String newcondition =
                                                          '${widget.condition.substring(0, widget.condition.length - 1)}' +
                                                              ',"type":"2"}';
                                                      financeIndexBloc
                                                          .getFinancialDayList(
                                                              loadType,
                                                              newcondition);
                                                    },
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                          )
                        ],
                        // ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Center(
                          child: Text(
                        '费用',
                        style: TextStyles.text16MediumLabel,
                      )),
                    ),
                    //   ],
                    // )
                  ]),
                ]),
              )
            ],
          ),
        ),
        Container(
          height: Screen.height - 90,
          child: EasyRefresh(
            key: _easyRefreshKey,
            refreshHeader: MaterialHeader(
              key: _headerKey,
            ),
            refreshFooter: MaterialFooter(
              key: _footerKey,
            ),
            child: ListView(children: <Widget>[
              StreamBuilder(
                  stream: financeIndexBloc.financialDaylistStream,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    List<Widget> customerContainer = List<Widget>();
                    Widget content;
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    mylist = snapshot.data['dataList'];

                    mylist.forEach((item) => customerContainer.add(
                          Container(
                              margin: EdgeInsets.only(left: 15, right: 15),
                              padding: EdgeInsets.only(left: 15, right: 15),
                              color: Colours.white_color,
                              child: Table(children: [
                                TableRow(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                            top: BorderSide(
                                          color: Colours.bottom_line,
                                          width: 1.0,
                                          style: BorderStyle.solid,
                                        ))),
                                    children: [
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      //   children: <Widget>[
                                      SizedBox(
                                        height: 50,
                                        // width: 70,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                '${item.dateTime.substring(11, 19)}',
                                                style: TextStyles
                                                    .text15MediumPPLabel,
                                              ),
                                              Text(
                                                '${item.dateTime.substring(0, 10)}',
                                                style: TextStyle(
                                                    color: Colours.gray_99,
                                                    fontSize: 10),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                        // width: 60,
                                        child: Center(
                                            child: Text(
                                          '${item.name}',
                                          style: TextStyles.text15MediumPPLabel,
                                        )),
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: Center(
                                            child: Text(
                                          '${item.type}',
                                          style: TextStyles.text15MediumPPLabel,
                                        )),
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: Center(
                                            child: Text(
                                          '${item.realMoney.toStringAsFixed(2)}',
                                          style: TextStyles.text15MediumPPLabel,
                                        )),
                                      ),
                                      //   ],
                                      // ),
                                    ]),
                              ])),
                        ));
                    content = Column(children: customerContainer);
                    return content;
                  }),
            ]),
            onRefresh: () async {
              this.setState(() {
                isOpen = true;
                loadType = 2;
                financeIndexBloc.addDayFinancialList = List();
                financeIndexBloc.addfilterDayFinancialList = List();
              });
            },
            loadMore: () async {
              this.setState(
                () {
                  isOpen = true;
                  loadType = 1;
                },
              );
            },
          ),
        )
      ]),
    );
  }
}
