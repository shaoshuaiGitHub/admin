import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:youxinbao/common/component_index.dart';

Map applyStatusMap = {
  0: '待审核',
  1: '已通过',
  2: '已拒绝',
  3: '补充资料中',
};
Map delegateTypeMap = {
  0: '未代管',
  1: '单次代还',
  2: '精养代操',
  3: '提额代操',
};
Map planTypeMap = {
  1: '消费计划',
  2: '还款计划',
};

Map statusMap = {
  '1': '待消费', //待消费（消费计划）
  '2': '待还款', //待还款（还款计划）
  '3': '待确认', //待确认（还款计划）
  '4': '完成',
  '-1': '问题订单',
};
Map roleTypeMap = {
  1: '普通用户',
  2: '管理师',
  4: '资金方',
};
Map payStatusMap = {
  '0': '未出账',
  '1': '已出账',
  '2': '还款部分 ',
  '3': '已还款',
  '4': '已逾期 ',
  '-1': '无数据',
};
Map isCertificationMap = {0: '未实名', 1: '已实名'};
Map applyCapitalStatusMap = {
  '-2': '解除成功',
  '-1': '申请解除',
  '0': '申请中',
  '1': '通过',
  '2': '拒绝',
  '-4': '撤销成功'
};

///通用模型
class LanguageModel {
  String titleId;
  String languageCode;
  String countryCode;
  bool isSelected;

  LanguageModel(this.titleId, this.languageCode, this.countryCode,
      {this.isSelected: false});

  LanguageModel.fromJson(Map<String, dynamic> json)
      : titleId = json['titleId'],
        languageCode = json['languageCode'],
        countryCode = json['countryCode'],
        isSelected = json['isSelected'];

  Map<String, dynamic> toJson() => {
        'titleId': titleId,
        'languageCode': languageCode,
        'countryCode': countryCode,
        'isSelected': isSelected,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"titleId\":\"$titleId\"");
    sb.write(",\"languageCode\":\"$languageCode\"");
    sb.write(",\"countryCode\":\"$countryCode\"");
    sb.write('}');
    return sb.toString();
  }
}

class SplashModel {
  String title;
  String content;
  String url;
  String imgUrl;

  SplashModel({this.title, this.content, this.url, this.imgUrl});

  SplashModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        content = json['content'],
        url = json['url'],
        imgUrl = json['imgUrl'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'url': url,
        'imgUrl': imgUrl,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"title\":\"$title\"");
    sb.write(",\"content\":\"$content\"");
    sb.write(",\"url\":\"$url\"");
    sb.write(",\"imgUrl\":\"$imgUrl\"");
    sb.write('}');
    return sb.toString();
  }
}

class VersionModel {
  String title;
  String content;
  String url;
  String version;

  VersionModel({this.title, this.content, this.url, this.version});

  VersionModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        content = json['content'],
        url = json['url'],
        version = json['version'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'url': url,
        'version': version,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"title\":\"$title\"");
    sb.write(",\"content\":\"$content\"");
    sb.write(",\"url\":\"$url\"");
    sb.write(",\"version\":\"$version\"");
    sb.write('}');
    return sb.toString();
  }
}

//获取用户中心信息
class UserInfoModel {
  var name;
  String sex;
  String icon;
  String provinces;
  String city;
  String birthDay;
  String createTime;
  int isCertification;
  int uid;
  var phone;
  int roleType;
  num myAuthMoney;
  num remainAuthMoney;
  num withdraw;
  num workAge;
  num money;
  num balance;
  num todayIncome;
  num curMonthIncome;
  num totalIncome;
  num unavailable;

  UserInfoModel.fromJson(Map json) {
    name = json['name'];
    sex = json['sex'];
    icon = json['icon'];
    provinces = json['provinces'];
    city = json['city'];
    birthDay = json['birthDay'];
    createTime = json['createTime'];
    isCertification = json['isCertification'];
    uid = json['uid'];
    phone = json['phone'];
    roleType = json['roleType'];
    myAuthMoney = json['myAuthMoney'];
    remainAuthMoney = json['remainAuthMoney'];
    withdraw = json['withdraw'];
    workAge = json['workAge'];
    money = json['money'];
    balance = json['balance'];
    totalIncome = json['totalIncome'];
    curMonthIncome = json['curMonthIncome'];
    todayIncome = json['todayIncome'];
    unavailable = json['unavailable'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sex': sex,
      'icon': icon,
      'provinces': provinces,
      'city': city,
      'birthDay': birthDay,
      'createTime': createTime,
      'isCertification': isCertification,
      'uid': uid,
      'phone': phone,
      'roleType': roleType,
      'name': name,
      'myAuthMoney': myAuthMoney,
      'remainAuthMoney': remainAuthMoney,
      'withdraw': withdraw,
      'workAge': workAge,
      'money': money,
      'balance': balance,
      'totalIncome': totalIncome,
      'curMonthIncome': curMonthIncome,
      'todayIncome': todayIncome,
      'unavailable': unavailable,
    };
  }
}

///用户端
//用户模型
class UserModel {
  String token;
  int id;
  var nickname;
  String avatarUrl;
  String roleType = "0";
  String isCertification;
  String isFirstLogin;
  List privilegeList;

  UserModel.fromJson(Map json) {
    token = json['token'];
    id = json['id'];
    nickname = json['nickname'];
    avatarUrl = json['avatar'];
    roleType = json['roleType'].toString();
    isFirstLogin = json['isFirstLogin'].toString();
    isCertification = json['isCertification'] != null
        ? json['isCertification'].toString()
        : "0";
    privilegeList = json['privilegeList'];
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'id': id,
      'nickname': nickname,
      'avatar': avatarUrl,
      'roleType': roleType,
      'isFirstLogin': isFirstLogin,
      'isCertification': isCertification,
      'privilegeList': privilegeList
    };
  }
}

//首页数据模型
class CardInfoModel {
  List<dynamic> cardList;
  num cardCount;
  num totalAccLimit;
  num totalAccCost;
  num totalAccLimitRepay;
  num totalUsableMoney;
  num totalDelegateMoney;
  num actualMoney;
  num delegateCount;
  num undelegateCount;

  CardInfoModel(this.cardCount);

  CardInfoModel.fromJson(Map json) {
    cardList = json["cardList"].map((value) {
      return CardItemModel.fromJson(value);
    }).toList();
    cardCount = json['cardCount'];
    totalAccLimit = json['totalAccLimit'];
    totalAccCost = json['totalAccCost'];
    totalAccLimitRepay = json['totalAccLimitRepay'];
    totalUsableMoney = json['totalUsableMoney'];
    totalDelegateMoney = json['totalDelegateMoney'];
    actualMoney = json['actualMoney'];
    delegateCount = json['delegateCount'];
    undelegateCount = json['undelegateCount'];
  }
}

