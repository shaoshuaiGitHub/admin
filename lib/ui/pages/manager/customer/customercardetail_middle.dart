import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';



class CustomerCardDetailMiddle extends StatefulWidget {
  CustomerCardDetailMiddle({this.cardId, this.item});
  int cardId;
  CustomerDetailItemModel item;
  @override
  State<StatefulWidget> createState() {
    return _CustomerCardDetailMiddle();
  }
}

class _CustomerCardDetailMiddle extends State<CustomerCardDetailMiddle>
    with SingleTickerProviderStateMixin {
  String name;
  num delegateCardCount;
  num totalUsableMoney;
  num totalAccLimit;
  String condition;

  int tabIndex = 0; //初始第一个页面
  final List<Tab> titleTabs = <Tab>[
    Tab(
      child: Container(
        height: 44,
        decoration: BoxDecoration(
            // color: Color(0xFFF2F2F2),
            ),
        child: Text('计划'),
      ),
    ),
    Tab(
      child: Container(
        height: 44,
        decoration: BoxDecoration(
            // color: Color(0xFFF2F2F2),
            ),
        child: Text('账单'),
      ),
    )
  ]; //tab

  @override
  Widget build(BuildContext context) {
    CustomerDetailBloc customerDetailBloc = CustomerDetailBloc();
    AllPlanListBloc allplanBloc = BlocProvider.of<AllPlanListBloc>(context);
    customerDetailBloc.bloccontext = context;

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Stack(
        alignment: FractionalOffset(0, 1.4),
        children: <Widget>[
          Column(
            children: <Widget>[
              //头部
              CustomerCardDetailHead(item: widget.item),

              Column(
                  // alignment: FractionalOffset(0,0.2),
                  children: <Widget>[
                    //tabs
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
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
                    //tabview
                    Container(
                      height: MediaQuery.of(context).size.height - 331,
                      child: TabBarView(
                        children: <Widget>[
                          // ListView(children: <Widget>[
                          PlanContent(
                              allPlanListBloc: allplanBloc,
                              cardId: widget.cardId),
                          //  ]), //计划
                          ListView(children: <Widget>[
                            Bill(cardId: widget.cardId), //账单
                          ]),
                        ],
                      ),
                      // ],)
                    ),
                  ]),
            ],
          ),
        ],
      ),
    );
  }
}