///用户登录
//发送验证码
class ValidCodeReq {
  String phone;
  int type;

  ValidCodeReq(this.phone, this.type);

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'type': type,
      };
}

//用户登录或注册
class UserSignInReq {
  String phone;
  String code;

  UserSignInReq(this.phone, this.code);

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'code': code,
      };
}

//用户首次设置密码
class UserSetPwdReq {
  String token;
  String password;

  UserSetPwdReq(this.token, this.password);

  Map<String, dynamic> toJson() => {
        'token': token,
        'password': password,
      };
}

//用户密码登录
class UserLoginByPwd {
  String phone;
  String password;

  UserLoginByPwd(this.phone, this.password);

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'password': password,
      };
}

//用户找回密码
class ForgetPwdReq {
  String phone;
  String password;
  String code;

  ForgetPwdReq(this.phone, this.password, this.code);

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'password': password,
        'code': code,
      };
}

//获取首页卡片列表信息
class CreditCardInfoReq {
  String token;
  CreditCardInfoReq(this.token);

  Map<String, dynamic> toJson() => {
        'token': token,
      };
}

//更新账单
class UpdateBillReq {
  String token;
  num cardInstId;
  UpdateBillReq(this.token, this.cardInstId);

  Map<String, dynamic> toJson() => {
        'token': token,
        'cardInstId': cardInstId,
      };
}

//获取可添加的银行列表
class GetBankAddListReq {
  String token;
  GetBankAddListReq(this.token);
  Map<String, dynamic> toJson() => {
        'token': token,
      };
}

//添加信用卡
class AddCreditCardReq {
  String token;
  String user;
  String password;
  num banCode;
  int delegateType;
  num toUid;

  AddCreditCardReq(
    this.token,
    this.user,
    this.password,
    this.banCode,
    this.delegateType,
    this.toUid,
  );

  Map<String, dynamic> toJson() => {
        'token': token,
        'user': user,
        'password': password,
        'banCode': banCode,
        'delegateType': delegateType,
        "toUid": toUid
      };
}

//卡片诊断
class CardDiagnoseReq {
  String token;
  String cardInstId;
  String squpdtime;
  String sqlimit;

  CardDiagnoseReq(
    this.token,
    this.cardInstId,
    this.squpdtime,
    this.sqlimit,
  );

  Map<String, dynamic> toJson() => {
        'token': token,
        'cardInstId': cardInstId,
        'squpdtime': squpdtime,
        'sqlimit': sqlimit,
      };
}

//移除卡片
class RemoveCardReq {
  String token;
  num cardInstId;

  RemoveCardReq(
    this.token,
    this.cardInstId,
  );

  Map<String, dynamic> toJson() => {
        'token': token,
        'cardInstId': cardInstId,
      };
}

//获取所有计划列表
class AllPlanListsReq {
  String token;
  int page;
  String condition;
  AllPlanListsReq(this.token, this.page, this.condition);

  Map<String, dynamic> toJson() =>
      {'token': token, 'page': page, 'condition': condition};
}

//计划列表condition
class PlanConditions {
  num flag;
  String startTime;
  String endTime;
  num delegateType;
  num planType;
  num userId;
  PlanConditions(this.flag, this.startTime, this.endTime, this.delegateType,
      this.planType, this.userId);

  Map<String, dynamic> toJson() => {
        'flag': flag,
        'startTime': startTime,
        'endTime': endTime,
        'delegateType': delegateType,
        'planType': planType,
        'userId': userId
      };
}

///资金方
//整体计划
class PlanListReq {
  String token;
  int page;
  String condition;
  PlanListReq(this.token, this.page, this.condition);

  Map<String, dynamic> toJson() => {
        'token': token,
        'page': page,
        'condition': condition,
      };
}

//资金方还款
class OperateRepayReq {
  String token;
  int planId;
  double realMoney;
  OperateRepayReq(this.token, this.planId, this.realMoney);

  Map<String, dynamic> toJson() => {
        'token': token,
        'planId': planId,
        'realMoney': realMoney,
      };
}

//标记问题订单
class OperateOrderStateReq {
  String token;
  int state;
  String applyMsg;
  int planId;
  OperateOrderStateReq(this.token, this.planId, this.state, this.applyMsg);

  Map<String, dynamic> toJson() => {
        'token': token,
        'planId': planId,
        'state': state,
        'applyMsg': applyMsg,
      };
}

//对账中心列表
class BanlanceListReq {
  String token;
  int page;
  BanlanceListReq(
    this.token,
    this.page,
  );