//首页卡片列表模型
class CardItemModel {
  num id;
  num bankId;
  num userId;
  var name;
  dynamic cardId;
  var cardName;
  var bankName;
  num accDay;
  num accPayday;
  num accLimit;
  num accLimitCost;
  num accLimitRepay;
  num usableMoney;
  num payStatus;
  num credit;
  num delegate;
  String updateTime;
  String createTime;
  num status;
  num isDelegated;
  num delegateType;
  var masterName;
  num delegateMoney;
  String icon;
  num isDiagnose;
  var nearAccPayday;
  var nearAccDay;
  num nearAccDays;
  num nearAccPaydays;
  num bankCode;

  CardItemModel();

  CardItemModel.fromJson(Map json) {
    id = json['id'];
    bankId = json['bankId'];
    userId = json['userId'];
    name = json['name'];
    cardId = json['cardId'];
    cardName = json['cardName'];
    bankName = json['bankName'];
    accDay = json['accDay'];
    accPayday = json['accPayday'] == "" ? 0 : json['accPayday'];
    accLimit = json['accLimit'];
    accLimitCost = json['accLimitCost'];
    accLimitRepay = json['accLimitRepay'];
    usableMoney = json['usableMoney'];
    payStatus = json['payStatus'];
    credit = json['credit'];
    delegate = json['delegate'];
    updateTime = json['updateTime'];
    createTime = json['createTime'];
    status = json['status'];
    isDelegated = json['isDelegated'];
    delegateType = json['delegateType'];
    masterName = json['masterName'];
    delegateMoney = json['delegateMoney'];
    icon = json['icon'];
    isDiagnose = json['isDiagnose'];
    nearAccPayday = json['nearAccPayday'];
    nearAccDay = json['nearAccDay'];
    nearAccDays = json['nearAccDays'];
    nearAccPaydays = json['nearAccPaydays'];
    bankCode = json['bankCode'];
  }
}

//可添加卡片列表项
class AddCardListItem {
  num id;
  num code;
  String cn;
  String icon;
  num sort;
  AddCardListItem.fromJson(Map json) {
    id = json['id'];
    code = json['code'];
    cn = json['cn'];
    icon = json['icon'];
    sort = json['sort'];
  }
}

//获取诊断信用卡项
class DiagnoseCardItem {
  num id;
  String bankName;
  num accLimit;
  dynamic cardId;
  num isDiagnose;
  String lastTime;
  String color;
  String icon;

  DiagnoseCardItem();

  DiagnoseCardItem.fromJson(Map json) {
    id = json['id'];
    bankName = json['bankName'];
    accLimit = json['accLimit'];
    cardId = json['cardId'];
    isDiagnose = json['isDiagnose'];
    lastTime = json['lastTime'];
    color = json['color'];
    icon = json['icon'];
  }
}

//获取诊断信用卡列表信息
class DiagnoseCardInfo {
  List<dynamic> cardList;
  num totalAccLimit;
  num totalCardCount;
  String icon;
  num account;

  DiagnoseCardInfo.fromJson(Map json) {
    cardList = json["cardList"].map((value) {
      return DiagnoseCardItem.fromJson(value);
    }).toList();
    totalAccLimit = json['totalAccLimit'];
    totalCardCount = json['totalCardCount'];
    icon = json['icon'];
    account = json['account'];
  }
}

//资金端
//整体计划信息模型
class PlanListModel {
  int page;
  List<dynamic> dataList;
  PlanListModel.fromJson(Map json) {
    dataList = json["dataList"].map((value) {
      return PlanItemModel.fromJson(value);
    }).toList();
    page = json['page'];
  }
}

