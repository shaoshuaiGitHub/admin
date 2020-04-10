import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';

class WindControlAuditMiddle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WindControlAuditMiddle();
}

class _WindControlAuditMiddle extends State<WindControlAuditMiddle>
    with AutomaticKeepAliveClientMixin {
  WindBloc windBloc = WindBloc();
  num score = 0;
  String idCard = '';
  String phone = '';
  List riskList = List();
  List aPartnerList = List();
  String selectedIndex = '7'; //默认显示7天内
  bool isLock = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    windBloc.bloccontext = context;
    if (!isLock) {
      Future.delayed(new Duration(milliseconds: 500)).then((_) {
        windBloc.getRiskControls(1001);
      });
      isLock = true;
    }
    return StreamBuilder(
      stream: windBloc.riskStream,
      builder:
          (BuildContext context, AsyncSnapshot<RiskControlModel> snapshot) {
        List<Widget> ristItemView = [];
        Widget ristListView;
        List<Widget> partItemView = [];
        Widget partListView;
        int n = 1;
        List partList = List(); //7天 1个月 3个月
        List lastPartList = List(); //3个月内申请人在多个平台被放款_不包含本合作方

        if (!snapshot.hasData) {
          return Container();
        } else {
          score = snapshot.data.score;
          riskList = snapshot.data.risk;
        }
        ristItemView.add(
          PartOne(
            score: score,
            // idCard: idCard,
            // phone: phone,
          ),
        );
        riskList.forEach(
          (item) {
            if (item.type == 'grey_list') {
              ristItemView.add(
                GreyList(
                    n: n,
                    riskName: item.riskName,
                    greyList: item.riskDetailList),
              );
            } else if (item.type == 'frequency_distinct') {
              ristItemView.add(
                FrequencyDistinct(
                    riskName: item.riskName,
                    frequencyList: item.riskDetailList),
              );
            } else if (item.type == 'frequency_one_dim') {
              ristItemView.add(
                FrequencyOneDim(
                  riskName: item.riskName,
                  result: item.result,
                ),
              );
            } else if (item.type == 'association_partner' &&
                item.riskName != '3个月内申请人在多个平台被放款_不包含本合作方') {
              Map partMap;
              partMap = {
                'riskName': item.riskName.substring(0, 1),
                'riskList': item.riskDetailList,
              };
              partList.add(partMap);
            } else if (item.type == 'association_partner' &&
                item.riskName == '3个月内申请人在多个平台被放款_不包含本合作方') {
              lastPartList.add({
                'riskName': item.riskName,
                'riskList': item.riskDetailList,
              });
            }
            n++;
          },
        );
        partItemView.add(
          Column(
            children: <Widget>[
              Container(
                width: Screen.width,
                height: 10,
                color: Colors.white,
              ),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Color(0xffe6e6e6),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 14,
                      height: 14,
                      child:
                          Image.asset('assets/images/manager/widcard_icon.png'),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      '申请人在多个平台申请借款',
                      style: TextStyles.text15OrangeMediumLabel,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.6,
                          color: Colours.orange_72,
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 60,
                            height: 30,
                            decoration: BoxDecoration(
                              color: selectedIndex == '7'
                                  ? Colours.orange_72
                                  : Colors.white,
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                this.setState(() {
                                  selectedIndex = '7';
                                });
                              },
                              padding: EdgeInsets.all(0),
                              minWidth: 0,
                              child: Text(
                                '七天内',
                                style: selectedIndex == '7'
                                    ? TextStyles.text13WhiteMediumLabel
                                    : TextStyles.text13BlackMediumLabel,
                              ),
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 30,
                            decoration: BoxDecoration(
                                color: selectedIndex == '1'
                                    ? Colours.orange_72
                                    : Colors.white,
                                border: Border(
                                  left: BorderSide(
                                      width: 0.6, color: Colours.orange_72),
                                  right: BorderSide(
                                      width: 0.6, color: Colours.orange_72),
                                )),
                            child: MaterialButton(
                              onPressed: () {
                                this.setState(() {
                                  selectedIndex = '1';
                                });
                              },
                              padding: EdgeInsets.all(0),
                              minWidth: 0,
                              child: Text(
                                '1个月内',
                                style: selectedIndex == '1'
                                    ? TextStyles.text13WhiteMediumLabel
                                    : TextStyles.text13BlackMediumLabel,
                              ),
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 30,
                            decoration: BoxDecoration(
                              color: selectedIndex == '3'
                                  ? Colours.orange_72
                                  : Colors.white,
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                this.setState(() {
                                  selectedIndex = '3';
                                });
                              },
                              padding: EdgeInsets.all(0),
                              minWidth: 0,
                              child: Text(
                                '3个月内',
                                style: selectedIndex == '3'
                                    ? TextStyles.text13WhiteMediumLabel
                                    : TextStyles.text13BlackMediumLabel,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );

        int partListForOne =
            partList.where((model) => model['riskName'] == '1').toList().length;
        int partListForSeven =
            partList.where((model) => model['riskName'] == '7').toList().length;
        int partListForThree =
            partList.where((model) => model['riskName'] == '3').toList().length;
        if (partListForOne == 0) {
          partList.add({
            'riskName': 1,
            'riskList': [],
          });
        }
        if (partListForSeven == 0) {
          partList.add({
            'riskName': 7,
            'riskList': [],
          });
        }
        if (partListForThree == 0) {
          partList.add({
            'riskName': 3,
            'riskList': [],
          });
        }
        partItemView.add(AssociationPartner(
          selectedIndex: selectedIndex,
          partList: partList,
        ));
        partListView = Column(children: partItemView);
        ristItemView.add(partListView);

        if (lastPartList.length != 0) {
          ristItemView.add(LastAssociationPartner(lastPartList: lastPartList));
        }

        ristListView = Column(children: ristItemView);
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: ristListView,
          // child: Text('12312312'),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PartOne extends StatelessWidget {
  final num score;
  var idCard;
  var phone;
  PartOne({
    Key key,
    this.idCard,
    this.phone,
    @required this.score,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                '风险系数',
                style: TextStyles.text16BlackMediumLabel,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '$score',
                style: TextStyle(
                  color: Color(0xffff0000),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '身份证号码',
                style: TextStyles.text13BlackMediumLabel,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '$idCard',
                style: TextStyles.text13BlackMediumLabel,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '手机号码',
                style: TextStyles.text13BlackMediumLabel,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '$phone',
                style: TextStyles.text13BlackMediumLabel,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GreyList extends StatelessWidget {
  final List greyList;
  int n;
  String riskName;
  List<TableRow> _tableWidget = [];
  GreyList({
    Key key,
    @required this.greyList,
    @required this.riskName,
    @required this.n,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Color(0xffe6e6e6),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 14,
                height: 14,
                child: n == 1
                    ? Image.asset('assets/images/manager/wprohibit_icon.png')
                    : Image.asset('assets/images/manager/wphone_icon.png'),
              ),
              SizedBox(
                width: 7,
              ),
              Text(
                '$riskName',
                style: TextStyles.text15OrangeMediumLabel,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
          child: Column(
            children: <Widget>[
              Container(
                child: Table(
                    columnWidths: const {
                      //列宽
                      0: FixedColumnWidth(100.0),
                      1: FixedColumnWidth(100.0),
                    },
                    border: TableBorder.all(
                      color: Colours.orange_72,
                      width: 0.6,
                      style: BorderStyle.solid,
                    ),
                    children: tabItem()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<TableRow> tabItem() {
    _tableWidget.add(
      TableRow(
        children: [
          SizedBox(
            height: 41,
            child: Center(
              child: Text(
                '风险类型',
                style: TextStyles.text14BlackMediumLabel,
              ),
            ),
          ),
          SizedBox(
            height: 41,
            child: Center(
              child: Text(
                '风险级别',
                style: TextStyles.text13BlackMediumLabel,
              ),
            ),
          ),
          SizedBox(
            height: 41,
            child: Center(
              child: Text(
                '证据时间',
                style: TextStyles.text14BlackMediumLabel,
              ),
            ),
          ),
        ],
      ),
    );
    greyList.forEach((item) => {
          _tableWidget.add(
            TableRow(
              children: [
                SizedBox(
                  height: 41,
                  child: Center(
                    child: Text(
                      '${item.fraudType}',
                      style: TextStyles.text14BlackMediumLabel,
                    ),
                  ),
                ),
                SizedBox(
                  height: 41,
                  child: Center(
                    child: Text(
                      '${item.riskLevel}',
                      style: TextStyles.text13BlackMediumLabel,
                    ),
                  ),
                ),
                SizedBox(
                  height: 41,
                  child: Center(
                    child: Text(
                      '${DateTime.fromMicrosecondsSinceEpoch(item.evidenceTime * 1000).toString().substring(0, 19)}',
                      style: TextStyles.text14BlackMediumLabel,
                    ),
                  ),
                ),
              ],
            ),
          )
        });
    return _tableWidget;
  }
}

class FrequencyDistinct extends StatelessWidget {
  final List frequencyList;
  final String riskName;

  FrequencyDistinct(
      {Key key, @required this.frequencyList, @required this.riskName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return showDistinct();
  }

  Widget showDistinct() {
    Widget distinctContainer;
    List<Widget> distinctItem = [];
    distinctItem.add(
      Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Color(0xffe6e6e6),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 14,
              height: 14,
              child: Image.asset('assets/images/manager/widcard_icon.png'),
            ),
            SizedBox(
              width: 7,
            ),
            Text(
              '$riskName',
              style: TextStyles.text15OrangeMediumLabel,
            ),
          ],
        ),
      ),
    );
    frequencyList.forEach(
      (item) => {
        distinctItem.add(
          Container(
            margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.6,
                color: Colours.orange_72,
              ),
            ),
            child: showAddress(item),
          ),
        ),
      },
    );
    distinctContainer = Column(children: distinctItem);
    return distinctContainer;
  }

  Widget showAddress(FrequencyDistinctDetailsModel data) {
    Widget addressContainer;
    List<Widget> addressItem = [];
    int i = 1;
    addressItem.add(
      Container(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 9,
          bottom: 7,
        ),
        decoration: BoxDecoration(
          color: Colours.orange_72,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${data.description}',
              style: TextStyles.text14WhiteMediumLabel,
            ),
            Text(
              '${data.result}',
              style: TextStyles.text14WhiteMediumLabel,
            ),
          ],
        ),
      ),
    );
    data.data.forEach(
      (model) {
        addressItem.add(
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 12,
              bottom: 12,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: i == data.data.length
                    ? BorderSide.none
                    : BorderSide(
                        width: 0.6,
                        color: Colours.orange_72,
                      ),
              ),
            ),
            child: Text(
              '${data.description == '3个月身份证关联家庭地址数' ? '地址' : data.description == '3个月身份证关联手机号数' ? '手机号' : '身份证号码'}$i：$model',
              style: TextStyles.text14BlackMediumLabel,
            ),
          ),
        );
        i++;
      },
    );

    addressContainer = Column(
      children: addressItem,
    );

    return addressContainer;
  }
}

class FrequencyOneDim extends StatelessWidget {
  String riskName;
  num result;
  FrequencyOneDim({
    Key key,
    @required this.riskName,
    @required this.result,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      decoration: BoxDecoration(
        color: Color(0xffe6e6e6),
      ),
      child: Container(
        padding: EdgeInsets.only(
          top: 14,
          bottom: 13,
          right: 5,
          left: 2,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.6,
              color: Colours.white_color,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 14,
                  height: 14,
                  child: Image.asset('assets/images/manager/wnail_icon.png'),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '$riskName',
                  style: TextStyles.text13OrangeMediumLabel,
                ),
              ],
            ),
            Text(
              '$result次',
              style: TextStyles.text13BlackMediumLabel,
            ),
          ],
        ),
      ),
    );
  }
}

class AssociationPartner extends StatefulWidget {
  final List partList;
  final String selectedIndex;
  AssociationPartner(
      {Key key, @required this.partList, @required this.selectedIndex})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _AssociationPartner();
}

class _AssociationPartner extends State<AssociationPartner> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 10),
          child: tableView(),
        ),
      ],
    );
  }

  Widget tableView() {
    List<Widget> tableList = [];
    Widget tableView;

    widget.partList.forEach(
      (item) {
        tableList.add(
          Offstage(
            offstage: item['riskName'] != widget.selectedIndex,
            child: Container(
              child: Table(
                columnWidths: const {
                  //列宽
                  0: FixedColumnWidth(160.0),
                  // 1: FixedColumnWidth(1.0),
                },
                border: TableBorder.all(
                  color: Colours.orange_72,
                  // color: Colors.white,
                  width: 0.6,
                  style: BorderStyle.solid,
                ),
                children: tabRowView(item['riskList']),
              ),
            ),
          ),
        );
      },
    );
    tableView = Column(
      children: tableList,
    );
    return tableView;
  }

  List<TableRow> tabRowView(List riskList) {
    List<TableRow> tabRowList = [];
    tabRowList.add(
      TableRow(
        decoration: BoxDecoration(
          color: Colours.orange_72,
        ),
        children: [
          SizedBox(
            height: 45,
            child: Center(
              child: Text(
                '行业类型',
                style: TextStyles.text14WhiteMediumLabel,
              ),
            ),
          ),
          SizedBox(
            height: 45,
            child: Center(
              child: Text(
                '命中该行业类型的数量',
                style: TextStyles.text14WhiteMediumLabel,
              ),
            ),
          ),
        ],
      ),
    );
    riskList.forEach(
      (item) {
        tabRowList.add(
          TableRow(
            children: [
              SizedBox(
                height: 45,
                child: Center(
                  child: Text(
                    '${item.industryDisplayName}',
                    style: TextStyles.text14BlackMediumLabel,
                  ),
                ),
              ),
              SizedBox(
                height: 45,
                child: Center(
                  child: Text(
                    '${item.count}',
                    style: TextStyles.text14BlackMediumLabel,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    return tabRowList;
  }
}

class LastAssociationPartner extends StatelessWidget {
  final List lastPartList;
  List<TableRow> tableRowlist = [];
  LastAssociationPartner({Key key, @required this.lastPartList})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Color(0xffe6e6e6),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 14,
                height: 14,
                child: Image.asset('assets/images/manager/widcard_icon.png'),
              ),
              SizedBox(
                width: 7,
              ),
              Text(
                '${lastPartList[0]['riskName']}',
                style: TextStyles.text15OrangeMediumLabel,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                child: Table(
                  columnWidths: const {
                    //列宽
                    0: FixedColumnWidth(160.0),
                  },
                  border: TableBorder.all(
                    color: Colours.orange_72,
                    width: 0.6,
                    style: BorderStyle.solid,
                  ),
                  children: tableRowView(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                '结果：建议拒绝',
                style: TextStyles.text15OrangeMediumLabel,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<TableRow> tableRowView() {
    tableRowlist.add(
      TableRow(
        decoration: BoxDecoration(
          color: Colours.orange_72,
        ),
        children: [
          SizedBox(
            height: 45,
            child: Center(
              child: Text(
                '行业类型',
                style: TextStyles.text14WhiteMediumLabel,
              ),
            ),
          ),
          SizedBox(
            height: 45,
            child: Center(
              child: Text(
                '命中该行业类型的数量',
                style: TextStyles.text14WhiteMediumLabel,
              ),
            ),
          ),
        ],
      ),
    );
    lastPartList[0]['riskList'].forEach(
      (item) {
        tableRowlist.add(
          TableRow(
            children: [
              SizedBox(
                height: 45,
                child: Center(
                  child: Text(
                    '${item.industryDisplayName}',
                    style: TextStyles.text14BlackMediumLabel,
                  ),
                ),
              ),
              SizedBox(
                height: 45,
                child: Center(
                  child: Text(
                    '${item.count}',
                    style: TextStyles.text14BlackMediumLabel,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    return tableRowlist;
  }
}
