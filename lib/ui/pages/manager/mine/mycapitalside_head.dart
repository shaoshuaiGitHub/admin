import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import 'mine_index.dart';

class MycapitalSidelHead extends StatefulWidget {
  var uid;
  MycapitalSidelHead({Key key, this.uid}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MycapitalSidelHead();
  }
}

class _MycapitalSidelHead extends State<MycapitalSidelHead> {
  bool isFirst = true;
  CapitalSideListBloc capitalSideListBloc = CapitalSideListBloc();
  @override
  void initState() {
    super.initState();
    Future.delayed(new Duration(milliseconds: 100)).then(
      (_) {
        capitalSideListBloc.getMyCapitalListDetail(widget.uid);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // CapitalSideListBloc capitalSideListBloc =
    //     BlocProvider.of<CapitalSideListBloc>(context);
    capitalSideListBloc.bloccontext = context;

    // if(isFirst){
    //     Future.delayed(new Duration(milliseconds: 100)).then((_) {
    //   capitalSideListBloc.getMyCapitalListDetail(widget.uid);
    // });
    //   isFirst = false;
    // }
    return StreamBuilder(
        stream: capitalSideListBloc.mycapitalSideListDetailStream,
        builder: (BuildContext context,
            AsyncSnapshot<CapitalSideListDetailModel> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          var name = snapshot.data.name;
          var isCertification = snapshot.data.isCertification;
          var account = snapshot.data.account;
          var sex = snapshot.data.sex;
          var workAge = snapshot.data.workAge;
          var area = snapshot.data.area;
          var money = snapshot.data.money;
          var age = snapshot.data.age;
          var isApplyed = snapshot.data.isApplyed;
          var icon = snapshot.data.icon;
          List<CapitalSideListDetailItemModel> posInfoList =
              snapshot.data.posInfoList.cast<CapitalSideListDetailItemModel>();

          return Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 80),
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 170,
                      color: Colours.orange_72,
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 15),
                            Container(
                              width: 68,
                              height: 68,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: FadeInImage.assetNetwork(
                                  placeholder:
                                      "assets/images/user/head_default.jpeg",
                                  image: icon,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 60),
                                Text('$name',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xffffffff))),
                                SizedBox(width: 5),
                                Container(
                                  width: 56,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(10, 0, 0, 0),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                      child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Icon(
                                          Icons.person,
                                          size: 15,
                                          color: Color.fromARGB(
                                              150, 255, 255, 255),
                                        ),
                                      ),
                                      Text('$isCertification',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Color(0xffffffff))),
                                    ],
                                  )),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Text('$account',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xffffffff))),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 44,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: 14,
                                height: 12,
                                margin: EdgeInsets.only(right: 5),
                                child: Image.asset(
                                    ImgPrefix.manager_prefix + 'sex_icon.png'),
                              ),
                              Text(
                                '性别：$sex',
                                style: TextStyle(
                                    fontSize: 12, color: Colours.gray_66),
                              ),
                            ],
                          ),
                          Container(
                            height: 10,
                            width: 1,
                            color: Colours.gray_cc,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 12,
                                height: 12,
                                margin: EdgeInsets.only(right: 5),
                                child: Image.asset(
                                    ImgPrefix.manager_prefix + 'age_icon.png'),
                              ),
                              Text(
                                '年龄：$age',
                                style: TextStyle(
                                    fontSize: 12, color: Colours.gray_66),
                              ),
                            ],
                          ),
                          Container(
                            height: 10,
                            width: 1,
                            color: Colours.gray_cc,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 12,
                                height: 12,
                                margin: EdgeInsets.only(right: 5),
                                child: Image.asset(ImgPrefix.manager_prefix +
                                    'years_icon.png'),
                              ),
                              Text(
                                '工龄：$workAge 天',
                                style: TextStyle(
                                    fontSize: 12, color: Colours.gray_66),
                              ),
                            ],
                          ),
                          Container(
                            height: 10,
                            width: 1,
                            color: Colours.gray_cc,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 10,
                                height: 12,
                                margin: EdgeInsets.only(right: 5),
                                child: Image.asset(
                                    ImgPrefix.manager_prefix + 'addr_icon.png'),
                              ),
                              Text(
                                '所在地:$area',
                                style: TextStyle(
                                    fontSize: 12, color: Colours.gray_66),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 50,
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('他的余额',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff212121))),
                                Text('$money',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff212121))),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 20),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colours.bottom_line))),
                                  child: Row(
                                    children: <Widget>[
                                      Text('他的POS机',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff212121))),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: posInfoList.map((item) {
                                    return Container(
                                      height: 50,
                                      alignment: Alignment.center,
                                      padding:
                                          EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colours.bottom_line))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text('${item.name}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xff666666))),
                                          Text('利率：${item.rate}%',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xff212121))),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 50,
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                margin: EdgeInsets.only(top: 10),
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('历史往来',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xff212121))),
                                    Container(
                                      height: 10,
                                      width: 6,
                                      child: Image.asset(
                                          'assets/images/user/arrowmore_small.png'),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            HistoryPage()));
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                child: Offstage(
                  offstage: isApplyed == 1,
                  child: Container(
                    margin: EdgeInsets.only(right: 20, left: 20),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 114, 0),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '解除关系',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                      onPressed: () {
                        capitalSideListBloc.unApplyInvestor(widget.uid);
                      },
                    ),
                  ),
                ),
                bottom: 20,
                right: 0,
                left: 0,
              ),
            ],
          );
        });
  }
}
