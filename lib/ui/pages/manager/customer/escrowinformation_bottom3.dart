import 'package:flutter/material.dart';
import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';
import '../../../../ui/widgets/asset_thumb.dart';

import 'dart:async';
// import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
// import 'package:custom_multi_image_picker/asset.dart';
// import 'package:custom_multi_image_picker/custom_multi_image_picker.dart';
// import 'asset_view.dart';

//查看合同
class ContractTab extends StatefulWidget {
  ContractTab({Key key, this.orderId, this.delegateDetailBloc})
      : super(key: key);
  final int orderId;
  final DelegateDetailBloc delegateDetailBloc;
  @override
  State<StatefulWidget> createState() => _ContractTab();
}

class _ContractTab extends State<ContractTab>
    with AutomaticKeepAliveClientMixin {
  bool ispressPush = false;
  int flag = 0;
  bool isEdit = false;
  List<List<int>> myupList = [];
  bool ispressAdd = false;

  void getUploadList(val) {
    myupList = val;
    ispressAdd = true;
  }


// DelegateDetailBloc delegateDetailBloc = DelegateDetailBloc();
  void initState() {
    super.initState();
    Future.delayed(new Duration(milliseconds: 500)).then((_) {
      if (widget.orderId != null) {
        widget.delegateDetailBloc.getviewContract(widget.orderId);
      }
    });
  }

  // int get orderId => widget.orderId;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // DelegateDetailBloc delegatedetailBloc =
    // DelegateDetailBloc();
    // BlocProvider.of<DelegateDetailBloc>(context);
    widget.delegateDetailBloc.bloccontext = context;

    return StreamBuilder<ViewContractListModel>(
        stream: widget.delegateDetailBloc.viewcontractStream,
        builder: (BuildContext context,
            AsyncSnapshot<ViewContractListModel> snapshot) {
          List<Widget> orderContainer = [];
          Widget content;

          if (!snapshot.hasData) {
            return Container();
          }

          List<ViewContractItemModel> contractList =
              snapshot.data.contractList.cast<ViewContractItemModel>();
          int contractListLength = contractList.length;

          // myupList = contractList;
          // flag=0;

          if (contractListLength == 0) {
            flag == 2 ? flag = 2 : flag = 0;
          } else {
            //编辑合同
            // flag = 2;
            flag == 2 ? flag = 2 : flag = 1;
          }
          // flag=1;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              flag == 0
                  ? ContractNullContent()
                  : ContractPushContent(
                      contractList: contractList,
                      isEdit: isEdit,
                      delegatedetailBloc: widget.delegateDetailBloc,
                      callback: (val) => getUploadList(val)),

              //按钮
              Container(
                margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                // width: 360,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 114, 0),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        flag == 0 ? '上传合同' : (flag == 2 ? '确认上传' : '编辑合同'),
                        // flag == 0 ? '上传合同' : '确认上传',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () {
                    if (flag == 0) {
                      //点击上传合同
                      setState(() {
                        flag = 2; //确认上传
                      });
                    } else if (flag == 2) {
                      //确认上传
                      if (ispressAdd) {
                        widget.delegateDetailBloc
                            .addContractAction(widget.orderId, myupList)
                            .then((onValue) {
                          widget.delegateDetailBloc
                              .getviewContract(widget.orderId);
                        });
                        ispressAdd = false;
                        setState(() {
                          flag = 1; //编辑合同
                          isEdit = false; //隐藏删除图标
                        });
                        print('$myupList');
                      } else {
                        widget.delegateDetailBloc.showToast('没有做任何修改');
                      }
                    } else {
                      //点击编辑合同
                      setState(() {
                        isEdit = !isEdit;
                        flag = 2;
                      });
                    }
                  },
                ),
              ),
            ],
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}