  Map<String, dynamic> toJson() => {
        'token': token,
        'page': page,
      };
}

//对账中心详情
class BanlanceDetailReq {
  String token;
  int delegateType;
  int masterId;
  int cardNo;
  String date;
  BanlanceDetailReq(
    this.token,
    this.delegateType,
    this.masterId,
    this.cardNo,
    this.date,
  );

  Map<String, dynamic> toJson() => {
        'token': token,
        'delegateType': delegateType,
        'masterId': masterId,
        'cardNo': cardNo,
        'date': date,
      };
}

//修改金额
class ModifyMoneyReq {
  String token;
  double money;
  ModifyMoneyReq(this.token, this.money);

  Map<String, dynamic> toJson() => {
        'token': token,
        'money': money,
      };
}

//提现记录列表
class LogListReq {
  String token;
  int page;
  LogListReq(this.token, this.page);

  Map<String, dynamic> toJson() => {
        'token': token,
        'page': page,
      };
}

//现金提现
class WithdrawHasPwdReq {
  String token;
  int cardInstId;
  double money;
  String password;
  WithdrawHasPwdReq(
    this.token,
    this.cardInstId,
    this.money,
    this.password,
  );
  Map<String, dynamic> toJson() => {
        'token': token,
        'cardInstId': cardInstId,
        'money': money,
        'password': password,
      };
}

class WithdrawNoPwdReq {
  String token;
  int cardInstId;
  double money;
  WithdrawNoPwdReq(
    this.token,
    this.cardInstId,
    this.money,
  );
  Map<String, dynamic> toJson() => {
        'token': token,
        'cardInstId': cardInstId,
        'money': money,
      };
}

//提现密码
class WithdrawByPwd {
  String token;
  String password;
  WithdrawByPwd(this.token, this.password);

  Map<String, dynamic> toJson() => {
        'token': token,
        'password': password,
      };
}

//忘记提现密码
class ForgetWithdrawPwdReq {
  String token;
  String password;
  String code;
  ForgetWithdrawPwdReq(this.token, this.password, this.code);

  Map<String, dynamic> toJson() => {
        'token': token,
        'password': password,
        'code': code,
      };
}

//添加收款银行卡
class AddReceiveCardReq {
  String token;
  String name;
  int cardNo;
  int bankId;
  String code;
  String phone;

  AddReceiveCardReq(
    this.token,
    this.name,
    this.cardNo,
    this.bankId,
    this.code,
    this.phone,
  );

  Map<String, dynamic> toJson() => {
        'token': token,
        'name': name,
        'cardNo': cardNo,
        'bankId': bankId,
        'code': code,
        'phone': phone,
      };
}

//忘记提现密码
class RemoveReceiveCardReq {
  String token;
  int cardInstId;
  RemoveReceiveCardReq(
    this.token,
    this.cardInstId,
  );

  Map<String, dynamic> toJson() => {
        'token': token,
        'cardInstId': cardInstId,
      };
}

//只传token
class TokenReq {
  String token;
  TokenReq(this.token);

  Map<String, dynamic> toJson() => {
        'token': token,
      };
}

//添加POS机
class PosTerminalReq {
  String token;
  int posId;
  int bankNo;
  var bankName;
  var alias;
  PosTerminalReq(
      this.token, this.posId, this.bankNo, this.bankName, this.alias);

  Map<String, dynamic> toJson() => {
        'token': token,
        'posId': posId,
        'bankNo': bankNo,
        'bankName': bankName,
        'alias': alias,
      };
}

//删除POS机
class RemovePosReq {
  String token;
  int posInstId;
  RemovePosReq(this.token, this.posInstId);

  Map<String, dynamic> toJson() => {
        'token': token,
        'posInstId': posInstId,
      };
}

//添加管理师POS机
class MasterPosReq {
  String token;
  int posId;
  int masterId;
  MasterPosReq(
    this.token,
    this.posId,
    this.masterId,
  );

  Map<String, dynamic> toJson() => {
        'token': token,
        'posId': posId,
        'masterId': masterId,
      };
}

class OrderDetailReq {
  String token;
  int id;
  OrderDetailReq(this.token, this.id);

  Map<String, dynamic> toJson() => {'token': token, 'id': id};
}

class RemoveApplyInvestorReq {
  String token;
  int id;
  RemoveApplyInvestorReq(this.token, this.id);

  Map<String, dynamic> toJson() => {'token': token, 'id': id};
}

class OrderOperationReq {
  String token;
  int orderInstId;
  int type;
  String applyMsg;
  OrderOperationReq(this.token, this.orderInstId, this.type, this.applyMsg);

