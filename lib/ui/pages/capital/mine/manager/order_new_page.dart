import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youxinbao/blocs/bloc_provider.dart';
import 'package:youxinbao/blocs/capital/mine/manager_bloc.dart';
import 'package:youxinbao/common/component_index.dart';
import 'package:youxinbao/res/res_index.dart';
import 'application_escrow.dart';

class OrderNewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OrderNewPage();
}

class _OrderNewPage extends State<OrderNewPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ManagerBloc>(
      bloc: ManagerBloc(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            titleSpacing: 0,
            backgroundColor: Color(0xFFFF9B1A),
            centerTitle: true,
            elevation: 0.0,
            leading: MaterialButton(
              minWidth: 0,
              padding: const EdgeInsets.only(left: 7),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/capital/arrowmore_wbig_left.png',
                      width: 8,
                      height: 15,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      '返回',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            title: Container(
              child: Text(
                '新订单',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeights.bold,
                ),
              ),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Color(0xFFF2F2F2),
            ),
            child: Refresh(),
          ),
        ),
      ),
    );
  }
}

class Refresh extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Refresh();
}

class _Refresh extends State<Refresh> with SingleTickerProviderStateMixin {
  bool isFirst = true;
  final List<Tab> titleTabs = <Tab>[];
  @override
  Widget build(BuildContext context) {
    final ManagerBloc managerBloc = BlocProvider.of<ManagerBloc>(context);
    if (isFirst) {
      Future.delayed(new Duration(milliseconds: 100)).then((_) {
        managerBloc.getWaitApplyList();
      });
      isFirst = false;
    }

    return Stack(
      children: <Widget>[
        Container(
          height: 46,
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
            tabs: <Tab>[
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F2F2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '申请代管',
                      ),
                    ],
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F2F2),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          StreamBuilder(
                            initialData: 0,
                            stream: managerBloc.outIntApplyCount,
                            builder: (BuildContext context,
                                AsyncSnapshot<int> snapshot) {
                              return Text(
                                '申请解除(${snapshot.data})',
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        buildTabBarView(),
        Positioned(
          child: Container(
            width: Screen.width,
            height: 10,
            color: Color(0xFFF2F2F2),
          ),
          top: 46,
        ),
      ],
    );
  }

  Widget buildTabBarView() {
    return Container(
      width: Screen.width,
      height: Screen.height - Screen.bottomTabBarHeight,
      margin: const EdgeInsets.only(top: 50),
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: Container(
        child: TabBarView(
          children: <Widget>[
            ApplicationEscrow(),
            ApplicationRelieve(),
          ],
        ),
      ),
    );
  }
}
