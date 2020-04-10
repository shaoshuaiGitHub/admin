import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';

class FinanceIndexMiddle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FinanceIndexMiddle();
  }
}

class _FinanceIndexMiddle extends State<FinanceIndexMiddle>
    with AutomaticKeepAliveClientMixin {
  int tabnum = 1;
  int loadType = 0;
  FinanceIndexBloc financeIndexBloc;
  String condition = '{"startTime":"${DateTime.now().add(Duration(days: -210)).toString().substring(0, 7)}","endTime":"${DateTime.now().toString().substring(0, 7)}"}';
  
  void initState() {
    super.initState();
    Future.delayed(new Duration(milliseconds: 500)).then((_) {
      financeIndexBloc.getAccountCenterList(2, false);
      // financeIndexBloc.getFinancialList(2, condition, false);
      financeIndexBloc.tabSink.add(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    financeIndexBloc = BlocProvider.of<FinanceIndexBloc>(context);
    financeIndexBloc.bloccontext = context;
    return Container(
      height: Screen.height,
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
      ),
      child: StreamBuilder(
          stream: financeIndexBloc.tabStream,
          builder: (BuildContext context, snapshot) {
            return Column(
                // alignment: FractionalOffset(0, 0),
                children: <Widget>[
                  Container(
                    height: 60,
                    color: Colours.orange_72,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            width: 150,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: snapshot.data == 2
                                    ? Colours.orange_72
                                    : Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              '对账中心',
                              style: TextStyle(
                                color: snapshot.data == 2
                                    ? Colors.white
                                    : Colours.orange_72,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          onTap: () async {
                            if (snapshot.data != 1) {
                              financeIndexBloc.tabSink.add(1);
                              financeIndexBloc.getAccountCenterList(2, false);
                              tabnum = 1;
                            }
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            width: 150,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: snapshot.data == 1
                                    ? Colours.orange_72
                                    : Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              '财务管理',
                              style: TextStyle(
                                color: snapshot.data == 1
                                    ? Colours.white_color
                                    : Colours.orange_72,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          onTap: () async {
                            if (snapshot.data != 2) {
                              financeIndexBloc.tabSink.add(2);
                              financeIndexBloc.getFinancialList(
                                  2, condition, false);
                              tabnum = 2;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: snapshot.data == 1
                        ? ReconciliationCenter(
                            financeIndexBloc: financeIndexBloc)
                        : FinancialManagementContent(
                            financeIndexBloc: financeIndexBloc), //对账中心 FinancialManagementContent()
                  ),
                ]);
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
