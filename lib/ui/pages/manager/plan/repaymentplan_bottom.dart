import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';

class RepaymentPlanBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20,left: 20,right: 20),
        decoration: BoxDecoration(
          color: Colours.gray_99,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: FlatButton(
            child: Text(
              '确认此计划',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () {},
          ),
        ));
  }
}