  Map<String, dynamic> toJson() => {
        'token': token,
        'orderInstId': orderInstId,
        'type': this.type,
        'applyMsg': this.applyMsg
      };
}

class OrderReq {
  String token;
  int page;
  OrderReq(this.token, this.page);

  Map<String, dynamic> toJson() => {'token': token, 'page': page};
}

class RecentUserListReq {
  String token;
  int page;
  RecentUserListReq(this.token, this.page);

  Map<String, dynamic> toJson() => {'token': token, 'page': page};
}

class CapitalSideListDetailReq {
  String token;
  int userId;
  CapitalSideListDetailReq(this.token, this.userId);

  Map<String, dynamic> toJson() => {'token': token, 'userId': userId};
}

class MyCapitalSideReq {
  String token;
  int page;
  MyCapitalSideReq(this.token, this.page);

  Map<String, dynamic> toJson() => {'token': token, 'page': page};
}

class CustomerReq {
  String token;
  String condition;
  CustomerReq(this.token, this.condition);

  Map<String, dynamic> toJson() => {
        'token': token,
        'condition': condition,
      };
}

class CustomerDetailReq {
  String token;
  int userId;
  CustomerDetailReq(this.token, this.userId);

  Map<String, dynamic> toJson() => {'token': token, 'userId': userId};
}

class CustomerDetailBillReq {
  String token;
  int cardId;
  CustomerDetailBillReq(this.token, this.cardId);

  Map<String, dynamic> toJson() => {'token': token, 'cardId': cardId};
}

class DelegateListReq {
  String token;
  int orderId;
  DelegateListReq(this.token, this.orderId);

  Map<String, dynamic> toJson() => {'token': token, 'orderId': orderId};
}

class ExamineReq {
  String token;
  String condition;
  ExamineReq(this.token, this.condition);

  Map<String, dynamic> toJson() => {'token': token, 'condition': condition};
}

class CapitalReq {
  String token;
  int page;
  CapitalReq(this.token, this.page);

  Map<String, dynamic> toJson() => {'token': token, 'id': page};
}

class AccountCenterListReq {
  String token;
  int page;

  AccountCenterListReq(this.token, this.page);

  Map<String, dynamic> toJson() => {'token': token, 'page': page};
}

class FinancialListReq {
  String token;
  int page;
  String condition;
  FinancialListReq(this.token, this.page, this.condition);

  Map<String, dynamic> toJson() =>
      {'token': token, 'page': page, 'condition': condition};
}

class FinancialMonthListReq {
  String token;
  int page;
  String condition;
  FinancialMonthListReq(this.token, this.page, this.condition);

  Map<String, dynamic> toJson() =>
      {'token': token, 'page': page, 'condition': condition};
}

class FinancialDayListReq {
  String token;
  int page;
  String condition;
  FinancialDayListReq(this.token, this.page, this.condition);

  Map<String, dynamic> toJson() =>
      {'token': token, 'page': page, 'condition': condition};
}

class CheckActionReq {
  String token;
  String condition;
  CheckActionReq(this.token, this.condition);

  Map<String, dynamic> toJson() => {'token': token, 'condition': condition};
}

class AllPlanListReq {
  String token;
  int page;
  String condition;
  AllPlanListReq(this.token, this.page, this.condition);

  Map<String, dynamic> toJson() =>
      {'token': token, 'page': page, 'condition': condition};
}

class PlanDetailReq {
  String token;
  int planId;
  PlanDetailReq(this.token, this.planId);

  Map<String, dynamic> toJson() => {'token': token, 'planId': planId};
}

class OperationReq {
  String consumMoney;
  String token;
  int posId;
  int planId;

  OperationReq(
      this.token, this.consumMoney, this.posId, this.planId);

  Map<String, dynamic> toJson() => {
        'token': token,
        'posId': posId,
        'money': consumMoney,
        'planId': planId,
      };
}

class RepaymentOperationReq {
  int planId;
  String token;
  int investorId;

  RepaymentOperationReq(this.token, this.planId, this.investorId);

  Map<String, dynamic> toJson() => {
        'token': token,
        'planId': planId,
        'investorId': investorId,
      };
}

class AddPlanReq {
  String token;
  String cardInstId;

  AddPlanReq(this.token, this.cardInstId);

  Map<String, dynamic> toJson() => {
        'token': token,
        'cardInstId': cardInstId,
      };
}

class OrderCardListReq {
  String token;
  String cardIds;

  OrderCardListReq(this.token, this.cardIds);

