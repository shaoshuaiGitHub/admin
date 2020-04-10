import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';

class OrderDetailBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: 100,
            height: 44,
            decoration: BoxDecoration(
              color: Colours.orange_72,
              borderRadius: BorderRadius.circular(5),
            ),
            child: FlatButton(
              child: Text(
                '通过',
                style: TextStyles.text15WhiteMediumLabel,
              ),
              onPressed: () {},
            ),
          ),
          Container(
            width: 100,
            height: 44,
            decoration: BoxDecoration(
              color: Colours.orange_72,
              borderRadius: BorderRadius.circular(5),
            ),
            child: FlatButton(
              child: Text(
                '拒绝',
                style: TextStyles.text15WhiteMediumLabel,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: Container(
                          height: 230,
                          width: 343,
                          decoration: BoxDecoration(
                            color: Colours.white_color,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: Colours.orange_72,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(5)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '备注',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            decoration: TextDecoration.none),
                                      ),
                                    ],
                                  )),
                              Container(
                                  height: 91,
                                  width: 323,
                                  margin: EdgeInsets.fromLTRB(10, 20, 10, 15),
                                  decoration: BoxDecoration(
                                      color: Colours.gray_e6,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Scaffold(
                                    backgroundColor: Colours.gray_e6,
                                    body: TextField(
                                      textAlign: TextAlign.left,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                        hintText: '请输入拒绝/通过的理由',
                                        contentPadding: EdgeInsets.only(
                                            top: 6,
                                            right: 10,
                                            left: 10,
                                            bottom: 10),
                                        disabledBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                      style: TextStyle(
                                          color: Colours.gray_99, fontSize: 15),
                                    ),
                                  )),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    width: 115,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Colours.orange_72,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: FlatButton(
                                        child: Text(
                                          '确认',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
          Container(
            width: 100,
            height: 44,
            decoration: BoxDecoration(
              color: Colours.orange_72,
              borderRadius: BorderRadius.circular(5),
            ),
            child: FlatButton(
              child: Text(
                '补充资料',
                style: TextStyles.text15WhiteMediumLabel,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: Container(
                          height: 230,
                          width: 343,
                          decoration: BoxDecoration(
                            color: Colours.white_color,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: Colours.orange_72,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(5)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '补充说明',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            decoration: TextDecoration.none),
                                      ),
                                    ],
                                  )),
                              Container(
                                  height: 91,
                                  width: 323,
                                  margin: EdgeInsets.fromLTRB(10, 20, 10, 15),
                                  decoration: BoxDecoration(
                                      color: Colours.gray_e6,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Scaffold(
                                    backgroundColor: Colours.gray_e6,
                                    body: TextField(
                                      textAlign: TextAlign.left,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                        hintText: '信用卡有贷款和分期/请补充资料',
                                        contentPadding: EdgeInsets.only(
                                            top: 6,
                                            right: 10,
                                            left: 10,
                                            bottom: 10),
                                        disabledBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                      style: TextStyle(
                                          color: Colours.gray_99, fontSize: 15),
                                    ),
                                  )),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    width: 115,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Colours.orange_72,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: FlatButton(
                                        child: Text(
                                          '确认',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          )
        ],
      ),
    );
  }
}