class PlanItemModel {
  int id;
  String bankName;
  int cardNo;
  var masterName;
  var ownerName;
  var usableMoney;
  var accLimit;
  int status;
  String updateTime;
  String finishTime;
  String startTime;
  String endTime;
  var repayMinMoney;
  var repayMaxMoney;
  int type;
  int delegateType;
  var realMoney;
  String icon;
  var paymentMoney;
  var isPayment;
  String paymentTime;
  PlanItemModel.fromJson(Map json) {
    id = json['id'];
    bankName = json['bankName'];
    cardNo = json['cardNo'];
    masterName = json['masterName'];
    ownerName = json['ownerName'];
    usableMoney = json['usableMoney'];
    accLimit = json['accLimit'];
    status = json['status'];
    updateTime = json['updateTime'];
    finishTime = json['finishTime'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    repayMinMoney = json['repayMinMoney'];
    repayMaxMoney = json['repayMaxMoney'];
    type = json['type'];
    delegateType = json['delegateType'];
    icon = json['icon'];
    realMoney = json['realMoney'];
    paymentMoney = json['paymentMoney'];
    isPayment = json['isPayment'];
    paymentTime = json['paymentTime'];
  }
}

//对账中心列表信息模型
class BanlanceListModel {
  num noRepayMoney;
  List<dynamic> dataList;
  BanlanceListModel.fromJson(Map json) {
    dataList = json["dataList"].map((value) {
      return BanlanceItemModel.fromJson(value);
    }).toList();
    noRepayMoney = json['noRepayMoney'];
  }
}

class BanlanceItemModel {
  var masterName;
  String date;
  String checkTime;
  int masterId;
  List<dynamic> cardList;
  BanlanceItemModel.fromJson(Map json) {
    masterName = json['masterName'];
    date = json['date'];
    checkTime = json['checkTime'];
    masterId = json['masterId'];
    cardList = json["cardList"].map((value) {
      return BanlanceCardItemModel.fromJson(value);
    }).toList();
  }
}

class BanlanceCardItemModel {
  var cardNo;
  num incomeMoney;
  num totalMoney;
  List<dynamic> delegateTypeList;
  BanlanceCardItemModel.fromJson(Map json) {
    cardNo = json['cardNo'];
    incomeMoney = json['incomeMoney'];
    totalMoney = json['totalMoney'];
    delegateTypeList = json["delegateTypeList"];
  }
}

//对账中心详情信息模型
class BanlanceDetailModel {
  List<dynamic> dataList;
  BanlanceDetailModel.fromJson(Map json) {
    dataList = json["dataList"].map((value) {
      return BanlanceDetailItemModel.fromJson(value);
    }).toList();
  }
}

class BanlanceDetailItemModel {
  var name;
  num minMoney;
  num realMoney;
  var cardNo;
  var bankName;
  String icon;
  int planType;
  String start;
  String end;
  String updateTime;
  String finishTime;
  int status;
  var posName;
  num posRate;
  num consumMoney;
  String posFinishTime;
  BanlanceDetailItemModel.fromJson(Map json) {
    name = json['name'];
    minMoney = json['minMoney'];
    realMoney = json['realMoney'];
    cardNo = json["cardNo"];
    bankName = json['bankName'];
    icon = json['icon'];
    planType = json["planType"];
    start = json['start'];
    end = json['end'];
    updateTime = json["updateTime"];
    finishTime = json['finishTime'];
    status = json['status'];
    posName = json["posInfo"]["posName"];
    posRate = json["posInfo"]["posRate"];
    consumMoney = json["posInfo"]["consumMoney"];
    posFinishTime = json["posInfo"]["finishTime"];
  }
}

//获取提现信息模型
class WithdrawModel {
  int hasWithdrawPwd;
  num totalMoney;
  List<dynamic> cardList;
  WithdrawModel.fromJson(Map json) {
    cardList = json["cardList"].map((value) {
      return WithdrawCardItemModel.fromJson(value);
    }).toList();
    totalMoney = json['totalMoney'];
    hasWithdrawPwd = json['hasWithdrawPwd'];
  }
}

class WithdrawCardItemModel {
  int id;
  String icon;
  var name;
  int cardNo;
  WithdrawCardItemModel.fromJson(Map json) {
    id = json['id'];
    icon = json['icon'];
    name = json['name'];
    cardNo = json['cardNo'];
  }
}

//获取提现记录模型
class WithdrawLogModel {
  int page;
  List<dynamic> logList;
  WithdrawLogModel.fromJson(Map json) {
    logList = json["dataList"].map((value) {
      return LogItemModel.fromJson(value);
    }).toList();
  }
}

class LogItemModel {
  int id;
  num money;
  num remainMoney;
  String create_time;
  String update_time;
  var status;
  var msg;
  LogItemModel.fromJson(Map json) {
    id = json['id'];
    money = json['money'];
    remainMoney = json['remainMoney'];
    create_time = json['create_time'];
    update_time = json['update_time'];
    status = json['status'];
    msg = json['msg'];
  }
}

//我的Pos机数据模型
class PosListModel {
  List<dynamic> posList;
  PosListModel.fromJson(Map json) {
    posList = json["dataList"].map((value) {
      return PosItemModel.fromJson(value);
    }).toList();
  }
}

//pos机列表模型
class PosItemModel {
  int id;
  int ownerId;
  int masterId;
  int posId;
  int bankNo;
  var bankName;
  var alias;
  String createTime;
  String updateTime;
  int status;
  var masterName;
  double rate;
  var posName;
  PosItemModel.fromJson(Map json) {
    id = json['id'];
    ownerId = json['ownerId'];
    masterId = json['masterId'];
    posId = json['posId'];
    bankNo = json['bankNo'];
    bankName = json['bankName'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    status = json['status'];
    masterName = json['masterName'];
    rate = json['rate'];
    posName = json['posName'];
    alias = json['alias'];
  }
}

//获取可用POS机数据模型
class PosInfoListModel {
  var typeList;
  var posInfoList;
  PosInfoListModel.fromJson(Map json) {
    typeList = json["typeList"].map((value) {
      return TypeList.fromJson(value);
    });
    posInfoList = json["posInfoList"].map((value) {
      return PosInfoList.fromJson(value);
    });
  }
}

class TypeList {
  int id;
  var name;
  String createTime;
  String updateTime;
  int status;
  TypeList.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    status = json['status'];
  }
}

class PosInfoList {
  int id;
  int type;
  String posName;
  num rate;
  String createTime;
  String updateTime;
  int status;
  PosInfoList.fromJson(Map json) {
    id = json['id'];
    type = json['type'];
    posName = json['posName'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    status = json['status'];
  }
}

//我的管理师数据模型
class ManagerListModel {
  int page;
  List<dynamic> managerList;
  ManagerListModel.fromJson(Map json) {
    managerList = json["dataList"].map((value) {
      return ManagerItemModel.fromJson(value);
    }).toList();
    page = json['page'];
  }
}

//管理师列表模型
class ManagerItemModel {
  int id;
  int masterId;
  var name;
  String icon;
  num authMoney;
  int account;
  ManagerItemModel.fromJson(Map json) {
    id = json['id'];
    masterId = json['masterId'];
    name = json['name'];
    icon = json['icon'];
    authMoney = json['authMoney'];
    account = json['account'];
  }
}

//管理师详细信息数据模型
class MyMasterDetailModel {
  String icon;
  var name;
  var account;
  String tips;
  num totalRepayCount;
  num totalRepayMoney;
  num totalConsumeMoney;
  num totalConsumeCount;
  num authMoney;
  num usableAuthMoney;
  num totalDelegateMoney;
  num totalDelegateCount;
  List<dynamic> cardList;
  List<dynamic> posList;
  String sex;
  String provinces;
  String city;
  int UID;
  var cardId;
  String cardA;
  String cardB;
  int age;
  int workAge;
  int masterLevel;
  MyMasterDetailModel.fromJson(Map json) {
    cardList = json["cardList"].map((value) {
      return MyMasterDetailItemModel.fromJson(value);
    }).toList();
    posList = json["posList"].map((value) {
      return MyMasterPosItemModel.fromJson(value);
    }).toList();
    icon = json['icon'];
    name = json['name'];
    account = json['account'];
    tips = json['tips'];
    totalRepayCount = json['totalRepayCount'];
    totalRepayMoney = json['totalRepayMoney'];
    totalConsumeMoney = json['totalConsumeMoney'];
    totalConsumeCount = json['totalConsumeCount'];
    authMoney = json['authMoney'];
    usableAuthMoney = json['usableAuthMoney'];
    totalDelegateMoney = json['totalDelegateMoney'];
    totalDelegateCount = json['totalDelegateCount'];
    sex = json['sex'];
    provinces = json['provinces'];
    city = json['city'];
    UID = json['UID'];
    cardId = json['cardId'];
    cardA = json['cardA'];
    cardB = json['cardB'];
    age = json['age'];
    workAge = json['workAge'];
    masterLevel = json['masterLevel'];
  }
}

class MyMasterDetailItemModel {
  var name;
  String icon;
  String bankName;
  var cardNo;
  num accLimitMoney;
  num usableMoney;
  MyMasterDetailItemModel.fromJson(Map json) {
    name = json['name'];
    icon = json['icon'];
    bankName = json['bankName'];
    cardNo = json['cardNo'];
    accLimitMoney = json['accLimitMoney'];
    usableMoney = json['usableMoney'];
  }
}

class MyMasterPosItemModel {
  int id;
  String name;
  String alias;
  num rate;
  MyMasterPosItemModel.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
    alias = json['alias'];
    rate = json["rate"];
  }
}

//个人中心明细模型
class DetailListModel {
  List<dynamic> dataList;
  num totalWardMoney;
  num wardMoney;
  num totalPosMoney;
  num page;
  DetailListModel.fromJson(Map json) {
    dataList = json["dataList"].map((value) {
      return DetailItemModel.fromJson(value);
    }).toList();
    totalWardMoney = json['totalWardMoney'];
    wardMoney = json['wardMoney'];
    totalPosMoney = json['totalPosMoney'];
    page = json["page"];
  }
}

class DetailItemModel {
  var masterName;
  var name;
  num minMoney;
  num realMoney;
  var bankName;
  String icon;
  int planType;
  String start;
  String end;
  String updateTime;
  String finishTime;
  int status;
  int paymentStatus;
  num payment;
  var posName;
  num posRate;
  var planCardNo;
  var cardNo;
  num posPayment;
  num delegateType;

