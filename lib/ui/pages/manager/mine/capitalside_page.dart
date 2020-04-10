import 'package:flutter/material.dart';
import 'package:youxinbao/common/component_index.dart';
import 'mine_index.dart';

class CapitalSidePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CapitalSidePage();
  }
}

class _CapitalSidePage extends State<CapitalSidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          '我的资金方',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: Color(0xFFF2F2F2),
        child: BlocProvider<CapitalSideListBloc>(
          bloc: CapitalSideListBloc(),
          child: Stack(
            children: <Widget>[
              CapitalSideHead(),
              Positioned(
                child: CapitalSideBottom(),
                bottom: 0,
                left: 0,
                right: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
