import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';

class CustomerIndexMiddle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CustomerIndexMiddle();
  }
}

class _CustomerIndexMiddle extends State<CustomerIndexMiddle> {
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  bool isFirst = true;
  String condition = '';

  CustomerIndexBloc customerindexBloc = CustomerIndexBloc();
  void searchCustomer(String str) {
    condition = str;
    Future.delayed(new Duration(milliseconds: 500)).then((_) {
      customerindexBloc.getCustomerList(str);
    });
  }

  @override
  Widget build(BuildContext context) {
    // CustomerIndexBloc customerindexBloc =
    //     BlocProvider.of<CustomerIndexBloc>(context);
    final ApplicationBloc applicationBloc =
        BlocProvider.of<ApplicationBloc>(context);

    customerindexBloc.bloccontext = context;

    if (applicationBloc.backType == 1) {
      isFirst = true;
    }

    if (isFirst) {
      Future.delayed(new Duration(milliseconds: 500)).then((_) {
        customerindexBloc.getCustomerList(condition);
      });
      isFirst = false;
    }

    return EasyRefresh(
      key: _easyRefreshKey,
      refreshHeader: MaterialHeader(
        key: _headerKey,
      ),
      refreshFooter: MaterialFooter(
        key: _footerKey,
      ),
      child: ListView(
        padding: EdgeInsets.only(
          top: 0,
        ),
        children: <Widget>[
          StreamBuilder(
            stream: customerindexBloc.customerStream,
            builder: (BuildContext context,
                AsyncSnapshot<CustomerListModel> snapshot) {
              if (!snapshot.hasData) {
                return Container(height: Screen.height);
              }

              List mylist = snapshot.hasData ? snapshot.data.customerList : [];
              int totalClientCount =
                  snapshot.hasData ? snapshot.data.totalClientCount : 0;
              int totalCardCount =
                  snapshot.hasData ? snapshot.data.totalCardCount : 0;
              num totalDelegateMoney =
                  snapshot.hasData ? snapshot.data.totalDelegateMoney : 0.00;

              return Container(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 54,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '我的客户',
                                  style: TextStyle(
                                      color: Colours.gray_21, fontSize: 14),
                                ),
                                Text(
                                  '$totalClientCount',
                                  style: TextStyle(
                                      color: Colours.gray_21, fontSize: 14),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 54,
                            color: Colours.bottom_line,
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '总代管额度（元）',
                                  style: TextStyle(
                                      color: Colours.gray_21, fontSize: 14),
                                ),
                                Text(
                                  '$totalDelegateMoney',
                                  style: TextStyle(
                                      color: Colours.gray_21, fontSize: 14),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 54,
                            color: Colours.bottom_line,
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '总代管卡片（张）',
                                  style: TextStyle(
                                      color: Colours.gray_21, fontSize: 14),
                                ),
                                Text(
                                  '$totalCardCount',
                                  style: TextStyle(
                                      color: Colours.gray_21, fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextField(
                              textInputAction: TextInputAction.search,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: '搜索',
                                contentPadding: EdgeInsets.only(left: 10),
                                disabledBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              onSubmitted: searchCustomer,
                              style: TextStyle(
                                  color: Colours.gray_66, fontSize: 16),
                            ),
                          ],
                        )),
                    StreamBuilder(
                        stream: customerindexBloc.customerStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<CustomerListModel> snapshot) {
                          List<Widget> customerContainer = List<Widget>();
                          Widget content;

                          mylist.forEach((item) => customerContainer.add(
                                FlatButton(
                                  padding: EdgeInsets.all(0),
                                  child: Container(
                                      height: 100,
                                      margin: EdgeInsets.only(top: 10),
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                        child: FadeInImage
                                                            .assetNetwork(
                                                          placeholder:
                                                              "assets/images/user/head_default.jpeg",
                                                          image: item.icon,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          '${item.name}',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colours
                                                                  .gray_21),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          '${item.account}',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colours
                                                                  .gray_21),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          '代管卡片：${item.count}',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colours
                                                                  .gray_21),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          '代管总额度：${item.delegateMoney.toStringAsFixed(2)}',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colours
                                                                  .gray_21),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Image.asset(
                                                  ImgPrefix.manager_prefix +
                                                      'arrowmore_big.png',
                                                  width: 7,
                                                  height: 12)
                                            ],
                                          ),
                                        ],
                                      )),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                CustomerDetailPage(
                                                  uid: item.uid,
                                                ))).then((dynamic type) {
                                      if (applicationBloc.backType == 1)
                                        customerindexBloc
                                            .getCustomerList(condition);
                                    });
                                    applicationBloc.backType = 0;
                                  },
                                ),
                              ));
                          content = Column(children: customerContainer);
                          return content;
                        }),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      onRefresh: () async {
        customerindexBloc.getCustomerList(condition);
      },
    );
  }
}
