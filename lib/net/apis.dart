class RequestApi {
  ///公共部分
  ///获取用户中心信息
  static const String UserInfo = "user/userInfo";

  /// 用户端
  /// 发送验证码
  static const String VALIDCODE = "user/sendCode";

  /// 用户登录或注册
  static const String UserSignIn = "user/signIn";

  /// 设置用户密码
  static const String SetUserPwd = "user/setPassword";

  /// 用户密码登录
  static const String LoginByPassword = "user/loginByPassword";

  /// 忘记密码
  static const String ForgetPwd = "User/forgetPassword";

  /// 修改手机号
  static const String ChangePhoneNum = "User/changePhone";

  /// 用户认证
  static const String UserCertificate = "user/certificate";

  ///获取首页卡片列表
  static const String GetCardInfo = "card/getCardList";

  ///更新账单
  static const String UpdateBill = "card/updateBill";

  ///获取可添加的银行列表
  static const String GetBankList = "card/getBankList";

  ///获取可添加的收款银行列表
  static const String GetReceiveBankList = "user/getReceiveBankList";

  ///获取收款银行列表
  static const String GetReceiveCardList = "user/getReceiveCardList";

  ///添加收款银行卡
  static const String AddReceiveCard = "user/addReceiveCard";

  ///移除收款银行卡
  static const String RemoveReceiveCard = "user/removeReceiveCard";

  ///获取诊断信用卡列表
  static const String GetDiagnoseCardList = "card/getDiagnoseCardList";

  ///添加信用卡
  static const String AddCreditCard = "card/addCard";

  ///卡片诊断
  static const String CardDiagnose = "card/diagnose";

  ///移除卡片
  static const String RemoveCard = "user/removeCard";

  ///发起托管
  static const String StartManager = "card/delegateCard";

  ///获取所有计划
  static const String GetAllPlanLists = "User/getPlanList";

  ///获取所有账单
  static const String GetAllBillLists = "user/getCardBill";

  ///获取用户中心信息
  static const String GetUserInfo = "user/userInfo";

  ///修改用户中心信息
  static const String modifyUserInfo = "user/modifyUser";

  ///获取我的管理师列表
  static const String GetMyMasterLists = "User/getMyMasterList";

  ///获取管理师下某个订单的卡片
  static const String GetMasterOrderCards = "User/getMasterOrderCard";

  ///设置查询参数
  static const String SetCardInput = "card/setCardInput";

  ///获取信用卡查询状态
  static const String GetCardStatus = "card/getCardStatus";

  ///修改密码
  static const String ModifyPassword = "user/modifyPassword";

  ///角色升级
  static const String UserUpgrade = "user/getUpgrade";

  ///用户余额明细
  static const String GetUserBanalanceDetail = "user/getBanlanceDetail";

  /// 资金方
  /// 获取整体计划
  static const String GetPlanList = "Investor/getPlanList";

  /// 资金方还款
  static const String OperateRepay = "Investor/operateRepay";

  /// 标记问题订单
  static const String OperateOrderState = "master/OperateOrderState";

  /// 对账中心列表
  static const String GetBanlanceList = "investor/getBanlanceList";

  /// 对账中心详情
  static const String GetBanlanceDetail = "investor/getBanlanceDetail";

  /// 修改出资方授信总金额
  static const String ModifyMyAuthorMoney = "investor/modifyMyAuthorMoney";

  /// 获取提现记录
  static const String GetLog = "withdraw/getLog";

  /// 获取提现信息
  static const String GetWithdrawInfo = "Withdraw/getWithdrawInfo";

  /// 现金提现
  static const String Withdraw = "Withdraw/withdraw";

  /// 设置提现密码
  static const String SetWithdrawPwd = "user/setWithdrawPwd";

  /// 修改提现密码
  static const String ModifyWithdrawPwd = "user/modifyWithdrawPwd";

  /// 忘记提现密码
  static const String ForgetWithdrawPwd = "user/forgetWithdrawPwd";

  ///个人中心明细
  static const String GetDetailList = "Investor/getDetailList";

  ///获取我的pos机列表
  static const String GetMyPosList = "Investor/getMyPosList";

  ///获取可以使用的POS机
  static const String GetPosInfoList = "Investor/getPosInfoList";

  ///添加POS机
  static const String AddPosTerminal = "Investor/addPosTerminal";

  ///删除POS机
  static const String RemovePos = "Investor/removePos";

  ///添加管理师POS机
  static const String AddPos = "Investor/addPos";

  ///移除管理师POS机
  static const String RemoveMasterPos = "Investor/removeMasterPos";

  ///获取历史往来
  static const String GetHistoryList = "Investor/getHistoryList";

  ///获取我的管理师列表
  static const String GetMyMasterList = "investor/getMyMasterList";

  ///获取我的管理师列表
  static const String GetMasterApplyList = "investor/getMasterApplyList";

  ///获取管理师申请详情
  static const String GetMasterApplyDetail = "investor/getMasterApplyDetail";

  //申请操作
  static const String OperateMasterApply = "investor/operateMasterApply";

  //获取管理师的详细信息
  static const String GetMyMasterDetail = "investor/getMyMasterDetail";

  //修改资金操作
  static const String ModifyAuthMoney = "investor/ModifyAuthMoney";
  static String getPath({String path: '', int page, String resType}) {
    StringBuffer sb = new StringBuffer(path);
    if (page != null) {
      sb.write('/$page');
    }
    if (resType != null && resType.isNotEmpty) {
      sb.write('/$resType');
    }
    return sb.toString();
  }

  /// 管理师
  /// 获取订单详情
  static const String GetOrderDetail = "Master/getOrderDetail"; //获取订单的详情列表
  static const String GetNewOrders = "Master/getNewOrderList"; //获取申请订单列表
  static const String GetAllPlanList = "Master/getPlanList"; //获取计划列表
  static const String OperateConsume = 'master/operateConsume'; //操作确认消费计划
  static const String OperateErrorConsume = 'master/operateOrderState'; //标记问题订单
  static const String GetPlanDetail = 'master/getPlanOrderDetail'; //获取计划订单详情
  static const String GetCapitalList = 'master/getMyInvestorList'; //获取我的出资方列表
  static const String CreateProfit = 'master/createUpLimitReward'; //创建提额分润
  static const String CreateProfitData = 'master/getUpLimitInfo'; //获取提额分润的信息
  static const String LiftingList = 'master/getUpLimitList'; //获取分润数据列表
  static const String ConsumList = 'Master/getConsumeRewardList'; //获取管理师消费分润管理
  static const String OperateRepayment = 'master/operateRepayPlan'; //确认还款计划
  static const String OperateOrder = 'master/operateOrder'; //操作订单
  static const String GetMyClientList = 'master/GetMyClientList'; //获取我的客户列表
  static const String GetPlanFinanceList = 'master/getPlanFinanceList'; //对账中心
  static const String GetMyClientDetail = 'master/getMyClientDetail'; //我的客户详情
  static const String GetMyCapitalSideList = 'master/'; //获取我的申请资金方列表
  static const String ApplyInvestor = 'Master/applyInvestor'; //申请资金方
  static const String GetMyClientBill = 'user/getCardBill'; //我的客户账单
  static const String GetApplyOrderList =
      'master/getApplyOrderList'; //获取申请订单 审核信息
  static const String GetDelegateList = 'master/getDelegateDetail'; //获取代管信息
  static const String GetContractInfo = 'master/getContractInfo'; //查看合同信息
  static const String UploadContractInfo = 'master/uploadContractInfo'; //添加合同
  static const String GetMasterHistoryList = 'Master/getHistoryList'; //获取历史往来
  static const String GetRiskControl = 'Master/getRiskControl'; //获取风控信息
  static const String RemoveDelegate = 'Master/removeDelegate'; //移除代管信息
  static const String RemoveAllDelegate = 'Master/removeAllDelegate'; //一键移除代管信息
  static const String RemoveContractInfo = 'master/removeContractInfo'; //删除合同
  static const String GetMyInvestorDetail =
      'master/getMyInvestorDetail'; //获取我的资金方详情
  static const String UnApplyInvestor = 'master/unApplyInvestor'; //解除资金方关系
  static const String GetMyApplyInvestorList =
      'master/getMyApplyInvestorList'; //获取我的资金方申请列表
  static const String RemoveApplyInvestor =
      'master/removeApplyInvestor'; //撤销资金方申请
  static const String GenPlanList = 'card/genPlanList'; //生成计划
  static const String GetRecentUserList = 'master/getRecentUserList'; //近期用户
  static const String GetPlanFinance = 'master/getPlanFinance'; //财务管理
  static const String CheckFinance = 'master/checkFinance'; //对账中心确认对账
  static const String CheckFinanceFilter =
      'master/getCheckFinanceFilter'; //账单筛选
  static const String CheckFinanceMonthly =
      'master/getCheckFinanceMonthly'; //每月账单
  static const String CheckFinanceDay = 'master/checkFinanceEvery'; //每日账单
  static const String GetOrderCardsList = 'master/getOrderCardsList'; //订单卡片
}
