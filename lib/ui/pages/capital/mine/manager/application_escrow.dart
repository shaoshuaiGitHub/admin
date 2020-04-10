import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:youxinbao/res/res_index.dart';
import 'application_detail_page.dart';
import '../../../../../common/component_index.dart';

//申请代管
class ApplicationEscrow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ApplicationEscrow();
}

class _ApplicationEscrow extends State<ApplicationEscrow>
    with AutomaticKeepAliveClientMixin {
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  Column applyContent;
  List applyDataList = List();
  bool isOpen = true;

  @override
  Widget build(BuildContext context) {
    ManagerBloc managerBloc = BlocProvider.of<ManagerBloc>(context);
    managerBloc.bloccontext = context;
    super.build(context);

    if (isOpen) {
      Future.delayed(new Duration(milliseconds: 100)).then((_) {
        managerBloc.getMasterApplyList(0, false);
      });
      isOpen = false;
    } else {
      if (managerBloc.escrowList.length == 0)
        Future.delayed(new Duration(milliseconds: 10)).then(
          (_) {
            managerBloc.getMasterApplyList(0, true);
          },
        );
    }

    return EasyRefresh(
      key: _easyRefreshKey,
      refreshHeader: MaterialHeader(
        key: _headerKey,
      ),
      refreshFooter: MaterialFooter(
        key: _footerKey,
      ),
      child: StreamBuilder(
        stream: managerBloc.outEscrow,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          applyDataList = snapshot.hasData ? snapshot.data : [];
          List<Widget> applyList = [];
          applyDataList.forEach((item) {
            applyList.add(
              Container(
                margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 11,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: MaterialButton(
                  minWidth: 0,
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ApplicationDetailPage(
                                id: item.id, applyStatus: item.applyStatus),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 32,
                            child: Center(
                              child: Text(
                                '日期：${item.createTime}',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeights.medium,
                                    color: Color(0xFF999999)),
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 40,
                                  height: 40,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: FadeInImage.assetNetwork(
                                      placeholder:
                                          "assets/images/user/head_default.jpeg",
                                      image: item.icon,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 9,
                                ),
                                Container(
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      '${item.masterName}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF212121),
                                        fontWeight: FontWeights.medium,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Container(
                                  height: 40,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 20,
                                        child: Center(
                                          child: Text(
                                            '代管客户：${item.count}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeights.medium,
                                              color: Color(0xFF212121),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 20,
                                        child: Center(
                                          child: Text(
                                            '代管总额度：${item.totalMoney.toStringAsFixd(2)}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeights.medium,
                                              color: Color(0xFF212121),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Offstage(
                            offstage: item.applyStatus != 0,
                            child: SizedBox(
                              height: 20,
                            ),
                          ),
                          Offstage(
                            offstage: item.applyStatus == 0,
                            child: Container(
                              height: 34,
                              margin: const EdgeInsets.only(
                                top: 5,
                              ),
                              child: Center(
                                child: Text(
                                  '${item.applyStatus == 1 ? '通过理由' : '拒绝理由'}：${item.applyMsg}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF212121),
                                    fontWeight: FontWeights.medium,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Text(
                              '${item.applyStatus == 0 ? '待审核' : item.applyStatus == 1 ? '已通过' : '已拒绝'}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeights.medium,
                                color: Color(0xFFFF0000),
                              ),
                            ),
                            SizedBox(
                              width: 1,
                            ),
                            Container(
                              width: 7,
                              height: 13,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/capital/navergitor.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
          applyContent = Column(children: applyList);
          return applyContent;
        },
      ),
      onRefresh: () async {
        managerBloc.getMasterApplyList(2, false);
      },
      loadMore: () async {
        managerBloc.getMasterApplyList(1, false);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

//申请解除
class ApplicationRelieve extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ApplicationRelieve();
}

class _ApplicationRelieve extends State<ApplicationRelieve>
    with AutomaticKeepAliveClientMixin {
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  bool isOpen = true;

  //同意解除窗口
  _removeManager(id, context, ManagerBloc managerBloc) {
    super.build(context);
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Color(0xFFFF9B1A),
              ),
              child: Center(
                child: Text(
                  '解除关系',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeights.medium,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              child: Text(
                '确定解除关系吗？',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF212121),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 44,
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                    right: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFCCCCCC),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: MaterialButton(
                    padding: const EdgeInsets.all(0),
                    minWidth: 0,
                    child: Center(
                      child: Text(
                        '取消',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeights.medium,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  width: 100,
                  height: 44,
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFFF9B1A),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: MaterialButton(
                    padding: const EdgeInsets.all(0),
                    minWidth: 0,
                    child: Center(
                      child: Text(
                        '确认',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeights.medium,
                        ),
                      ),
                    ),
                    onPressed: () {
                      managerBloc.operationMasterApply(id, '1', -2);
                      Navigator.pop(context);
                      Future.delayed(new Duration(milliseconds: 10)).then((_) {
                        managerBloc.getRemoveApplyList(2, false);
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List removeApplyList = List();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ManagerBloc managerBloc = BlocProvider.of<ManagerBloc>(context);
    managerBloc.bloccontext = context;
    if (isOpen) {
      Future.delayed(new Duration(milliseconds: 100)).then((_) {
        managerBloc.getRemoveApplyList(0, false);
      });
      isOpen = false;
    } else {
      if (managerBloc.removeList.length == 0)
        Future.delayed(new Duration(milliseconds: 10)).then((_) {
          managerBloc.getRemoveApplyList(0, true);
        });
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
        children: <Widget>[
          StreamBuilder(
              stream: managerBloc.outRemove,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                List<Widget> applyList = [];
                Widget applyContent;
                if (!snapshot.hasData)
                  return Container();
                else {
                  removeApplyList = snapshot.data;
                }
                removeApplyList.forEach((item) {
                  applyList.add(
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 11,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 32,
                                child: Center(
                                  child: Text(
                                    '日期：${item.createTime}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeights.medium,
                                        color: Color(0xFF999999)),
                                  ),
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 40,
                                      height: 40,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: FadeInImage.assetNetwork(
                                          placeholder:
                                              "assets/images/user/head_default.jpeg",
                                          image: item.icon,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 9,
                                    ),
                                    Container(
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          '${item.masterName}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF212121),
                                            fontWeight: FontWeights.medium,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Container(
                                      height: 40,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            height: 20,
                                            child: Center(
                                              child: Text(
                                                '代管客户：${item.count}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeights.medium,
                                                  color: Color(0xFF212121),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 20,
                                            child: Center(
                                              child: Text(
                                                '代管总额度：${item.totalMoney.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeights.medium,
                                                  color: Color(0xFF212121),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Offstage(
                                offstage: item.applyStatus != -2,
                                child: SizedBox(
                                  height: 20,
                                ),
                              ),
                              Offstage(
                                offstage: item.applyStatus != -1,
                                child: Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      MaterialButton(
                                        minWidth: 0,
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) => _removeManager(
                                                item.id, context, managerBloc),
                                          );
                                        },
                                        child: Text(
                                          '同意解除',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeights.medium,
                                              color: Colours.blue_color),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Offstage(
                                offstage: item.applyStatus != -3,
                                child: Container(
                                  height: 34,
                                  margin: const EdgeInsets.only(
                                    top: 5,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '拒绝理由：${item.applyMsg}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF212121),
                                        fontWeight: FontWeights.medium,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '${item.applyStatus == -1 ? '待处理' : item.applyStatus == -2 ? '已同意' : '已拒绝'}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeights.medium,
                                    color: Color(0xFFFF0000),
                                  ),
                                ),
                                SizedBox(
                                  width: 1,
                                ),
                                Container(
                                  width: 7,
                                  height: 13,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/capital/navergitor.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
                applyContent = Column(children: applyList);
                return applyContent;
              }),
        ],
      ),
      onRefresh: () async {
        managerBloc.getRemoveApplyList(2, false);
      },
      loadMore: () async {
        managerBloc.getRemoveApplyList(1, false);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
