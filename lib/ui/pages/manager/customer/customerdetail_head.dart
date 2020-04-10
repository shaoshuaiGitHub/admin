import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';

class CustomerDetailHead extends StatefulWidget {
  CustomerDetailHead({
    Key key,
    this.uid,
    this.isdelete,
    // this.name,
    // this.delegateCardCount,
    // this.totalUsableMoney,
    // this.totalAccLimit
  }) : super(key: key);
  final num uid;
  final bool isdelete;
  // var name;
  // var delegateCardCount;
  // var totalUsableMoney;
  // var totalAccLimit;

  @override
  State<StatefulWidget> createState() {
    return _CustomerDetailHead();
  }
}

class _CustomerDetailHead extends State<CustomerDetailHead> {
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    CustomerDetailBloc customerDetailBloc = CustomerDetailBloc();
    if (widget.isdelete) {
      Future.delayed(new Duration(milliseconds: 500)).then((_) {
        customerDetailBloc.getCustomerDetail(widget.uid, false);
      });
    }

    return StreamBuilder<CustomerDetailModel>(
        stream: customerDetailBloc.customerStream,
        builder: (BuildContext context,
            AsyncSnapshot<CustomerDetailModel> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          var name = snapshot.data.name;
          var icon = snapshot.data.icon;
          num delegateCardCount = snapshot.data.delegateCardCount;
          num totalAccLimit = snapshot.data.totalAccLimit;
          num totalUsableMoney = snapshot.data.totalUsableMoney;

          return MaterialButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => EscrowInformationPage(
                          uid: widget.uid,
                          name: name,
                          delegateCardCount: delegateCardCount,
                          totalAccLimit: totalAccLimit,
                          icon: icon)));
            },
            child: Container(
                height: 100,
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 60,
                              height: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: FadeInImage.assetNetwork(
                                  placeholder:
                                      "assets/images/user/head_default.jpeg",
                                  image: icon != null ? icon : '',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  '${name != null ? name : ''}',
                                  style: TextStyle(
                                      color: Colours.gray_21, fontSize: 16),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '代管卡片：${delegateCardCount != null ? delegateCardCount : ''}',
                                  style: TextStyle(
                                      color: Colours.gray_21, fontSize: 14),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '代管信息',
                            style: TextStyle(
                                color: Colours.orange_72, fontSize: 14),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            '信用额度：${totalAccLimit != null ? totalAccLimit.toStringAsFixed(2) : ''}',
                            style:
                                TextStyle(color: Colours.gray_21, fontSize: 14),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            '可用额度：${totalUsableMoney != null ? totalUsableMoney.toStringAsFixed(2) : ''}',
                            style:
                                TextStyle(color: Colours.gray_21, fontSize: 14),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          );
        });
  }
}
