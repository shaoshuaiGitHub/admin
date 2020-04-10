import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:youxinbao/blocs/bloc_provider.dart';
import 'package:youxinbao/blocs/capital/mine/manager_bloc.dart';
import 'package:youxinbao/res/res_index.dart';
import '../../../../../common/component_index.dart';
import 'package:event_bus/event_bus.dart';

EventBus eventBus = new EventBus();

class ApplyStatusEvent {
  int applyStatus;
  ApplyStatusEvent(this.applyStatus);
}

class ErrorStatusEvent {
  bool isError;
  ErrorStatusEvent(this.isError);
}

class ApplicationDetailPage extends StatefulWidget {
  final int id;
  final int applyStatus;
  ApplicationDetailPage({
    Key key,
    @required this.id,
    @required this.applyStatus,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() =>
      _ApplicationDetailPage(applyStatus: applyStatus);
}

class _ApplicationDetailPage extends State<ApplicationDetailPage>
    with AutomaticKeepAliveClientMixin {
  int applyStatus;
  bool isUpdate = false;

  void changeUpdate(val) {
    isUpdate = val;
  }

  _ApplicationDetailPage({Key key, @required this.applyStatus});
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xFFFF9B1A),
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
            Navigator.pop(context, isUpdate);
          },
        ),
        title: Container(
          child: Text(
            '申请详情',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeights.bold,
            ),
          ),
        ),
      ),
      body: BlocProvider<ManagerBloc>(
        bloc: ManagerBloc(),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF2F2F2),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(
                  bottom: 80,
                ),
                child: ApplicationMiddle(
                  id: widget.id,
                  applyStatus: applyStatus,
                ),
              ),
              Positioned(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  padding: const EdgeInsets.only(
                    left: 44,
                    right: 44,
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F2F2),
                  ),
                  child: ControlButton(
                    id: widget.id,
                    applyStatus: applyStatus,
                    callback: (val) => changeUpdate(val),
                  ),
                ),
                bottom: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

