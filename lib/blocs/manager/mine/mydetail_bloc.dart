
import '../../../ui/pages/page_index.dart';
import "../../../common/component_index.dart";
import 'package:rxdart/rxdart.dart';

import 'package:permission_handler/permission_handler.dart';

class MyDetailBloc implements BlocBase {

  BuildContext bloccontext;

  NetRepository netRepository = NetRepository();



  BehaviorSubject<MyDetailLiftingListModel> _myDetailLiftItemModelController =
      BehaviorSubject<MyDetailLiftingListModel>();
  Sink<MyDetailLiftingListModel> get _mydataSink => _myDetailLiftItemModelController.sink;
  Stream<MyDetailLiftingListModel> get mydataStream => _myDetailLiftItemModelController.stream;


  MyDetailBloc();

  Future getLiftingData() async {
    LiftingReq _getdataReq = LiftingReq(AppInstance.currentUser.token);
    XsProgressHud.show(bloccontext);
    return netRepository.getLiftingData(_getdataReq.toJson()).then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if(resp.data != null)
        _mydataSink.add(MyDetailLiftingListModel.fromJson(resp.data));
      } else {
        showToast(resp.msg);
      }
    });
  }

    BehaviorSubject<MyDetailConsumListModel> _myDetailConsumItemModelController =
      BehaviorSubject<MyDetailConsumListModel>();
  Sink<MyDetailConsumListModel> get _myconsumdataSink => _myDetailConsumItemModelController.sink;
  Stream<MyDetailConsumListModel> get myconsumdataStream => _myDetailConsumItemModelController.stream;

  Future getConsumData(int page) async {
    ConsumReq _getdataReq = ConsumReq(AppInstance.currentUser.token,page);
    XsProgressHud.show(bloccontext);
    return netRepository.getConsumData(_getdataReq.toJson()).then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if(resp.data != null)
        _myconsumdataSink.add(MyDetailConsumListModel.fromJson(resp.data));
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
    _myDetailLiftItemModelController.close();
    _myDetailConsumItemModelController.close();
  }
}