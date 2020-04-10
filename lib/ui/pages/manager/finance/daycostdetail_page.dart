import 'package:flutter/material.dart';
import 'package:youxinbao/blocs/bloc_index.dart';
import 'finance_index.dart';

class DayCostDetailPage extends StatelessWidget {
  DayCostDetailPage({Key key, this.condition}) : super(key: key);
  final String condition;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          // backgroundColor: Color.fromARGB(255, 255, 114, 0),
          title: Text(
            '每日费用明细',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        body: BlocProvider<FinanceIndexBloc>(
            bloc: FinanceIndexBloc(),
            child: ListView(
              children: <Widget>[
                DayCostDetailMiddle(condition: condition),
              ],
            )));
  }
}
