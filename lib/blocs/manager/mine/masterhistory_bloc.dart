import '../../../ui/pages/page_index.dart';
import "../../../common/component_index.dart";
import 'package:rxdart/rxdart.dart';

import 'package:permission_handler/permission_handler.dart';

class MasterHistoryBloc implements BlocBase {
  BuildContext bloccontext;

  NetRepository netRepository = NetRepository();

  BehaviorSubject<dynamic> _getMasterHistoryController =
      BehaviorSubject<dynamic>();
  Sink<dynamic> get _myHistoryDataSink => _getMasterHistoryController.sink;
  Stream<dynamic> get myHistoryDataStream => _getMasterHistoryController.stream;

  int currentPage = 0;
  List historyList = List();
  Future getMasterHistoryDatas(int loadType) async {
    print(loadType);
     if (loadType != 0) {
      if (loadType == 1) {
        currentPage++;
      } else {
        currentPage = 0;
        historyList = [];
      }
    }
    MasterHistoryReq _getMasterHistoryReq =
        MasterHistoryReq(AppInstance.currentUser.token, currentPage);
    XsProgressHud.show(bloccontext);
    return netRepository
        .getMasterHistoryList(_getMasterHistoryReq.toJson())
        .then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null){
          List historydataList =
              MasterHistoryModel.fromJson(resp.data).dataList;
              
          if (historydataList.length > 0) {
            historyList.addAll(historydataList);

          } else {
            currentPage--;
          }
         _myHistoryDataSink.add(historyList);
        }
          // _myHistoryDataSink
          //     .add(MasterHistoryModel.fromJson(resp.data).dataList);
      } else {
        showToast(resp.msg);
      }
    });
  }

  void showToast(String msg, {int duration, int gravity: 0}) {
    Toast.show(msg, bloccontext, duration: duration, gravity: gravity);
  }

  @override
  void dispose() {
    _getMasterHistoryController.close();
  }
}
