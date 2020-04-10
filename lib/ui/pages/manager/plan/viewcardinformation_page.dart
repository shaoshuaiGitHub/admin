import 'package:flutter/material.dart';
import 'plan_index.dart';

class  ViewCardInformationPage extends StatefulWidget {
  ViewCardInformationPage({this.delegateMoney,this.delegateCardCount,this.accLimitMoney,this.cardIds});
  final String cardIds;
  final num delegateCardCount;
  final num delegateMoney;
  final num accLimitMoney;

@override
  State<StatefulWidget> createState() {
    return _ViewCardInformationPage();
  }
}
class  _ViewCardInformationPage extends State<ViewCardInformationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          // backgroundColor: Color.fromARGB(255, 255, 114, 0),
          title: Text(
            '信用卡管理',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        body: ListView(
          children: <Widget>[
            // ViewCardInformationHead(),
              ViewCardInformationMiddle(delegateMoney:widget.delegateMoney,delegateCardCount:widget.delegateCardCount,
                                          accLimitMoney:widget.accLimitMoney,cardIds:widget.cardIds),
          ],
        ));
  }
}
