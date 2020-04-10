import '../common/component_index.dart';

class NetRepository {
  ///用户端
  //获取验证码
  Future<BaseResp> getValidCode(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.VALIDCODE),
            data: reqData);
    return baseResp;
  }

  //短信验证码登录
  Future<BaseResp> userLogin(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.UserSignIn),
            data: reqData);
    if (baseResp.data != null)
      AppInstance.putObject("user", baseResp.data["userData"]);
    return baseResp;
  }

  //首次设置密码
  Future<BaseResp> setPwd(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.SetUserPwd),
            data: reqData);
    return baseResp;
  }

  //密码登录
  Future<BaseResp> userLoginByPwd(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.LoginByPassword),
            data: reqData);
    if (baseResp.data != null)
      AppInstance.putObject("user", baseResp.data["userData"]);
    return baseResp;
  }

  //找回密码
  Future<BaseResp> forgetPwd(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.ForgetPwd),
            data: reqData);
    return baseResp;
  }

  //修改手机号
  Future<BaseResp> changePhoneNum(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.ChangePhoneNum),
            data: reqData);
    return baseResp;
  }

  //用户认证
  Future<BaseResp> userAuth(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.UserCertificate),
            data: reqData);
    return baseResp;
  }

  //获取首页卡片列表
  Future<BaseResp> getCardInfo(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetCardInfo),
            data: reqData);
    return baseResp;
  }

  //更新账单
  Future<BaseResp> updateBill(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.UpdateBill),
            data: reqData);
    return baseResp;
  }

  //移除卡片
  Future<BaseResp> removeCard(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.RemoveCard),
            data: reqData);
    return baseResp;
  }

  //获取可添加卡片列表
  Future<BaseResp> getAddCardList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetBankList),
            data: reqData);
    return baseResp;
  }

  //导入信用卡
  Future<BaseResp> importCardInfo(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.AddCreditCard),
            data: reqData);
    return baseResp;
  }

  //设置查询参数
  Future<BaseResp> setCardInput(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.SetCardInput),
            data: reqData);
    return baseResp;
  }

  //获取信用卡查询状态
  Future<BaseResp> getCardStatus(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetCardStatus),
            data: reqData);
    return baseResp;
  }

  //获取诊断卡片信息
  Future<BaseResp> getDiagnoseCardInfo(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post,
            RequestApi.getPath(path: RequestApi.GetDiagnoseCardList),
            data: reqData);
    return baseResp;
  }

  //卡片诊断
  Future<BaseResp> cardDiagnoseInfo(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.CardDiagnose),
            data: reqData);
    return baseResp;
  }

  //发起托管
  Future<BaseResp> startManager(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.StartManager),
            data: reqData);
    return baseResp;
  }

  //获取全部计划列表
  Future<BaseResp> getPlanLists(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetAllPlanLists),
            data: reqData);
    return baseResp;
  }

  //获取全部账单列表
  Future<BaseResp> getBillLists(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetAllBillLists),
            data: reqData);
    return baseResp;
  }

  //获取用户中心信息
  Future<BaseResp> getUserInfo(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetUserInfo),
            data: reqData);
    return baseResp;
  }

  //修改用户中心信息
  Future<BaseResp> editUserInfo(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.modifyUserInfo),
            data: reqData);
    return baseResp;
  }

  //修改用户密码
  Future<BaseResp> modifyPwd(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.ModifyPassword),
            data: reqData);
    return baseResp;
  }

  //获取我的管理师列表
  Future<BaseResp> getMyMasterLists(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetMyMasterLists),
            data: reqData);
    return baseResp;
  }

  //获取管理师下某个订单的卡片
  Future<BaseResp> getMasterOrderCards(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post,
            RequestApi.getPath(path: RequestApi.GetMasterOrderCards),
            data: reqData);
    return baseResp;
  }

  //角色升级
  Future<BaseResp> userUpgrade(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.UserUpgrade),
            data: reqData);
    return baseResp;
  }

  //余额明细
  Future<BaseResp> getUserBanalanceDetail(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post,
            RequestApi.getPath(path: RequestApi.GetUserBanalanceDetail),
            data: reqData);
    return baseResp;
  }

  ///资金方
  //获取整体计划列表
  Future<BaseResp> getPlanList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetPlanList),
            data: reqData);
    return baseResp;
  }

  //资金方还款操作
  Future<BaseResp> operateRepay(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.OperateRepay),
            data: reqData);
    return baseResp;
  }

  //标记问题订单
  Future<BaseResp> operateOrderState(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.OperateOrderState),
            data: reqData);
    return baseResp;
  }

  //对账中心列表
  Future<BaseResp> getBanlanceList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetBanlanceList),
            data: reqData);
    return baseResp;
  }

  //对账中心详情
  Future<BaseResp> getBanlanceDetail(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetBanlanceDetail),
            data: reqData);
    return baseResp;
  }

  //修改出资方授信总额度
  Future<BaseResp> modifyMyAuthorMoney(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post,
            RequestApi.getPath(path: RequestApi.ModifyMyAuthorMoney),
            data: reqData);
    return baseResp;
  }

  //获取提现记录
  Future<BaseResp> getLog(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetLog),
            data: reqData);
    return baseResp;
  }

  //提现信息
  Future<BaseResp> getWithdrawInfo(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetWithdrawInfo),
            data: reqData);
    return baseResp;
  }

  //现金提现
  Future<BaseResp> withdraw(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.Withdraw),
            data: reqData);
    return baseResp;
  }

  //设置提现密码
  Future<BaseResp> setWithdrawPwd(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.SetWithdrawPwd),
            data: reqData);
    return baseResp;
  }

  //修改提现密码
  Future<BaseResp> modifyWithdrawPwd(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.ModifyWithdrawPwd),
            data: reqData);
    return baseResp;
  }

  //忘记提现密码
  Future<BaseResp> forgetWithdrawPwd(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.ForgetWithdrawPwd),
            data: reqData);
    return baseResp;
  }

  //个人中心明细
  Future<BaseResp> getDetailList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetDetailList),
            data: reqData);
    return baseResp;
  }

  //获取我的pos机列表
  Future<BaseResp> getMyPosList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetMyPosList),
            data: reqData);
    return baseResp;
  }

  //获取可以使用的pos机
  Future<BaseResp> getPosInfoList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetPosInfoList),
            data: reqData);
    return baseResp;
  }

  //添加POS机
  Future<BaseResp> addPosTerminal(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.AddPosTerminal),
            data: reqData);
    return baseResp;
  }

  //删除POS机
  Future<BaseResp> removePos(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.RemovePos),
            data: reqData);
    return baseResp;
  }

  //添加管理师POS机
  Future<BaseResp> addPos(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.AddPos),
            data: reqData);
    return baseResp;
  }

  //移除管理师POS机
  Future<BaseResp> removeMasterPos(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.RemoveMasterPos),
            data: reqData);
    return baseResp;
  }

  //获取历史往来
  Future<BaseResp> getHistoryList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetHistoryList),
            data: reqData);
    return baseResp;
  }

  //获取收款银行卡列表
  Future<BaseResp> getReceiveCardList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post,
            RequestApi.getPath(path: RequestApi.GetReceiveCardList),
            data: reqData);
    return baseResp;
  }

  //获取可添加银行卡列表
  Future<BaseResp> getReceiveBankList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post,
            RequestApi.getPath(path: RequestApi.GetReceiveBankList),
            data: reqData);
    return baseResp;
  }

  //添加收款银行卡
  Future<BaseResp> addReceiveCard(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.AddReceiveCard),
            data: reqData);
    return baseResp;
  }

  //移除收款银行卡
  Future<BaseResp> removeReceiveCard(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.RemoveReceiveCard),
            data: reqData);
    return baseResp;
  }

