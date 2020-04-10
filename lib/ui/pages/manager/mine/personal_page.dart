import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';

import '../../../../common/component_index.dart';
import 'mine_index.dart';

class MpersonalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MpersonalPage();
  }
}

class _MpersonalPage extends State<MpersonalPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: BlocProvider<UserBloc>(
        bloc: UserBloc(),
        child: MasterMineRefresh(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MasterMineRefresh extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MasterMineRefresh();
}

class _MasterMineRefresh extends State<MasterMineRefresh> {
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    userBloc.bloccontext = context;
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
          MpersonalMiddle(),
        ],
      ),
      onRefresh: () async {
        Future.delayed(new Duration(milliseconds: 500)).then((_) {
          userBloc.getUserInfo();
        });
      },
    );
  }
}
