import 'package:flutter/material.dart';
import 'mine_index.dart';

class MydetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        // backgroundColor: Color.fromARGB(255, 255, 114, 0),
        title: Text(
          '明细',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: Color(0xFFF2F2F2),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // ConsumContainer(),
            // LiftingAmountContainer(),
            MyDetailMiddle(),
          ],
        ),
      ),
    );
  }
}
