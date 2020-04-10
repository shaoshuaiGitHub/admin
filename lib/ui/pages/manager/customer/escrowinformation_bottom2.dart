import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';

//审核信息
class ExamineContent extends StatefulWidget {
  ExamineContent({Key key, this.orderId, this.delegateDetailBloc})
      : super(key: key);
  int orderId;
  final DelegateDetailBloc delegateDetailBloc;
  @override
  State<StatefulWidget> createState() => _ExamineContent();
}

class _ExamineContent extends State<ExamineContent>
    with AutomaticKeepAliveClientMixin {
  // DelegateDetailBloc delegateDetailBloc = DelegateDetailBloc();

  void initState() {
    super.initState();
    Future.delayed(new Duration(milliseconds: 500)).then((_) {
      if (widget.orderId != null) {
        widget.delegateDetailBloc.getOrderDetail(widget.orderId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // DelegateDetailBloc delegateDetailBloc =
    //     BlocProvider.of<DelegateDetailBloc>(context);
    widget.delegateDetailBloc.bloccontext = context;

    return StreamBuilder<OrderDetailModel>(
        stream: widget.delegateDetailBloc.orderdetailStream,
        builder:
            (BuildContext context, AsyncSnapshot<OrderDetailModel> snapshot) {
          List<Widget> orderContainer = [];
          Widget content;

          if (!snapshot.hasData) {
            return Container();
          }

          var name = snapshot.data.name;
          int uid = snapshot.data.uid;
          var icon = snapshot.data.icon;
          var phone = snapshot.data.phone;
          var idCardNO = snapshot.data.idCardNO;
          var creditScore = snapshot.data.creditScore;
          var platformStatus = snapshot.data.platformStatus;
          var idCardImagesA = snapshot.data.idCardImagesA;
          var idCardImagesB = snapshot.data.idCardImagesB;
          var delegateType = snapshot.data.delegateType;
          var delegateMoney = snapshot.data.delegateMoney;
          var accLimitMoney = snapshot.data.accLimitMoney;
          var reportImage = snapshot.data.reportImage;
          var applyMsg = snapshot.data.applyMsg;
          var updateTime = snapshot.data.updateTime;
          return Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                Container(
                    height: 260,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(5)),
                    ),
                    margin: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 30,
                                  child: Row(
                                    children: <Widget>[
                                      Text('日期：',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colours.gray_99,
                                          )),
                                      Text('$updateTime',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colours.gray_99,
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(right: 10),
                                        width: 40,
                                        height: 40,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                "assets/images/user/card_default.jpeg",
                                            image: icon,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Text('$name',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colours.gray_21,
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(
                              width: 60,
                              height: 60,
                              margin: EdgeInsets.only(right: 30, top: 10),
                              child:
                                  // Image.network(icon),
                                  Image.asset(ImgPrefix.manager_prefix +
                                      'pass_icon.png'),
                            ),
                            //  child: widget.applyStatus == '待审核'
                            //       ? Image.asset(ImgPrefix.manager_prefix +
                            //           'toaudited_icon.png')
                            //       : widget.applyStatus == '已通过'
                            //           ? Image.asset(ImgPrefix.manager_prefix +
                            //               'pass_icon.png')
                            //           : widget.applyStatus == '已拒绝'
                            //               ? Image.asset(
                            //                   ImgPrefix.manager_prefix +
                            //                       'refuse_icon.png')
                            //               : Image.asset(
                            //                   ImgPrefix.manager_prefix +
                            //                       'toaudited_icon.png'),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('UID',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colours.gray_21,
                                  )),
                              Text('$uid',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colours.gray_21,
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('手机号码',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colours.gray_21,
                                  )),
                              Text('$phone',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colours.gray_21,
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('身份证号码',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colours.gray_21,
                                  )),
                              Text('$idCardNO',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colours.gray_21,
                                  )),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                width: 181,
                                height: 66,
                                color: Colours.gray_e6,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      width: 84,
                                      height: 60,
                                      color: Colors.white,
                                      child: FlatButton(
                                        onPressed: () {},
                                        padding: EdgeInsets.all(0),
                                        child: FadeInImage.assetNetwork(
                                          placeholder:
                                              "assets/images/user/card_default.jpeg",
                                          image: idCardImagesA,
                                          fit: BoxFit.cover,
                                        ),
                                        // child: Image.network('$idCardImagesA')//正式打开
                                      ),
                                    ),
                                    Container(
                                      width: 84,
                                      height: 60,
                                      color: Colors.white,
                                      child: FlatButton(
                                        onPressed: () {},
                                        padding: EdgeInsets.all(0),
                                        child: FadeInImage.assetNetwork(
                                          placeholder:
                                              "assets/images/user/card_default.jpeg",
                                          image: idCardImagesB,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      // child: Image.network('$idCardImagesB')//正式打开
                                    ),
                                  ],
                                ))
                          ],
                        )
                      ],
                    )),
                Container(
                  height: 60,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(5)),
                  ),
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('风险系数',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colours.gray_21,
                                  )),
                              SizedBox(
                                width: 40,
                              ),
                              Text('$creditScore',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                  )),
                            ],
                          ),
                          GestureDetector(
                            child: Text('查看风控审核',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                )),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          WindControlAuditPage()));
                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('平台审核状态',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colours.gray_21,
                              )),
                          Text('$platformStatus',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colours.gray_21,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  height: 306,
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: 4,
                            height: 20,
                            color: Colours.orange_72,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('其他资料',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colours.gray_21,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Text('图片资料',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colours.gray_21,
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 84,
                            height: 62,
                           decoration: BoxDecoration(
                              border: Border.all(
                                width: 2.5,
                                color: Color(0xFFE6E6E6),
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: FadeInImage.assetNetwork(
                              placeholder:
                                  "assets/images/user/image_default.jpeg",
                              image: reportImage,
                              fit: BoxFit.cover,
                            ),
                            // Image.network('$reportImage'),//正式打开
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 4,
                            height: 20,
                            color: Colours.orange_72,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('通过理由',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colours.gray_21,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Text('$applyMsg',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colours.gray_21,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
