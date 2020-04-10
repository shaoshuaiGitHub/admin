import 'dart:async';

import 'package:youxinbao/blocs/application_bloc.dart';
import 'package:youxinbao/blocs/manager/plan/allplanlist_bloc.dart';
import 'package:youxinbao/blocs/manager/plan/neworders_bloc.dart';
import 'package:youxinbao/blocs/manager/plan/recentuserlist_bloc.dart';
import 'package:youxinbao/common/screen.dart';
import 'package:youxinbao/models/models.dart';
import 'package:youxinbao/res/colors.dart';
import 'package:youxinbao/res/styles.dart';
import '../../../../ui/pages/page_index.dart';
import 'package:youxinbao/blocs/bloc_provider.dart';
import 'package:event_bus/event_bus.dart';
import 'package:youxinbao/ui/widgets/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart' hide NestedScrollView;

EventBus masterEventBus = new EventBus();

class MasterPlanCondition {
  int index;
  String condition;
  MasterPlanCondition(this.index, this.condition);
}

class PlanIndexMiddle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlanIndexMiddle();
  }
}

class _PlanIndexMiddle extends State<PlanIndexMiddle>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AllPlanListBloc allplanBloc;
  RecentUserListBloc recentUserListBloc = RecentUserListBloc();
  NewOrdersBloc neworderBloc = NewOrdersBloc();
  String condition1 =
      '{"startTime":"${DateTime.now().add(Duration(days: -6)).toString().substring(0, 11)}00:00:00","endTime":"${DateTime.now().toString().substring(0, 11)}23:59:59"}';
  String condition2 =
      '{"startTime":"${DateTime.now().add(Duration(days: -6)).toString().substring(0, 11)}00:00:00","endTime":"${DateTime.now().toString().substring(0, 11)}23:59:59","status":[4,-1]}';
  bool isWholeExpanded = false;
  bool isHistoryExpanded = false;
  num tabOneHeight = 0.0;

  num tabTwoHeight = 0.0;
  TabController _tabController;
  List<RecentUserItemModel> recentUserList = List<RecentUserItemModel>();
  int ordersnum = 0;
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
  ]; //tab

  @override
  void initState() {
    super.initState();
    allplanBloc = AllPlanListBloc();
    Future.delayed(new Duration(milliseconds: 500)).then((_) {
      recentUserListBloc.getRecentUserList(0);
    });
    Future.delayed(new Duration(milliseconds: 500)).then((_) {
      neworderBloc.getOrderList(0);
    });
    _tabController = TabController(vsync: this, length: titleTabs.length)
      ..addListener(() {
        if (_tabController.index.toDouble() == _tabController.animation.value) {
          allplanBloc.tabIndex = _tabController.index;
        }
      });

    masterEventBus.on<MasterPlanCondition>().listen(
      (event) {
        if (mounted) {
          if (event.index == 0) {
            condition1 = event.condition;
          } else {
            condition2 = event.condition;
          }
        }
      },
    );

    eventBuses.on<WholeExpanded>().listen(
      (event) {
        if (mounted) {
          isWholeExpanded = event.isExpanded;
        }
      },
    );

    eventBuses.on<HistoryExpanded>().listen(
      (event) {
        if (mounted) {
          isHistoryExpanded = event.isExpanded;
        }
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> buildSliverHeader(appBarHeight, applicationBloc) {
    var widgets = <Widget>[];
    widgets.add(
      SliverPersistentHeader(
        pinned: false,
        delegate: _SliverAppBarDelegate(
            Column(
              children: <Widget>[
                //近期用户
                StreamBuilder<RecentUserListModel>(
                    stream: recentUserListBloc.recentlistStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<RecentUserListModel> snapshot) {
                      if (snapshot.hasData) {
                        recentUserList = snapshot.data.recentUserList
                            .cast<RecentUserItemModel>();
                      }

                      return PlanIndexHead(
                        recentUserList: recentUserList,
                      );
                    }),
                //订单
                StreamBuilder(
                  stream: neworderBloc.orderlistStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<OrderListModel> snapshot) {
                    if (snapshot.hasData) {
                      ordersnum = snapshot.data.count;
                    }
                    return Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: 44,
                      child: FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '新订单($ordersnum)',
                              style: TextStyles.text16OrangeMediumLabel,
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  NewOrdersPage(),
                            ),
                          ).then((dynamic type) {
                            eventBuses.fire(GetOpen(true));
                            if (applicationBloc.backType == 1) {
                              neworderBloc.getOrderList(0);
                            }
                          });
                          eventBuses.fire(GetOpen(false));
                          eventBuses.fire(BackControl(true));
                          applicationBloc.backType = 0;
                        },
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            appBarHeight),
      ),
    );
    return widgets;
  }

  Future<Null> onRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    new Timer(const Duration(milliseconds: 500), () {
      completer.complete(null);
    });
    return completer.future.then((_) {
      if (allplanBloc.tabIndex == 0) {
        allplanBloc.getAllplanList(condition1, 2, false, isWholeExpanded);

        eventBuses.fire(WholePanel(false));
      } else {
        allplanBloc.getHistoryplanList(condition2, 2, false, isHistoryExpanded);

        eventBuses.fire(HistoryPanel(false));
      }
      recentUserListBloc.getRecentUserList(0);
      neworderBloc.getOrderList(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ApplicationBloc applicationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    allplanBloc.bloccontext = context;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    var _appBarHeight = 239.0 - statusBarHeight;
    var primaryTabBar = Container(
      padding: EdgeInsets.only(
        left: 80,
        right: 80,
      ),
      height: 36,
      decoration: BoxDecoration(
          color: Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(5)),
      child: TabBar(
        controller: _tabController,
        labelStyle: TextStyle(
          fontSize: 16.0,
        ),
        labelColor: Colours.orange_72,
        unselectedLabelColor: Color(0xFF212121),
        indicatorColor: Colours.orange_72,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorPadding: EdgeInsets.only(bottom: 0.0),
        indicatorWeight: 2,
        tabs: titleTabs,
      ),
    );
    return BlocProvider<AllPlanListBloc>(
      bloc: allplanBloc,
      child: NestedScrollViewRefreshIndicator(
        onRefresh: onRefresh,
        child: NestedScrollView(
          headerSliverBuilder: (c, f) {
            return buildSliverHeader(_appBarHeight, applicationBloc);
          },
          body: Column(
            children: <Widget>[
              primaryTabBar,
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    AllPlanIndexContent(),
                    HistoryPlanIndexContent(),
                  ],
                ),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._head, this._height);

  final Column _head;
  final double _height;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _head;
  }

  @override
  double get maxExtent => _height;

  @override
  double get minExtent => _height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
