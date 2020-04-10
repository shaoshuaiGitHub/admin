import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youxinbao/blocs/capital/manage/plan_bloc.dart';
import 'package:youxinbao/common/component_index.dart';
import 'package:youxinbao/res/colors.dart';

class PlanDetail extends StatefulWidget {
  final PlanItemModel planItem;
  PlanDetail({Key key, @required this.planItem}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlanDetail(planItem: this.planItem);
}

class _PlanDetail extends State<PlanDetail> {
  bool isCheck = false;
  final PlanItemModel planItem;

  _PlanDetail({Key key, @required this.planItem});
  PlanBloc planBloc = PlanBloc();
  var repayInputCrl = TextEditingController();
  var errorInputCrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    planBloc.bloccontext = context;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Color(0xFFFF9B1A),
        title: Text(
          '计划详情',
          style: TextStyle(fontSize: 18, fontWeight: FontWeights.bold),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF2F2F2),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: ListView(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Container(
                  child: MyDetailItem(planItem: planItem),
                ),
              ),
              Offstage(
                offstage: planItem.status == 4 || planItem.status == -1,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 34,
                      margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '实际还款',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.only(top: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          controller: repayInputCrl,
                          inputFormatters: [
                            WhitelistingTextInputFormatter(
                              RegExp(r"^\d+(?:\.\d{0,2})?"),
                            ),
                          ],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeights.medium,
                          ),
                          maxLines: 1,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            hintText: '请输入实际还款金额',
                            hintStyle: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF999999),
                              fontWeight: FontWeights.medium,
                            ),
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 4,
                          ),
                          MaterialButton(
                            padding: EdgeInsets.all(0),
                            minWidth: 40,
                            onPressed: () {
                              setState(() {
                                isCheck = !isCheck;
                              });
                            },
                            child: Container(
                              width: 15,
                              height: 15,
                              margin: EdgeInsets.only(top: 1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: Color(0xFFFF9B1A),
                              ),
                              child: isCheck
                                  ? Icon(
                                      Icons.check,
                                      size: 15,
                                      color: Colors.white,
                                    )
                                  : Icon(
                                      Icons.check_box_outline_blank,
                                      size: 15,
                                      color: Color(0xFFFF9B1A),
                                    ),
                            ),
                          ),
                          // SizedBox(
                          //   width: 6,
                          // ),
                          Container(
                            child: Text(
                              '标记为问题订单',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Color(0xFF212121),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Offstage(
                      offstage: !isCheck,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.only(top: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextField(
                            controller: errorInputCrl,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeights.medium,
                            ),
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              hintText: '请输入该订单遇到的问题',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF999999),
                                fontWeight: FontWeights.medium,
                              ),
                              disabledBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: planItem.status == 4 || planItem.status == -1,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 30, 16, 0),
                        width: MediaQuery.of(context).size.width - 32,
                        height: 44.0,
                        decoration: BoxDecoration(
                          color: Color(0xFFFF9B1A),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: MaterialButton(
                          padding: const EdgeInsets.all(0),
                          minWidth: 0,
                          onPressed: () {
                            if (!isCheck) {
                              if (repayInputCrl.text.length == 0 ||
                                  double.parse(repayInputCrl.text) == 0.0) {
                                planBloc.showToast("请输入实际还款金额");
                                return;
                              }
                              if (double.parse(repayInputCrl.text) <
                                  planItem.repayMinMoney.toDouble()) {
                                planBloc.showToast("实际还款金额不能低于计划还款金额");
                                return;
                              }
                              planBloc.operatesRepay(planItem.id,
                                  double.parse(repayInputCrl.text));
                            } else {
                              if (errorInputCrl.text.length == 0) {
                                planBloc.showToast("请输入该订单遇到的问题");
                                return;
                              }
                              planBloc.operateOrderState(
                                planItem.id,
                                -1,
                                errorInputCrl.text,
                              );
                            }
                          },
                          child: Text(
                            '标记已还款成功',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyDetailItem extends StatelessWidget {
  final PlanItemModel planItem;
  MyDetailItem({Key key, @required this.planItem});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: <Widget>[
          Container(
            height: 56,
            padding: const EdgeInsets.fromLTRB(11, 5, 13, 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '来自管理师：${planItem.masterName}',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeights.medium,
                    color: Color(0xFF212121),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '客户：${planItem.ownerName}',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeights.medium,
                        color: Color(0xFF212121),
                      ),
                    ),
                    Text(
                      '代管类型：${planItem.delegateType == 0 ? '未代管' : planItem.delegateType == 1 ? '单次代还' : planItem.delegateType == 2 ? '精养代操' : planItem.delegateType == 3 ? '提额代操' : '未知类型'}',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeights.medium,
                        color: Color(0xFF212121),
                      ),
                    ),
                    SizedBox(
                      width: 1,
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              height: 1,
              color: Color(0xFFE5E5E5),
            ),
          ),
          Container(
            child: MyDetails(planItem: planItem),
          ),
        ],
      ),
    );
  }
}