  DetailItemModel.fromJson(Map json) {
    masterName = json['masterName'];
    name = json['name'];
    minMoney = json['minMoney'];
    realMoney = json['realMoney'];
    bankName = json['bankName'];
    icon = json['icon'];
    planCardNo = json['cardNo'];
    planType = json['planType'];
    start = json['start'];
    end = json['end'];
    updateTime = json['updateTime'];
    finishTime = json['finishTime'];
    status = json['status'];
    delegateType = json['delegateType'];
    payment = json['payment'];
    paymentStatus = json['paymentStatus'];
    if (json['posInfo'] != null) {
      posName = json['posInfo']['posName'];
    }
    if (json['posInfo'] != null) {
      posRate = json['posInfo']['posRate'];
    }
    if (json['posInfo'] != null) {
      cardNo = json['posInfo']['cardNo'];
    }
    if (json['posInfo'] != null) {
      posPayment = json['posInfo']['posPayment'];
    }
  }
}

//历史往来数据模型
class MasterHistoryModel {
  List<dynamic> dataList;
  num totalRepayMoney;
  num totalPosMoney;
  num page;
  MasterHistoryModel.fromJson(Map json) {
    dataList = json["dataList"].map((value) {
      return MasterHistoryItemModel.fromJson(value);
    }).toList();
    totalRepayMoney = json['totalRepayMoney'];
    totalPosMoney = json['totalPosMoney'];
    page = json["page"];
  }
}

class MasterHistoryItemModel {
  var name;
  num minMoney;
  num realMoney;
  String bankName;
  String icon;
  int planType;
  String start;
  String end;
  String updateTime;
  int status;
  String posName;
  num posRate;
  num cardNo;
  num posPayment = 0;
  num remainMoney = 0;
  String finishTime;
  num payment = 0;
  int paymentStatus;
  num posRealMoney = 0;
  num bankNo;
  num delegateType;
  MasterHistoryItemModel.fromJson(Map json) {
    name = json['name'];
    minMoney = json['minMoney'];
    realMoney = json["realMoney"];
    bankName = json['bankName'];
    bankNo = json['bankNo'];
    icon = json["icon"];
    planType = json['planType'];
    start = json["start"];
    end = json['end'];
    updateTime = json["updateTime"];
    status = json['status'];
    delegateType = json['delegateType'];
    finishTime = json['finishTime'];
    if (json['payment'] != null) {
      payment = json['payment'];
    }
    if (json['paymentStatus'] != null) {
      paymentStatus = json['paymentStatus'];
    }
    if (json['posInfo'] != null) {
      posName = json['posInfo']['posName'];
    }
    if (json['posInfo'] != null) {
      posRate = json['posInfo']['posRate'];
    }
    if (json['posInfo'] != null) {
      cardNo = json['posInfo']['cardNo'];
    }
    if (json['posInfo'] != null) {
      posPayment = json['posInfo']['posPayment'];
    }
    if (json['posInfo'] != null) {
      remainMoney = json['posInfo']['remainMoney'];
    }
    if (json['posInfo'] != null) {
      posRealMoney = json['posInfo']['realMoney'];
    }
  }
}

//我的银行卡数据模型
class ReceiveCardListModel {
  List<dynamic> bankList;
  ReceiveCardListModel.fromJson(Map json) {
    bankList = json["dataList"].map((value) {
      return ReceiveCardItemModel.fromJson(value);
    }).toList();
  }
}

class ReceiveCardItemModel {
  String bankName;
  var cardId;
  String icon;
  int id;
  ReceiveCardItemModel.fromJson(Map json) {
    bankName = json['bankName'];
    icon = json['icon'];
    cardId = json['cardId'];
    id = json['id'];
  }
}

//可添加收款银行数据模型
class ReceiveBankListModel {
  List<dynamic> bankList;
  // var userData;
  ReceiveBankListModel.fromJson(Map json) {
    bankList = json["dataList"].map((value) {
      return ReceiveBankItemModel.fromJson(value);
    }).toList();
  }
}

class ReceiveBankItemModel {
  int id;
  var name;
  String icon;
  ReceiveBankItemModel.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
  }
}

//管理师
//计划管理-订单详情
class OrderDetailModel {
  var name;
  var icon;
  int uid;
  var phone;
  var idCardNO;
  var idCardImagesA;
  var idCardImagesB;
  var creditScore;
  var platformStatus;
  var delegateType;
  var delegateMoney;
  var accLimitMoney;
  var reportImage;
  var updateTime;
  var applyMsg;
  List delegateCardList;
  var cardIds;
  var delegateCardCount;

  OrderDetailModel.fromJson(Map json) {
    name = json['name'];
    icon = json['icon'];
    phone = json['phone'];
    idCardNO = json['idCardNO'];
    idCardImagesA = json['idCardImages']['A'];
    idCardImagesB = json['idCardImages']['B'];
    creditScore = json['creditScore'];
    platformStatus = json['platformStatus'];
    delegateType = delegateTypeMap[json['delegateType']];
    delegateMoney = json['delegateMoney'];
    accLimitMoney = json['accLimitMoney'];
    reportImage = json['reportImage'];
    applyMsg = json['applyMsg'];
    updateTime = json['updateTime'];
    cardIds = json['cardIds'];
    uid = json['UID'];
    delegateCardCount = json['delegateCardCount'];

    delegateCardList = json["delegateCardList"].map((value) {
      return DelegateCardListModel.fromJson(value);
    }).toList();
  }
}

class OrderCardListModel {
  List dataList;
  OrderCardListModel.fromJson(Map json) {
    dataList = json["dataList"].map((value) {
      return CustomerDetailItemModel.fromJson(value);
    }).toList();
  }
}

class DelegateCardListModel {
  var cardNo;
  var bankName;
  var money;
  var bankIcon;
  var cardId;

  DelegateCardListModel.fromJson(Map json) {
    bankName = json['bankName'];
    cardNo = json['cardNo'];
    bankIcon = json['bankIcon'];
    money = json['money'];
    cardId = json['cardId'];
  }
}

//管理师
//计划管理-订单列表
class OrderListModel {
  // String page;
  List<dynamic> orderList;
  int count;
  int num;
  OrderListModel.fromJson(Map json) {
    orderList = json["dataList"].map((value) {
      // num = num+1;
      return OrderItemModel.fromJson(value);
    }).toList();
    // orderList.insert(json["dataList"].length,json["dataList"].length);
    // print(orderList);
    count = json['count'];
  }
}

class OrderItemModel {
  int id;
  var name;
  String icon;
  int cardCount;
  String createTime;
  String applyStatus;
  String delegateType;
  num delegateMoney;

  OrderItemModel.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    cardCount = json['cardCount'];
    createTime = json['createTime'];
    applyStatus = applyStatusMap[json['applyStatus']];
    delegateType = delegateTypeMap[json['delegateType']];
    delegateMoney = json['delegateMoney'];
  }
}

