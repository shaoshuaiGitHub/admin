import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
// import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
// import 'package:numberpicker/numberpicker.dart';
import '../../../../ui/widgets/yearmonth_selector.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_easyrefresh/material_footer.dart';

//财务管理
class FinancialManagementContent extends StatefulWidget {
  final FinanceIndexBloc financeIndexBloc;
  FinancialManagementContent({this.financeIndexBloc});
  @override
  State<StatefulWidget> createState() {
    return _FinancialManagementContent();
  }
}

class _FinancialManagementContent extends State<FinancialManagementContent>
    with AutomaticKeepAliveClientMixin {
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  String selectDateRangeStr = '请选择日期';
  String startMonth = '选择日期';
  String endMonth = '选择日期';
  DateTime mystartDate;
  DateTime myendDate;

  int loadType = 0;

  String condition = '';

  bool isFirstCl = true;
  List<dynamic> mylist = List();
  List<dynamic> dataTop = List();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    widget.financeIndexBloc.bloccontext = context;

    return Column(
      children: <Widget>[
        Container(
          height: 140,
          width: MediaQuery.of(context).size.width,
          color: Colours.orange_72,
          child: StreamBuilder(
              stream: widget.financeIndexBloc.financiallistStream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                List<Widget> customerContainer = List<Widget>();
                Widget content;
                if (!snapshot.hasData) {
                  return Container();
                }

                dataTop = snapshot.data['dataTop'];
                dataTop.forEach((item) => customerContainer.add(Column(
                      children: <Widget>[
                        SizedBox(height: 10),
                        Text(item.totalCost.toStringAsFixed(2),
                            style: TextStyles.text25WhiteMediumLabel),
                        Text('总费用', style: TextStyles.text14WhiteMediumLabel),
                        Container(
                          height: 60,
                          color: Color.fromARGB(30, 0, 0, 0),
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('${item.repay1.toStringAsFixed(2)}',
                                      style: TextStyles.text16WhiteMediumLabel),
                                  Text('单次代还',
                                      style: TextStyles.text13WhiteMediumLabel),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('${item.repay2.toStringAsFixed(2)}',
                                      style: TextStyles.text14WhiteMediumLabel),
                                  Text('精养代操',
                                      style: TextStyles.text13WhiteMediumLabel),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('${item.repay3.toStringAsFixed(2)}',
                                      style: TextStyles.text14WhiteMediumLabel),
                                  Text('提额代操',
                                      style: TextStyles.text13WhiteMediumLabel),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    )));
                content = Column(children: customerContainer);
                return content;
              }),
        ),
        Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            padding: EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  child: Image.asset(
                    ImgPrefix.manager_prefix + 'date_filter_icon.png',
                    width: 16,
                    height: 16,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, state) {
                          return Container(
                            margin: EdgeInsets.only(
                              top: 193,
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: 300,
                                  height: 180,
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colours.white_color,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '选择日期',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colours.orange_72,
                                          fontWeight: FontWeights.medium,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                height: 20,
                                                child: FlatButton(
                                                  padding: EdgeInsets.all(0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        '开始日期',
                                                        style: TextStyles
                                                            .text14MediumLabel,
                                                      ),
                                                      Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          size: 20,
                                                          color:
                                                              Colours.gray_99),
                                                    ],
                                                  ),
                                                  onPressed:
                                                      // _showDialog,
                                                      () {
                                                    DatePicker.showDatePicker(
                                                        context,
                                                        showTitleActions: true,
                                                        minTime:
                                                            DateTime(2018, 1),
                                                        maxTime:
                                                            DateTime(2020, 1),
                                                        theme: DatePickerTheme(
                                                            backgroundColor:
                                                                Colors.white,
                                                            itemStyle: TextStyle(
                                                                color: Colours
                                                                    .orange_72,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            doneStyle: TextStyle(
                                                                color: Colours
                                                                    .orange_72,
                                                                fontSize: 14)),
                                                        onChanged: (date) {},
                                                        onConfirm: (date) {
                                                      mystartDate = date;
                                                      if (isFirstCl) {
                                                        myendDate =
                                                            DateTime(2020, 1);
                                                        isFirstCl = false;
                                                      }
                                                      if (!date.isBefore(
                                                          myendDate)) {
                                                        date = myendDate;
                                                      }
                                                      state(() {
                                                        startMonth = date
                                                            .toString()
                                                            .substring(0, 7);
                                                      });
                                                    },
                                                        currentTime:
                                                            DateTime.now(),
                                                        locale: LocaleType.zh);
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '$startMonth',
                                                style: TextStyles
                                                    .text10OrangeMediumLabel,
                                              ),
                                            ],
                                          ),
                                          //中间的分割线
                                          Container(
                                            height: 15,
                                            margin: EdgeInsets.only(
                                                left: 20, right: 20),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    left: BorderSide(
                                                        width: 1,
                                                        color:
                                                            Colours.gray_e6))),
                                          ),
                                          Column(children: <Widget>[
                                            Container(
                                              height: 20,
                                              child: FlatButton(
                                                padding: EdgeInsets.all(0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      '结束日期',
                                                      style: TextStyles
                                                          .text14MediumLabel,
                                                    ),
                                                    Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                        size: 20,
                                                        color: Colours.gray_99),
                                                  ],
                                                ),
                                                onPressed:
                                                    // _showDialog,
                                                    () async {
                                                  await DatePicker.showDatePicker(
                                                      context,
                                                      showTitleActions: true,
                                                      minTime:
                                                          DateTime(2018, 1),
                                                      maxTime:
                                                          DateTime(2020, 1),
                                                      theme: DatePickerTheme(
                                                          backgroundColor:
                                                              Colors.white,
                                                          itemStyle: TextStyle(
                                                              color: Colours
                                                                  .orange_72,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          doneStyle: TextStyle(
                                                              color: Colours
                                                                  .orange_72,
                                                              fontSize: 14)),
                                                      onChanged: (date) {},
                                                      onConfirm: (date) {
                                                    myendDate = date;
                                                    if (isFirstCl) {
                                                      mystartDate =
                                                          DateTime(2018, 1);
                                                      isFirstCl = false;
                                                    }
                                                    if (!date
                                                        .isAfter(mystartDate)) {
                                                      date = mystartDate;
                                                    }
                                                    state(() {
                                                      endMonth = date
                                                          .toString()
                                                          .substring(0, 7);
                                                    });
                                                  },
                                                      currentTime:
                                                          DateTime.now(),
                                                      locale: LocaleType.zh);
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '$endMonth',
                                              style: TextStyles
                                                  .text10OrangeMediumLabel,
                                            ),
                                          ]),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Container(
                                            width: 105,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colours.gray_e6,
                                            ),
                                            child: FlatButton(
                                              child: Text(
                                                '取消',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colours.gray_99),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                          Container(
                                            width: 105,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colours.orange_72,
                                            ),
                                            child: FlatButton(
                                              child: Text(
                                                '确定',
                                                style: TextStyles
                                                    .text16WhiteMediumLabel,
                                              ),
                                              onPressed: () {
                                                if (endMonth == '选择日期' &&
                                                    startMonth == '选择日期') {
                                                  widget.financeIndexBloc
                                                      .showToast('请选择日期');
                                                  return;
                                                }
                                                if (startMonth == '选择日期') {
                                                  widget.financeIndexBloc
                                                      .showToast('请选择开始日期');
                                                  return;
                                                }
                                                if (endMonth == '选择日期') {
                                                  widget.financeIndexBloc
                                                      .showToast('请选择结束日期');
                                                  return;
                                                }
                                                condition =
                                                    '{ "startTime": "$startMonth","endTime":"$endMonth"}';
                                                Navigator.pop(context);

                                                widget.financeIndexBloc
                                                    .getFinancialList(
                                                        2, condition, false);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                      },
                    );
                  },
                ),
              ],
            )),
        Container(
          height: Screen.height -
              Screen.navigationBarHeight -
              Screen.bottomTabBarHeight -
              60 -
              140 -
              36 -
              12 -
              8,
          // padding: EdgeInsets.only(bottom: 200),
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
                  stream: widget.financeIndexBloc.financiallistStream,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    List<Widget> customerContainer = List<Widget>();
                    Widget content;
                    if (!snapshot.hasData) {
                      return Container();
                    }

                    mylist = snapshot.data['financialList'];

                    mylist.forEach((item) => customerContainer.add(
                          MaterialButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            MonthCostDetailPage(
                                                condition:
                                                    '{"time":"${item.date}"}')));
                              },
                              child: Container(
                                color: Colors.white,
                                height: 194,
                                margin: EdgeInsets.only(bottom: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      color: Colours.orange_72,
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      height: 44,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text('${item.date}',
                                                  style: TextStyles
                                                      .text16WhiteMediumLabel),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text('总费用',
                                                  style: TextStyles
                                                      .text16WhiteMediumLabel),
                                              Text(
                                                  '${item.totalCost.toStringAsFixed(2)}',
                                                  style: TextStyles
                                                      .text16WhiteMediumLabel),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colours.bottom_line)),
                                      ),
                                      padding:
                                          EdgeInsets.only(left: 15, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text('单次代还',
                                              style:
                                                  TextStyles.text14MediumLabel),
                                          Text(
                                              '${item.repay1.toStringAsFixed(2)}',
                                              style:
                                                  TextStyles.text14MediumLabel),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colours.bottom_line)),
                                      ),
                                      padding:
                                          EdgeInsets.only(left: 15, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text('精养代操',
                                              style:
                                                  TextStyles.text14MediumLabel),
                                          Text(
                                              '${item.repay2.toStringAsFixed(2)}',
                                              style:
                                                  TextStyles.text14MediumLabel),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text('提额代操',
                                              style:
                                                  TextStyles.text14MediumLabel),
                                          Text(
                                              '${item.repay3.toStringAsFixed(2)}',
                                              style:
                                                  TextStyles.text14MediumLabel),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ));
                    content = Column(children: customerContainer);
                    return content;
                  }),
            ]),
            onRefresh: () async {
              widget.financeIndexBloc.getFinancialList(2, condition, false);
            },
            loadMore: () async {
              widget.financeIndexBloc.getFinancialList(1, condition, false);
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
