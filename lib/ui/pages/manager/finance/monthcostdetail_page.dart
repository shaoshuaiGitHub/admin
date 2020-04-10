import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import 'finance_index.dart';

class MonthCostDetailPage extends StatelessWidget {
  MonthCostDetailPage({this.condition});
  final String condition;
  @override
  Widget build(BuildContext context) {
    FinanceIndexBloc financeIndexBloc = FinanceIndexBloc();
    financeIndexBloc.bloccontext = context;

    print(condition);
    Future.delayed(new Duration(milliseconds: 100)).then((_) {
      financeIndexBloc.getFinancialMonthList(0, condition);
    });

    Map dateMap = {
      '01': '一',
      '02': '二',
      '03': '三',
      '04': '四',
      '05': '五',
      '06': '六',
      '07': '七',
      '08': '八',
      '09': '九',
      '10': '十',
      '11': '十一',
      '12': '十二',
    };

    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          // backgroundColor: Color.fromARGB(255, 255, 114, 0),
          title: Text(
            dateMap[condition.substring(14, 16)] + '月费用',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  StreamBuilder<FinancialMonthListModel>(
                      stream: financeIndexBloc.financialMonthlistStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<FinancialMonthListModel> snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        num monthlyTotals = snapshot.data.monthlyTotals;
                        return Container(
                          height: 44,
                          color: Colors.white,
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('${condition.substring(14, 16)}月',
                                  style: TextStyles.listContent),
                              Row(
                                children: <Widget>[
                                  Text('总费用', style: TextStyles.listContent),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('${monthlyTotals.toStringAsFixed(2)}',
                                      style: TextStyles.listContent),
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    padding: EdgeInsets.only(left: 15, right: 15),
                    color: Colours.white_color,
                    child: Column(
                      children: <Widget>[
                        Table(children: [
                          TableRow(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                SizedBox(
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    '日期',
                                    style: TextStyles.text16MediumLabel,
                                  )),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    '费用',
                                    style: TextStyles.text16MediumLabel,
                                  )),
                                ),
                              ],
                            )
                          ]),
                        ]),
                        StreamBuilder<FinancialMonthListModel>(
                            stream: financeIndexBloc.financialMonthlistStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<FinancialMonthListModel>
                                    snapshot) {
                              List<Widget> customerContainer = List<Widget>();
                              Widget content;
                              if (!snapshot.hasData) {
                                return Container();
                              }
                              List<FinancialMonthItemModel> mylist = snapshot
                                  .data.dataList
                                  .cast<FinancialMonthItemModel>();

                              mylist.forEach((item) => customerContainer.add(
                                    Table(children: [
                                      TableRow(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                            color: Colours.bottom_line,
                                            width: 1.0,
                                            style: BorderStyle.solid,
                                          ))),
                                          children: [
                                            FlatButton(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 50,
                                                    child: Center(
                                                        child: Text(
                                                      '${item.dataTime}',
                                                      style: TextStyles
                                                          .text15MediumPPLabel,
                                                    )),
                                                  ),
                                                  SizedBox(
                                                    height: 50,
                                                    child: Center(
                                                        child: Text(
                                                      '${item.account.toStringAsFixed(2)}',
                                                      style: TextStyles
                                                          .text15MediumPPLabel,
                                                    )),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            DayCostDetailPage(condition:
                                                                    '{"time":"${item.dataTime}"}')));
                                              },
                                            ),
                                          ]),
                                    ]),
                                  ));
                              content = Column(children: customerContainer);
                              return content;
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