//管理师端
  //获取订单详情
  Future<BaseResp> getOrderDetial(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetOrderDetail),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //操作订单
  Future<BaseResp> passOperation(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.OperateOrder),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //获取订单列表
  Future<BaseResp> getNewOrders(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetNewOrders),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //对账中心 账单列表
  Future<BaseResp> getAccountList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post,
            RequestApi.getPath(path: RequestApi.GetPlanFinanceList),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //对账中心 财务管理
  Future<BaseResp> getFinancialList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetPlanFinance),
            data: reqData);
    return baseResp;
  }

  //对账中心 对账操作
  Future<BaseResp> checkAction(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.CheckFinance),
            data: reqData);
    return baseResp;
  }

  //对账中心 每月
  Future<BaseResp> getFinancialMonthList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post,
            RequestApi.getPath(path: RequestApi.CheckFinanceMonthly),
            data: reqData);
    return baseResp;
  }

  //对账中心 每日
  Future<BaseResp> getFinancialDayList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.CheckFinanceDay),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //获取资金方列表
  Future<BaseResp> getCapital(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetCapitalList),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //获取资金方列表
  Future<BaseResp> getMyApplyInvestorList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post,
            RequestApi.getPath(path: RequestApi.GetMyApplyInvestorList),
            data: reqData);
    return baseResp;
  }

  Future<BaseResp> removeApplyInvestor(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post,
            RequestApi.getPath(path: RequestApi.RemoveApplyInvestor),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //获取我的资金方详情
  Future<BaseResp> getCapitalSideListDetail(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post,
            RequestApi.getPath(path: RequestApi.GetMyInvestorDetail),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //解除资金方关系
  Future<BaseResp> unApplyInvestor(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.UnApplyInvestor),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //获取计划列表
  Future<BaseResp> getAllPlanList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetAllPlanList),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //处理消费计划
  Future<BaseResp> operation(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.OperateConsume),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //处理还款计划
  Future<BaseResp> repayMentoperation(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.OperateRepayment),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //生成计划
  Future<BaseResp> genPlanList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GenPlanList),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //订单的卡片
  Future<BaseResp> getOrderCardsList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetOrderCardsList),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //申请资金方
  Future<BaseResp> applyCapital(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.ApplyInvestor),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //处理有问题的消费计划
  Future<BaseResp> operationError(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post,
            RequestApi.getPath(path: RequestApi.OperateErrorConsume),
            data: reqData);
    return baseResp;
  }

