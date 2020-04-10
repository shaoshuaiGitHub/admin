
import '../../../ui/pages/page_index.dart';
import "../../../common/component_index.dart";
import 'package:rxdart/rxdart.dart';

import 'package:permission_handler/permission_handler.dart';

class CreateProfitBloc implements BlocBase {

  BuildContext bloccontext;

  NetRepository netRepository = NetRepository();

  StreamController<int> _createprofitController = StreamController<int>();
  StreamSink<int> get _mysink => _createprofitController.sink;
  Stream<int> get myStream => _createprofitController.stream;


  Future createAction(String cardInstId, String preMoney,String afterMoney) async {
    print(cardInstId);
    CreateProfitReq _createprofitReq = CreateProfitReq(AppInstance.currentUser.token,cardInstId,preMoney,afterMoney);
    XsProgressHud.show(bloccontext);
    return netRepository.createProfit(_createprofitReq.toJson()).then((resp) {
      XsProgressHud.hide();
      FocusScope.of(bloccontext).requestFocus(FocusNode());

      if (resp.code == Constant.SUCCESS_CODE) {
        print(resp.code);
         _mysink.add(resp.code);

      } else {
        showToast(resp.msg);
      }
    });
  }


  BehaviorSubject<GetCreateProfitDataModel> _getcreateprofitdataController =
      BehaviorSubject<GetCreateProfitDataModel>();
  Sink<GetCreateProfitDataModel> get _mydataSink => _getcreateprofitdataController.sink;
  Stream<GetCreateProfitDataModel> get mydataStream => _getcreateprofitdataController.stream;

  CreateProfitBloc();

  Future getCreateProfitData() async {
    // print(id);
    GetCreateProfitDataReq _getdataReq = GetCreateProfitDataReq(AppInstance.currentUser.token);
    XsProgressHud.show(bloccontext);
    return netRepository.getCreateData(_getdataReq.toJson()).then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if(resp.data != null)
        _mydataSink.add(GetCreateProfitDataModel.fromJson(resp.data));
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
    _createprofitController.close();
    _getcreateprofitdataController.close();
  }
}