class MyDetails extends StatelessWidget {
  final PlanItemModel planItem;
  MyDetails({Key key, @required this.planItem});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(0, 6, 0, 0),
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${planItem.startTime.substring(0, 16)}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF999999),
                  ),
                ),
                Text(
                  '-${planItem.endTime.substring(0, 16)}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.fromLTRB(10, 0, 50, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '类型：还款计划',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeights.medium,
                    color: Color(0xFF212121),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      '计划还款',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF212121),
                      ),
                    ),
                    Text(
                      '${planItem.repayMinMoney.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              height: 1,
              color: Color(0xFFE5E5E5),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/user/card_default.jpeg",
                            image: planItem.icon,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        '${planItem.bankName} ${planItem.cardNo}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 146.0,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                '信用额度',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeights.medium,
                                  color: Color(0xFF212121),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(9, 0, 0, 0),
                              child: Text(
                                '${planItem.accLimit.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeights.medium,
                                  color: Color(0xFF999999),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                '可用额度',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeights.medium,
                                  color: Color(0xFF212121),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(9, 0, 0, 0),
                              child: Text(
                                '${planItem.usableMoney.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeights.medium,
                                  color: Color(0xFF999999),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              height: 1,
              color: Color(0xFFE5E5E5),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: <Widget>[
                            Text(
                              '计划状态：',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeights.medium,
                                color: Color(0xFF212121),
                              ),
                            ),
                            Text(
                              '${planItem.status == -1 ? '问题订单' : planItem.status == 4 ? '完成' : '待还款'}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeights.medium,
                                color: Color(0xFFFF0000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 146.0,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '实际还款：',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeights.medium,
                          color: Color(0xFF212121),
                        ),
                      ),
                      Text(
                        '${planItem.status == 4 ? planItem.realMoney.toStringAsFixed(2) : '-'}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeights.medium,
                          color: planItem.status == 4
                              ? Color(0xFFFF0000)
                              : Color(0xFF212121),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Text(
              '更新日期：${planItem.updateTime}',
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                  fontWeight: FontWeights.medium),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              height: 1,
              color: Color(0xFFE5E5E5),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: <Widget>[
                            Text(
                              '扣款情况：',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeights.medium,
                                color: Color(0xFF212121),
                              ),
                            ),
                            Text(
                              '${planItem.isPayment == 0 ? '未扣款' : '已扣款'}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeights.medium,
                                color: Color(0xFFFF0000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 146.0,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '扣款金额：',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeights.medium,
                          color: Color(0xFF212121),
                        ),
                      ),
                      Text(
                        '${planItem.isPayment == 0 ? '-' : planItem.paymentMoney}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeights.medium,
                          color: planItem.isPayment == 0
                              ? Color(0xFF212121)
                              : Color(0xFFFF0000),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
            padding: planItem.isPayment == 0
                ? const EdgeInsets.fromLTRB(0, 0, 114, 6)
                : const EdgeInsets.fromLTRB(0, 0, 10, 6),
            child: Text(
              '扣款日期：${planItem.isPayment == 0 ? '-' : planItem.paymentTime}',
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                  fontWeight: FontWeights.medium),
            ),
          ),
        ],
      ),
    );
  }
}
