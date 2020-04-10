import 'package:flutter/material.dart';
import '../../../../ui/pages/page_index.dart';

class CapitalSideBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
    Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xffff7200),
        borderRadius: BorderRadius.circular(5),
      ),
      child: FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '申请资金方',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ApplicationRecordPage()));
        },
      ),
    );
  }
}
