import 'package:flutter/material.dart';
import 'package:youxinbao/blocs/manager/mine/mine_index.dart';
import 'package:youxinbao/common/component_index.dart';
import 'mine_index.dart';

class MycapitalSidePage extends StatefulWidget{
  MycapitalSidePage({Key key,this.uid}):super(key: key);
  int uid;
   @override
  State<StatefulWidget> createState() {
    return _MycapitalSidePage();
  }
}
class _MycapitalSidePage extends State<MycapitalSidePage> {
      
    
  @override
  Widget build(BuildContext context) {
    final ApplicationBloc applicationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    applicationBloc.backType = 1;

    return Scaffold(
      resizeToAvoidBottomInset: false,
        backgroundColor:  Color(0xfff2f2f2),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          // backgroundColor: Color.fromARGB(255, 255, 114, 0),
          title: Text(
            '我的资金方',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        body:  BlocProvider<CapitalSideListBloc>(
              bloc: CapitalSideListBloc(),
              child: 
             MycapitalSidelHead(uid:widget.uid),
        ),
            //  MycapitalSideBottom(),
         );
  }
}
