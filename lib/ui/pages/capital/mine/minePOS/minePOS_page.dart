import 'package:flutter/material.dart';
import 'addPOS_page.dart';
import '../../../../../common/component_index.dart';
import '../../../../../ui/pages/page_index.dart';
import 'package:flutter/gestures.dart';

class MinePOSPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MinePOSPage();
}

class _MinePOSPage extends State<MinePOSPage> {
  //我的POS机Page
  @override
  Widget build(BuildContext context) {
    // PosBloc posBloc = PosBloc();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          '我的POS机',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xffff9b1a),
      ),
      body: BlocProvider<PosBloc>(
        bloc: PosBloc(),
        child: PosMiddle(),
      ),
    );
  }
}

class PosMiddle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PosMiddle();
}

class _PosMiddle extends State<PosMiddle> {
  List posList = List();
  PosBloc posBloc = PosBloc();

  void setPosList(val) {
    posList = val;
  }

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc applocationBloc =
        BlocProvider.of<ApplicationBloc>(context);

    return Container(
      color: Color(0xFFF2F2F2),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                // color: Colors.yellow
                ),
            margin: const EdgeInsets.only(top: 10, bottom: 78),
            child: Pos(posBloc: posBloc, callback: (val) => setPosList(val)),
          ),
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xffff9b1a),
              ),
              margin: EdgeInsets.all(16),
              child: FlatButton(
                child: Text(
                  '新增POS机',
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
                      builder: (BuildContext context) =>
                          AddPOSPage(posList: posList),
                    ),
                  ).then((_) {
                    if (applocationBloc.backType == 1) {
                      posBloc.getPosList();
                    }
                  });
                  applocationBloc.backType = 0;
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

class Pos extends StatefulWidget {
  final PosBloc posBloc;
  final callback;
  Pos({Key key, @required this.posBloc, @required this.callback})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _Pos();
}

class _Pos extends State<Pos> {
  List posList = [];
  @override
  void initState() {
    super.initState();
    Future.delayed(new Duration(milliseconds: 100)).then((_) {
      widget.posBloc.getPosList();
    });
  }

  //删除pos确认窗口
  _removePosView(id, context) {
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
                color: Color(0xFFFF9B1A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
              child: Center(
                child: Text(
                  '删除POS机',
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
                '确定要删除此POS机吗？',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF212121),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 44,
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colours.gray_cc,
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
                      widget.posBloc.removesPos(id);
                      applocationBloc.backType = 1;
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

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc applocationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    widget.posBloc.bloccontext = context;
    return StreamBuilder<PosListModel>(
      stream: widget.posBloc.outPos,
      builder: (BuildContext context, AsyncSnapshot<PosListModel> snapshot) {
        posList = snapshot.hasData ? snapshot.data.posList : [];
        List<Widget> posContainer = [];
        Widget content;
        //回调列表
        widget.callback(posList);
        // var  key= GlobalKey<SlideButtonState>();
        posList.forEach(
          (item) => posContainer.add(
            SlideButton(
              key: GlobalKey<SlideButtonState>(),
              buttons: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                margin: EdgeInsets.only(
                  right: 16,
                  top: 5,
                  bottom: 5,
                ),
                alignment: Alignment.center,
                width: 80,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => _removePosView(item.id, context),
                    ).then((val) {
                      if (applocationBloc.backType == 1) {
                        Future.delayed(new Duration(milliseconds: 100))
                            .then((_) {
                          widget.posBloc.getPosList();
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
                margin: EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
                padding: EdgeInsets.only(
                  top: 6,
                  bottom: 8,
                  left: 20,
                  right: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0xffffffff),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(33, 33, 33, 0.25),
                      offset: Offset(1.0, 0.0),
                      blurRadius: 1.0,
                    )
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${item.alias}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          '利率: ${item.rate}%',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          '收款卡: ${item.bankNo}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              '银行: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF212121),
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              '${item.bankName}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF212121),
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '所属管理师: ${item.masterName == false ? '未分配' : item.masterName}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        content = ListView(children: posContainer);
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
