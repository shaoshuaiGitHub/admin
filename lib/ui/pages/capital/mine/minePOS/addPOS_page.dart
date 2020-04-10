import 'package:flutter/material.dart';
import 'package:youxinbao/ui/pages/capital/mine/minePOS/minePOS_index.dart';
import '../../../../../common/component_index.dart';
import '../../../../../ui/pages/page_index.dart';

class AddPOSPage extends StatefulWidget {
  final List posList;
  AddPOSPage({Key key, @required this.posList}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AddPOSPage();
}

class _AddPOSPage extends State<AddPOSPage> {
  @override
  Widget build(BuildContext context) {
    //新增POSPage部分
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          '新增POS机',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          FlatButton(
              padding: EdgeInsets.all(0),
              child: Text(
                '取消',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xffffffff),
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.none,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
        backgroundColor: Color(0xffff9b1a),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: BlocProvider<PosBloc>(
          bloc: PosBloc(),
          child: MainView(posList: widget.posList),
        ),
      ),
    );
  }
}

//主要部分
class MainView extends StatefulWidget {
  final List posList;
  MainView({Key key, @required this.posList}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MainView();
}

class _MainView extends State<MainView> {
  int typeId = 0; //选中机名
  int posInfoId = 0; //选中机型
  var cardNoInputCrl = TextEditingController();
  var bankInputCrl = TextEditingController();
  var posNameIputCtrl = TextEditingController();
  String posName1 = '';
  String posName2 = '';
  PosBloc posBloc = PosBloc();

  @override
  void initState() {
    super.initState();
    Future.delayed(new Duration(milliseconds: 100)).then(
      (_) {
        posBloc.getPosInfoList();
      },
    );
  }

  void selectType(val) {
    typeId = val;
  }

  void selectPos(val) {
    posInfoId = val;
  }

  void selectPosName1(val) {
    posName1 = val;
    // posNameIputCtrl.text = '';
  }

  void selectPosName2(val) {
    posName2 = val;
    // posNameIputCtrl.text = posName1 + posName2;
  }

  void selectPosName3(val) {
    posName2 = val;
  }