//详情信息
class ApplicationMiddle extends StatefulWidget {
  final int applyStatus;
  final int id;
  ApplicationMiddle({
    Key key,
    @required this.id,
    @required this.applyStatus,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() =>
      _ApplicationMiddle(applyStatus: applyStatus);
}

class _ApplicationMiddle extends State<ApplicationMiddle>
    with AutomaticKeepAliveClientMixin {
  bool isFirst = true;
  int applyStatus;
  var name;
  String icon = ""; //头像
  int UID = 0;
  var account;
  String Lv = "";
  var workAge = 0;
  var idCardNo;
  num totalUsableMoney;
  String totalAccLimit = '0.00';
  String cardIcon = ""; //银行卡
  String cardA = ""; //身份证正面
  String cardB = ""; //身份反面正面

  String createTime = "";
  List cardList = List();
  _ApplicationMiddle({Key key, @required this.applyStatus});
  ManagerBloc managerBloc = ManagerBloc();
  void initState() {
    super.initState();
    eventBus.on<ApplyStatusEvent>().listen((event) {
      applyStatus = event.applyStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    managerBloc.bloccontext = context;
    if (isFirst) {
      Future.delayed(new Duration(milliseconds: 100)).then((_) {
        managerBloc.getMasterDetail(widget.id);
      });
      isFirst = false;
    }

    return StreamBuilder<MasterApplyDetailModel>(
        stream: managerBloc.outMasterDetail,
        builder: (BuildContext context,
            AsyncSnapshot<MasterApplyDetailModel> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            eventBus.fire(ErrorStatusEvent(false));
            name = snapshot.data.name;
            icon = snapshot.data.icon;
            UID = snapshot.data.UID;
            account = snapshot.data.account;
            Lv = snapshot.data.Lv;
            workAge = snapshot.data.workAge;
            idCardNo = snapshot.data.idCardNo;
            // num totalUsableMoney =
            //     snapshot.hasData ? snapshot.data.totalUsableMoney : 0;
            totalAccLimit = snapshot.data.totalAccLimit.toStringAsFixed(2);
            createTime = snapshot.data.createTime;
            cardList = snapshot.data.cardList;
            cardA = snapshot.data.cardA;
            cardB = snapshot.data.cardB;
          }

          List<Widget> detailPage = []; //大组件模块列表
          Widget detailContent; //大组件模块层

          List<Widget> cardListView = []; //卡片列表
          Widget cardView; //卡片层
          int index = 1;
          bool isLast;
          cardList.forEach((item) {
            isLast = index == cardList.length;
            cardListView.add(
              CardItem(
                isLast: isLast,
                bankName: item.bankName,
                cardNo: item.cardNo,
                name: item.name,
                accLimit: item.accLimit.toStringAsFixed(2),
                usableMoney: item.usableMoney.toStringAsFixed(2),
                cardIcon: item.icon,
              ),
            );
            index++;
          });
          cardView = Column(
            children: cardListView,
          );

          detailPage.add(
            Container(
                margin: const EdgeInsets.fromLTRB(16, 13, 16, 0),
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 72,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 32,
                                child: Center(
                                  child: Text(
                                    '日期：$createTime',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF999999),
                                    ),
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
                                          image: icon,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Container(
                                      child: Center(
                                        child: Text(
                                          '$name',
                                          style: TextStyle(
                                            fontSize: 15,
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
                          Container(
                            width: 60,
                            height: 60,
                            margin: const EdgeInsets.only(
                              right: 20,
                            ),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: applyStatus == 0
                                  ? AssetImage(
                                      'assets/images/capital/wait_pass.png')
                                  : applyStatus == 1
                                      ? AssetImage(
                                          'assets/images/capital/pass_icon.png')
                                      : applyStatus == 2
                                          ? AssetImage(
                                              'assets/images/capital/refuse_icon.png')
                                          : AssetImage(
                                              'assets/images/capital/wait_pass.png'),
                              fit: BoxFit.cover,
                            )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Container(
                      height: 28,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Center(
                              child: Text(
                                'UID',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF212121),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                '$UID',
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
                    Container(
                      height: 28,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Center(
                              child: Text(
                                '手机号码',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF212121),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                '$account',
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
                    Container(
                      height: 28,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Center(
                              child: Text(
                                '管理师等级',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF212121),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                '$Lv',
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
                    Container(
                      height: 28,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Center(
                              child: Text(
                                '工龄',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF212121),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                '$workAge天',
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
                    Container(
                      height: 28,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Center(
                              child: Text(
                                '身份证号',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF212121),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                '$idCardNo',
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
                    Container(
                      height: 28,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Center(
                              child: Text(
                                '身份证正反面',
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
                    Container(
                      margin: const EdgeInsets.only(
                        top: 3,
                        bottom: 10,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 84,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2.5,
                                color: Color(0xFFE6E6E6),
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: FadeInImage.assetNetwork(
                              placeholder:
                                  "assets/images/user/card_default.jpeg",
                              // image: '',
                              image: cardA,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            width: 84,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2.5,
                                color: Color(0xFFE6E6E6),
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: FadeInImage.assetNetwork(
                              placeholder:
                                  "assets/images/user/card_default.jpeg",
                              // image: '',
                              image: cardB,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          );
          detailPage.add(
            Container(
              margin: const EdgeInsets.fromLTRB(16, 11, 16, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: Color(0xFFFF9B1A),
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 73,
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFFF9B1A),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 9,
                        ),
                        Container(
                          height: 20,
                          padding: const EdgeInsets.only(
                            left: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                width: 4,
                                color: Colors.white,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '代管卡片',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeights.medium,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 44,
                          child: Row(
                            children: <Widget>[
                              Center(
                                child: Text(
                                  '代管总额度：$totalAccLimit',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 33,
                              ),
                              Center(
                                child: Text(
                                  '代管卡片(张）：${cardList.length}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeights.medium,
                                    color: Colors.white,
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
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: cardView,
                  ),
                ],
              ),
            ),
          );
          detailContent = ListView(children: detailPage);
          return detailContent;
        });
  }

  @override
  bool get wantKeepAlive => true;
}

//卡片子信息
class CardItem extends StatefulWidget {
  final bool isLast; //是否最后一个，控制样式
  var bankName;
  var cardNo;
  var name;
  String accLimit;
  String usableMoney;
  final String cardIcon;
  CardItem(
      {Key key,
      @required this.isLast,
      @required this.bankName,
      @required this.cardNo,
      @required this.name,
      this.accLimit,
      this.usableMoney,
      @required this.cardIcon})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _CardItem();
}

class _CardItem extends State<CardItem> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: 98,
      decoration: BoxDecoration(
        border: Border(
          bottom: widget.isLast
              ? BorderSide.none
              : BorderSide(
                  width: 1,
                  color: Color(0xFFFF9B1A),
                  style: BorderStyle.solid,
                ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '客户姓名：${widget.name}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    fontWeight: FontWeights.medium,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 40,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/user/card_default.jpeg",
                            image: widget.cardIcon,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 40,
                        child: Center(
                          child: Row(
                            children: <Widget>[
                              Text(
                                '${widget.bankName}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeights.medium,
                                  color: Color(0xFF212121),
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                '${widget.cardNo}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeights.medium,
                                  color: Color(0xFF999999),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 20,
                        child: Center(
                          child: Text(
                            '信用额度：${widget.accLimit}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeights.medium,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 20,
                        child: Center(
                          child: Text(
                            '可用额度：${widget.usableMoney}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeights.medium,
                              color: Color(0xFF999999),
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
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

//通过，拒绝
class ControlButton extends StatefulWidget {
  final int id;
  final callback;
  final int applyStatus;
  ControlButton({
    Key key,
    @required this.id,
    @required this.callback,
    @required this.applyStatus,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() =>
      _ControlButton(applyStatus: applyStatus);
}

class _ControlButton extends State<ControlButton> {
  int applyStatus;
  bool isError = true;
  _ControlButton({Key key, @required this.applyStatus});

  var passInputCtrl = TextEditingController();
  var refuseInputCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    eventBus.on<ErrorStatusEvent>().listen((event) {
      if (mounted) {
        this.setState(() {
          isError = event.isError;
        });
      }
    });
  }

  //通过弹窗

  _passView(context, managerBloc) {
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
                  '备注',
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
              height: 90,
              margin: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFE6E6E6),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: passInputCtrl,
                maxLines: 3,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeights.medium,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(
                    11,
                    10,
                    11,
                    10,
                  ),
                  hintText: '请输入通过的理由',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF999999),
                    fontWeight: FontWeights.medium,
                  ),
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
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
                      if (passInputCtrl.text.length == 0) {
                        managerBloc.showToast('请输入通过理由');
                        return;
                      }
                      Navigator.pop(context, true);
                      managerBloc.operationMasterApply(
                          widget.id, passInputCtrl.text, 1);
                      this.setState(() {
                        applyStatus = 1;
                      });
                      eventBus.fire(ApplyStatusEvent(1));
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

  //拒绝理由
  _refuseView(managerBloc, applicationBloc) {
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
                  '备注',
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
              height: 90,
              margin: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFE6E6E6),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: refuseInputCtrl,
                maxLines: 3,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeights.medium,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(
                    11,
                    10,
                    11,
                    10,
                  ),
                  hintText: '请输入拒绝的理由',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF999999),
                    fontWeight: FontWeights.medium,
                  ),
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
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
                      Navigator.of(context).pop();
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
                      if (refuseInputCtrl.text.length == 0) {
                        managerBloc.showToast('请输入拒绝理由');
                        return;
                      }
                      Navigator.of(context).pop();
                      managerBloc.operationMasterApply(
                          widget.id, refuseInputCtrl.text, 2);
                      this.setState(() {
                        applyStatus = 2;
                      });
                      eventBus.fire(ApplyStatusEvent(2));
                      Future.delayed(new Duration(milliseconds: 500)).then((_) {
                        Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc applicationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    ManagerBloc managerBloc = BlocProvider.of<ManagerBloc>(context);
    managerBloc.bloccontext = context;
    return Offstage(
      offstage: applyStatus == 1 || applyStatus == 2 || isError,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 100,
            height: 44,
            decoration: BoxDecoration(
              color: Color(0xFFFF9B1A),
              borderRadius: BorderRadius.circular(5),
            ),
            child: MaterialButton(
              padding: const EdgeInsets.all(0),
              minWidth: 0,
              child: Center(
                child: Text(
                  '通过',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeights.medium,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (_) => _passView(context, managerBloc),
                ).then((bool isUpdate) {
                  if (isUpdate != null) {
                    if (isUpdate) {
                      widget.callback(true);
                    }
                  }
                });
              },
            ),
          ),
          Container(
            width: 100,
            height: 44,
            decoration: BoxDecoration(
              color: Color(0xFFFF9B1A),
              borderRadius: BorderRadius.circular(5),
            ),
            child: MaterialButton(
              padding: const EdgeInsets.all(0),
              minWidth: 0,
              child: Center(
                child: Text(
                  '拒绝',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeights.medium,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => _refuseView(managerBloc, applicationBloc),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
