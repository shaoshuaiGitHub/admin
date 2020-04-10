import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class NewOrdersMiddle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new NewOrdersState();
  }
}

class NewOrdersState extends State<NewOrdersMiddle> {
  NewOrdersBloc orderBloc = NewOrdersBloc();
  @override
  Widget build(BuildContext context) {
final ApplicationBloc applicationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    // OrderDetailBloc orderdetailBloc = BlocProvider.of<OrderDetailBloc>(context);
    orderBloc.bloccontext = context;

    return StreamBuilder<OrderListModel>(
      stream: orderBloc.orderlistStream,
      builder: (BuildContext context, AsyncSnapshot<OrderListModel> snapshot) {
        List<Widget> orderContainer = List<Widget>();
        Widget content;
        if (!snapshot.hasData) {
          Future.delayed(new Duration(milliseconds: 500)).then((_) {
            orderBloc.getOrderList(0);
          });
          return Container();
        }
        
        applicationBloc.backType=1;

        List mylist = snapshot.hasData ? snapshot.data.orderList : [];
          mylist.forEach((item) => orderContainer.add(Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: <Widget>[
                    FlatButton(
                      child: Container(
                        height: 110,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  '日期：${item.createTime}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colours.gray_99,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 40,
                                        height: 40,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            child: FadeInImage.assetNetwork(
                                              placeholder:
                                                  "assets/images/user/head_default.jpeg",
                                              image: item.icon,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${item.name}',
                                        style: TextStyles.text14MediumLabel,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '代管类型：${item.delegateType}',
                                            style: TextStyles.text14MediumLabel,
                                          ),
                                          Text(
                                            '代管卡片：${item.cardCount}（张）',
                                            style: TextStyles.text14MediumLabel,
                                          ),
                                          Text(
                                            '代管总额度：${item.delegateMoney.toStringAsFixed(2)}',
                                            style: TextStyles.text14MediumLabel,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${item.applyStatus}',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 13),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Image.asset(ImgPrefix.manager_prefix +
                                        'arrowmore_small.png',width: 8,height: 13),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    OrderDetailPage(id: item.id,applyStatus:item.applyStatus))).then((dynamic type) {
                    if (applicationBloc.backType == 1)
                      orderBloc.getOrderList(0);
                  });
                  applicationBloc.backType = 0;
                      },
                    ),
                  ],
                ),
              )));
        content = ListView(children: orderContainer);
        return content;
      },
    );
  }
}
