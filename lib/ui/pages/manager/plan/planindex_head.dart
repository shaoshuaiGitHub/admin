import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';

class PlanIndexHead extends StatefulWidget {
  List<RecentUserItemModel> recentUserList;
  PlanIndexHead({this.recentUserList});
  @override
  State<StatefulWidget> createState() {
    return _PlanIndexHead();
  }
}

class _PlanIndexHead extends State<PlanIndexHead> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 175,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImgPrefix.manager_prefix + 'plan_top_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 4,
                    height: 20,
                    color: Colours.white_color,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('近期用户',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colours.white_color,
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(children: [
                widget.recentUserList.length >= 3
                    ? CarouselSlider(
                        items: widget.recentUserList.map((item) {
                          return Container(
                            margin: EdgeInsets.all(5.0),
                            child: GestureDetector(
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                child: Stack(children: <Widget>[
                                  Container(
                                    width: 64,
                                    height: 64,
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
                                  Positioned(
                                    bottom: 0.0,
                                    left: 4.0,
                                    right: 0.0,
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          '${item.name}',
                                          style: TextStyle(
                                            color: Colours.gray_21,
                                            fontSize: 15.0,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        CustomerDetailPage(
                                      uid: item.uUID,
                                    ),
                                  ),
                                ).then((_) {
                                  eventBuses.fire(GetOpen(true));
                                });
                                eventBuses.fire(GetOpen(false));
                                eventBuses.fire(BackControl(true));
                              },
                            ),
                          );
                        }).toList(),
                        autoPlay: false,
                        enlargeCenterPage: true,
                        viewportFraction: 0.3,
                        aspectRatio: 3.2,
                        onPageChanged: (index) {
                          setState(() {
                            _current = index;
                          });
                        },
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: widget.recentUserList.map((item) {
                          return Container(
                            width: 64,
                            // margin: EdgeInsets.only(right: 5),
                            child: GestureDetector(
                              child: Stack(
                                  alignment: FractionalOffset(0, 2),
                                  children: <Widget>[
                                    Container(
                                      width: 64,
                                      height: 64,
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
                                    Container(
                                      child: Center(
                                        child: Text(
                                          '${item.name}',
                                          style: TextStyle(
                                            color: Colours.gray_21,
                                            fontSize: 15.0,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                      ),
                                    ),
                                  ]),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        CustomerDetailPage(
                                          uid: item.uUID,
                                        ),
                                  ),
                                ).then((_) {
                                  eventBuses.fire(GetOpen(true));
                                });
                                eventBuses.fire(GetOpen(false));
                                eventBuses.fire(BackControl(true));
                              },
                            ),
                          );
                        }).toList(),
                      ),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}
