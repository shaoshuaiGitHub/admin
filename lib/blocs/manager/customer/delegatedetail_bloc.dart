import "../../../common/component_index.dart";
import 'package:rxdart/rxdart.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class DelegateDetailBloc implements BlocBase {
  BuildContext bloccontext;

  NetRepository netRepository = NetRepository();

  BehaviorSubject<DelegateDetailListModel> _delegatedetailController =
      BehaviorSubject<DelegateDetailListModel>();
  Sink<DelegateDetailListModel> get _delegateSink =>
      _delegatedetailController.sink;
  Stream<DelegateDetailListModel> get delegateStream =>
      _delegatedetailController.stream;

  DelegateDetailBloc();

//代管信息
  Future getDelegateList(int orderId) async {
    DelegateListReq _delegateListReq =
        DelegateListReq(AppInstance.currentUser.token, orderId);
    XsProgressHud.show(bloccontext);
    return netRepository
        .getDelegateList(_delegateListReq.toJson())
        .then((resp) {
      XsProgressHud.hide();

      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          _delegateSink.add(DelegateDetailListModel.fromJson(resp.data));
        }
      } else {
        showToast(resp.msg);
      }
    });
  }

//审核信息
  BehaviorSubject<OrderDetailModel> _orderdetailController =
      BehaviorSubject<OrderDetailModel>();
  Sink<OrderDetailModel> get _orderdetailSink => _orderdetailController.sink;
  Stream<OrderDetailModel> get orderdetailStream =>
      _orderdetailController.stream;

  Future getOrderDetail(int id) async {
    // print(id);
    OrderDetailReq _orderDetailReq =
        OrderDetailReq(AppInstance.currentUser.token, id);
    XsProgressHud.show(bloccontext);
    return netRepository.getOrderDetial(_orderDetailReq.toJson()).then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null)
          _orderdetailSink.add(OrderDetailModel.fromJson(resp.data));
      } else {
        //  _orderdetailSink.add(OrderDetailModel.fromJson({}));
        showToast(resp.msg);
      }
    });
  }

//查看合同
  BehaviorSubject<ViewContractListModel> _viewcontractController =
      BehaviorSubject<ViewContractListModel>();
  StreamSink<ViewContractListModel> get _viewcontractSink =>
      _viewcontractController.sink;
  Stream<ViewContractListModel> get viewcontractStream =>
      _viewcontractController.stream;

  Future getviewContract(int applyId) async {
    ViewContractReq _operationReq =
        ViewContractReq(AppInstance.currentUser.token, applyId);
    XsProgressHud.show(bloccontext);
    return netRepository.viewContract(_operationReq.toJson()).then((resp) {
      XsProgressHud.hide();
      FocusScope.of(bloccontext).requestFocus(FocusNode());

      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          _viewcontractSink.add(ViewContractListModel.fromJson(resp.data));
        }
      } else {
        showToast(resp.msg);
      }
    });
  }

  //添加合同
  StreamController<int> _addcontractController = StreamController<int>();
  StreamSink<int> get _addcontractSink => _addcontractController.sink;
  Stream<int> get addcontractStream => _addcontractController.stream;

  Future addContractAction(
    int applyId,
    List file,
  ) async {
    FormData uploadImgReq = FormData.from({
      "token": AppInstance.currentUser.token,
      "applyId": applyId,
      // "file1": UploadFileInfo.fromBytes(file19, 'images.jpg')
    });

    for (var i = 0; i < file.length; i++) {
      var fileResult = await FlutterImageCompress.compressWithList(
        file[i],
        minWidth: 100,
        minHeight: 60,
        quality: 10,
        rotate: 0,
      );
      uploadImgReq.add("file${i + 1}",
          UploadFileInfo.fromBytes(fileResult, 'images${i + 1}.jpg'));
    }

    XsProgressHud.show(bloccontext);
    return netRepository.addContract(uploadImgReq).then((resp) {
      XsProgressHud.hide();
      FocusScope.of(bloccontext).requestFocus(FocusNode());

      if (resp.code == Constant.SUCCESS_CODE) {
        showToast(resp.msg);
      } else {
        showToast(resp.msg);
      }
    });
  }

  //删除合同
  StreamController<int> _deletecontractController = StreamController<int>();
  StreamSink<int> get _deletecontractSink => _deletecontractController.sink;
  Stream<int> get deletecontractStream => _deletecontractController.stream;

  Future deleteContractAction(int applyId, String fileName) async {
    print(applyId);
    DeleteContractReq _operationReq =
        DeleteContractReq(AppInstance.currentUser.token, applyId, fileName);
    XsProgressHud.show(bloccontext);
    return netRepository.deleteContract(_operationReq.toJson()).then((resp) {
      XsProgressHud.hide();
      FocusScope.of(bloccontext).requestFocus(FocusNode());

      if (resp.code == Constant.SUCCESS_CODE) {
        showToast(resp.msg);
      } else {
        showToast(resp.msg);
      }
    });
  }

  //解除代管 removeDelegate
  StreamController<int> _removeDelegateController = StreamController<int>();
  StreamSink<int> get _removeDelegateSink => _removeDelegateController.sink;
  Stream<int> get removeDelegateStream => _removeDelegateController.stream;

  Future removeDelegateAction(int id, String condition) async {
    RemoveDelegateReq _operationReq =
        RemoveDelegateReq(AppInstance.currentUser.token, id);
    XsProgressHud.show(bloccontext);
    return netRepository.removeDelegate(_operationReq.toJson()).then((resp) {
      XsProgressHud.hide();
      FocusScope.of(bloccontext).requestFocus(FocusNode());
      if (resp.code == Constant.SUCCESS_CODE) {
        showToast(resp.msg);
        getExamineDetail(condition);
      } else {
        showToast(resp.msg);
      }
    });
  }

