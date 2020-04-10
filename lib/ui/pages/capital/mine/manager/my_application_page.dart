import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:youxinbao/blocs/capital/mine/manager_bloc.dart';
import 'package:youxinbao/res/res_index.dart';
import 'order_new_page.dart';
import 'mineManager_page.dart';
import '../../../../../common/component_index.dart';

EventBus applyEventBus = new EventBus();

class ReloadApplyCount {
  ReloadApplyCount();
}

class MyApplicationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyApplicationPage();
}

class _MyApplicationPage extends State<MyApplicationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            Navigator.of(context).pop();
          },
        ),
        title: Container(
          child: Text(
            '我的管理师',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeights.bold,
            ),
          ),
        ),
      ),
      body: BlocProvider<ManagerBloc>(
        bloc: ManagerBloc(),
        child: MyApplicationMiddle(),
      ),
    );
  }
}

class MyApplicationMiddle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyApplicationMiddle();
}

class _MyApplicationMiddle extends State<MyApplicationMiddle>
    with AutomaticKeepAliveClientMixin {
  bool isLock = false;
  int applyCount = 0;
  bool inPage = true;

  void initState() {
    super.initState();
    applyEventBus.on<ReloadApplyCount>().listen((event) {
      if (mounted) {
        isLock = false;
      }
    });
  }

  void changePageState(val) {
    inPage = val;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ManagerBloc managerBloc = BlocProvider.of<ManagerBloc>(context);
    if (!isLock) {
      Future.delayed(new Duration(milliseconds: 500)).then((_) {
        managerBloc.getApplyCount(0);
      });
      isLock = true;
    }

    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            margin: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: MaterialButton(
              padding: const EdgeInsets.all(0),
              minWidth: 0,
              onPressed: () {
                inPage = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => OrderNewPage(),
                  ),
                ).then((_) {
                  inPage = true;
                  isLock = false;
                });
              },
              child: Center(
                child: StreamBuilder(
                  stream: managerBloc.outApplyCount,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (!snapshot.hasData) {
                      Future.delayed(new Duration(milliseconds: 500)).then((_) {
                        managerBloc.getApplyCount(0);
                      });
                    } else {
                      applyCount = snapshot.data;
                    }
                    return Text(
                      '新申请($applyCount)',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFFF9B1A),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 170,
            child: MyApplication(
                inPage: inPage, callback: (val) => changePageState(val)),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MyApplication extends StatefulWidget {
  final bool inPage;
  final callback;
  MyApplication({Key key, @required this.inPage, @required this.callback})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _MyApplication();
}

class _MyApplication extends State<MyApplication>
    with AutomaticKeepAliveClientMixin {
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  Column managerList;
  List managerLists = [];
  bool isLock = false;
  var authInputMoney = TextEditingController();
  //修改金额弹窗
  _EditAuthMoneyDialog(id, context, managerBloc, applicationBloc) {
    return Dialog(
      elevation: 0,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        width: 300,
        height: 187,
        padding: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color(0xffffffff),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                color: Color(0xffff9b1a),
              ),
              height: 43,
              alignment: Alignment.center,
              child: Text(
                '我的资金',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xffffffff),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              height: 75,
              padding: EdgeInsets.only(left: 20, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 234,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Color(0xff999999),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: TextField(
                      controller: authInputMoney,
                      inputFormatters: [
                        WhitelistingTextInputFormatter(
                            RegExp(r"^\d+(?:\.\d{0,2})?"))
                      ], //保留两位有效数字
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        disabledBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff212121),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '元',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff212121),
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MaterialButton(
                    padding: const EdgeInsets.all(0),
                    minWidth: 0,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 100,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colours.gray_cc,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '取消',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    padding: const EdgeInsets.all(0),
                    minWidth: 0,
                    onPressed: () {
                      if (authInputMoney.text.length == 0) {
                        managerBloc.showToast('请输入修改的授权金额');
                        return;
                      }
                      managerBloc.modifyAuthsMoney(
                        id,
                        double.parse(authInputMoney.text),
                      );
                      applicationBloc.personalBackType = 1;
                      Navigator.of(context).pop();
                      authInputMoney.text = '';
                      isLock = false;
                    },
                    child: Container(
                      width: 100,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xffff9b1a),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '修改',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w400,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ApplicationBloc applicationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    final ManagerBloc managerBloc = BlocProvider.of<ManagerBloc>(context);
    if (!isLock) {
      Future.delayed(new Duration(milliseconds: 500)).then((_) {
        managerBloc.getManagerList(0, false);
      });
      isLock = true;
    } else {
      if (managerBloc.myMasterList.length == 0 && widget.inPage)
        Future.delayed(new Duration(milliseconds: 100)).then(
          (_) {
            managerBloc.getManagerList(0, true);
          },
        );
    }
    managerBloc.bloccontext = context;
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
            stream: managerBloc.outManager,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              managerLists = snapshot.hasData ? snapshot.data : [];
              List<Widget> managerView = [];
              managerLists.forEach(
                (item) => managerView.add(
                  GestureDetector(
                    child: Container(
                      height: 80,
                      margin: const EdgeInsets.only(
                        bottom: 15,
                      ),
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Color(0xFFFF9B1A),
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 50,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 50,
                                  height: 50,
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
                                  width: 10,
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(
                                          top: 2,
                                        ),
                                        height: 20,
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              height: 20,
                                              child: Center(
                                                child: Text(
                                                  '${item.name}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFF212121),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                              ),
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFFF9B1A),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Center(
                                                child: Text(
                                                  '管理员',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        height: 20,
                                        child: Center(
                                          child: Text(
                                            '${item.account}',
                                            style: TextStyle(
                                              fontSize: 14,
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
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              showDialog<bool>(
                                context: context,
                                builder: (_) => _EditAuthMoneyDialog(item.id,
                                    context, managerBloc, applicationBloc),
                              );
                            },
                            child: Container(
                              height: 50,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(
                                          right: 4,
                                          left: 3,
                                        ),
                                        height: 20,
                                        child: Center(
                                          child: Text(
                                            '授信金额',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeights.medium,
                                              color: Color(0xFF212121),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '修改',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFFFF0000),
                                          fontWeight: FontWeights.medium,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      bottom: 4,
                                    ),
                                    height: 20,
                                    child: Center(
                                      child: Text(
                                        '${item.authMoney.toStringAsFixed(2)}',
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
                          ),
                          Container(
                            width: 7,
                            height: 13,
                            margin: const EdgeInsets.only(
                              left: 10,
                            ),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/capital/navergitor.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      widget.callback(false);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              MineManagerPage(id: item.masterId),
                        ),
                      ).then((_) {
                        widget.callback(true);
                        applyEventBus.fire(ReloadApplyCount());
                      });
                    },
                  ),
                ),
              );
              managerList = Column(
                children: managerView,
              );

              return managerList;
            },
          ),
        ],
      ),
      onRefresh: () async {
        managerBloc.getManagerList(2, false);
      },
      loadMore: () async {
        managerBloc.getManagerList(1, false);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
