import 'package:flutter/material.dart';
import 'plan_index.dart';

class  RepaymentPlanPage extends StatelessWidget {
   RepaymentPlanPage({Key key,this.id}): super(key: key);
  int id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          // backgroundColor: Color.fromARGB(255, 255, 114, 0),
          title: Text(
            '计划详情',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        body: ListView(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
              RepaymentPlanMiddle(id:this.id),
            //  RepaymentPlanBottom(),
          ],
        ));
  }
}
