import 'package:flutter/material.dart';
import 'package:youxinbao/blocs/capital/mine/detail_bloc.dart';
import 'package:youxinbao/common/component_index.dart';

class DetailListBottom extends StatelessWidget {
  //明细bottom部分 定位视口底部
  Widget build(BuildContext context) {
    DetailListBloc detailListBloc = BlocProvider.of<DetailListBloc>(context);
    return Container(
      // height: 140,
      color: Color(0xffFF9B1A),
      child: Column(
        children: <Widget>[
          Container(
            //总分润
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '总分润',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffffffff)),
                ),
                StreamBuilder(
                  stream: detailListBloc.totalWardMoneyStream,
                  builder: (BuildContext context, AsyncSnapshot<num> snapshot) {
                    return Text(
                      '${(snapshot.hasData && snapshot.data != null) ? snapshot.data.toStringAsFixed(2) : '-----'} 元',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffff0000)),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Color(0xffffffff),
          ),
          Container(
            //分润
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '分润',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffffffff)),
                ),
                StreamBuilder(
                  stream: detailListBloc.wardMoneyStream,
                  builder: (BuildContext context, AsyncSnapshot<num> snapshot) {
                    return Text(
                      '${(snapshot.hasData && snapshot.data != null) ? snapshot.data.toStringAsFixed(2) : '-----'} 元',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffff0000)),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Color(0xffffffff),
          ),
          Container(
            //返还POS机费用
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '返还POS机费用',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffffffff)),
                ),
                StreamBuilder(
                  stream: detailListBloc.totalPosMoneyStream,
                  builder: (BuildContext context, AsyncSnapshot<num> snapshot) {
                    return Text(
                      '${(snapshot.hasData && snapshot.data != null) ? snapshot.data.toStringAsFixed(2) : '-----'} 元',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffffffff)),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
