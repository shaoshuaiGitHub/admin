import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import 'createprofit_page.dart';
import '../../../../ui/widgets/expansion_panel.dart';

class ConsumContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConsumContainer();
  }
}

class _ConsumContainer extends State<ConsumContainer> {
  var currentGetprofitPanelIndex = 0; // -1默认全部闭合
  MyDetailBloc mydetailbloc = MyDetailBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          // backgroundColor: Color.fromARGB(255, 255, 114, 0),
          title: Text(
            '消费分润',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        body: ListView(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            StreamBuilder<MyDetailConsumListModel>(
                stream: mydetailbloc.myconsumdataStream,
                builder: (BuildContext context,
                    AsyncSnapshot<MyDetailConsumListModel> snapshot) {
                  List<Widget> consumContainer = [];
                  Widget content;

                  if (!snapshot.hasData) {
                    Future.delayed(new Duration(milliseconds: 500)).then((_) {
                      mydetailbloc.getConsumData(0);
                    });
                    return Container();
                  }
                  List consumList =
                      snapshot.hasData ? snapshot.data.consumList : [];
                  int n = 0;

                  consumContainer.add(Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.elliptical(5, 5))),
                      child: SingleChildScrollView(
                        child: ExpansionPanelCustomList(
                          animationDuration: Duration(milliseconds: 500),
                          expansionCallback: (panelIndex, isExpanded) {
                            setState(() {
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
                                    // margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color.fromARGB(
                                                65, 255, 114, 0)),
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.elliptical(5, 5))),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          color: Colors.white,
                                          // height: 300,
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text('类型:${i.planType}',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colours
                                                                    .gray_66)),
                                                        Text(
                                                            '${i.startTime} - ${i.endTime}',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colours
                                                                    .gray_21)),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: <Widget>[
                                                        Text(
                                                            '计划${i.planType.substring(0, 2)}',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colours
                                                                    .gray_66)),
                                                        Text(
                                                            '${i.minMoney.toStringAsFixed(2)}',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colours
                                                                    .gray_21)),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: Colours
                                                                  .bottom_line))),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        '${i.info}',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colours
                                                                .gray_66),
                                                      ),
                                                    ],
                                                  )),
                                              Container(
                                                height: 50,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Container(
                                                          width: 20,
                                                          height: 20,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 5),
                                                          child:
                                                              // Image.network(i.icon),
                                                              ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40),
                                                            child: FadeInImage
                                                                .assetNetwork(
                                                              placeholder:
                                                                  "assets/images/user/card_default.jpeg",
                                                              image: i.icon,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
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
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: <Widget>[
                                                        Text('代管金额',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colours
                                                                    .gray_66)),
                                                        Text(
                                                            '${i.delegateMoney}',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colours
                                                                    .gray_21)),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 40,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Text('计划状态:',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colours
                                                                    .gray_66)),
                                                        Text('${i.status}',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .red)),
                                                      ],
                                                    ),
                                                    Text(
                                                        '实际消费：${i.realMoney.toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colours
                                                                .gray_21)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: Colours.gray_cc,
                                    height: 40,
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10),
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('更新时间:${i.updateTime}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colours.gray_21)),
                                        Row(
                                          children: <Widget>[
                                            Text('分润金额：',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colours.gray_21)),
                                            Text(
                                                '${i.rewardMoney.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.red)),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              isExpanded: currentGetprofitPanelIndex == n++,
                            );
                          }).toList(),
                        ),
                      )));
                  content = Column(children: consumContainer);
                  return content;
                })
          ],
        ));
  }
}
