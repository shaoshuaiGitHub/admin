import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';

class CapitalSideHead extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CapitalSideHead();
  }
}

class _CapitalSideHead extends State<CapitalSideHead> {
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  CapitalSideListBloc capitalsideListBloc = CapitalSideListBloc();
  void initState() {
    super.initState();
    Future.delayed(new Duration(milliseconds: 100)).then(
      (_) {
        capitalsideListBloc.getCapitalList(0);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    capitalsideListBloc.bloccontext = context;
    List<CapitalSideModel> mylist;

    final ApplicationBloc applicationBloc =
        BlocProvider.of<ApplicationBloc>(context);
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
          capitalsideListBloc.getCapitalList(0);
        },
        child: ListView(
          padding: EdgeInsets.only(
            top: 0,
          ),
          children: <Widget>[
            StreamBuilder<CapitalSideListModel>(
              stream: capitalsideListBloc.capitalsidelistStream,
              builder: (BuildContext context,
                  AsyncSnapshot<CapitalSideListModel> snapshot) {
                List<Widget> capitalContainer = [];
                Widget content;
                if (!snapshot.hasData) {
                  return Container();
                }

                mylist = snapshot.hasData
                    ? snapshot.data.capitalList.cast<CapitalSideModel>()
                    : [];
                mylist.forEach((item) => capitalContainer.add(Container(
                      child: Column(
                        children: <Widget>[
                          FlatButton(
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 76,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
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
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Text('${item.name}',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Color(
                                                              0xffFC8251))),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                    width: 50,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffFF9B1A),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Center(
                                                      child: Text(
                                                          '${item.roleType}',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Text('${item.account}',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colours.gray_66)),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                      'assets/images/user/arrowmore_small.png',
                                      width: 8,
                                      height: 13)
                                ],
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              MycapitalSidePage(uid: item.uid)))
                                  .then((dynamic type) {
                                if (applicationBloc.backType == 1)
                                  capitalsideListBloc.getCapitalList(0);
                              });
                            },
                          ),
                        ],
                      ),
                    )));
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
