import 'package:flutter/material.dart';
import 'package:youxinbao/blocs/bloc_index.dart';
import 'customer_index.dart';

class CustomerDetailAllplanHistoryPage extends StatelessWidget {
  CustomerDetailAllplanHistoryPage({this.userId, this.cardId});
  int userId;
  int cardId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfff2f2f2),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          // backgroundColor: Color.fromARGB(255, 255, 114, 0),
          title: Text(
            '历史计划',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        body: BlocProvider<AllPlanListBloc>(
          bloc: AllPlanListBloc(),
          child:
              //       ListView(
              // children: <Widget>[
              CustomerDetailAllplanHistoryMiddle(
                  userId: userId, cardId: cardId),
          //   ],
          // )
        ));
  }
}
