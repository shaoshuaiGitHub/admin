import 'package:flutter/material.dart';
import 'package:youxinbao/blocs/bloc_index.dart';
import 'plan_index.dart';
import '../../../../ui/pages/page_index.dart';

class PlanConsumePage extends StatefulWidget {
  PlanConsumePage({Key key,this.id}): super(key: key);
  int id;

  @override
  State<StatefulWidget> createState() {
    return new PlanConsumeState();
  }
}

class PlanConsumeState extends State<PlanConsumePage> {
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
        body: BlocProvider<AllPlanItemDetailBloc>(
              bloc: AllPlanItemDetailBloc(),
              child: ListView(
                children: <Widget>[
                    PlanConsumeMiddle(id:widget.id),
                  //  PlanConsumeBottom(),
                ],
              ))
        );
  }
}