//一键解除代管 removeAllDelegate
  StreamController<int> _removeAllDelegateController = StreamController<int>();
  StreamSink<int> get _removeAllDelegateSink =>
      _removeAllDelegateController.sink;
  Stream<int> get removeAllDelegateStream =>
      _removeAllDelegateController.stream;

  Future removeAllDelegateAction(int userId) async {
    RemoveAllDelegateReq _operationReq =
        RemoveAllDelegateReq(AppInstance.currentUser.token, userId);
    XsProgressHud.show(bloccontext);
    return netRepository.removeAllDelegate(_operationReq.toJson()).then((resp) {
      XsProgressHud.hide();
      FocusScope.of(bloccontext).requestFocus(FocusNode());
      if (resp.code == Constant.SUCCESS_CODE) {
        showToast(resp.msg);
        Future.delayed(new Duration(milliseconds: 500)).then((_) {
          Navigator.of(bloccontext).pop();
          Navigator.of(bloccontext).pop();
        });
      } else {
        showToast(resp.msg);
      }
    });
  }

  //订单列表
  BehaviorSubject<ExamineListModel> _examineController =
      BehaviorSubject<ExamineListModel>();
  Sink<ExamineListModel> get _examineSink => _examineController.sink;
  Stream<ExamineListModel> get examineStream => _examineController.stream;

  Future getExamineDetail(String condition) async {
    ExamineReq _examineReq =
        ExamineReq(AppInstance.currentUser.token, condition);
    XsProgressHud.show(bloccontext);
    return netRepository.getExamineDetail(_examineReq.toJson()).then((resp) {
      XsProgressHud.hide();
      if (resp.code == Constant.SUCCESS_CODE) {
        if (resp.data != null) {
          _examineSink.add(ExamineListModel.fromJson(resp.data));
        }
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
    _delegatedetailController.close();
    _orderdetailController.close();
    _examineController.close();
    _viewcontractController.close();
    _addcontractController.close();
    _deletecontractController.close();
    _removeDelegateController.close();
    _removeAllDelegateController.close();
  }
}