//管理师
//计划管理-订单列表
class AllPlanListModel {
  // String page;
  List<dynamic> allplanList;
  AllPlanListModel.fromJson(Map json) {
    allplanList = json["dataList"].map((value) {
      return AllplanItemModel.fromJson(value);
    }).toList();
    //  page = json['page'];
  }
}

class AllplanItemModel {
  num id;

  num minMoney;
  num maxMoney;

  num accLimitMoney;
  var cardNo;
  num usableMoney;
  num flag;
  num realMoney;
  String bankName;
  String planType;
  String delegateType;
  var payment;
  String paymentTime;

  String icon;
  String createTime;
  String updateTime;
  String startTime;
  String endTime;
  var name;
  String status;
  var info;
  var accPayday;
  var accDay;
  var accDays;
  var accPaydays;
  var msg;

  AllplanItemModel.fromJson(Map json) {
    id = json['id'];
    planType = planTypeMap[json['planType']];
    minMoney = json['minMoney'];
    maxMoney = json['maxMoney'];
    delegateType = delegateTypeMap[json['delegateType']];

    accLimitMoney = json['accLimitMoney'];
    cardNo = json['cardNo'];
    usableMoney = json['usableMoney'];
    flag = json['flag'];
    realMoney = json['realMoney'];
    updateTime = json['updateTime'].substring(0, json['updateTime'].length - 3);
    endTime = json['endTime'].substring(0, json['endTime'].length - 3);
    startTime = json['startTime'].substring(0, json['startTime'].length - 3);
    createTime = json['createTime'];
    info = json['info'];
    bankName = json['bankName'];
    icon = json['icon'];
    name = json['name'];
    payment = json['payment'];
    status = statusMap[json['status'].toString()];
    accPayday = json['accPayday'];
    accDay = json['accDay'];
    paymentTime = json['paymentTime'];
    accPaydays = json['accPaydays'];
    accDays = json['accDays'];
    msg = json['msg'];
  }
}

//管理师
//计划管理-订单列表
class CapitalListModel {
  // String page;
  List<dynamic> orderList;
  CapitalListModel.fromJson(Map json) {
    print(json);
    orderList = json["dataList"].map((value) {
      return CapitalItemModel.fromJson(value);
    }).toList();
    //  page = json['page'];
  }
}

//管理师
//计划管理-计划详情
class AllplanItemDetailModel {
  var id;
  var minMoney;
  var maxMoney;
  var accLimitMoney;
  var cardNo;
  var usableMoney;
  var flag;
  var realMoney;
  var bankName;
  var planType;
  var delegateType;
  var icon;
  var createTime;
  var updateTime;
  var startTime;
  var endTime;
  var name;
  var status;
  var info;
  var capitalname;
  List investorList;
  var accPayday;
  var accDay;
  var accPaydays;
  var accDays;
  var payment;

  AllplanItemDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    minMoney = json['minMoney'];
    maxMoney = json['maxMoney'];
    accLimitMoney = json['accLimitMoney'];
    cardNo = json['cardNo'];
    usableMoney = json['usableMoney'];
    flag = json['flag'];
    realMoney = json['realMoney'];
    updateTime = json['update_time'];
    endTime = json['endTime'].substring(0, json['endTime'].length - 3);
    startTime = json['startTime'].substring(0, json['startTime'].length - 3);
    createTime = json['createTime'];
    info = json['info'];
    bankName = json['bankName'];
    icon = json['icon'];
    delegateType = delegateTypeMap[json['delegateType']];
    planType = planTypeMap[json['type']];
    name = json['name'];
    status = statusMap[json['status'].toString()];
    accPayday = json['accPayday'];
    accDay = json['accDay'];
    accDays = json['accDays'];
    accPaydays = json['accPaydays'];
    payment = json['payment'];
    investorList = json["investorList"].map((value) {
      return CapitalModel.fromJson(value);
    }).toList();

    // capitalname = json['accPayday'];
  }
}

class CapitalModel {
  int id;
  var name;
  List posInfoList;
  CapitalModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    posInfoList = json["posInfoList"].map((value) {
      return PostIdModel.fromJson(value);
    }).toList();
  }
}

class PostIdModel {
  int id;
  var name;
  var alias;
  PostIdModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    alias = json['alias'];
  }
}

//管理师
//个人中心-我的资金方列表
class CapitalSideListModel {
  // String page;
  List<dynamic> capitalList;
  CapitalSideListModel.fromJson(Map json) {
    print(json);
    capitalList = json["dataList"].map((value) {
      return CapitalSideModel.fromJson(value);
    }).toList();
    //  page = json['page'];
  }
}

class CapitalSideModel {
  int uid;
  var name;
  String icon;
  String roleType;
  num account;

  CapitalSideModel.fromJson(Map json) {
    uid = json['UID'];
    roleType = roleTypeMap[json['roleType']];
    account = json['account'];
    name = json['name'];
    icon = json['icon'];
  }
}

//管理师
//个人中心-我的资金方申请列表
class CapitalSideApplyListModel {
  // String page;
  List<dynamic> capitalList;
  CapitalSideApplyListModel.fromJson(Map json) {
    capitalList = json["dataList"].map((value) {
      return CapitalSideApplyItemListModel.fromJson(value);
    }).toList();
    //  page = json['page'];
  }
}

class CapitalSideApplyItemListModel {
  int id;
  var name;
  var icon;
  var applyStatus;
  var updateTime;
  var account;
  var isCertification;
  var sex;
  var area;
  var applyMsg;
  var workAge;

  CapitalSideApplyItemListModel.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    applyStatus = applyCapitalStatusMap[json['applyStatus'].toString()];
    updateTime = json['updateTime'];
    account = json['account'];
    isCertification = isCertificationMap[json['isCertification']];
    sex = json['sex'];
    area = json['area'];
    applyMsg = json['applyMsg'];
    workAge = json['workAge'];
  }
}

class CapitalSideListDetailModel {
  // String page;
  List<dynamic> posInfoList;
  var name;
  var isCertification;
  num account;
  var sex;
  num workAge;
  var area;
  num age;
  num money;
  var isApplyed;
  var icon;
  CapitalSideListDetailModel.fromJson(Map json) {
    posInfoList = json["posInfoList"].map((value) {
      return CapitalSideListDetailItemModel.fromJson(value);
    }).toList();
    //  page = json['page'];
    name = json['name'];
    isCertification = isCertificationMap[json['isCertification']];
    account = json['account'];
    sex = json['sex'];
    workAge = json['workAge'];
    area = json['area'];
    money = json['money'];
    age = json['age'];
    isApplyed = json['isApplyed'];
    icon = json['icon'];
  }
}

class CapitalSideListDetailItemModel {
  num rate;
  String name;

  CapitalSideListDetailItemModel.fromJson(Map json) {
    rate = json['rate'];
    name = json['name'];
  }
}

//管理师
//个人中心-我的资金方申请列表
class MyCapitalSideListModel {
  // String page;
  List<dynamic> mycapitalList;
  MyCapitalSideListModel.fromJson(Map json) {
    print(json);
    mycapitalList = json["dataList"].map((value) {
      return MyCapitalSideModel.fromJson(value);
    }).toList();
    //  page = json['page'];
  }
}

