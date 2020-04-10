import 'package:flutter/material.dart';
import 'package:youxinbao/blocs/capital/account/account_bloc.dart';
import 'package:youxinbao/common/component_index.dart';
import 'package:youxinbao/res/colors.dart';

class AccountDetail extends StatelessWidget {
  final int delegateType;
  final int masterId;
  var cardNo;
  final String date;
  var masterName;
  final num incomeMoney;
  AccountDetail({
    this.delegateType,
    this.masterId,
    this.cardNo,
    this.date,
    this.masterName,
    this.incomeMoney,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      bloc: AccountBloc(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xFFFF9B1A),
          title: Text(
            '详情',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeights.bold,
            ),
          ),
        ),
        body: Container(
          color: Color(
            0xFFF2F2F2,
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: 34,
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '收款卡：${this.cardNo != null ? this.cardNo : '数据异常'}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeights.medium,
                        color: Color(0xFF212121),
                      ),
                    ),
                    Text(
                      '${this.date}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeights.medium,
                        color: Color(0xFF212121),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 83,
                margin: EdgeInsets.fromLTRB(16, 2, 16, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 14,
                              top: 18,
                            ),
                            height: 24,
                            child: Text(
                              '管理师：$masterName',
                              style: TextStyle(
                                fontSize: 15,
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
                            margin: const EdgeInsets.only(
                              left: 80,
                              top: 18,
                            ),
                            height: 24,
                            child: Text(
                              '收款金额:',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeights.medium,
                                color: Color(
                                  0xFF212121,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 14,
                            ),
                            height: 24,
                            child: Text(
                              '类型：${this.delegateType == 1 ? '单次代还' : this.delegateType == 2 ? '精养代操' : '提额代操'}',
                              style: TextStyle(
                                fontSize: 15,
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
                            height: 24,
                            margin: const EdgeInsets.only(
                              left: 80,
                            ),
                            child: Text(
                              '${incomeMoney.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeights.medium,
                                color: Color(
                                  0xFF212121,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AccountDetailList(
                delegateType: this.delegateType,
                masterId: this.masterId,
                cardNo: this.cardNo,
                date: this.date,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountDetailList extends StatelessWidget {
  final int delegateType;
  final int masterId;
  final int cardNo;
  final String date;
  AccountDetailList({this.delegateType, this.masterId, this.cardNo, this.date});
  List detailList = List();
  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc = BlocProvider.of<AccountBloc>(context);
    accountBloc.bloccontext = context;
    Future.delayed(new Duration(milliseconds: 100)).then((_) {
      accountBloc.getBanlanceDetails(delegateType, masterId, cardNo, date);
    });
    return StreamBuilder(
      stream: accountBloc.outAccountDetail,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        Container detailContainer;
        List<Widget> detailListView = [];
        detailList = snapshot.data;
        detailList.forEach(
          (item) {
            detailListView.add(
              Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 33,
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(
                              color: Color(0xFFE5E5E5),
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          )),
                          margin: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '客户：${item.name}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeights.medium,
                                  color: Color(
                                    0xFF212121,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: 24,
                              margin: const EdgeInsets.only(left: 11, top: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '类型：${item.planType == 1 ? '消费计划' : '还款计划'}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF212121),
                                      fontWeight: FontWeights.medium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 102,
                              height: 24,
                              margin: const EdgeInsets.only(top: 5),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '${item.planType == 1 ? '计划消费' : '计划还款'}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeights.medium,
                                      color: Color(0xFF212121),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          padding: const EdgeInsets.only(
                            bottom: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFE5E5E5),
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 20,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${item.updateTime}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF999999),
                                        fontWeight: FontWeights.medium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 92.0,
                                height: 20,
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${item.minMoney.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF999999),
                                        fontWeight: FontWeights.medium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(
                                        left: 12,
                                      ),
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFCCCCCC),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                        left: 8,
                                      ),
                                      child: Text(
                                        '${item.bankName} ${item.cardNo != null ? item.cardNo.toString().substring(item.cardNo.toString().length - 4, item.cardNo.toString().length) : '数据异常'}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeights.medium,
                                          color: Color(0xFF212121),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 166,
                                      height: 24,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '计划状态：',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(
                                                0xFF212121,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${item.planType == 1 ? '已消费成功' : '已还款成功'}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(
                                                0xFFFF0000,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: 166,
                                      height: 24,
                                      child: Text(
                                        '${item.planType == 1 ? '实际消费' : '实际还款'}：${item.realMoney}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(
                                            0xFF212121,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: 26,
                              margin: const EdgeInsets.only(
                                left: 13,
                                top: 10,
                              ),
                              child: Text(
                                'POS机名：${item.posName}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF212121),
                                ),
                              ),
                            ),
                            Container(
                              width: 185,
                              height: 26,
                              alignment: Alignment.bottomLeft,
                              margin: const EdgeInsets.only(bottom: 3),
                              child: Text(
                                '收款金额：${item.consumMoney.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF212121),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: 26,
                              margin: const EdgeInsets.only(
                                left: 12,
                              ),
                              child: Text(
                                '容POS机利率：${item.posRate}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF212121),
                                ),
                              ),
                            ),
                            Container(
                              width: 185,
                              height: 26,
                              child: Text(
                                '收款日期：${item.posFinishTime}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF212121),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
        detailContainer = Container(
          height: Screen.height - 200 * Screen.screenRate,
          child: ListView(
            children: detailListView,
          ),
        );
        return detailContainer;
      },
    );
  }
}
