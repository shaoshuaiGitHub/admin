import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import 'createprofit_page.dart';
import '../../../../ui/widgets/expansion_panel.dart';

class MyDetailHead extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyDetailHead();
  }
}

class _MyDetailHead extends State<MyDetailHead> {
  var currentPanelIndex = 0; // -1默认全部闭合
  var currentConsumePanelIndex = 0; // -1默认全部闭合
  var currentGetprofitPanelIndex = 0;
  List<int> mList;
  ExpansionPanelCustomList _expansionPanelList;

  _MyDetailHead() {
    mList = new List();
    for (int i = 0; i < 3; i++) {
      mList.add(i);
    }
  }

  //消费分润下拉内容
  _consumePanelList() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.elliptical(5, 5))),
      child: SingleChildScrollView(
        child: ExpansionPanelCustomList(
            animationDuration: Duration(milliseconds: 500),
            expansionCallback: (panelIndex, isExpanded) {
              setState(() {
                currentConsumePanelIndex =
                    (currentConsumePanelIndex != panelIndex) ? panelIndex : -1;
              });
            },
            parms: {
              'type': 'custom',
              'backgroundcolor': 0xffff7200,
              'iconcolor': 0xffffffff
            },
            children: [
              ExpansionPanelCustom(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('客户：哇哈哈',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                        Row(
                          children: <Widget>[
                            Text('代管类型：单次代操',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)),
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
                              color: Color.fromARGB(65, 255, 114, 0)),
                          borderRadius: BorderRadius.vertical(
                              top: Radius.elliptical(5, 5))),
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            // height: 300,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colours.bottom_line))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('类型:还款计划',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colours.gray_66)),
                                          Text('1209-20-33 12:11',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colours.gray_21)),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text('计划消费',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colours.gray_66)),
                                          Text('250000.00',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colours.gray_21)),
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
                                                color: Colours.bottom_line))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '建议行业：[脑子有问题][精神啥的]',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colours.gray_66),
                                        ),
                                      ],
                                    )),
                                Container(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            width: 20,
                                            height: 20,
                                            margin: EdgeInsets.only(right: 5),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    "assets/images/user/card_default.jpeg",
                                                // image: item.icon,
                                                image: '',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '工商银行',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colours.gray_66),
                                              ),
                                              Text(
                                                '222222222222222',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colours.gray_66),
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
                                          Text('代管金额',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colours.gray_66)),
                                          Text('250.00',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colours.gray_21)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text('计划状态:',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colours.gray_66)),
                                          Text('已消费成功',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.red)),
                                        ],
                                      ),
                                      Text('实际消费：30000.00',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colours.gray_21)),
                                      // Text('未还款',
                                      //     style:
                                      //         TextStyle(fontSize: 12, color: Colours.gray_66)),
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
                      margin: EdgeInsets.only(left: 30, right: 30, bottom: 10),
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('更新时间:2019-02-22 22:22',
                              style: TextStyle(
                                  fontSize: 14, color: Colours.gray_21)),
                          Row(
                            children: <Widget>[
                              Text('分润金额：',
                                  style: TextStyle(
                                      fontSize: 12, color: Colours.gray_21)),
                              Text('70.00',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red)),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                isExpanded: currentConsumePanelIndex == 0,
              )
            ]),
      ),
    );
  }

//提额分润下拉内容
  _getprofitPanelList() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.elliptical(5, 5))),
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
              children: [
                ExpansionPanelCustom(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('客户：哇哈哈',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                          Row(
                            children: <Widget>[
                              Text('代管类型：单次代操',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white)),
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
                              color: Color.fromARGB(65, 255, 114, 0)),
                        ),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colours.bottom_line))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: 20,
                                        height: 20,
                                        margin: EdgeInsets.only(right: 5),
                                        child: Image.asset(
                                            ImgPrefix.manager_prefix +
                                                'gongshang.png'),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '工商银行',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colours.gray_66),
                                          ),
                                          Text(
                                            '222222222222222',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colours.gray_66),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text('代管金额',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colours.gray_66)),
                                      Text('250.00',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colours.gray_21)),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text('70.00',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colours.gray_21)),
                                      Text('创建时间：2019-02-21 14:88',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colours.gray_66)),
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
                  isExpanded: currentGetprofitPanelIndex == 0,
                )
              ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    _expansionPanelList = new ExpansionPanelCustomList(
      animationDuration: Duration(milliseconds: 500),
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          currentPanelIndex =
              (currentPanelIndex != panelIndex) ? panelIndex : -1;
        });
      },
      parms: {
        'type': 'custom',
        'backgroundcolor': 0xffffffff,
        'iconcolor': 0xff212121
      },
      children: [
        ExpansionPanelCustom(
          headerBuilder: (context, isExpanded) {
            return Container(
                height: 50,
                padding: EdgeInsets.only(left: 0),
                margin: EdgeInsets.only(left: 20),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '消费分润(元)',
                      style: TextStyle(fontSize: 16, color: Colours.gray_21),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '1322150.22',
                          style:
                              TextStyle(fontSize: 16, color: Colours.gray_21),
                        ),
                      ],
                    )
                  ],
                ));
          },
          body: Column(
            children: <Widget>[
              _consumePanelList(),
            ],
          ),
          isExpanded: currentPanelIndex == 0,
        ),
        ExpansionPanelCustom(
          headerBuilder: (context, isExpanded) {
            return Container(
              height: 50,
              // padding: EdgeInsets.only(left: 20),
              margin: EdgeInsets.only(left: 20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '提额分润(元)',
                    style: TextStyle(fontSize: 16, color: Colours.gray_21),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '2150.22',
                        style: TextStyle(fontSize: 16, color: Colours.gray_21),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
          body: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  _getprofitPanelList(),
                ],
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 20, top: 20),
                  width: 200,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 114, 0),
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: Center(
                    child: FlatButton(
                      // padding: EdgeInsets.fromLTRB(170, 10, 170, 10),
                      // color: Color.fromARGB(255, 255, 114, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '创建',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
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
            ],
          ),
          isExpanded: currentPanelIndex == 1,
        ),
      ],
    );

    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            child: _expansionPanelList,
          ),
        ],
      ),
    );
  }
}
