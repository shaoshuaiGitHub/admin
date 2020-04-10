import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:event_bus/event_bus.dart';

EventBus eventApplyRecBus = new EventBus();

class ReloadApplyRec {
  ReloadApplyRec();
}

class ApplicationRecordHead extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ApplicationRecordHead();
  }
}

class _ApplicationRecordHead extends State<ApplicationRecordHead> {
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  CapitalSideListBloc capitalSideListBloc = CapitalSideListBloc();
  bool isFirst = true;
  void initState() {
    super.initState();

    eventApplyRecBus.on<ReloadApplyRec>().listen((event) {
      this.setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    capitalSideListBloc.bloccontext = context;
    final ApplicationBloc applocationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    if (isFirst) {
      Future.delayed(new Duration(milliseconds: 100)).then((_) {
        capitalSideListBloc.getCapitalApplyList(0);
      });
      isFirst = false;
    } else {
      if (applocationBloc.backType == 1) {
        Future.delayed(new Duration(milliseconds: 100)).then((_) {
          capitalSideListBloc.getCapitalApplyList(0);
        });
      }
    }
    return Container(
      margin: EdgeInsets.only(bottom: 90),
      child: EasyRefresh(
        key: _easyRefreshKey,
        refreshHeader: MaterialHeader(
          key: _headerKey,
        ),
        refreshFooter: MaterialFooter(
          key: _footerKey,
        ),
        onRefresh: () async {
          capitalSideListBloc.getCapitalApplyList(0);
        },
        child: ListView(
          padding: EdgeInsets.only(
            top: 0,
          ),
          children: <Widget>[
            StreamBuilder<CapitalSideApplyListModel>(
              stream: capitalSideListBloc.capitalsideapplylistStream,
              builder: (BuildContext context,
                  AsyncSnapshot<CapitalSideApplyListModel> snapshot) {
                List<Widget> capitalContainer = [];
                Widget content;
                if (!snapshot.hasData) {
                  return Container();
                }
                List<CapitalSideApplyItemListModel> myapplyList = snapshot
                    .data.capitalList
                    .cast<CapitalSideApplyItemListModel>();
                myapplyList.forEach(
                  (item) => capitalContainer.add(
                    FlatButton(
                      padding: EdgeInsets.all(0),
                      child: Container(
                        child: Container(
                          color: Colors.white,
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                color: Colours.orange_72,
                                padding: EdgeInsets.only(left: 20),
                                height: 33,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${item.updateTime}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 76,
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        height: 50,
                                        child: Row(
                                          children: <Widget>[
                                             Container(
                                            height: 50,
                                            width: 50,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    "assets/images/user/head_default.jpeg",
                                                image: item.icon,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text('${item.name}',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            Color(0xffFC8251))),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  width: 50,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xffFF9B1A),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Center(
                                                    child: Text('资金方',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xffffffff))),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          '${item.applyStatus}',
                                          style: TextStyle(
                                              color: Colours.gray_66,
                                              fontSize: 12),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Image.asset(
                                          'assets/images/manager/arrowmore_small.png',
                                          width: 8,
                                          height: 13,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      onPressed: () {
                        applocationBloc.backType = 0;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ApplicationDetailPage(item: item),
                          ),
                        ).then(
                          (_) {
                            if (applocationBloc.backType == 1) {
                              Future.delayed(new Duration(milliseconds: 100))
                                  .then((_) {
                                capitalSideListBloc.getCapitalApplyList(0);
                              });
                            }
                          },
                        );
                      },
                    ),
                  ),
                );
                content = Column(children: capitalContainer);
                return content;
              },
            ),
          ],
        ),
      ),
    );
  }
}
