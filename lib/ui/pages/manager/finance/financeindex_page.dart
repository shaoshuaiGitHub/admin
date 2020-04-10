import 'package:flutter/material.dart';
import 'finance_index.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class FinanceIndexPage extends StatefulWidget {
  @override
  State<FinanceIndexPage> createState() => _FinanceIndexPage();
}

class _FinanceIndexPage extends State<FinanceIndexPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colours.orange_72,
        title: Text(
          '财务管理',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        leading: Container(),
      ),
      body: 
      // Container());
      BlocProvider<FinanceIndexBloc>(
        bloc: FinanceIndexBloc(),
        child: 
        // ListView(
        //   children: <Widget>[
            FinanceIndexMiddle(),
        //   ],
        // ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
