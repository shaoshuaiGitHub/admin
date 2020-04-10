import 'package:flutter/material.dart';
import 'package:youxinbao/blocs/bloc_index.dart';
import 'package:youxinbao/blocs/capital/mine/detail_bloc.dart';
import 'package:youxinbao/common/component_index.dart';
import 'detailList_bottom.dart';
import 'detailList_middle.dart.dart';

class DetailListPage extends StatelessWidget {
  //明细Page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          '明细',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xffff9b1a),
      ),
      body: BlocProvider<DetailListBloc>(
        bloc: DetailListBloc(),
        child: Container(
          height: Screen.height,
          color: Color(0xFFF2F2F2),
          child: Stack(
            children: <Widget>[
              Container(
                child: DetailListMiddle(),
              ),
              Positioned(
                child: DetailListBottom(),
                left: 0,
                right: 0,
                bottom: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
