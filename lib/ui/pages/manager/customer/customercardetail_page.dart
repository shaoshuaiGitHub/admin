import 'package:flutter/material.dart';
import 'customer_index.dart';
import '../../../../common/component_index.dart';

class CustomerCardDetailPage extends StatefulWidget{
  CustomerCardDetailPage({Key key,this.cardId,this.item}):super(key:key);
  int cardId;
  CustomerDetailItemModel item;
  @override
  State<StatefulWidget> createState() {
    return _CustomerCardDetailPage();
  }

}
class _CustomerCardDetailPage extends State<CustomerCardDetailPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color(0xfff2f2f2),
          appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            // backgroundColor: Color.fromARGB(255, 255, 114, 0),
            title: Text(
              '客户详情',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          body:  
          BlocProvider<AllPlanListBloc>(
              bloc: AllPlanListBloc(),
              child: 
              Container(
            decoration: BoxDecoration(
              color: Color(0xFFF2F2F2),
            ),
            child:
            CustomerCardDetailMiddle(cardId:widget.cardId,item:widget.item),
          )
          // ),
          // ListView(
          //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          //      CustomerCardDetailHead(),
          //      CustomerCardDetailMiddle(),
          //   ],
          // )
        )));
  }
}

