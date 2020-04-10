import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';

class HistoryBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      padding: EdgeInsets.all(10),
      color: Colours.gray_cc,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'POS机名：XXX',
                style: TextStyle(fontSize: 14, color: Colours.gray_66),
              ),
              Row(
                children: <Widget>[
                  Text(
                    '收款金额：',
                    style: TextStyle(fontSize: 14, color: Colours.gray_21),
                  ),
                  Text(
                    '250000.00',
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'POS利率：XXX',
                style: TextStyle(fontSize: 14, color: Colours.gray_66),
              ),
              Text(
                '收款日期：2019-05-01 05：01',
                style: TextStyle(fontSize: 10, color: Colours.gray_21),
              ),
            ],
          ),
          Container(
            height: 1,
            color: Colours.gray_66,
            margin: EdgeInsets.only(top: 5, bottom: 5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                '对账时间：2019-05-01 15：10',
                style: TextStyle(fontSize: 12, color: Colours.gray_21),
              )
            ],
          )
        ],
      ),
    );
  }
}
