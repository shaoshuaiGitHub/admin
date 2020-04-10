import 'package:flutter/material.dart';
import 'package:youxinbao/common/component_index.dart';
import 'package:youxinbao/res/colors.dart';
import 'account_middle.dart';
import 'package:youxinbao/blocs/capital/account/account_bloc.dart';
class AccountPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_AccountPage();
}
class _AccountPage extends State<AccountPage> with AutomaticKeepAliveClientMixin{ 
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<AccountBloc>(
      bloc: AccountBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF9B1A),
          centerTitle: true,
          elevation: 0.0,
          title: Container(
            child: Text(
              '对账中心',
              style: TextStyle(fontSize: 18, fontWeight: FontWeights.bold),
            ),
          ),
          leading: Container(),
        ),
        body: Container(
          color: Color(0xFFF2F2F2),
          child:AddAccountMiddle(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

 
