import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youxinbao/blocs/bloc_index.dart';
import 'package:youxinbao/models/models.dart';
import 'package:youxinbao/res/res_index.dart';

class AddPosPage extends StatefulWidget {
  final int masterId;
  final List<dynamic> posList;
  AddPosPage({Key key, @required this.posList, @required this.masterId})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _AddPosPage();
}

class _AddPosPage extends State<AddPosPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: PosBloc(),
      child: Scaffold(
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
              Navigator.pop(context);
            },
          ),
          title: Container(
            child: Text(
              '我的POS机',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeights.bold,
              ),
            ),
          ),
        ),
        body: Container(
          color: Color(0xFFF2F2F2),
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(16, 15, 16, 0),
                padding: const EdgeInsets.only(
                  left: 2,
                  right: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                    color: Color(0xFFFF9B1A),
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: PosList(
                  posList: widget.posList,
                  masterId: widget.masterId,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PosList extends StatefulWidget {
  final int masterId;
  final List<dynamic> posList;
  // final callback;
  PosList({Key key, @required this.posList, @required this.masterId})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _PosList();
}

class _PosList extends State<PosList> {
  PosBloc posBloc = PosBloc();
  List posSelectedList = []; //选中需添加pos列表
  List posList = [];
  @override
  void initState() {
    super.initState();
    Future.delayed(new Duration(milliseconds: 100)).then((_) {
      posBloc.getPosList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc applocationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    posBloc.bloccontext = context;
    return StreamBuilder(
      stream: posBloc.outPos,
      builder: (BuildContext context, AsyncSnapshot<PosListModel> snapshot) {
        posList = snapshot.hasData ? snapshot.data.posList : [];
        List<Widget> posListView = [];
        Widget posColumnView;
        posListView.add(
          SizedBox(
            height: 14,
          ),
        );
        posList.forEach(
          (item) => {
            posListView.add(
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: 25,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            child: widget.posList
                                        .where((model) => model.id == item.id)
                                        .toList()
                                        .length ==
                                    1
                                ? Container(
                                    width: 14,
                                    height: 14,
                                  )
                                : Container(
                                    width: 40,
                                    child: FlatButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        //查询是否选中
                                        if (posSelectedList
                                                .where(
                                                    (model) => model == item.id)
                                                .toList()
                                                .length ==
                                            1) {
                                          posSelectedList.remove(item.id);
                                          posBloc.removeMastersPos(
                                              item.id, widget.masterId);
                                        } else {
                                          posSelectedList.add(item.id);
                                          posBloc.addMasterPos(
                                              item.id, widget.masterId);
                                        }
                                        applocationBloc.backType = 1;

                                        this.setState(() {
                                          posSelectedList = posSelectedList;
                                        });
                                      },
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          color: Colors.white,
                                          border: Border.all(
                                            width: 1,
                                            color: Color(0xFFCCCCCC),
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        child: posSelectedList
                                                    .where((model) =>
                                                        model == item.id)
                                                    .toList()
                                                    .length ==
                                                1
                                            ? Icon(
                                                Icons.check,
                                                size: 10,
                                                color: Color(0xFFFF9B1A),
                                              )
                                            : Icon(
                                                Icons.check_box_outline_blank,
                                                size: 10,
                                                color: Colors.white,
                                              ),
                                      ),
                                    ),
                                  ),
                          ),
                          Container(
                            height: 25,
                            child: Center(
                              child: Text(
                                '${item.alias}',
                                style: TextStyle(
                                  fontSize: 13,
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
                      height: 25,
                      child: Center(
                        child: Text(
                          '利率：${item.rate}%',
                          style: TextStyle(
                            fontSize: 13,
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
          },
        );
        posListView.add(
          SizedBox(
            height: 14,
          ),
        );

        posColumnView = Column(
          children: posListView,
        );
        return posColumnView;
      },
    );
  }
}