class MyCapitalSideModel {
  int id;
  var name;
  String icon;
  num delegateMoney;
  num cardCount;
  String createTime;
  int applyStatus;

  MyCapitalSideModel.fromJson(Map json) {
    id = json['id'];
    applyStatus = applyStatusMap[json['applyStatus']];
    cardCount = json['cardCount'];
    name = json['name'];
    icon = json['icon'];
    createTime = json['createTime'];
    delegateMoney = json['delegateMoney'];
  }
}

//管理师
//我的客户-对账中心
class AccountCenterListModel {
  // String page;
  List<dynamic> accountCheckList;
  num notReturned;
  num totalInvestor;
  AccountCenterListModel.fromJson(Map json) {
    print(json);
    accountCheckList = json["dataList"].map((value) {
      return AccountCenterItemModel.fromJson(value);
    }).toList();
    notReturned = json['notReturned'];
    totalInvestor = json['totalInvestor'];
    //  page = json['page'];
  }
}

class AccountCenterItemModel {
  String date;
  num repay1;
  num consume1;
  num repay2;
  num consume2;
  num repay3;
  num consume3;
  num totalInvestor;
  int status;

  AccountCenterItemModel.fromJson(Map json) {
    date = json['date'];
    repay1 = json['repay1'];
    consume1 = json['consume1'];
    repay2 = json['repay2'];
    consume2 = json['consume2'];
    repay3 = json['repay3'];
    consume3 = json['consume3'];
    totalInvestor = json['totalInvestor'];
    status = json['status'];
  }
}

//每月
class FinancialMonthListModel {
  List<dynamic> dataList;
  num monthlyTotals;
  FinancialMonthListModel.fromJson(Map json) {
    dataList = json["dataList"].map((value) {
      return FinancialMonthItemModel.fromJson(value);
    }).toList();
    monthlyTotals = json['monthlyTotals'];
  }
}

class FinancialMonthItemModel {
  String dataTime;
  num account;
  FinancialMonthItemModel.fromJson(Map json) {
    dataTime = json['dataTime'];
    account = json['account'];
  }
}

//每日
class FinancialDayListModel {
  List<dynamic> dataList;
  String dataTime;
  num account;
  FinancialDayListModel.fromJson(Map json) {
    dataList = json["dataList"].map((value) {
      return FinancialDayItemModel.fromJson(value);
    }).toList();
    dataTime = json['dayTotals']['dataTime'];
    account = json['dayTotals']['account'];
  }
}

class FinancialDayItemModel {
  String dateTime;
  String type;
  num realMoney;
  String name;
  FinancialDayItemModel.fromJson(Map json) {
    dateTime = json['dateTime'];
    type = delegateTypeMap[json['type']];
    realMoney = json['realMoney'];
    name = json['name'];
  }
}

//财务管理
class FinancialListModel {
  // String page;
  List<dynamic> dataTop;
  List<dynamic> financialList;
  FinancialListModel.fromJson(Map json) {
    dataTop = json["dataTop"].map((value) {
      return DataTopModel.fromJson(value);
    }).toList();

    financialList = json["dataList"].map((value) {
      return FinancialItemModel.fromJson(value);
    }).toList();

    //  page = json['page'];
  }
}

class DataTopModel {
  num totalCost;
  num repay1;
  num repay2;
  num repay3;

  DataTopModel.fromJson(Map json) {
    totalCost = json['totalCost'];
    repay1 = json['repay1'];
    repay2 = json['repay2'];
    repay3 = json['repay3'];
  }
}

class FinancialItemModel {
  num totalCost;
  num repay1;
  num repay2;
  num repay3;
  String date;

  FinancialItemModel.fromJson(Map json) {
    totalCost = json['totalCost'];
    repay1 = json['repay1'];
    repay2 = json['repay2'];
    repay3 = json['repay3'];
    date = json['date'];
  }
}

//资金方列表
class CapitalItemModel {
  int id;
  var name;

  CapitalItemModel.fromJson(Map json) {
    name = json['name'];
  }
}

class GetCreateProfitDataModel {
  List ownerList;
  List cardList;
  num userPaymentScale;
  num masterRewardScale;

  GetCreateProfitDataModel.fromJson(Map json) {
    userPaymentScale = json['userPaymentScale'];
    masterRewardScale = json['masterRewardScale'];
    ownerList = json["ownerList"].map((value) {
      return OwnerListModel.fromJson(value);
    }).toList();

    cardList = json["cardList"].map((value) {
      return CardListModel.fromJson(value);
    }).toList();
  }
}

class MyDetailLiftingListModel {
  List<dynamic> consumList;
  num totalMoney;

  MyDetailLiftingListModel.fromJson(Map json) {
    print(json);
    consumList = json["dataList"].map((value) {
      return MyDetailLiftItemModel.fromJson(value);
    }).toList();
    totalMoney = json['totalMoney'];
  }
}

class MyDetailLiftItemModel {
  int id;
  var name;
  String icon;
  String bankName;
  String cardNo;
  num preMoney;
  num afterMoney;
  String updateTime;
  int reward;
  String delegateType;

  MyDetailLiftItemModel.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    bankName = json['bankName'];
    cardNo = json['cardNo'];
    preMoney = json['preMoney'];
    afterMoney = json['afterMoney'];
    updateTime = json['updateTime'];
    reward = json['reward'];
    delegateType = delegateTypeMap[json['delegateType']];
  }
}
//管理师历史计划

//消费分润
class MyDetailConsumListModel {
  List<dynamic> consumList;
  num totalMoney;

  MyDetailConsumListModel.fromJson(Map json) {
    print(json);
    consumList = json["dataList"].map((value) {
      return MyDetailConsumItemModel.fromJson(value);
    }).toList();
    totalMoney = json['totalMoney'];
  }
}

class MyDetailConsumItemModel {
  String startTime;
  String endTime;
  num minMoney;
  num maxMoney;
  num delegateMoney;
  var info;
  String bankName;
  num cardNo;
  String status;
  num rewardMoney;
  String updateTime;
  var name;
  var delegateType;
  var type;
  String icon;
  String planType;
  num realMoney;

  MyDetailConsumItemModel.fromJson(Map json) {
    startTime = json['startTime'].substring(0, 16);
    endTime = json['endTime'].substring(0, 16);
    minMoney = json['minMoney'];
    maxMoney = json['maxMoney'];
    cardNo = json['cardNo'];
    delegateMoney = json['delegateMoney'];
    info = json['info'];
    updateTime = json['updateTime'];
    bankName = json['bankName'];
    delegateType = delegateTypeMap[json['delegateType']];
    rewardMoney = json['rewardMoney'];
    name = json['name'];
    status = statusMap[json['status']];
    icon = json['icon'];
    planType = planTypeMap[json['type']];
    realMoney = json['realMoney'];
  }
}

class OwnerListModel {
  int id;
  var name;
  num account;

