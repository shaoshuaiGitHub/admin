import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import 'package:youxinbao/blocs/manager/mine/withdraw_bloc.dart';
import 'mineBankCard/mineBankCard_page.dart';

class MpersonalMiddle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MpersonalMiddle();
  }
}

class _MpersonalMiddle extends State<MpersonalMiddle> {
  WithdrawBloc withdrawBloc = WithdrawBloc();
  bool isLock = false;
  var name;
  var phone;
  int roleType = 2;
  int isCertification = 0;
  int workAge = 0;
  num mybalance = 0.0;
  num totalIncome = 0.0;
  num curMonthIncome = 0.0;
  num todayIncome = 0.0;
  num withdraw = 0.0;
  num unavailable = 0.0;
  @override
  Widget build(BuildContext context) {
    final ApplicationBloc applocationBloc =
        BlocProvider.of<ApplicationBloc>(context);

    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    withdrawBloc.bloccontext = context;
    userBloc.bloccontext = context;
    if (!isLock) {
      Future.delayed(new Duration(milliseconds: 100)).then((_) {
        userBloc.getUserInfo();
      });
      isLock = true;
    }
    return StreamBuilder(
        stream: userBloc.outUserInfo,
        builder: (BuildContext context, AsyncSnapshot<UserInfoModel> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          name = snapshot.data.name;
          phone = snapshot.data.phone != null
              ? snapshot.data.phone.toString().replaceRange(3, 9, "******")
              : '';
          roleType = snapshot.data.roleType;
          String icon = snapshot.data.icon;
          isCertification = snapshot.data.isCertification;
          workAge = snapshot.data.workAge;
          mybalance = snapshot.data.money.toDouble();
          totalIncome = snapshot.data.totalIncome.toDouble();
          curMonthIncome = snapshot.data.curMonthIncome.toDouble();
          todayIncome = snapshot.data.todayIncome.toDouble();
          withdraw = snapshot.data.withdraw.toDouble();
          unavailable = snapshot.data.unavailable.toDouble();

          return Column(
            children: <Widget>[
              //header
              Container(
                height: 290,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        ImgPrefix.manager_prefix + 'personal_top_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      height: 70,
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: MaterialButton(
                        padding: EdgeInsets.all(0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 70,
                                    height: 70,
                                    child: Stack(
                                      alignment: FractionalOffset(1.2, 1),
                                      children: <Widget>[
                                        Container(
                                          width: 70,
                                          height: 70,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            child: FadeInImage.assetNetwork(
                                              placeholder:
                                                  "assets/images/user/head_default.jpeg",
                                              image: icon,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 32,
                                          height: 15,
                                          child: Image.asset(
                                              ImgPrefix.manager_prefix +
                                                  'lv.png'),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '$name',
                                            style: new TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                          Container(
                                              width: 50,
                                              height: 18,
                                              margin: EdgeInsets.only(left: 5),
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 255, 191, 55),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${roleType == 1 ? '普通用户' : (roleType == 2 ? '管理师' : '资金方')}',
                                                  style: new TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                ),
                                              ))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        width: 88,
                                        height: 18,
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                30, 255, 255, 255),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '$phone',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color.fromARGB(
                                                      255, 255, 254, 254)),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 80,
                                  height: 22,
                                  padding: EdgeInsets.only(left: 24),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(30, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        '${isCertification == 1 ? '已实名' : '未实名'}',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_right,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '工齡:$workAge天',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        onPressed: () {
                          applocationBloc.personalBackType = 0;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MyInformationPage(),
                            ),
                          ).then(
                            (_) {
                              if (applocationBloc.personalBackType == 1) {
                                this.setState(() {
                                  isLock = false;
                                });
                              }
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Text(
                              '${mybalance.toStringAsFixed(2)}',
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white),
                            ),
                            Text(
                              '余额(元)',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        color: Color.fromARGB(40, 0, 0, 0),
                        child: DefaultTextStyle(
                          style: TextStyle(color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '${todayIncome.toStringAsFixed(2)}',
                                    style: TextStyles.text16WhiteMediumLabel,
                                  ),
                                  Text(
                                    '今日收入',
                                    style: TextStyles.text13WhiteMediumLabel,
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '${curMonthIncome.toStringAsFixed(2)}',
                                    style: TextStyles.text16WhiteMediumLabel,
                                  ),
                                  Text(
                                    '本月收入',
                                    style: TextStyles.text13WhiteMediumLabel,
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '${totalIncome.toStringAsFixed(2)}',
                                    style: TextStyles.text16WhiteMediumLabel,
                                  ),
                                  Text(
                                    '总收入',
                                    style: TextStyles.text13WhiteMediumLabel,
                                  )
                                ],
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              //下面的列表
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        // padding: EdgeInsets.fromLTRB(17, 0, 20, 0),
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(10, 0, 0, 0))),
                        ),
                        child: FlatButton(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 20,
                                      height: 20,
                                      child: Image.asset(
                                          ImgPrefix.manager_prefix +
                                              'cash.png'),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '可提现(元)',
                                      style: TextStyles.text16MediumLabel,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Text('${withdraw.toStringAsFixed(2)}',
                                      style: TextStyles.text16MediumLabel),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Image.asset(
                                      ImgPrefix.manager_prefix +
                                          'arrowmore_big.png',
                                      width: 7,
                                      height: 12),
                                ],
                              )
                            ],
                          ),
                          onPressed: () {
                            withdrawBloc.getWithdrawInfos();
                          },
                        )),
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 17, 0),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom:
                                BorderSide(color: Color.fromARGB(10, 0, 0, 0))),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 20,
                                  height: 20,
                                  child: Image.asset(
                                      ImgPrefix.manager_prefix + 'nocash.png'),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  '不可提现(元)',
                                  style: TextStyles.text16MediumLabel,
                                )
                              ],
                            ),
                          ),
                          Text(
                            '${unavailable.toStringAsFixed(2)}',
                            style: TextStyles.text16MediumLabel,
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom:
                                BorderSide(color: Color.fromARGB(50, 0, 0, 0))),
                      ),
                      child: FlatButton(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Container(
                                    width: 17,
                                    height: 17,
                                    child: Image.asset(
                                        ImgPrefix.manager_prefix +
                                            'detail.png'),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '明细',
                                    style: TextStyles.text16MediumLabel,
                                  )
                                ],
                              ),
                            ),
                            Image.asset(
                                ImgPrefix.manager_prefix + 'arrowmore_big.png',
                                width: 7,
                                height: 12)
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => MydetailPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom:
                                BorderSide(color: Color.fromARGB(50, 0, 0, 0))),
                      ),
                      child: MaterialButton(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    '我的资金方',
                                    style: TextStyles.text16MediumLabel,
                                  )
                                ],
                              ),
                            ),
                            Image.asset(
                                ImgPrefix.manager_prefix + 'arrowmore_big.png',
                                width: 7,
                                height: 12)
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CapitalSidePage(),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom:
                                BorderSide(color: Color.fromARGB(50, 0, 0, 0))),
                      ),
                      child: FlatButton(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    '我的银行卡',
                                    style: TextStyles.text16MediumLabel,
                                  )
                                ],
                              ),
                            ),
                            Image.asset(
                                ImgPrefix.manager_prefix + 'arrowmore_big.png',
                                width: 7,
                                height: 12)
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MineBankCard(),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
