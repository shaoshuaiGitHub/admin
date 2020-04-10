import 'package:flutter/material.dart';
import 'package:youxinbao/blocs/capital/mine/bank_bloc.dart';
import 'addBankCard_page.dart';
import '../../../../../common/component_index.dart';
import 'package:flutter/gestures.dart';

class MineBankCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MineBankCard();
}

class _MineBankCard extends State<MineBankCard> {
  //我的银行page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          '我的银行卡',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colours.orange_72,
      ),
      body: BlocProvider<BankBloc>(
        bloc: BankBloc(),
        child: BankMiddle(),
      ),
    );
  }
}

//
class BankMiddle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BankMiddle();
}

class _BankMiddle extends State<BankMiddle> {
  BankBloc bankBloc = BankBloc();

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc applicationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    return Container(
      color: Color(0xFFF2F2F2),
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 78),
            child: Bank(bankBloc: bankBloc),
          ),
          Positioned(
            //添加银行卡按钮 定位底部
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colours.orange_72,
              ),
              margin: EdgeInsets.all(16),
              child: FlatButton(
                child: Text(
                  '添加银行卡',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => AddBankCard(),
                    ),
                  ).then((val) {
                    if (applicationBloc.backType == 1) {
                      bankBloc.getReceiveCardsList();
                    }
                  });
                  applicationBloc.backType = 0;
                },
              ),
            ),
            bottom: 0,
            left: 0,
            right: 0,
          ),
        ],
      ),
    );
  }
}

//银行卡
class Bank extends StatefulWidget {
  final BankBloc bankBloc;
  Bank({Key key, @required this.bankBloc}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _Bank();
}

class _Bank extends State<Bank> {
  int showId = 0;
  List<dynamic> blankList = []; //银行卡列表
  @override
  void initState() {
    super.initState();
    Future.delayed(new Duration(milliseconds: 100)).then((_) {
      widget.bankBloc.getReceiveCardsList();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.bankBloc.bloccontext = context;
    final ApplicationBloc applocationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    return StreamBuilder(
      stream: widget.bankBloc.outBank,
      builder:
          (BuildContext context, AsyncSnapshot<ReceiveCardListModel> snapshot) {
        if (snapshot.hasData) {
          blankList = snapshot.data.bankList;
        }
        List<Widget> blankContainer = [];
        Widget content;
        blankList.forEach(
          (item) => blankContainer.add(
                SlideButton(
                  key: GlobalKey<SlideButtonState>(),
                  buttons: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      // borderRadius: BorderRadius.only(
                      //   topRight: Radius.circular(5),
                      //   bottomRight: Radius.circular(5),
                      // ),
                    ),
                    margin: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.center,
                    width: 80,
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) =>
                              DelDialog(id: item.id, bankBloc: widget.bankBloc),
                        ).then((val) {
                          if (applocationBloc.backType == 1) {
                            Future.delayed(new Duration(milliseconds: 100))
                                .then((_) {
                              widget.bankBloc.getReceiveCardsListReLoad();
                            });
                          }
                        });
                        applocationBloc.backType = 0;
                      },
                      child: Text('删除',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                  ),
                  singleButtonWidth: 80.0,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Container(
                      height: 90,
                      margin: EdgeInsets.only(left: 16, right: 16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              width: 1.0,
                              color: Color(0xfff2f2f2),
                              style: BorderStyle.solid,
                            ),
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: 40,
                                height: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                        "assets/images/user/card_default.jpeg",
                                    image: '${item.icon}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${item.bankName}',
                                    style: TextStyle(
                                        fontSize: 16, color: Color(0xFF666666)),
                                  ),
                                  Text(
                                    '${item.cardId}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF666666),
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        );
        content = ListView(children: blankContainer);
        return content;
      },
    );
  }
}

//侧滑按钮
class SlideButton extends StatefulWidget {
  Widget child;
  Widget buttons;
  GlobalKey<SlideButtonState> key;
  double singleButtonWidth;

  VoidCallback onSlideStarted;

  VoidCallback onSlideCompleted;

  VoidCallback onSlideCanceled;

  SlideButton(
      {this.key,
      @required this.child,
      @required this.singleButtonWidth,
      @required this.buttons,
      this.onSlideStarted,
      this.onSlideCompleted,
      this.onSlideCanceled})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SlideButtonState();
  }
}

class SlideButtonState extends State<SlideButton>
    with TickerProviderStateMixin {
  double translateX = 0;
  double maxDragDistance;
  final Map<Type, GestureRecognizerFactory> gestures =
      <Type, GestureRecognizerFactory>{};

  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    maxDragDistance = widget.singleButtonWidth;
    gestures[HorizontalDragGestureRecognizer] =
        GestureRecognizerFactoryWithHandlers<HorizontalDragGestureRecognizer>(
      () => HorizontalDragGestureRecognizer(debugOwner: this),
      (HorizontalDragGestureRecognizer instance) {
        instance
          ..onDown = onHorizontalDragDown
          ..onUpdate = onHorizontalDragUpdate
          ..onEnd = onHorizontalDragEnd;
      },
    );
    animationController = AnimationController(
        lowerBound: -maxDragDistance,
        upperBound: 0,
        vsync: this,
        duration: Duration(milliseconds: 300))
      ..addListener(() {
        translateX = animationController.value;
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            widget.buttons,
          ],
        )),
        RawGestureDetector(
          gestures: gestures,
          child: Transform.translate(
            offset: Offset(translateX, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: widget.child,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  void onHorizontalDragDown(DragDownDetails details) {
    if (widget.onSlideStarted != null) widget.onSlideStarted.call();
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    translateX = (translateX + details.delta.dx).clamp(-maxDragDistance, 0.0);
    setState(() {});
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    animationController.value = translateX;
    if (details.velocity.pixelsPerSecond.dx > 200) {
      close();
    } else if (details.velocity.pixelsPerSecond.dx < -200) {
      open();
    } else {
      if (translateX.abs() > maxDragDistance / 2) {
        open();
      } else {
        close();
      }
    }
  }

  void open() {
    if (translateX != -maxDragDistance)
      animationController.animateTo(-maxDragDistance).then((_) {
        if (widget.onSlideCompleted != null) widget.onSlideCompleted.call();
      });
  }

  void close() {
    if (translateX != 0)
      animationController.animateTo(0).then((_) {
        if (widget.onSlideCanceled != null) widget.onSlideCanceled.call();
      });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

//删除银行卡确认窗口
class DelDialog extends StatefulWidget {
  final int id;
  final BankBloc bankBloc;
  DelDialog({Key key, @required this.id, @required this.bankBloc})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _DelDialog();
}

class _DelDialog extends State<DelDialog> {
  @override
  Widget build(BuildContext context) {
    final ApplicationBloc applocationBloc =
        BlocProvider.of<ApplicationBloc>(context);
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
                  color: Colours.orange_72,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  )),
              child: Center(
                child: Text(
                  '删除银行卡',
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
                '确定要删除此银行卡吗？',
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
                    color: Colours.orange_72,
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
                      widget.bankBloc.removeReceiveCards(widget.id);
                      applocationBloc.backType = 1;
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
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
}
