import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youxinbao/blocs/bloc_index.dart';
import 'package:youxinbao/blocs/capital/mine/withdraw_bloc.dart';
import 'package:youxinbao/common/component_index.dart';
import 'package:youxinbao/res/res_index.dart';
import 'withdrawals_record_page.dart';
import 'setpwd_page.dart';
import 'withdraw_done.dart';

class WithdrawMoneyCapitalPage extends StatefulWidget {
  final int type; //1未设置密码 2已设置
  WithdrawMoneyCapitalPage({
    Key key,
    @required this.type,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _WithdrawMoneyPage(
        type: this.type,
      );
}

class _WithdrawMoneyPage extends State<WithdrawMoneyCapitalPage> {
  bool offStage = false; //菜单默认关闭
  int type; //1 未设置 2已设置
  _WithdrawMoneyPage({
    Key key,
    @required this.type,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        if (offStage) {
          setState(() {
            offStage = !offStage;
          });
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color(0xFFFF9B1A),
          centerTitle: true,
          elevation: 0,
          title: Text(
            '提现',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeights.bold,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {
                offStage = !offStage;
                setState(() {
                  offStage = offStage;
                });
              },
            ),
          ],
        ),
        body: BlocProvider<WithdrawBloc>(
          bloc: WithdrawBloc(),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFF2F2F2),
            ),
            child: Stack(
              children: <Widget>[
                WithdrawMoneyMiddle(type: this.type),
                Positioned(
                  child: MenusWidget(
                    offStage: offStage,
                  ),
                  right: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WithdrawMoneyMiddle extends StatefulWidget {
  int type; //1 未设置 2 已设置
  WithdrawMoneyMiddle({
    Key key,
    @required this.type,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _WithdrawMoneyMiddle(
        type: this.type,
      );
}

class _WithdrawMoneyMiddle extends State<WithdrawMoneyMiddle> {
  //页面
  List<dynamic> cardList;
  num maxMoney = 0; //最大可提现
  int cardInstId = 0; //选中银行卡id
  var moneyInputCrl = TextEditingController(); //提现金额
  int type; //1 未设置 2 已设置
  _WithdrawMoneyMiddle({
    Key key,
    @required this.type,
  });
  WithdrawBloc withdrawBloc = WithdrawBloc();

  @override
  void initState() {
    super.initState();
    withdrawBloc.getWithdrawInfo();
  }

  void changeId(val) {
    cardInstId = val;
  }

  //提现确认页面回传
  void changeMoney(val) {
    moneyInputCrl.text = val;
  }

  void changeMaxMoney(val) {
    maxMoney = val;
  }

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc applicationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    withdrawBloc.bloccontext = context;
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
            top: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '提现到我的银行卡',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeights.medium,
                        color: Color(0xFF282828),
                      ),
                    ),
                    Container(
                      width: 16,
                      height: 8,
                      margin: const EdgeInsets.only(
                        right: 10,
                      ),
                      child: Image(
                        width: 16,
                        height: 8,
                        image: AssetImage('assets/images/capital/triangle.png'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: MaterialButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (_) => BankList(
                              cardList: cardList,
                              cardInstId: cardInstId,
                              callback: (val) => changeId(val),
                              withdrawBloc: withdrawBloc),
                        ),
                    child: StreamBuilder(
                      stream: withdrawBloc.outSelectedBlank,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        String name =
                            snapshot.hasData ? snapshot.data.name : '';
                        int cardNo =
                            snapshot.hasData ? snapshot.data.cardNo : 0;
                        String cardIcon =  snapshot.hasData ? snapshot.data.icon : '';
                        return Row(
                          children: <Widget>[
                            Container(
                              width: 46,
                              height: 46,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                        "assets/images/user/card_default.jpeg",
                                    image: cardIcon, 
                                    fit: BoxFit.cover,
                                  ),
                                ),
                            ),
                            Container(
                              height: 46,
                              margin: const EdgeInsets.only(
                                left: 16,
                              ),
                              child: Center(
                                child: Text(
                                  '$name (尾号$cardNo)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFFFF9B1A),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    )),
              ),
              Container(
                height: 34,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '提现金额',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF282828),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 1,
                      ),
                      child: Text(
                        '请留意到账时间',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(
                            0xFF999999,
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
        Container(
          height: 44,
          padding: const EdgeInsets.only(
            left: 16,
          ),
          child: TextField(
            controller: moneyInputCrl,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp(r"^\d+(?:\.\d{0,2})?"))
            ],
            decoration: InputDecoration(
              hintText: '￥ 请输入提现金额...',
              hintStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeights.medium,
                color: Color(0xFF999999),
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        Container(
          height: 42,
          padding: const EdgeInsets.only(
            left: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(
                  right: 15,
                ),
                child: StreamBuilder(
                  stream: withdrawBloc.outInfo,
                  builder: (BuildContext context,
                      AsyncSnapshot<WithdrawModel> snapshot) {
                    num totalMoney =
                        snapshot.hasData ? snapshot.data.totalMoney : 0;
                    cardList = snapshot.hasData ? snapshot.data.cardList : [];
                    maxMoney = totalMoney;
                    if (cardList.length != 0) {
                      withdrawBloc.getSelectedCard.add(cardList[0]);
                      cardInstId = cardList[0].id;
                    }
                    return Text(
                      '当前最大可提现：￥${maxMoney.toDouble()}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeights.medium,
                        color: Color(0xFF999999),
                      ),
                    );
                  },
                ),
              ),
              MaterialButton(
                onPressed: () {
                  moneyInputCrl.text = maxMoney.toDouble().toString();
                },
                minWidth: 0,
                height: 12,
                padding: EdgeInsets.all(0),
                child: Container(
                  child: Text(
                    '全部提现',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeights.medium,
                      color: Color(0xFFFF9B1A),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        MaterialButton(
          padding: const EdgeInsets.all(0),
          minWidth: 0,
          onPressed: () {
            if (cardInstId == 0) {
              withdrawBloc.showToast("请选择提现银行卡");
              return;
            }
            if (moneyInputCrl.text.length == 0 ||
                moneyInputCrl.text == "0" ||
                moneyInputCrl.text == "0.0") {
              withdrawBloc.showToast("请输入提现金额");
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => WithdrawDonePage(
                      type: this.type,
                      cardInstId: cardInstId,
                      money: double.parse(moneyInputCrl.text),
                      maxMoney: maxMoney,
                      callback: (val) => changeMoney(val),
                      callMaxBack: (val) => changeMaxMoney(val),
                    ),
              ),
            ).then(
              (val) {
                if (applicationBloc.backType == 1) {
                  withdrawBloc.getWithdrawInfo();
                }
              },
            );
            applicationBloc.backType = 0;
          },
          child: Container(
            height: 40,
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFFF9B1A),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                '提现',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BankList extends StatefulWidget {
  final List<dynamic> cardList;
  final int cardInstId;
  final callback;
  final WithdrawBloc withdrawBloc;
  BankList({
    Key key,
    @required this.cardList,
    @required this.cardInstId,
    @required this.callback,
    @required this.withdrawBloc,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BankList(
        selectedId: this.cardInstId,
      );
}

class _BankList extends State<BankList> {
  int selectedId;
  _BankList({
    Key key,
    @required this.selectedId,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> cardItemView = [];
    Widget cardListView;
    cardListView = ListView(
      shrinkWrap: true,
      children: cardItemView,
    );
    if (widget.cardList.length != 0) {
      widget.cardList.forEach(
        (item) => {
              cardItemView.add(
                Container(
                  child: MaterialButton(
                    padding: const EdgeInsets.all(0),
                    minWidth: 0,
                    onPressed: () {
                      widget.withdrawBloc.getSelectedCard.add(item);
                      this.setState(() {
                        selectedId = item.id;
                      });
                      widget.callback(item.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 18,
                        right: 20,
                      ),
                      height: 74,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Color(0xFFE6E6E6),
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Color(0xFFFF9000),
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: item.id == selectedId
                                ? Icon(
                                    Icons.check,
                                    size: 18,
                                    color: Color(0xFFFF9000),
                                  )
                                : Icon(
                                    Icons.check_box_outline_blank,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Container(
                            width: 44,
                            height: 44,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: FadeInImage.assetNetwork(
                                placeholder:
                                    "assets/images/user/card_default.jpeg",
                                image: item.icon,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 23,
                                ),
                                Text(
                                  '${item.name}（尾号${item.cardNo}）',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF212121),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '储蓄卡',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF212121),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            },
      );
    }
    return Container(
      constraints: BoxConstraints(maxHeight: 218),
      child: cardListView,
    );
  }
}

//导航
class MenusWidget extends StatelessWidget {
  final bool offStage;
  const MenusWidget({Key key, this.offStage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !offStage,
      child: Container(
        width: 118,
        height: 81,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/capital/rect.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 4,
            ),
            Container(
              height: 38,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SetPasswordPage(),
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    '密码设置',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFFFF9B1A),
                      fontWeight: FontWeights.medium,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 38,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Color(0xFFFF9B1A),
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          WithdrawalsRecordPage(),
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    '提现记录',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFFFF9B1A),
                      fontWeight: FontWeights.medium,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
