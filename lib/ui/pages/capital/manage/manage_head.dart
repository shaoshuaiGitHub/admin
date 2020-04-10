import 'package:flutter/material.dart';
import 'package:youxinbao/res/colors.dart';

class AddManageHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.fromLTRB(0, 0, 60.0, 10.0),
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color: Color(0xFFFF9B1A), width: 2.0, style: BorderStyle.solid),
          ),
        ),
        child: Container(
          height: 24,
          child: Center(
            child: Text(
              '整体计划',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Color(0xFFFF9B1A),
                  fontWeight: FontWeights.bold),
            ),
          ),
        ),
      ),
      Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
        child: Container(
          height: 26,
          child: Center(
            child: Text(
              '历史计划',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Color(0xFF212121),
                  fontWeight: FontWeights.bold),
            ),
          ),
          
        ),
      ),
    ]);
  }
}
