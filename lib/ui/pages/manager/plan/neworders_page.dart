import 'package:flutter/material.dart';
import 'plan_index.dart';
import '../../../../common/component_index.dart';

class  NewOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          // backgroundColor: Color.fromARGB(255, 255, 114, 0),
          title: Text(
            '新订单',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        body:BlocProvider<NewOrdersBloc>(
        bloc: NewOrdersBloc(),
        child: Stack(
          children: <Widget>[
            Container(
              height: 40,
            margin: EdgeInsets.only(left: 20, right: 20,bottom:10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  '申请代管',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colours.orange_72,
                  ),
                ),
              ],
            ),
          ),
            
            Container(
              margin: EdgeInsets.only(top:30),
              child: NewOrdersMiddle(),
            ),
             
          ],
        )));
  }
}
