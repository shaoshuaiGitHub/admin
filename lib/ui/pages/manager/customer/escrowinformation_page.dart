import 'package:flutter/material.dart';
import 'customer_index.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';

class EscrowInformationPage extends StatefulWidget {
  EscrowInformationPage(
      {Key key,
      this.uid,
      this.name,
      this.delegateCardCount,
      this.totalAccLimit,
      this.icon})
      : super(key: key);
  int uid;
  var name;
  num delegateCardCount;
  num totalAccLimit;
  var icon;

  @override
  State<StatefulWidget> createState() {
    return _EscrowInformationPage();
  }
}

class _EscrowInformationPage extends State<EscrowInformationPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: Color(0xfff2f2f2),
          appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            title: Text(
              '代管信息',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          body: BlocProvider<DelegateDetailBloc>(
            bloc: DelegateDetailBloc(),
            child: EscrowInformationMiddle(
                uid: widget.uid,
                name: widget.name,
                delegateCardCount: widget.delegateCardCount,
                totalAccLimit: widget.totalAccLimit,
                icon:widget.icon),
          )),
    );
  }
}
