import 'package:flutter/material.dart';
import 'package:youxinbao/blocs/bloc_provider.dart';
import 'package:youxinbao/blocs/manager/plan/wind_bloc.dart';
import 'plan_index.dart';

class WindControlAuditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<WindBloc>(
      bloc: WindBloc(),
      child: Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            '风控审核',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(bottom: 0),
          // constraints: BoxConstraints(maxHeight: 600),
        child:ListView(
          children: <Widget>[
            WindControlAuditMiddle(),
          ],
        ),
      ),
      ),
    );
  }
}
