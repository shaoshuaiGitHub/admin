import 'package:flutter/material.dart';
import 'package:youxinbao/blocs/bloc_provider.dart';
import 'package:youxinbao/blocs/capital/manage/plan_bloc.dart';
import 'package:youxinbao/common/component_index.dart';
import 'package:youxinbao/res/colors.dart';
import 'manage_whole.dart';
import 'manage_history.dart';


class ManagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ManagePage();
}

class _ManagePage extends State<ManagePage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<PlanBloc>(
      bloc: PlanBloc(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            titleSpacing: 0,
            backgroundColor: Color(0xFFFF9B1A),
            centerTitle: true,
            elevation: 0.0,
            title: Container(
              child: Text(
                '计划管理',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeights.bold,
                ),
              ),
            ),
            leading: Container(),
          ),
          body: Container(
            color: Color(0xFFF2F2F2),
            child: PlanMiddle(),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PlanMiddle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlanMiddle();
}

class _PlanMiddle extends State<PlanMiddle> {
  final List<Tab> titleTabs = <Tab>[
    Tab(
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Color(0xFFF2F2F2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '整体计划',
            ),
          ],
        ),
      ),
    ),
    Tab(
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Color(0xFFF2F2F2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '历史计划',
            ),
          ],
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        buildTabBarView(),
        Container(
          color: Color(0xFFF2F2F2),
          padding: EdgeInsets.only(
            left: 79,
            right: 79,
          ),
          height: 36,
          child: TabBar(
            labelStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeights.bold,
            ),
            labelColor: Color(0xFFFF9B1A),
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Color(0xFF212121),
            indicatorColor: Color(0xFFFF9B1A),
            indicatorWeight: 2,
            tabs: titleTabs,
          ),
        ),
      ],
    );
  }

  Widget buildTabBarView() {
    return Container(
      width: Screen.width,
      height: Screen.height - 60 - Screen.bottomTabBarHeight,
      child: TabBarView(
        children: <Widget>[
          AddManageWhole(),
          AddManageHistory(),
        ],
      ),
    );
  }
}
