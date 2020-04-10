import 'package:flutter/material.dart';
import 'package:youxinbao/common/component_index.dart';
import 'mine_index.dart';

class ApplicationDetailPage extends StatelessWidget {
  ApplicationDetailPage({Key key, this.item}) : super(key: key);
  CapitalSideApplyItemListModel item;

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc applocationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    CapitalSideListBloc capitalSideListBloc = CapitalSideListBloc();
    capitalSideListBloc.bloccontext = context;
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          // backgroundColor: Color.fromARGB(255, 255, 114, 0),
          title: Text(
            '申请详情',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colours.bottom_line))),
                    child: Text(
                      '${item.updateTime}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff212121),
                      ),
                    ),
                  ),
                  Container(
                    height: 76,
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colours.bottom_line))),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 50,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  width: 50,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: FadeInImage.assetNetwork(
                                      placeholder:
                                          "assets/images/user/head_default.jpeg",
                                      image: item.icon,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text('${item.name}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xffFC8251))),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                            padding: EdgeInsets.only(
                                              left: 7,
                                              right: 8,
                                              bottom: 5,
                                              top: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    ImgPrefix.manager_prefix +
                                                        'aldtname_icon.png'),
                                              ),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 13,
                                                    color: Color.fromARGB(
                                                        150, 255, 255, 255),
                                                  ),
                                                ),
                                                Text(
                                                  '${item.isCertification}',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xfff2f2f2),
                                                  ),
                                                ),
                                              ],
                                            )),
                                        // )
                                      ],
                                    ),
                                    Container(
                                      // width: 88,
                                      height: 20,
                                      padding: EdgeInsets.only(
                                        left: 9,
                                        right: 9,
                                        bottom: 5,
                                        top: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              ImgPrefix.manager_prefix +
                                                  'aldtphone_icon.png'),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${item.account.toString().replaceRange(3, 9, "******")}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xffff7200),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Text(
                          '${item.applyStatus}',
                          style:
                              TextStyle(fontSize: 12, color: Colours.gray_66),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colours.bottom_line))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('性别',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff666666))),
                        Text('${item.sex}',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff212121))),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colours.bottom_line))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('工龄',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff666666))),
                        Text('${item.workAge}天',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff212121))),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colours.bottom_line))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('所在地',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff666666))),
                        Text('${item.area}',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff212121))),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colours.bottom_line))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('备注',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff666666))),
                        Container(
                          width: 360,
                          height: 50,
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xff666666))),
                          child: Text(
                            '${item.applyMsg}',
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            item.applyStatus == '通过' || item.applyStatus == '拒绝'
                ? Container()
                : Container(
                    margin: EdgeInsets.only(bottom: 20),
                    width: 360,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 114, 0),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: item.applyStatus == '撤销成功'
                        ? Center(
                            child: Text(
                              '撤销成功',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          )
                        : MaterialButton(
                            minWidth: 0,
                            padding: const EdgeInsets.all(0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '撤销申请',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ]),
                            onPressed: () {
                              capitalSideListBloc.removeApplyInvestor(item.id);
                            },
                          )),
          ],
        ));
  }
}
