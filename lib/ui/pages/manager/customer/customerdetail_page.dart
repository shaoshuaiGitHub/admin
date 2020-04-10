import 'package:flutter/material.dart';
import 'customer_index.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';

class CustomerDetailPage extends StatefulWidget {
  CustomerDetailPage({Key key,this.uid,}):super(key:key);
  final int uid;
  // final String name;
  // final num delegateMoney;
  // final num accLimit;
  // final int count;

  @override
  State<StatefulWidget> createState() {
    return _CustomerDetailPage();
  }
}

class _CustomerDetailPage extends State<CustomerDetailPage> 
with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            brightness: Brightness.light,
            titleSpacing: 0,
            backgroundColor: Colours.orange_72,
            centerTitle: true,
            elevation: 0.0,
            title: Container(
              child: Text(
                '客户详情',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeights.bold,
                ),
              ),
            ),
          ),
          body: BlocProvider<AllPlanListBloc>(
              bloc: AllPlanListBloc(),
              child: ListView(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                    ),
                    child: CustomerDetailMiddle(uid:widget.uid),
                  ),
                ],
              ))),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
