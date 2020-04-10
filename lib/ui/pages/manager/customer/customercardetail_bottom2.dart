import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import 'package:youxinbao/blocs/bloc_index.dart';

//账单

class Bill extends StatefulWidget {
  Bill({Key key, this.cardId}) : super(key: key);
  final int cardId;
  @override
  State<Bill> createState() => _Bill();
}

class _Bill extends State<Bill> with AutomaticKeepAliveClientMixin {
  List<int> billVisibles = [];
  int billVisible = 0;
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    CustomerDetailBloc customerDetailBloc = CustomerDetailBloc();
    customerDetailBloc.bloccontext = context;
    //请求数据
    if (isFirst) {
      Future.delayed(new Duration(milliseconds: 100)).then((_) {
        customerDetailBloc.getCustomerBill(widget.cardId);
      });
      isFirst = false;
    }

    return Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 70, top: 0),
        child: Column(children: <Widget>[
          StreamBuilder(
              stream: customerDetailBloc.billListStream,
              builder: (BuildContext context,
                  AsyncSnapshot<BillListModel> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                List<BillItemModel> billList =
                    snapshot.data.billList.cast<BillItemModel>();
                List billItems = [
                  // ['待出', '0.00', '0', '2019/03/17-2019/4/18'],
                ];
                for (var item in billList) {
                  var mon = item.mon.toString().length == 0
                      ? '待出'
                      : item.mon.toString() + '月';
                  List myItem = [
                    mon,
                    item.billMoney,
                    item.count,
                    item.billDate.toString()
                  ];
                  billItems.add(myItem);
                }
                List needBillList = [];
                for (var item in billList) {
                  Map myneedBillList = {
                    'billMoney': item.billMoney,
                    'minRepayMoney': item.minRepayMoney,
                    'remainderRepay': item.remainderRepay,
                    'remainderMinRepay': item.remainderMinRepay,
                    'count': item.count,
                    'detail': item.detail
                        .cast<BillItemDetailModel>()
                        .toList(), //.cast<BillItemDetailModel>()
                  };
                  needBillList.add(myneedBillList);
                }
                if (billVisibles.length < billList.length)
                  for (int i = 0; i < billList.length; i++) {
                    billVisibles.add(0);
                  }
                return ListView.builder(
                    shrinkWrap: true,
                    physics: new BouncingScrollPhysics(),
                    itemCount: billItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 11,
                                      height: 11,
                                      decoration: BoxDecoration(
                                          color: billVisibles[index] == 1
                                              ? Colours.orange_72
                                              : Colours.gray_99,
                                          borderRadius:
                                              BorderRadius.circular(90)),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${billItems[index][0]}账单',
                                      style: TextStyle(
                                          fontSize: 16, color: Colours.gray_21),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                        color: Colours.gray_cc,
                                        onPressed: () {
                                          _Bill();
                                          // billVisibles[index]==0?_controller.forward():_controller.reverse();
                                          billVisible =
                                              billVisibles[index] == 1 ? 0 : 1;
                                          setState(() {
                                            billVisibles[index] = billVisible;
                                          });
                                        },
                                        icon: Icon(
                                          billVisibles[index] == 0
                                              ? Icons.arrow_drop_down
                                              : Icons.arrow_drop_up,
                                          size: 30,
                                        ))
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    '${billItems[index][1].toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: 16, color: Colours.gray_21),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    '${billItems[index][2]}笔',
                                    style: TextStyle(
                                        fontSize: 16, color: Colours.gray_21),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 1,
                                      height: 42,
                                      color: Colours.gray_cc,
                                      margin:
                                          EdgeInsets.only(left: 6, right: 10),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 6),
                                      child: Text(
                                        billItems[index][3],
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colours.gray_99),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 6),
                                child: Text(
                                  '本期消费金额',
                                  style: TextStyle(
                                      fontSize: 12, color: Colours.gray_99),
                                ),
                              ),
                            ],
                          ),
                          BillContent(
                            billVisible: billVisibles[index],
                            needBillList: needBillList[index],
                          )
                        ],
                      );
                    });
              }),
        ]));
  }

  @override
  bool get wantKeepAlive => true;
}

