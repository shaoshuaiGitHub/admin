import 'package:flutter/material.dart';
import 'package:youxinbao/blocs/bloc_index.dart';
import 'customer_index.dart';

class CustomerIndexPage extends StatefulWidget {
  @override
  State<CustomerIndexPage> createState() => _CustomerIndexPage();
}

class _CustomerIndexPage extends State<CustomerIndexPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        // backgroundColor: Color.fromARGB(255, 255, 114, 0),
        title: Text(
          '我的客户',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        leading: Container(),
      ),
      body: Container(
        color: Color(0xFFF2F2F2),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            //触摸回收键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          // Container());
          child: BlocProvider<CustomerIndexBloc>(
            bloc: CustomerIndexBloc(),
            child: CustomerIndexMiddle(),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
