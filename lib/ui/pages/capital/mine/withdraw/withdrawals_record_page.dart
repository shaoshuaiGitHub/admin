import 'package:flutter/material.dart';
import 'package:youxinbao/blocs/bloc_provider.dart';
import 'package:youxinbao/blocs/capital/mine/withdraw_bloc.dart';
import 'package:youxinbao/models/models.dart';
import 'package:youxinbao/res/res_index.dart';

class WithdrawalsRecordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9B1A),
        centerTitle: true,
        elevation: 0,
        title: Text(
          '提现记录',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeights.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocProvider<WithdrawBloc>(
        bloc: WithdrawBloc(),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF2F2F2),
          ),
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: Log(),
        ),
      ),
    );
  }
}

class Log extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Log();
}

class _Log extends State<Log> {
  WithdrawBloc withdrawBloc = WithdrawBloc();
  @override
  Widget build(BuildContext context) {
    withdrawBloc.bloccontext = context;
    return StreamBuilder(
      stream: withdrawBloc.outLog,
      builder:
          (BuildContext context, AsyncSnapshot<WithdrawLogModel> snapshot) {
        if (!snapshot.hasData) {
          Future.delayed(new Duration(milliseconds: 100)).then((_) {
            withdrawBloc.getLogs(0);
          });
        }
        List<dynamic> logList = snapshot.hasData ? snapshot.data.logList : [];
        List<Widget> logListView = [];
        Widget logView;
        logList.forEach((item) => {
              logListView.add(
                Container(
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Color(0xFFEAEAEA),
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 24,
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                '提现金额',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeights.medium,
                                  color: Color(0xFF313131),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 1,
                                left: 50,
                              ),
                              child: Text(
                                '${item.money.toDouble()}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeights.medium,
                                  color: Color(0xFF272727),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 120,
                              height: 29,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '剩余可提现：${item.remainMoney.toDouble()}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF929292),
                                ),
                              ),
                            ),
                            Container(
                              width: 120,
                              height: 29,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${item.create_time}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF999999),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            });
        logView = ListView(
          children: logListView,
        );
        return logView;
      },
    );
  }
}