class BillContent extends StatelessWidget {
  final int billVisible;
  final needBillList;
  // final detail = needBillList['detail'];
  const BillContent({Key key, this.billVisible, this.needBillList})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<BillItemDetailModel> detail = needBillList['detail'];
    return Offstage(
      offstage: billVisible == 0 ? true : false,
      child: Container(
        margin: EdgeInsets.only(left: 6, right: 6),
        decoration: BoxDecoration(
            border: Border(
          left: BorderSide(
            width: 1,
            color: Colours.gray_cc,
          ),
        )),
        padding: EdgeInsets.only(left: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              needBillList['minRepayMoney'].toString().length != 0
                  ? Container(
                      padding: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                          color: Colours.gray_e6,
                        )),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '账单总额',
                                      style: TextStyle(
                                          fontSize: 13, color: Colours.gray_99),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '最低还款额',
                                      style: TextStyle(
                                          fontSize: 13, color: Colours.gray_99),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '剩余应还',
                                      style: TextStyle(
                                          fontSize: 13, color: Colours.gray_99),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '剩余最低应还',
                                      style: TextStyle(
                                          fontSize: 13, color: Colours.gray_99),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      '￥${needBillList['billMoney']}',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xff282828)),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '￥${needBillList['minRepayMoney']}',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xff282828)),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '￥${needBillList['remainderRepay']}',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xff282828)),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '￥${needBillList['remainderMinRepay']}',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xff282828)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${needBillList['count']}笔',
                            style: TextStyle(
                                fontSize: 13, color: Color(0xff282828)),
                          ),
                        ],
                      ))
                  : Container(),
              //  needBillList['minRepayMoney'].toString().length!=0? Container(
              //     height: 1,
              //     color: Colours.gray_e6,
              //     margin: EdgeInsets.only(top: 10, bottom: 10),
              //   ):Container(),

              Column(
                children: detail.map((item) {
                  return Container(
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                        color: Colours.gray_e6,
                      )),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${item.title}',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xff282828)),
                            ),
                            Text(
                              '${item.date}来自${item.from}',
                              style: TextStyle(
                                  fontSize: 13, color: Colours.gray_99),
                            ),
                          ],
                        ),
                        Text(
                          '${item.money}',
                          style:
                              TextStyle(fontSize: 12, color: Colours.orange_72),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        //  child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: <Widget>[
        //       Container(
        //         width: 1,
        //         color: Colours.gray_cc,
        //         margin: EdgeInsets.only(left: 6, right: 1),
        //       ),
        //       Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: <Widget>[
        //           Container(
        //             width: 345,
        //             padding: EdgeInsets.all(8),
        //             margin: EdgeInsets.only(left: 5, right: 20),
        //             decoration: BoxDecoration(
        //                 color: Colors.white,
        //                 borderRadius: BorderRadius.circular(5)),
        //             child: Column(
        //               children: <Widget>[
        //                 needBillList['minRepayMoney'].toString().length != 0
        //                     ? Container(
        //                         padding: EdgeInsets.only(bottom: 10),
        //                         decoration: BoxDecoration(
        //                           border: Border(
        //                               bottom: BorderSide(
        //                             color: Colours.gray_e6,
        //                           )),
        //                         ),
        //                         child: Row(
        //                           mainAxisAlignment:
        //                               MainAxisAlignment.start,
        //                           crossAxisAlignment:
        //                               CrossAxisAlignment.start,
        //                           children: <Widget>[
        //                             Expanded(
        //                               child: Row(
        //                                 children: <Widget>[
        //                                   Column(
        //                                     crossAxisAlignment:
        //                                         CrossAxisAlignment.start,
        //                                     children: <Widget>[
        //                                       Text(
        //                                         '账单总额',
        //                                         style: TextStyle(
        //                                             fontSize: 13,
        //                                             color: Colours.gray_99),
        //                                       ),
        //                                       SizedBox(
        //                                         height: 5,
        //                                       ),
        //                                       Text(
        //                                         '最低还款额',
        //                                         style: TextStyle(
        //                                             fontSize: 13,
        //                                             color: Colours.gray_99),
        //                                       ),
        //                                       SizedBox(
        //                                         height: 5,
        //                                       ),
        //                                       Text(
        //                                         '剩余应还',
        //                                         style: TextStyle(
        //                                             fontSize: 13,
        //                                             color: Colours.gray_99),
        //                                       ),
        //                                       SizedBox(
        //                                         height: 5,
        //                                       ),
        //                                       Text(
        //                                         '剩余最低应还',
        //                                         style: TextStyle(
        //                                             fontSize: 13,
        //                                             color: Colours.gray_99),
        //                                       ),
        //                                     ],
        //                                   ),
        //                                   SizedBox(
        //                                     width: 50,
        //                                   ),
        //                                   Column(
        //                                     children: <Widget>[
        //                                       Text(
        //                                         '￥${needBillList['billMoney']}',
        //                                         style: TextStyle(
        //                                             fontSize: 13,
        //                                             color:
        //                                                 Color(0xff282828)),
        //                                       ),
        //                                       SizedBox(
        //                                         height: 5,
        //                                       ),
        //                                       Text(
        //                                         '￥${needBillList['minRepayMoney']}',
        //                                         style: TextStyle(
        //                                             fontSize: 13,
        //                                             color:
        //                                                 Color(0xff282828)),
        //                                       ),
        //                                       SizedBox(
        //                                         height: 5,
        //                                       ),
        //                                       Text(
        //                                         '￥${needBillList['remainderRepay']}',
        //                                         style: TextStyle(
        //                                             fontSize: 13,
        //                                             color:
        //                                                 Color(0xff282828)),
        //                                       ),
        //                                       SizedBox(
        //                                         height: 5,
        //                                       ),
        //                                       Text(
        //                                         '￥${needBillList['remainderMinRepay']}',
        //                                         style: TextStyle(
        //                                             fontSize: 13,
        //                                             color:
        //                                                 Color(0xff282828)),
        //                                       ),
        //                                     ],
        //                                   ),
        //                                 ],
        //                               ),
        //                             ),
        //                             Text(
        //                               '${needBillList['count']}笔',
        //                               style: TextStyle(
        //                                   fontSize: 13,
        //                                   color: Color(0xff282828)),
        //                             ),
        //                           ],
        //                         ))
        //                     : Container(),
        //                 //  needBillList['minRepayMoney'].toString().length!=0? Container(
        //                 //     height: 1,
        //                 //     color: Colours.gray_e6,
        //                 //     margin: EdgeInsets.only(top: 10, bottom: 10),
        //                 //   ):Container(),

        //                 Column(
        //                   children: detail.map((item) {
        //                     return Container(
        //                       padding: EdgeInsets.only(bottom: 10),
        //                       decoration: BoxDecoration(
        //                         border: Border(
        //                             bottom: BorderSide(
        //                           color: Colours.gray_e6,
        //                         )),
        //                       ),
        //                       child: Row(
        //                         mainAxisAlignment:
        //                             MainAxisAlignment.spaceBetween,
        //                         children: <Widget>[
        //                           Column(
        //                             crossAxisAlignment:
        //                                 CrossAxisAlignment.start,
        //                             children: <Widget>[
        //                               Text(
        //                                 '${item.title}',
        //                                 style: TextStyle(
        //                                     fontSize: 13,
        //                                     color: Color(0xff282828)),
        //                               ),
        //                               Text(
        //                                 '${item.date}来自${item.from}',
        //                                 style: TextStyle(
        //                                     fontSize: 13,
        //                                     color: Colours.gray_99),
        //                               ),
        //                             ],
        //                           ),
        //                           Text(
        //                             '${item.money}',
        //                             style: TextStyle(
        //                                 fontSize: 12,
        //                                 color: Colours.orange_72),
        //                           ),
        //                         ],
        //                       ),
        //                     );
        //                   }).toList(),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ],
        //       )
        //     ],
        //   ),
      ),
    );
  }
}
