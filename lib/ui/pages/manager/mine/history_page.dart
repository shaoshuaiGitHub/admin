import 'package:flutter/material.dart';
import 'package:youxinbao/blocs/manager/mine/masterhistory_bloc.dart';
import 'package:youxinbao/common/component_index.dart';
import 'mine_index.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        // backgroundColor: Color.fromARGB(255, 255, 114, 0),
        title: Text(
          '历史往来',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocProvider<MasterHistoryBloc>(
        bloc: MasterHistoryBloc(),
        child: HistoryMiddle(),
        // HistoryBottom(),
      ),
    );
  }
}
