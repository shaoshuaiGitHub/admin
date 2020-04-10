import 'package:flutter/material.dart';
import 'package:youxinbao/common/component_index.dart';
import 'mine_index.dart';
import 'applicationrecord_bottom.dart';

class ApplicationRecordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        // backgroundColor: Color.fromARGB(255, 255, 114, 0),
        title: Text(
          '申请记录',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ApplicationRecordHead(),
          Positioned(
            child:  ApplicationRecordBottom(),
            bottom: 0,
            left: 0,
            right: 0,
          )
        ],
      ),
    );
    // ));
  }
}
