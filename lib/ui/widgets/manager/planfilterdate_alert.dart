import '../../../common/component_index.dart';
import '../../pages/page_index.dart';

import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import '../../../ui/pages/manager/plan/planindex_middle.dart';

class PlanFilterDateAlert extends StatefulWidget {
  PlanFilterDateAlert(
      {Key key,
      this.tabIndex,
      this.allplanBloc,
      this.userId,
      this.cardId,
      this.callback});
  final callback;
  final int tabIndex;
  final AllPlanListBloc allplanBloc;
  final int userId;
  final int cardId;

  @override
  State<StatefulWidget> createState() => PlanFilterDateAlertState();
}

class PlanFilterDateAlertState extends State<PlanFilterDateAlert>
    with AutomaticKeepAliveClientMixin {
  String selectDateRangeStr = '请选择日期';
  int filterType = 0;
  DateTime now = DateTime.now();
  DateTime defaultFirstDate =
      DateTime.now().subtract(Duration(days: 6)); //默认开始时间
  DateTime defaultLastDate = DateTime.now(); //默认结束时间
  String dateTime; //时间
  bool allPlanSelect = true;
  bool consumPlanSelect = false;
  bool reypayPlanSelect = false;
  dynamic planType = ''; //消费计划
  bool allDelegateSelect = true;
  bool oneDelegateSelect = false;
  bool getcashDelegateSelect = false;
  bool quietDelegateSelect = false;
  dynamic delegateType = ''; //单次代还
  bool isWholeExpanded = false;
  bool isHistoryExpanded = false;
  String startTime =
      DateTime.now().add(Duration(days: -6)).toString().substring(0, 11) +
          '00:00:00';
  String endTime = DateTime.now().toString().substring(0, 11) + '23:59:59';

  void initState() {
    super.initState();
    //初始获取一周内的计划
    dateTime =
        '{"startTime":"${now.add(Duration(days: -6)).toString().substring(0, 11)}00:00:00","endTime":"${now.toString().substring(0, 11)}23:59:59"}';

    eventBuses.on<WholeExpanded>().listen(
      (event) {
        if (mounted) {
          isWholeExpanded = event.isExpanded;
        }
      },
    );

    eventBuses.on<HistoryExpanded>().listen(
      (event) {
        if (mounted) {
          isHistoryExpanded = event.isExpanded;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    widget.allplanBloc.bloccontext = context;
    return Container(
      width: 250,
      height: 144,
      margin: EdgeInsets.only(
        top: 193,
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 300,
            height: 358,
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colours.white_color,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '日期范围',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colours.orange_72,
                    fontWeight: FontWeights.medium,
                    decoration: TextDecoration.none,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    widget.tabIndex == 2
                        ? Text(
                            '${now.add(Duration(days: -6)).toString().substring(0, 11)}至 ${now.toString().substring(0, 11)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colours.gray_21,
                              fontWeight: FontWeights.medium,
                              decoration: TextDecoration.none,
                            ),
                          )
                        : Container(
                            height: 20,
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    selectDateRangeStr,
                                    style: TextStyles.text14MediumLabel,
                                  ),
                                  Icon(Icons.keyboard_arrow_down,
                                      size: 20, color: Colours.gray_99),
                                ],
                              ),
                              onPressed: () async {
                                var dateTimeMap = Map();

                                await DateRagePicker.showDatePicker(
                                        context: context,
                                        initialFirstDate: defaultFirstDate,
                                        initialLastDate: defaultLastDate,
                                        firstDate: new DateTime(2015),
                                        lastDate: new DateTime(2020))
                                    .then((val) {
                                  //判断是否选择时间
                                  if (val != null) {
                                    //若只点击一个时间,获取两次点击时间一致
                                    bool isSame = false;
                                    if (val.length == 2) {
                                      DateTime beDate =
                                          DateTime.parse(val[0].toString());
                                      DateTime afDate =
                                          DateTime.parse(val[1].toString());

                                      isSame = beDate
                                              .difference(afDate)
                                              .toString()
                                              .substring(0, 7) ==
                                          "0:00:00";
                                    }
                                    //只点击一次或两次时间一致
                                    if (val.length == 1 || isSame) {
                                      DateTime singleDate =
                                          DateTime.parse(val[0].toString());
                                      //判断选择的这个时间与现在时间先后
                                      startTime = now.isAfter(singleDate)
                                          ? singleDate
                                              .toString()
                                              .substring(0, 19)
                                          : now.toString().substring(0, 19);
                                      endTime = now.isAfter(singleDate)
                                          ? now.toString().substring(0, 19)
                                          : singleDate
                                              .toString()
                                              .substring(0, 19);
                                      this.setState(() {
                                        defaultFirstDate = singleDate;
                                        defaultLastDate = singleDate;
                                      });
                                    } else {
                                      DateTime beDate =
                                          DateTime.parse(val[0].toString());
                                      DateTime afDate =
                                          DateTime.parse(val[1].toString());
                                      startTime =
                                          beDate.toString().substring(0, 19);
                                      endTime =
                                          afDate.toString().substring(0, 19);
                                      this.setState(() {
                                        defaultFirstDate = beDate;
                                        defaultLastDate = afDate;
                                      });
                                    }

                                    if (startTime != "" && endTime != "") {
                                      dateTimeMap.addAll({
                                        '"startTime"': '"$startTime"',
                                        '"endTime"': '"$endTime"'
                                      });
                                      dateTime = dateTimeMap.toString();
                                      this.setState(() {
                                        dateTime = dateTime;
                                      });
                                    }

                                    //传时间范围的值到弹窗上
                                    selectDateRangeStr = val.toString();
                                    StringBuffer strBuf = StringBuffer();
                                    for (int i = 0; i < 2; i++) {
                                      DateTime date = val[i];
                                      strBuf.write(
                                          "${date.year}-${date.month}-${date.day} ");
                                      if (i == 0) strBuf.write("至 ");
                                    }
                                    selectDateRangeStr = strBuf.toString();
                                  }
                                });
                              },
                            ),
                          ),
                  ],
                ),
                Container(
                  height: 0.5,
                  padding: EdgeInsets.only(
                    left: 10,
                  ),
                  color: Colours.background_color2,
                ),
                Text(
                  '计划类型',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colours.orange_72,
                    fontWeight: FontWeights.medium,
                    decoration: TextDecoration.none,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 90,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: allPlanSelect
                              ? Colours.orange_72
                              : Colours.text_placehold2,
                          width: 1.0,
                        ),
                      ),
                      child: GestureDetector(
                        child: Center(
                          child: Text(
                            '全部计划',
                            style: allPlanSelect
                                ? TextStyles.text14OrangeMediumLabel
                                : TextStyles.text14MediumLabel,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            consumPlanSelect = false;
                            allPlanSelect = true;
                            reypayPlanSelect = false;
                            planType = '';
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 90,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: consumPlanSelect
                              ? Colours.orange_72
                              : Colours.text_placehold2,
                          width: 1.0,
                        ),
                      ),
                      child: GestureDetector(
                        child: Center(
                          child: Text(
                            '消费计划',
                            style: consumPlanSelect
                                ? TextStyles.text14OrangeMediumLabel
                                : TextStyles.text14MediumLabel,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            consumPlanSelect = true;
                            allPlanSelect = false;
                            reypayPlanSelect = false;
                            planType = 1;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 90,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: reypayPlanSelect
                              ? Colours.orange_72
                              : Colours.text_placehold2,
                          width: 1.0,
                        ),
                      ),
                      child: GestureDetector(
                        child: Center(
                          child: Text(
                            '还款计划',
                            style: reypayPlanSelect
                                ? TextStyles.text14OrangeMediumLabel
                                : TextStyles.text14MediumLabel,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            consumPlanSelect = false;
                            allPlanSelect = false;
                            reypayPlanSelect = true;
                            planType = 2;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 0.5,
                  padding: EdgeInsets.only(
                    left: 10,
                  ),
                  margin: EdgeInsets.only(top: 8, bottom: 5),
                  color: Colours.background_color2,
                ),
                Text(
                  '代管类型',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colours.orange_72,
                    fontWeight: FontWeights.medium,
                    decoration: TextDecoration.none,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 90,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: allDelegateSelect
                              ? Colours.orange_72
                              : Colours.text_placehold2,
                          width: 1.0,
                        ),
                      ),
                      child: GestureDetector(
                        child: Center(
                          child: Text(
                            '全部代管',
                            style: allDelegateSelect
                                ? TextStyles.text14OrangeMediumLabel
                                : TextStyles.text14MediumLabel,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            allDelegateSelect = true;
                            oneDelegateSelect = false;
                            getcashDelegateSelect = false;
                            quietDelegateSelect = false;
                            delegateType = '';
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 90,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: getcashDelegateSelect
                              ? Colours.orange_72
                              : Colours.text_placehold2,
                          width: 1.0,
                        ),
                      ),
                      child: GestureDetector(
                        child: Center(
                          child: Text(
                            '提额代操',
                            style: getcashDelegateSelect
                                ? TextStyles.text14OrangeMediumLabel
                                : TextStyles.text14MediumLabel,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            allDelegateSelect = false;
                            oneDelegateSelect = false;
                            getcashDelegateSelect = true;
                            quietDelegateSelect = false;
                            delegateType = 3;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 90,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: quietDelegateSelect
                              ? Colours.orange_72
                              : Colours.text_placehold2,
                          width: 1.0,
                        ),
                      ),
                      child: GestureDetector(
                        child: Center(
                          child: Text(
                            '精养代操',
                            style: quietDelegateSelect
                                ? TextStyles.text14OrangeMediumLabel
                                : TextStyles.text14MediumLabel,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            allDelegateSelect = false;
                            oneDelegateSelect = false;
                            getcashDelegateSelect = false;
                            quietDelegateSelect = true;
                            delegateType = 2;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 90,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: oneDelegateSelect
                          ? Colours.orange_72
                          : Colours.text_placehold2,
                      width: 1.0,
                    ),
                  ),
                  child: GestureDetector(
                    child: Center(
                      child: Text(
                        '单次代操',
                        style: oneDelegateSelect
                            ? TextStyles.text14OrangeMediumLabel
                            : TextStyles.text14MediumLabel,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        allDelegateSelect = false;
                        oneDelegateSelect = true;
                        getcashDelegateSelect = false;
                        quietDelegateSelect = false;
                        delegateType = 1;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 135,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colours.gray_e6,
                      ),
                      child: FlatButton(
                        child: Text(
                          '重置',
                          style:
                              TextStyle(fontSize: 18, color: Colours.gray_99),
                        ),
                        onPressed: () {
                          setState(() {
                            allPlanSelect = true;
                            consumPlanSelect = false;
                            reypayPlanSelect = false;
                            planType = '';

                            allDelegateSelect = true;
                            oneDelegateSelect = false;
                            getcashDelegateSelect = false;
                            quietDelegateSelect = false;
                            delegateType = '';

                            //时间
                            startTime = DateTime.now()
                                    .add(Duration(days: -6))
                                    .toString()
                                    .substring(0, 11) +
                                '00:00:00';
                            endTime =
                                DateTime.now().toString().substring(0, 11) +
                                    '23:59:59';
                          });
                          selectDateRangeStr = '请选择日期';
                        },
                      ),
                    ),
                    Container(
                      width: 135,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colours.orange_72,
                      ),
                      child: FlatButton(
                        child: Text(
                          '确定',
                          style: TextStyles.text16WhiteMediumLabel,
                        ),
                        onPressed: () {
                          String condition;

                          if (widget.tabIndex == 1) {
                            //计划管理的历史计划
                            condition = {
                              '"startTime"': '"$startTime"',
                              '"endTime"': '"$endTime"',
                              '"planType"': '"$planType"',
                              '"delegateType"': '"$delegateType"',
                              '"status"': [4, -1],
                            }.toString();
                            if (widget.userId != null) {
                              condition = {
                                //用户下的历史计划
                                '"startTime"': '"$startTime"',
                                '"endTime"': '"$endTime"',
                                '"planType"': '"$planType"',
                                '"delegateType"': '"$delegateType"',
                                '"status"': [4, -1],
                                '"userId"': widget.userId,
                              }.toString();
                              if (widget.cardId != null) {
                                //卡片下的计划
                                condition = {
                                  '"startTime"': '"$startTime"',
                                  '"endTime"': '"$endTime"',
                                  '"planType"': '"$planType"',
                                  '"delegateType"': '"$delegateType"',
                                  '"status"': [4, -1],
                                  '"cardId"': widget.cardId,
                                }.toString();
                              }
                            }
                          } else {
                            condition = {
                              '"startTime"': '"$startTime"',
                              '"endTime"': '"$endTime"',
                              '"planType"': '"$planType"',
                              '"delegateType"': '"$delegateType"',
                            }.toString();
                          }
                          Navigator.pop(context);
                          if (widget.tabIndex == 0) {
                            widget.allplanBloc.getAllplanList(
                                condition, 2, false, isWholeExpanded);
                            eventBuses.fire(WholePanel(false));
                          } else {
                            widget.allplanBloc.getHistoryplanList(
                                condition, 2, false, isHistoryExpanded);
                            eventBuses.fire(HistoryPanel(false));
                          }
                          masterEventBus.fire(
                              MasterPlanCondition(widget.tabIndex, condition));

                          widget.callback(condition);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