//暂无合同信息
class ContractNullContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        // height: MediaQuery.of(context).size.height - 395,
        margin: EdgeInsets.only(
          top: 50,
        ),
        child: Center(
          child: Text(
            '暂无合同信息',
            style: TextStyle(
              fontSize: 16,
              color: Colours.gray_99,
            ),
          ),
        ));
  }
}

//上传合同
class ContractPushContent extends StatefulWidget {
  ContractPushContent(
      {Key key,
      this.contractList,
      this.isEdit,
      this.delegatedetailBloc,
      this.callback})
      : super(key: key);
  List<ViewContractItemModel> contractList;
  bool isEdit;
  DelegateDetailBloc delegatedetailBloc;
  final callback;
  @override
  State<StatefulWidget> createState() => _ContractPushContent();
}

class _ContractPushContent extends State<ContractPushContent>
    with AutomaticKeepAliveClientMixin {
  bool hideSelPicker = true;
  int selBtn;
  File frontImg;
  DelegateDetailBloc delegatedetailBloc = DelegateDetailBloc();

  @override
  void initState() {
    super.initState();
  }

  // List<Asset> images = List<Asset>();
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  Future<void> loadAssets() async {
    setState(() {
      images = images;
    });

    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    List<List<int>> myupList = [];

    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: 9 - images.length,
          enableCamera: true,
          selectedAssets: images, //List<Asset>()
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            actionBarColor: '#ff7200',
            actionBarTitle: "YOUXINBAO App",
            allViewTitle: "All Photos",
            selectCircleStrokeColor: "#000000",
          ));
    } on PlatformException catch (e) {
      error = e.message;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    images = List<Asset>();
    if (widget.isEdit) {
      // setState(() {
      widget.contractList = [];
      // });
    }

    images.addAll(resultList);
    _error = error;
    // operation(images, myupList);
    // myupList = myupList;
    myupList = [];
    for (int i = 0; i < images.length; i++) {
      List<int> list;
      Asset asset = images[i];
      ByteData data = await asset.requestOriginal(quality: 80);
      list = data.buffer.asUint8List();
      myupList.add(list);
      if (i == images.length - 1) {
        widget.callback(myupList);
      }
    }
    widget.callback(myupList);
    setState(() {
      // widget.contractList = resultList.cast<ViewContractItemModel>();
    });
  }

  Future<void> operation(images, myupList) async {
    for (int i = 0; i < images.length; i++) {
      List<int> list;
      Asset asset = images[i];
      ByteData data = await asset.requestOriginal(quality: 80);
      list = data.buffer.asUint8List();
      myupList.add(list);
      if (i == images.length - 1) {
        widget.callback(myupList);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    delegatedetailBloc.bloccontext = context;

    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            top: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                ),
                child: Column(
                  children: <Widget>[
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: widget.contractList.length == 0
                          ? images.length == 0
                              ? [
                                  GestureDetector(
                                    onTap: loadAssets,
                                    child: Container(
                                      color: Theme.of(context).dividerColor,
                                      width: 100,
                                      height: 70,
                                      child: Icon(
                                        Icons.add,
                                        size: 50.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                ]
                              : List.generate((images.length + 1), (index) {
                                  if (index != images.length) {
                                    Asset asset = images[index];
                                    return AssetThumbCustom(
                                      asset: asset,
                                      width: 100,
                                      height: 70,
                                      index: index,
                                      valueChanged: (index) {
                                        setState(() {
                                          images.removeAt(index);
                                          List<List<int>> myupList = [];
                                          operation(images, myupList);
                                        });
                                      },
                                    );
                                  } else {
                                    if (images.length < 9) {
                                      return GestureDetector(
                                        onTap: loadAssets,
                                        child: Container(
                                          color: Theme.of(context).dividerColor,
                                          width: 100,
                                          height: 70,
                                          child: Icon(
                                            Icons.add,
                                            size: 50.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }
                                })
                          : List.generate((widget.contractList.length + 1),
                              (index) {
                              if (index != widget.contractList.length) {
                                return Stack(
                                  alignment: FractionalOffset(4.3, -1.0),
                                  children: <Widget>[
                                    Container(
                                      // width: 162,
                                      width: 100,
                                      height: 70,
                                      color: Colours.white_color,
                                      padding: EdgeInsets.all(5),
                                      child: FadeInImage.assetNetwork(
                                        placeholder:
                                            "assets/images/user/img_default.jpeg",
                                        image: widget
                                            .contractList[index].contractUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Offstage(
                                        offstage: !widget.isEdit,
                                        child: MaterialButton(
                                          height: 20,
                                          padding: EdgeInsets.all(0),
                                          onPressed: () {
                                            //删除图片
                                            widget.delegatedetailBloc
                                                .deleteContractAction(
                                                    widget.contractList[index]
                                                        .applyId,
                                                    widget.contractList[index]
                                                        .fileName);
                                            setState(() {
                                              print(1111111111111);
                                              print(widget.contractList);
                                              widget.contractList
                                                  .removeAt(index);
                                              widget.callback(
                                                  widget.contractList);
                                              print(widget.contractList);
                                              print(1111111111111);
                                            });
                                          },
                                          child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colours.orange_72,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '-',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )),
                                        )),
                                  ],
                                );
                              } else {
                                if (images.length < 9) {
                                  return Offstage(
                                      offstage: !widget.isEdit,
                                      child: GestureDetector(
                                        onTap: loadAssets,
                                        child: Container(
                                          color: Theme.of(context).dividerColor,
                                          width: 100,
                                          height: 70,
                                          child: Icon(
                                            Icons.add,
                                            size: 50.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ));
                                } else {
                                  return Container();
                                }
                              }
                            }),
                    ),
                    // Wrap(
                    //   spacing: 20,
                    //   runSpacing: 20,
                    //   children: images.length != 0
                    //       ? Column(
                    //           children:
                    //               List.generate((images.length + 1), (index) {
                    //             Asset asset = images[index];
                    //             return AssetThumbCustom(
                    //               asset: asset,
                    //               width: 100,
                    //               height: 70,
                    //               index: index,
                    //               valueChanged: (index) {
                    //                 setState(() {
                    //                   images.removeAt(index);
                    //                   print(123);
                    //                   print(images);
                    //                   print(images.length);
                    //                   List myupList = [];
                    //                   operation(images, myupList);
                    //                 });
                    //               },
                    //             );
                    //           }),
                    //         )
                    //       : [Container()],
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

//编辑合同
class ContractEditContent extends StatefulWidget {
  ContractEditContent({Key key, this.contractList}) : super(key: key);
  List<ViewContractItemModel> contractList;
  @override
  State<StatefulWidget> createState() => _ContractEditContent();
}

class _ContractEditContent extends State<ContractEditContent> {
  bool isEdit = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Stack(
                  alignment: FractionalOffset(1.55, -0.25),
                  children: <Widget>[
                    Container(
                      width: 162,
                      height: 125,
                      color: Colours.white_color,
                      padding: EdgeInsets.all(5),
                      child:
                          Image.asset(ImgPrefix.manager_prefix + 'avatar.png'),
                    ),
                    Offstage(
                      offstage: !isEdit,
                      child: MaterialButton(
                        child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colours.orange_72,
                            ),
                            child: Center(
                              child: Text(
                                '-',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                Stack(
                  alignment: FractionalOffset(1.55, -0.25),
                  children: <Widget>[
                    Container(
                      width: 162,
                      height: 125,
                      color: Colours.white_color,
                      padding: EdgeInsets.all(5),
                      child:
                          Image.asset(ImgPrefix.manager_prefix + 'avatar.png'),
                    ),
                    Offstage(
                      offstage: !isEdit,
                      child: MaterialButton(
                        child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colours.orange_72,
                            ),
                            child: Center(
                              child: Text(
                                '-',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