  OwnerListModel.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
    account = json['account'];
  }
}

class CardListModel {
  int userId;
  String name;
  num cardNo;
  String bankName;

  CardListModel.fromJson(Map json) {
    userId = json['userId'];
    name = json['name'];
    cardNo = json['cardNo'];
    bankName = json['bankName'];
  }
}

//管理师申请数据模型
class MasterApplyListModel {
  int page;
  List<dynamic> masterApplyList;
  MasterApplyListModel.fromJson(Map json) {
    masterApplyList = json["dataList"].map((value) {
      return MasterApplyItemModel.fromJson(value);
    }).toList();
    page = json['page'];
  }
}

//申请管理师列表模型
class MasterApplyItemModel {
  int id;
  var masterName;
  String icon;
  int count;
  num totalMoney;
  String applyMsg;
  String createTime;
  int applyStatus;
  MasterApplyItemModel.fromJson(Map json) {
    id = json['id'];
    masterName = json['masterName'];
    icon = json['icon'];
    count = json['count'];
    totalMoney = json['totalMoney'];
    applyMsg = json['applyMsg'];
    createTime = json['createTime'];
    applyStatus = json['applyStatus'];
  }
}

//管理师申请详情数据模型
class MasterApplyDetailModel {
  String icon;
  var name;
  int UID;
  String Lv;
  var workAge;
  var idCardNo;
  var account;
  String cardA;
  String cardB;
  num totalAccLimit;
  num totalUsableMoney;
  int applyStatus;
  String createTime;
  List<dynamic> cardList;
  MasterApplyDetailModel.fromJson(Map json) {
    cardList = json["dataList"].map((value) {
      return MasterCardItemModel.fromJson(value);
    }).toList();
    icon = json['icon'];
    name = json['name'];
    UID = json['UID'];
    Lv = json['Lv'];
    account = json['account'];
    workAge = json['workAge'];
    idCardNo = json['idCardNo'];
    cardA = json['cardA'];
    cardB = json['cardB'];
    totalAccLimit = json['totalAccLimit'];
    totalUsableMoney = json['totalUsableMoney'];
    applyStatus = json['applyStatus'];
    createTime = json['createTime'];
  }
}

//申请详情代管卡片列表模型
class MasterCardItemModel {
  var bankName;
  var cardNo;
  var name;
  num accLimit;
  num usableMoney;
  String icon;
  MasterCardItemModel.fromJson(Map json) {
    bankName = json['bankName'];
    cardNo = json['cardNo'];
    icon = json['icon'];
    name = json['name'];
    accLimit = json['accLimit'];
    usableMoney = json['usableMoney'];
  }
}

//管理师申请通过id
class MasterPassIdModel {
  int id;
  MasterPassIdModel.fromJson(Map json) {
    id = json['id'];
  }
}

//管理师
//我的客户-我的客户主页列表
class CustomerListModel {
  // String page;
  List<dynamic> customerList;
  int totalClientCount;
  int totalCardCount;
  num totalDelegateMoney;
  CustomerListModel.fromJson(Map json) {
    print(json);
    customerList = json["dataList"].map((value) {
      return CustomerItemModel.fromJson(value);
    }).toList();
    //  page = json['page'];
    totalClientCount = json['totalClientCount'];
    totalCardCount = json['totalCardCount'];
    totalDelegateMoney = json['totalDelegateMoney'];
  }
}

class CustomerItemModel {
  int uid;
  var name;
  var icon;
  int count;
  num account;
  num delegateMoney;
  num accLimit;

  CustomerItemModel.fromJson(Map json) {
    uid = json['UID'];
    delegateMoney = json['delegateMoney'];
    account = json['account'];
    name = json['name'];
    icon = json['icon'];
    count = json['count'];
    accLimit = json['accLimit'];
  }
}

//管理师
//我的��户-我的客户详情 计划
class CustomerDetailModel {
  // String page;
  List<dynamic> customerDetailList;
  var name;
  var delegateCardCount;
  var totalUsableMoney;
  var totalAccLimit;
  var icon;

  CustomerDetailModel.fromJson(Map json) {
    customerDetailList = json["dataList"].map((value) {
      return CustomerCardListModel.fromJson(value);
    }).toList();
    //  page = json['page'];
    delegateCardCount = json['delegateCardCount'];
    totalUsableMoney = json['totalUsableMoney'];
    name = json['name'];
    totalAccLimit = json['totalAccLimit'];
    icon = json['icon'];
  }
}

class CustomerCardListModel {
  // String page;
  List<dynamic> orderCardsList;
  var orderName;
  num cardsCount;

  CustomerCardListModel.fromJson(Map json) {
    orderCardsList = json["orderCardsList"].map((value) {
      return CustomerDetailItemModel.fromJson(value);
    }).toList();
    orderName = json['orderName'];
    cardsCount = json['cardsCount'];
  }
}

class CustomerDetailItemModel {
  var bankName;
  var cardNo;
  var accDay;
  var accDays;
  var usableMoney;
  var accPayday;
  var accPaydays;
  num accLimit;
  var updateTime;
  var payStatus;
  var cardId;
  var icon;
  var bankCode;
  var before;

  CustomerDetailItemModel.fromJson(Map json) {
    bankName = json['bankName'];
    //截取后四位
    cardNo = int.parse(json['cardNo']
        .toString()
        .substring(json['cardNo'].toString().length - 4));
    accDay = json['accDay'];
    accDays = json['accDays'];
    accPayday = json['accPayday'];
    accPaydays = json['accPaydays'];
    usableMoney = json['usableMoney'];
    updateTime = json['updateTime'].substring(0, json['updateTime'].length - 9);
    accLimit = json['accLimit'];
    payStatus = payStatusMap[json['payStatus'].toString()];
    cardId = json['cardId'];
    icon = json['icon'];
    bankCode = json['bankCode'];
    before = json['before'];
  }
}

//管理师
//我的客户-我的客户详情 账单
class BillListModel {
  List<dynamic> billList;

  BillListModel.fromJson(Map json) {
    billList = json["bill"].map((value) {
      return BillItemModel.fromJson(value);
    }).toList();
  }
}

class BillItemModel {
  num billMoney;
  num count;
  String billDate;
  var minRepayMoney;
  var mon;
  var year;
  var remainderRepay;
  var remainderMinRepay;
  List<dynamic> detail;

  BillItemModel.fromJson(Map json) {
    billMoney = json['billMoney'];
    count = json['count'];
    billDate = json['billDate'];
    minRepayMoney = json['minRepayMoney'];
    year = json['year'];
    mon = json['mon'];
    remainderRepay = json['remainderRepay'];
    remainderMinRepay = json['remainderMinRepay'];

    detail = json["detail"].map((value) {
      return BillItemDetailModel.fromJson(value);
    }).toList();
  }
}

class BillItemDetailModel {
  String title;
  num money;
  String date;
  var from;

  BillItemDetailModel.fromJson(Map json) {
    title = json['title'];
    money = json['money'];
    date = json['date'];
    from = json['from'];
  }
}

