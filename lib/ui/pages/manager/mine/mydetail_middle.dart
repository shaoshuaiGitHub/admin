import 'package:youxinbao/blocs/manager/mine/mydetail_bloc.dart';

import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import 'createprofit_page.dart';
import '../../../../ui/widgets/expansion_panel.dart';

class MyDetailMiddle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyDetailMiddle();
  }
}

class _MyDetailMiddle extends State<MyDetailMiddle> {
  MyDetailBloc mydetailbloc = MyDetailBloc();
  @override
  Widget build(BuildContext context) {
    mydetailbloc.bloccontext = context;
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          StreamBuilder<MyDetailConsumListModel>(
              stream: mydetailbloc.myconsumdataStream,
              builder: (BuildContext context,
                  AsyncSnapshot<MyDetailConsumListModel> snapshot) {
                List<Widget> liftingContainer = [];
                Widget content;

                if (!snapshot.hasData) {
                  Future.delayed(new Duration(milliseconds: 500)).then((_) {
                    mydetailbloc.getConsumData(0);
                  });
                  return Container();
                }
                num totalmoney =
                    snapshot.hasData ? snapshot.data.totalMoney : 0;

                liftingContainer.add(GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ConsumContainer()));
                  },
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '消费分润(元)',
                            style:
                                TextStyle(fontSize: 16, color: Colours.gray_21),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '${totalmoney.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 16, color: Colours.gray_21),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Image.asset(ImgPrefix.manager_prefix +
                                  'arrowmore_small.png',width: 8,height: 13),
                            ],
                          )
                        ],
                      )),
                ));
                content = Column(children: liftingContainer);
                return content;
              }),

          StreamBuilder<MyDetailLiftingListModel>(
              stream: mydetailbloc.mydataStream,
              builder: (BuildContext context,
                  AsyncSnapshot<MyDetailLiftingListModel> snapshot) {
                List<Widget> liftingContainer = [];
                Widget content;

                if (!snapshot.hasData) {
                  Future.delayed(new Duration(milliseconds: 500)).then((_) {
                    mydetailbloc.getLiftingData();
                  });
                  return Container();
                }
                num totalmoney =
                    snapshot.hasData ? snapshot.data.totalMoney : 0;

                liftingContainer.add(GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                LiftingAmountContainer()));
                  },
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '提额分润(元)',
                            style:
                                TextStyle(fontSize: 16, color: Colours.gray_21),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '${totalmoney.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 16, color: Colours.gray_21),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Image.asset(ImgPrefix.manager_prefix +
                                  'arrowmore_small.png',width: 8,height: 13),
                            ],
                          )
                        ],
                      )),
                ));
                content = Column(children: liftingContainer);
                return content;
              })
        ],
      ),
    );

// );
// content = Column(children: liftingContainer);
//           return content;

//             });
  }
}
