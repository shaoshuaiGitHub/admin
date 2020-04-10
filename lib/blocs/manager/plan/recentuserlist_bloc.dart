import "../../../common/component_index.dart";
import 'package:rxdart/rxdart.dart';

import 'package:youxinbao/ui/pages/page_index.dart';

class RecentUserListBloc implements BlocBase {
  BuildContext bloccontext;

  NetRepository netRepository = NetRepository();

  BehaviorSubject<RecentUserListModel> _recentuserController =
      BehaviorSubject<RecentUserListModel>();
  Sink<RecentUserListModel> get _recentlistSink => _recentuserController.sink;
  Stream<RecentUserListModel> get recentlistStream =>
      _recentuserController.stream;

  RecentUserListBloc();

  Future getRecentUserList(int page) async {
    RecentUserListReq _recentReq =
        RecentUserListReq(AppInstance.currentUser.token, page);
    XsProgressHud.show(bloccontext);
    return netRepository.getRecentUserList(_recentReq.toJson()).then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null)
          _recentlistSink.add(RecentUserListModel.fromJson(resp.data));
      } else {
        if (resp.code == 50008) {
          Navigator.pushReplacement(bloccontext,
              MaterialPageRoute<void>(builder: (ctx) => LoginPage()));
          AppInstance.putString(Constant.KEY_THEME_COLOR, 'usercolor');
          final ApplicationBloc bloc =
              BlocProvider.of<ApplicationBloc>(bloccontext);
          bloc.sendAppEvent(1);
        }
        showToast(resp.msg);
      }
    });
  }

  void showToast(String msg, {int duration, int gravity: 0}) {
    Toast.show(msg, bloccontext, duration: duration, gravity: gravity);
  }

  @override
  void dispose() {
    _recentuserController.close();
  }
}
