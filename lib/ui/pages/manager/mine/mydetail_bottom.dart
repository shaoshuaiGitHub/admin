import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import 'createprofit_page.dart';
import '../../../../ui/widgets/expansion_panel.dart';

class LiftingAmountContainer extends StatefulWidget {
  // LiftingAmountContainer({this.consumList,this.n});
  // List consumList;
  // int n;
  @override
  State<StatefulWidget> createState() {
    return _LiftingAmountContainer();
  }
}

class _LiftingAmountContainer extends State<LiftingAmountContainer> {
  var currentGetprofitPanelIndex = 0; // -1默认全部闭合
  MyDetailBloc mydetailbloc = MyDetailBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  Color(0xfff2f2f2),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            '提额分润',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        body:
            Stack(children: <Widget>[
               StreamBuilder<MyDetailLiftingListModel>(
                stream: mydetailbloc.mydataStream,
                builder: (BuildContext context,
                    AsyncSnapshot<MyDetailLiftingListModel> snapshot) {
                  List<Widget> liftingContainer = [];
                  Widget content;

                  if (!snapshot.hasData) {
                    Future.delayed(new Duration(milliseconds: 500)).then((_) {
                      mydetailbloc.getLiftingData();
                    });
                    return Container();
                  }
                  List consumList =
                      snapshot.hasData ? snapshot.data.consumList : [];
                  int n = 0;

                  liftingContainer.add(Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(5))),
                      child: SingleChildScrollView(
                        child: ExpansionPanelCustomList(
                          animationDuration: Duration(milliseconds: 500),
                          expansionCallback: (panelIndex, isExpanded) {
                            setState(() {
                              print(panelIndex);
                              print(currentGetprofitPanelIndex);
                              currentGetprofitPanelIndex =
                                  (currentGetprofitPanelIndex != panelIndex)
                                      ? panelIndex
                                      : -1;
                            });
                          },
                          parms: {
                            'type': 'custom',
                            'backgroundcolor': 0xffff7200,
                            'iconcolor': 0xffffffff
                          },
                          children: consumList.map((i) {
                            return ExpansionPanelCustom(
                              headerBuilder: (context, isExpanded) {
                                return Container(
                                  margin: EdgeInsets.only(left: 20),
                                  height: 44,
                                  padding: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      // color: Colours.orange_72,
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.elliptical(5, 5))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('客户：${i.name}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white)),
                                      Row(
                                        children: <Widget>[
                                          Text('代管类型：${i.delegateType}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white)),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                              body: Column(
                                children: <Widget>[
                                  Container(
                                    // height: 300,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color:
                                              Color.fromARGB(65, 255, 114, 0)),
                                    ),
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colours
                                                          .bottom_line))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    margin: EdgeInsets.only(
                                                        right: 5),
                                                    child: 
                                                    // Image.network('${i.icon}')
                                                    Image.asset(ImgPrefix
                                                            .manager_prefix +
                                                        'gongshang.png'),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        '${i.bankName}',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colours
                                                                .gray_66),
                                                      ),
                                                      Text(
                                                        '${i.cardNo}',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colours
                                                                .gray_66),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Text('提额前额度：${i.preMoney.toStringAsFixed(2)}',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colours.gray_66)),
                                                  Text('提额后额度：${i.afterMoney.toStringAsFixed(2)}',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colours.gray_21)),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 50,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text('提额费用',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colours.gray_21)),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Text('${i.reward}',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colours.gray_21)),
                                                  Text('创建时间：${i.updateTime}',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                              Colours.gray_66)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              isExpanded: currentGetprofitPanelIndex == n++,
                            );
                          }).toList(),
                        ),
                      )));
                  content = ListView(children: liftingContainer);
                  return content;
                }),
                Positioned(
                  left:0,
                  right:0,
                  bottom:10,
                  child:  Container(
                  margin: EdgeInsets.only(bottom: 20, top: 20,right:80,left:80),
                  width: 200,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 114, 0),
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: Center(
                    child: FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        Text(
                        '创建',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      ],),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CreateProfitPage(),
                          ),
                        );
                      },
                    ),
                  ))
          )
               

            ],)
           );
  }
}
