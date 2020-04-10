import 'package:flutter/material.dart';
import 'plan_index.dart';
import '../../../../common/component_index.dart';

class OrderDetailPage extends StatefulWidget {
  OrderDetailPage({Key key, this.id,this.applyStatus}) : super(key: key);
  final int id;
  final String applyStatus;

  @override
  State<StatefulWidget> createState() {
    return new OrderDetailPageState();
  }
}
class OrderDetailPageState extends State<OrderDetailPage> {

  OrderDetailBloc orderDetailBloc = OrderDetailBloc();
  @override
  Widget build(BuildContext context) {
    // orderDetailBloc.bloccontext = context;
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          // backgroundColor: Color.fromARGB(255, 255, 114, 0),
          title: Text(
            '订单详情',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        body:BlocProvider<OrderDetailBloc>(
        bloc: OrderDetailBloc(),
        child: ListView(
          children: <Widget>[
            OrderDetailMiddle(id:widget.id,applyStatus:widget.applyStatus),
            // OrderDetailBottom(),
          ],
        )));
  }
}