  Map<String, dynamic> toJson() => {
        'token': token,
        'cardIds': cardIds,
      };
}

class ApplyCapitalReq {
  int account;
  String token;
  String applyMsg;

  ApplyCapitalReq(this.token, this.account, this.applyMsg);

  Map<String, dynamic> toJson() => {
        'token': token,
        'account': account,
        'applyMsg': applyMsg,
      };
}

class ViewContractReq {
  int applyId;
  String token;

  ViewContractReq(this.token, this.applyId);

  Map<String, dynamic> toJson() => {
        'token': token,
        'applyId': applyId,
      };
}
// class AddContractReq{
//   int applyId;
//   String token;
//   File file19;

//   AddContractReq(this.token, this.applyId,this.file19);

//   Map<String, dynamic> toJson() => {
//         'token': token,
//         'applyId': applyId,
//         'file1-9':file19
//       };
// }

class DeleteContractReq {
  int applyId;
  String token;
  String fileName;

  DeleteContractReq(this.token, this.applyId, this.fileName);

  Map<String, dynamic> toJson() => {
        'token': token,
        'applyId': applyId,
        'fileName': fileName,
      };
}

class RemoveDelegateReq {
  int orderId;
  String token;

  RemoveDelegateReq(this.token, this.orderId);

  Map<String, dynamic> toJson() => {
        'token': token,
        'orderId': orderId,
      };
}

class RemoveAllDelegateReq {
  int userId;
  String token;

  RemoveAllDelegateReq(this.token, this.userId);

  Map<String, dynamic> toJson() => {
        'token': token,
        'userId': userId,
      };
}

class OperationErrorReq {
  String token;
  int planId;
  int iserror;
  String applyMsg;

  OperationErrorReq(this.token, this.planId, this.iserror, this.applyMsg);

  Map<String, dynamic> toJson() => {
        'token': token,
        'planId': planId,
        'state': iserror,
        'applyMsg': applyMsg,
      };
}

class CreateProfitReq {
  String token;
  String cardInstId;
  String preMoney;
  String afterMoney;

  CreateProfitReq(this.token, this.cardInstId, this.preMoney, this.afterMoney);

  Map<String, dynamic> toJson() => {
        'token': token,
        'cardInstId': cardInstId,
        'preMoney': preMoney,
        'afterMoney': afterMoney
      };
}

class GetCreateProfitDataReq {
  String token;
  GetCreateProfitDataReq(this.token);

  Map<String, dynamic> toJson() => {
        'token': token,
      };
}

class LiftingReq {
  String token;
  LiftingReq(this.token);

  Map<String, dynamic> toJson() => {
        'token': token,
      };
}

class ConsumReq {
  String token;
  int page;
  ConsumReq(this.token, this.page);

  Map<String, dynamic> toJson() => {'token': token, 'page': page};
}

class MasterHistoryReq {
  String token;
  int page;
  MasterHistoryReq(this.token, this.page);

  Map<String, dynamic> toJson() => {'token': token, 'page': page};
}

//我的管理师列表
class MyMasterListReq {
  String token;
  int page;
  MyMasterListReq(this.token, this.page);

  Map<String, dynamic> toJson() => {
        'token': token,
        'page': page,
      };
}

//我的管理师列表
class MyMasterDetailReq {
  String token;
  int masterId;
  MyMasterDetailReq(this.token, this.masterId);

  Map<String, dynamic> toJson() => {
        'token': token,
        'masterId': masterId,
      };
}

//管理师详情
class MasterDetailReq {
  String token;
  int applyId;
  MasterDetailReq(this.token, this.applyId);

  Map<String, dynamic> toJson() => {
        'token': token,
        'applyId': applyId,
      };
}

//申请操作
class OperationApplyReq {
  String token;
  int applyId;
  String applyMsg;
  int applyState;
  OperationApplyReq(this.token, this.applyId, this.applyMsg, this.applyState);

  Map<String, dynamic> toJson() => {
        'token': token,
        'applyId': applyId,
        'applyMsg': applyMsg,
        'applyState': applyState,
      };
}

//修改授信金额
class ModifyAuthMoney {
  String token;
  int id;
  double authMoney;
  ModifyAuthMoney(this.token, this.id, this.authMoney);

  Map<String, dynamic> toJson() => {
        'token': token,
        'id': id,
        'authMoney': authMoney,
      };
}

//风控
class RiskReq {
  String token;
  int userId;
  RiskReq(this.token, this.userId);

  Map<String, dynamic> toJson() => {'token': token, 'userId': userId};
}
