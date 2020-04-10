import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import '../../../../ui/widgets/expansion_panel.dart';
import 'customer_index.dart';

class CustomerDetailMiddle extends StatefulWidget {
  CustomerDetailMiddle({
    Key key,
    this.uid,
    // this.name,
    // this.count,
    // this.delegateMoney,
    // this.accLimit
  }) : super(key: key);
  final int uid;
  // final String name;
  // final num delegateMoney;
  // final num accLimit;
  // final int count;

  @override
  State<StatefulWidget> createState() {
    return _CustomerDetailMiddle();
  }
}

class _CustomerDetailMiddle extends State<CustomerDetailMiddle>
    with SingleTickerProviderStateMixin {
  var name;
  var delegateCardCount;
  var totalUsableMoney;
  var totalAccLimit;
  String condition;

  int tabIndex = 0; //初始第一个页面
  final List<Tab> titleTabs = <Tab>[
    Tab(
      child: Container(
        height: 44,
        decoration: BoxDecoration(),
        child: Text('卡片管理'),
      ),
    ),
    Tab(
      child: Container(
        height: 44,
        decoration: BoxDecoration(),
        child: Text('全部计划'),
      ),
    )
  ]; //tab
  bool isdelete = true;
  bool isdelete1 = false;
  void changeValue(val) {
    setState(() {
      isdelete = val;
      isdelete1 = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomerDetailBloc customerDetailBloc = CustomerDetailBloc();
    AllPlanListBloc allplanBloc = BlocProvider.of<AllPlanListBloc>(context);
    customerDetailBloc.bloccontext = context;

    final ApplicationBloc applicationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    if (applicationBloc.backType == 1) {
      changeValue(true);
    }
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
      ),
      child: Column(
        // alignment: FractionalOffset(0, 1.55),
        children: <Widget>[
          Column(
            children: <Widget>[
              CustomerDetailHead(
                uid: widget.uid,
                isdelete: isdelete,
                // name: widget.name,
                // delegateCardCount: widget.count,
                // totalUsableMoney: widget.delegateMoney,
                // totalAccLimit: widget.accLimit
              ),
              //tabs
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                padding: EdgeInsets.only(top: 5, bottom: 6),
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: TabBar(
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
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height - 190,
            margin: EdgeInsets.only(left: 20, right: 20),
            child: TabBarView(
              // controller: tabController,
              children: <Widget>[
                CardManagerContent(
                    customerDetailBloc: customerDetailBloc,
                    userId: widget.uid,
                    allplanBloc: allplanBloc,
                    isdelete: isdelete1,
                    callback: (val) => changeValue(val)),
                ListView(children: <Widget>[
                  AllPlanContent(
                      allPlanListBloc: allplanBloc, userId: widget.uid),
                ]),
              ],
            ),
            // ],)
          ),
        ],
      ),
    );
  }
}
