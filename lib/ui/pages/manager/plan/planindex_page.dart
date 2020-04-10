import 'package:flutter/material.dart';
import 'package:youxinbao/ui/pages/page_index.dart' as prefix0;
import 'plan_index.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class PlanIndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlanIndexPage();
  }
}

class _PlanIndexPage extends State<PlanIndexPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          // backgroundColor: Color.fromARGB(255, 255, 114, 0),
          title: Text(
            '计划管理',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          leading: Row(
            children: <Widget>[],
          ),
        ),
        body:
            // Container()));
            BlocProvider<AllPlanListBloc>(
          bloc: AllPlanListBloc(),
          child: ListView(
            children: <Widget>[
              Container(
                height: Screen.height,
                decoration: BoxDecoration(
                  color: Color(0xFFF2F2F2),
                ),
                child: PlanIndexMiddle(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