  @override
  Widget build(BuildContext context) {
    // final PosBloc posBloc = BlocProvider.of<PosBloc>(context);
    final ApplicationBloc applocationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    posBloc.bloccontext = context;

    void showToast(String msg, {int duration, int gravity: 0}) {
      Toast.show(msg, context, duration: duration, gravity: gravity);
    }

    return Container(
      color: Color(0xFFF2F2F2),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 13, bottom: 10),
            child: Column(
              children: <Widget>[
                Container(
                  //POS机名选项框
                  height: 44,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    border: Border.all(
                      color: Color(0xffff9b1a),
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'POS机品牌',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff212121),
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            StreamBuilder(
                              stream: posBloc.outTypeSelected,
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                String posInfoName = snapshot.hasData
                                    ? snapshot.data.name
                                    : '请选择POS机品牌';
                                return Text(
                                  posInfoName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: snapshot.hasData
                                        ? Colors.black
                                        : Color(0xff999999),
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.none,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Container(
                          width: 11,
                          height: 5,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/capital/triangle.png'))),
                        ),
                      ],
                    ),
                    onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (_) => POSName(
                                posBloc: posBloc,
                                callback: (val) => selectType(val),
                                callback2: (val) => selectPos(val),
                                callback3: (val) => selectPosName1(val),
                                callback4: (val) => selectPosName3(val),
                              ),
                        ),
                  ),
                ), //1
                SizedBox(
                  height: 10,
                ),
                Container(
                  //POS机型选项框
                  height: 44,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    border: Border.all(
                      color: Color(0xffff9b1a),
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'POS机型号',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff212121),
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            StreamBuilder(
                              stream: posBloc.outPosInfoSelected,
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                String posInfoName = snapshot.hasData
                                    ? snapshot.data.posName
                                    : '请选择POS机型';
                                return Text(
                                  posInfoName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: snapshot.hasData
                                        ? Colors.black
                                        : Color(0xff999999),
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.none,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Container(
                          width: 11,
                          height: 5,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/capital/triangle.png'))),
                        ),
                      ],
                    ),
                    onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (_) => POSType(
                                posBloc: posBloc,
                                callback: (val) => selectPos(val),
                                callback2: (val) => selectPosName2(val),
                              ),
                        ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  //POS机名
                  padding: EdgeInsets.only(
                    left: 32,
                    right: 26,
                  ),
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    border: Border.all(
                      color: Color(0xffff9b1a),
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'POS机名',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff212121),
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Container(
                        width: 200,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.all(
                            const Radius.circular(5.0),
                          ),
                        ),
                        child: TextField(
                          controller: posNameIputCtrl,
                          decoration: InputDecoration(
                            hintText: '给这个POS机取个名字吧',
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xff999999),
                            ),
                            contentPadding: EdgeInsets.all(10.0),
                            // fillColor: Colors.white, filled: true,
                            // 以下属性可用来去除TextField的边框
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  //POS机费率
                  height: 66,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'POS机费率',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff212121),
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        '0.60%',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xffff0000),
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      )
                    ],
                  ),
                ), //3
                Container(
                  //收款卡input框
                  padding: EdgeInsets.only(
                    left: 11,
                    right: 11,
                  ),
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    border: Border.all(
                      color: Color(0xffff9b1a),
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '收款卡',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff212121),
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 217,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.all(
                            const Radius.circular(5.0),
                          ),
                        ),
                        child: TextField(
                          controller: cardNoInputCrl,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(18)
                          ], //只允许输入数字
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '请输入POS机收款卡卡号',
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xff999999),
                            ),
                            contentPadding: EdgeInsets.all(10.0),
                            // fillColor: Colors.white, filled: true,
                            // 以下属性可用来去除TextField的边框
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    ],
                  ),
                ), //4
                SizedBox(
                  height: 10,
                ),
                Container(
                  //银行input框
                  padding: EdgeInsets.only(
                    left: 26,
                    right: 26,
                  ),
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    border: Border.all(
                      color: Color(0xffff9b1a),
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '银行',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff212121),
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 217,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.all(
                            const Radius.circular(5.0),
                          ),
                        ),
                        child: TextField(
                          controller: bankInputCrl,
                          decoration: InputDecoration(
                            hintText: '请输入收款卡所属银行',
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xff999999),
                            ),
                            contentPadding: EdgeInsets.all(10.0),
                            // fillColor: Colors.white, filled: true,
                            // 以下属性可用来去除TextField的边框
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            //底部定位 完成按钮
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xffff9b1a),
              ),
              margin: EdgeInsets.all(16),
              child: FlatButton(
                child: Text(
                  '完成',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
                onPressed: () {
                  if (typeId == 0) {
                    showToast('请选择POS机品牌');
                    return;
                  }
                  if (posInfoId == 0) {
                    showToast('请选择POS机型号');
                    return;
                  }
                  if (posNameIputCtrl.text.length == 0) {
                    showToast('请输入POS机别名');
                    return;
                  }
                  if (posNameIputCtrl.text.length > 15) {
                    showToast('请输入小于16位字符POS机名');
                    return;
                  }
                  if (cardNoInputCrl.text.length == 0) {
                    showToast('请输入POS机收款银行卡号');
                    return;
                  }
                  if (bankInputCrl.text.length == 0) {
                    showToast('请输入收款卡所属银行');
                    return;
                  }
                  // int sameLength = widget.posList
                  //     .where((item) =>
                  //         item.posId == posInfoId 
                  //         &&
                  //         item.alias == posNameIputCtrl.text)
                  //     .toList()
                  //     .length;
                  // if (sameLength == 1) {
                  //   posNameIputCtrl.text = posNameIputCtrl.text + 'x';
                  // }
                  posBloc.addPosTerminals(
                    posInfoId,
                    int.parse(cardNoInputCrl.text),
                    bankInputCrl.text,
                    posNameIputCtrl.text,
                  );
                  applocationBloc.backType = 1;
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

//底部POS机型弹窗
class POSType extends StatefulWidget {
  final PosBloc posBloc;
  final callback;
  final callback2;
  POSType({
    Key key,
    @required this.callback,
    @required this.callback2,
    @required this.posBloc,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _POSType();
}

class _POSType extends State<POSType> {
  @override
  Widget build(BuildContext context) {
    widget.posBloc.bloccontext = context;
    int i = 1;
    if (widget.posBloc.useInfoList != null) {
      return StreamBuilder(
        stream: widget.posBloc.outPosInfoSelected,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Widget> posInfoView = [];
          Widget posInfoListView;
          int selectedId = snapshot.hasData ? snapshot.data.id : 0;
          widget.posBloc.useInfoList.forEach(
            (item) {
              posInfoView.add(
                Container(
                  height: 44,
                  child: MaterialButton(
                    minWidth: 0,
                    onPressed: () {
                      widget.posBloc.setSelectedPosInfo.add(item);
                      widget.callback2(item.posName);
                      widget.callback(item.id);
                      Navigator.of(widget.posBloc.bloccontext).pop();
                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 44,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: i != widget.posBloc.useInfoList.length
                              ? BorderSide(
                                  width: 1,
                                  color: Color(0xFFFF9B1A),
                                  style: BorderStyle.solid)
                              : BorderSide.none,
                        ),
                      ),
                      child: Text(
                        '${item.posName}',
                        style: TextStyle(
                          fontSize: 16,
                          color: item.id == selectedId
                              ? Color(0xffff9b1a)
                              : Color(0xff212121),
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
              );
              i++;
            },
          );
          posInfoListView =
              Column(mainAxisSize: MainAxisSize.min, children: posInfoView);
          return posInfoListView;
        },
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
      );
    }
  }
}

//POS机名底部弹窗
class POSName extends StatefulWidget {
  final PosBloc posBloc;
  final callback4;
  final callback3;
  final callback2;
  final callback;
  POSName(
      {Key key,
      @required this.callback,
      @required this.callback2,
      @required this.callback3,
      @required this.callback4,
      @required this.posBloc})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _POSName();
}

class _POSName extends State<POSName> {
  @override
  Widget build(BuildContext context) {
    widget.posBloc.bloccontext = context;
    int i = 1;
    if (widget.posBloc.typeList != null) {
      return StreamBuilder(
        stream: widget.posBloc.outTypeSelected,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List useList = [];
          List<Widget> typeView = [];
          Widget typeListView;
          int selectedId = snapshot.hasData ? snapshot.data.id : 0;
          widget.posBloc.typeList.forEach(
            (item) {
              typeView.add(
                Container(
                  height: 44,
                  child: MaterialButton(
                    minWidth: 0,
                    onPressed: () {
                      widget.posBloc.setSelectedType.add(item);
                      widget.callback(item.id);
                      widget.callback2(0);
                      widget.callback3(item.name);
                      widget.callback4('');
                      
                      widget.posBloc.posInfoList.forEach(
                        (idx)  {
                          
                              if (idx.type == item.id)
                                {
                                  useList.add(idx);
                                }
                            },
                      );
                      widget.posBloc.useInfoList = useList;
                      Navigator.of(widget.posBloc.bloccontext).pop();
                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 44,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: i != widget.posBloc.typeList.length
                              ? BorderSide(
                                  width: 1,
                                  color: Color(0xFFFF9B1A),
                                  style: BorderStyle.solid)
                              : BorderSide.none,
                        ),
                      ),
                      child: Text(
                        '${item.name}',
                        style: TextStyle(
                          fontSize: 16,
                          color: item.id == selectedId
                              ? Color(0xffff9b1a)
                              : Color(0xff212121),
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
              );
              i++;
            },
          );
          typeListView =
              Column(mainAxisSize: MainAxisSize.min, children: typeView);
          return typeListView;
        },
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
      );
    }
  }
}
