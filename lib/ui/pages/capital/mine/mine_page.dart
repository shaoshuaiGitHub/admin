import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:youxinbao/blocs/bloc_index.dart';
import 'mine_main.dart';

class CapicalMinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CapicalMinePage();
}

class _CapicalMinePage extends State<CapicalMinePage>
    with AutomaticKeepAliveClientMixin {
  //资金方个人中心
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider<BasisBloc>(
      bloc: BasisBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: MineRefresh(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MineRefresh extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MineRefresh();
}

class _MineRefresh extends State<MineRefresh> {
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  @override
  Widget build(BuildContext context) {
    final BasisBloc basisBloc = BlocProvider.of<BasisBloc>(context);
    basisBloc.bloccontext = context;
    return EasyRefresh(
      key: _easyRefreshKey,
      refreshHeader: MaterialHeader(
        key: _headerKey,
      ),
      refreshFooter: MaterialFooter(
        key: _footerKey,
      ),
      child: ListView(
        padding: EdgeInsets.only(
          top: 0,
        ),
        children: <Widget>[
          CapitalMineMain(),
        ],
      ),
      // onRefresh: () async {
      //     basisBloc.getUserInfo();
      // },
    );
  }
}