//管理师
//我的客户-代管信息
class DelegateDetailListModel {
  // String page;
  List<dynamic> delegateDetailList;

  DelegateDetailListModel.fromJson(Map json) {
    delegateDetailList = json["dataList"].map((value) {
      return DelegateDetailItemModel.fromJson(value);
    }).toList();
    //  page = json['page'];
  }
}

class DelegateDetailItemModel {
  var bankName;
  var cardNo;
  var accDay;
  var accDays;
  var usableMoney;
  int accPayday;
  var accPaydays;
  var accLimitCost;
  var accLimit;
  var icon;
  var delegateType;
  var cardId;
  var bankCode;

  DelegateDetailItemModel.fromJson(Map json) {
    bankName = json['bankName'];
    cardNo = json['cardNo'];
    accDay = json['accDay'];
    accDays = json['accDays'];
    accPayday = json['accPayday'];
    accPaydays = json['accPaydays'];
    usableMoney = json['usableMoney'];
    icon = json['icon'];
    accLimitCost = json['accLimitCost'];
    accLimit = json['accLimit'];
    delegateType = delegateTypeMap[json['delegateType']];
    bankCode = json['bankCode'];
    cardId = json['cardId'];
  }
}

//管理师
//我的客户-订单列表和审核信息
class ExamineListModel {
  // String page;
  List<dynamic> orderDetailList;

  ExamineListModel.fromJson(Map json) {
    orderDetailList = json["dataList"].map((value) {
      return ExamineItemModel.fromJson(value);
    }).toList();
    //  page = json['page'];
  }
}

class ExamineItemModel {
  num id;
  var cardId;
  var userId;
  var delegateType;
  var applyStatus;
  var reportImage;

  var applyMsg;
  var rejectMsg;
  var aproveMsg;

  var createTime;
  var updateTime;
  var status;

  ExamineItemModel.fromJson(Map json) {
    id = json['id'];
    cardId = json['cardId'];
    userId = json['userId'];
    applyStatus = applyStatusMap[json['applyStatus']];
    reportImage = json['reportImage'];
    applyMsg = json['applyMsg'];
    rejectMsg = json['rejectMsg'];
    aproveMsg = json['aproveMsg'];
    createTime = json['createTime'];
    updateTime =
        json['update_time'].substring(0, json['update_time'].length - 3);
    status = json['status'];
    delegateType = delegateTypeMap[json['delegateType']];
  }
}

//管理师
//我的客户-查看合同
class ViewContractListModel {
  List contractList;

  ViewContractListModel.fromJson(Map json) {
    contractList = json["dataList"].map((value) {
      return ViewContractItemModel.fromJson(value);
    }).toList();
    //  page = json['page'];
  }
}

class ViewContractItemModel {
  num applyId;
  String contractUrl;
  String fileName;

  ViewContractItemModel.fromJson(Map json) {
    applyId = json['applyId'];
    contractUrl = json['contractUrl'];
    fileName = json['fileName'];
  }
}

//风控信息

class RiskControlModel {
  var id;
  bool success;
  var nextService;
  var risk;
  num score;
  String decision;
  RiskControlModel.fromJson(Map json) {
    id = json['id'];
    success = json['success'];
    nextService = json['nextService'];
    score = json["result_desc"]['ANTIFRAUD']['score'];
    decision = json["result_desc"]['ANTIFRAUD']['decision'];
    risk = json["result_desc"]['ANTIFRAUD']['risk_items'].map((value) {
      return RiskDetailModel.fromJson(value);
    }).toList();
  }
}

class RiskDetailModel {
  var riskName;
  List riskDetailList = List();
  List frequencyOneDimList = List();
  var type;
  num result;
  RiskDetailModel.fromJson(Map json) {
    riskName = json['risk_name'];
    if (json["risk_detail"] != null) {
      type = json["risk_detail"]['type'];
      if (type == 'grey_list') {
        riskDetailList = json["risk_detail"]["grey_list_details"].map((value) {
          return GreyListDetailsModel.fromJson(value);
        }).toList();
      } else if (type == 'frequency_distinct') {
        riskDetailList =
            json["risk_detail"]["frequency_distinct_details"].map((value) {
          return FrequencyDistinctDetailsModel.fromJson(value);
        }).toList();
      } else if (type == 'frequency_one_dim') {
        result = json["risk_detail"]['result'];
      } else if (type == 'association_partner') {
        riskDetailList =
            json["risk_detail"]["association_partner_details"].map((value) {
          return AssociationPartnerDetailsModel.fromJson(value);
        }).toList();
      }
    }
  }
}

class GreyListDetailsModel {
  var evidenceTime;
  String riskLevel;
  String fraudType;
  var value;
  GreyListDetailsModel.fromJson(Map json) {
    evidenceTime = json['evidence_time'];
    riskLevel = json['risk_level'];
    fraudType = json['fraud_type'];
    value = json['value'];
  }
}

class FrequencyDistinctDetailsModel {
  var result;
  List data;
  String description;
  FrequencyDistinctDetailsModel.fromJson(Map json) {
    result = json['result'];
    data = json['data'].toList();
    description = json['description'];
  }
}

class AssociationPartnerDetailsModel {
  num count;
  String industryDisplayName;
  AssociationPartnerDetailsModel.fromJson(Map json) {
    count = json['count'];
    industryDisplayName = json['industryDisplayName'];
  }
}

//近期用户
class RecentUserListModel {
  List recentUserList;
  int page;

  RecentUserListModel.fromJson(Map json) {
    recentUserList = json["dataList"].map((value) {
      return RecentUserItemModel.fromJson(value);
    }).toList();
    //  page = json['page'];
  }
}

class RecentUserItemModel {
  var uUID;
  var name;
  var icon;
  num accLimit;
  num usableMoney;
  num count;

  RecentUserItemModel.fromJson(Map json) {
    uUID = json['UUID'];
    name = json['name'];
    icon = json['icon'];
    accLimit = json['accLimit'];
    usableMoney = json['usableMoney'];
    count = json['count'];
  }
}

//管理师-对账中心
//我的管理师数据模型
class PlanFinanceListModel {
  int page;
  num notReturned;
  num totalInvestor;
  List<dynamic> dataList;
  PlanFinanceListModel.fromJson(Map json) {
    dataList = json["dataList"].map((value) {
      return ManagerItemModel.fromJson(value);
    }).toList();
    page = json['page'];
    notReturned = json['notReturned'];
    totalInvestor = json['totalInvestor'];
  }
}

class PlanFinanceItemModel {
  String date;
  num repay1;
  num consume1;
  num repay2;
  num consume2;
  num repay3;
  num consume3;
  int status;
  PlanFinanceItemModel.fromJson(Map json) {
    date = json['date'];
    repay1 = json['repay1'];
    consume1 = json['consume1'];
    repay2 = json['repay2'];
    consume2 = json['consume2'];
    repay3 = json['repay3'];
    consume3 = json['consume3'];
    status = json['status'];
  }
}
