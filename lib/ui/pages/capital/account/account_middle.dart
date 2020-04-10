import 'package:flutter/material.dart';
import 'package:youxinbao/res/colors.dart';
import 'package:youxinbao/blocs/capital/account/account_bloc.dart';
import 'account_detail.dart';
import 'package:youxinbao/common/component_index.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:event_bus/event_bus.dart';

EventBus accountEventBus = new EventBus();

class TabStatus {
  final bool inPage;
  TabStatus(this.inPage);
}

class AddAccountMiddle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddAccountMiddle();
}

class _AddAccountMiddle extends State<AddAccountMiddle> {
  bool isFirst = true;
  bool visible = true;
  bool inPage = true;

  GlobalKey<EasyRefreshState> _accountEasyRefreshKey =
      GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _accountHeaderKey =
      GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _accountFooterKey =
      GlobalKey<RefreshFooterState>();

  void initState() {
    super.initState();
    accountEventBus.on<TabStatus>().listen(
      (event) {
        if (mounted) {
          this.setState(() {
            inPage = event.inPage;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc = BlocProvider.of<AccountBloc>(context);
    accountBloc.bloccontext = context;
    if (isFirst) {
      Future.delayed(new Duration(milliseconds: 100)).then((_) {
        accountBloc.getBanlanceLists(2, false);
      });
      isFirst = false;
    } else {
      if (accountBloc.accountList.length == 0 && inPage) {
        Future.delayed(new Duration(milliseconds: 10)).then((_) {
          accountBloc.getBanlanceLists(2, true);
        });
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
      ),
      child: Stack(
        children: <Widget>[
          EasyRefresh(
            key: _accountEasyRefreshKey,
            refreshHeader: MaterialHeader(
              key: _accountHeaderKey,
            ),
            refreshFooter: MaterialFooter(
              key: _accountFooterKey,
            ),
            child: ListView(
              padding: const EdgeInsets.only(
                top: 66,
                bottom: 10,
              ),
              children: <Widget>[
                AccountItem(),
              ],
            ),
            onRefresh: () async {
              accountBloc.getBanlanceLists(2, false);
            },
            loadMore: () async {
              accountBloc.getBanlanceLists(1, false);
            },
          ),
          Positioned(
            top: 0,
            child: Container(
              width: Screen.width,
              height: 66,
              decoration: BoxDecoration(
                color: Color(0xFFF2F2F2),
              ),
              child: Container(
                height: 44,
                margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.fromLTRB(26, 0, 0, 0),
                      child: Text(
                        '未归还资金',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ),
                    StreamBuilder(
                      stream: accountBloc.outRepayMoney,
                      initialData: 0,
                      builder:
                          (BuildContext context, AsyncSnapshot<num> snapshot) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 26, 0),
                          child: Text(
                            '${snapshot.data.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF212121),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AccountItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountItem();
}

class _AccountItem extends State<AccountItem> {
  List accountList = List();
  List accountItem = List();
  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc = BlocProvider.of<AccountBloc>(context);
    return StreamBuilder(
      stream: accountBloc.outAccount,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        //控制折叠块开关数组
        if (!snapshot.hasData) {
          return Container();
        }
        Container accountContainer;
        List<Widget> accountColumn = [];
        accountList = snapshot.data;
        for (int i = 0; i < accountList.length; i++) {
          accountItem.add(List());
          for (int j = 0; j < accountList[i].cardList.length; j++) {
            accountItem[i].add(false);
          }
        }

        for (int i = 0; i < accountList.length; i++) {
          var accountData = accountList[i];
          List<Widget> cardColumn = [];
          //控制折叠块开关子数组
          num sumIncomeMoney = 0.0;
          num sumTotalMoney = 0.0;

          for (int j = 0; j < accountData.cardList.length; j++) {
            var cardData = accountData.cardList[j];
            sumIncomeMoney += cardData.incomeMoney;
            sumTotalMoney += cardData.totalMoney;
            cardColumn.add(
              Container(
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(0),
                            height: 34,
                            alignment: Alignment.center,
                            child: MaterialButton(
                              padding: const EdgeInsets.all(0),
                              minWidth: 0,
                              onPressed: () {
                                this.setState(() {
                                  accountItem[i][j] = !accountItem[i][j];
                                });
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '${cardData.cardNo != null ? cardData.cardNo : '数据异常'}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeights.medium,
                                      color: Color(0xFF212121),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    width: 13,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: !accountItem[i][j]
                                            ? AssetImage(
                                                'assets/images/capital/triangle.png')
                                            : AssetImage(
                                                'assets/images/capital/triangle_toggle.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Fold(
                            visible: accountItem[i][j],
                            delegateTypeList: cardData.delegateTypeList,
                            masterId: accountData.masterId,
                            cardNo: cardData.cardNo,
                            date: accountData.date,
                            masterName: accountData.masterName,
                            incomeMoney: cardData.incomeMoney,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 34,
                        alignment: Alignment.center,
                        child: Text(
                          '${cardData.incomeMoney.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeights.medium,
                            color: Color(
                              0xFF212121,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 34,
                        alignment: Alignment.center,
                        child: Text(
                          '${cardData.totalMoney.toStringAsFixed(2)}',
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
            );
          }

          accountColumn.add(
            Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 34,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                '${accountData.date}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF212121),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Text(
                                '管理师：${accountData.masterName}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF212121),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 34,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '收款卡卡号',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF212121),
                                  ),
                                ),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '收款金额',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF212121),
                                  ),
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '收款卡余额',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF212121),
                                  ),
                                ),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: cardColumn,
                ),
                Container(
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          child: Container(
                            margin: const EdgeInsets.only(right: 40),
                            child: Text(
                              '小计',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeights.medium,
                                color: Color(0xFF212121),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${sumIncomeMoney.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeights.medium,
                              color: Color(0xFF212121),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${sumTotalMoney.toStringAsFixed(2)}',
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
                Container(
                  height: 34,
                  margin: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: 10,
                    ),
                    child: Text(
                      '对账时间：${accountData.checkTime}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(
                          0xFF212121,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
          // accountItem.add(accountBoolItem);
        }

        accountContainer = Container(
          child: Column(
            children: accountColumn,
          ),
        );
        return accountContainer;
      },
    );
  }
}

//折叠块
class Fold extends StatefulWidget {
  final bool visible;
  final List delegateTypeList;
  final int masterId;
  var cardNo;
  final String date;
  var masterName;
  final num incomeMoney;
  // List<Widget> foldList=[];
  Fold({
    Key key,
    this.visible,
    this.delegateTypeList,
    this.masterId,
    this.cardNo,
    this.date,
    this.masterName,
    this.incomeMoney,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _Fold();
}

class _Fold extends State<Fold> {
  List<Widget> foldColumn = [];
  void initState() {
    super.initState();
    widget.delegateTypeList.forEach(
      (item) {
        foldColumn.add(
          Container(
            height: 34,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    '${item == 1 ? '单次代还' : item == 2 ? '精养代操' : '提额代操'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(
                        0xFF212121,
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  padding: const EdgeInsets.all(0),
                  minWidth: 0,
                  onPressed: () {
                    accountEventBus.fire(TabStatus(false));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => AccountDetail(
                          delegateType: item,
                          masterId: widget.masterId,
                          cardNo: widget.cardNo,
                          date: widget.date,
                          masterName: widget.masterName,
                          incomeMoney: widget.incomeMoney,
                        ),
                      ),
                    ).then((_) {
                      accountEventBus.fire(TabStatus(true));
                    });
                  },
                  child: Container(
                    child: Text(
                      '详情',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(
                          0xFFFF9B1A,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !widget.visible,
      child: Column(
        children: foldColumn,
      ),
    );
  }
}