//管理师端
  //获取计划详情
  Future<BaseResp> getPlanDetial(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetPlanDetail),
            data: reqData);
    return baseResp;
  }

  //创建提额分润
  Future<BaseResp> createProfit(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.CreateProfit),
            data: reqData);
    return baseResp;
  }

  //获取创建提额分润的客户和卡片信息
  Future<BaseResp> getCreateData(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.CreateProfitData),
            data: reqData);
    return baseResp;
  }

  //获取提额分润信息列表
  Future<BaseResp> getLiftingData(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.LiftingList),
            data: reqData);
    return baseResp;
  }

  Future<BaseResp> getConsumData(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.ConsumList),
            data: reqData);
    return baseResp;
  }

  //获取我的管理师列表
  Future<BaseResp> getMyMasterList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetMyMasterList),
            data: reqData);
    return baseResp;
  }

  //获取管理师申请列表
  Future<BaseResp> getMasterApplyList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post,
            RequestApi.getPath(path: RequestApi.GetMasterApplyList),
            data: reqData);
    return baseResp;
  }

  //获取管理师申请详情
  Future<BaseResp> getMasterApplyDetail(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post,
            RequestApi.getPath(path: RequestApi.GetMasterApplyDetail),
            data: reqData);
    return baseResp;
  }

  //申请操作
  Future<BaseResp> operateMasterApply(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post,
            RequestApi.getPath(path: RequestApi.OperateMasterApply),
            data: reqData);
    return baseResp;
  }

  //获取管理师详情信��
  Future<BaseResp> getMyMasterDetail(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetMyMasterDetail),
            data: reqData);
    return baseResp;
  }

  //修改授��金���
  Future<BaseResp> modifyAuthMoney(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.ModifyAuthMoney),
            data: reqData);
    return baseResp;
  }

  //公共部分
  //获取用户中心信息
  Future<BaseResp> userInfo(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.UserInfo),
            data: reqData);
    return baseResp;
  }

  //获取我的客户列表
  Future<BaseResp> getCustomer(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetMyClientList),
            data: reqData);
    return baseResp;
  }

  Future<BaseResp> getCustomerDetail(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetMyClientDetail),
            data: reqData);
    return baseResp;
  }

  Future<BaseResp> getExamineDetail(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetApplyOrderList),
            data: reqData);
    return baseResp;
  }

  Future<BaseResp> getDelegateList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetDelegateList),
            data: reqData);
    return baseResp;
  }

  Future<BaseResp> getMyCapitalSideReqReq(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post,
            RequestApi.getPath(path: RequestApi.GetMyCapitalSideList),
            data: reqData);
    return baseResp;
  }

//我的客户 账单
  Future<BaseResp> getBillList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetMyClientBill),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //查看合同
  Future<BaseResp> viewContract(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetContractInfo),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //添加合同
  Future<BaseResp> addContract(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post,
            RequestApi.getPath(path: RequestApi.UploadContractInfo),
            data: reqData);
    return baseResp;
  }

//管理师端
  //删除合同
  Future<BaseResp> deleteContract(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post,
            RequestApi.getPath(path: RequestApi.RemoveContractInfo),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //解除代管
  Future<BaseResp> removeDelegate(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.RemoveDelegate),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //一键解除代管
  Future<BaseResp> removeAllDelegate(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.RemoveAllDelegate),
            data: reqData);
    return baseResp;
  }

  //获取历史往来
  Future<BaseResp> getMasterHistoryList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post,
            RequestApi.getPath(path: RequestApi.GetMasterHistoryList),
            data: reqData);
    return baseResp;
  }

  //获取风控审核
  Future<BaseResp> getRiskControl(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetRiskControl),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //近期用户
  Future<BaseResp> getRecentUserList(reqData) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.post, RequestApi.getPath(path: RequestApi.GetRecentUserList),
            data: reqData);
    return baseResp;
  }

  //管理师端
  //对账中心
  // Future<BaseResp> getPlanFinanceList(reqData) async {
  //   BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
  //       .request<Map<String, dynamic>>(
  //           Method.post, RequestApi.getPath(path: RequestApi.GetPlanFinanceList),
  //           data: reqData);
  //   return baseResp;
  // }
}
