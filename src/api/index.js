import {get, post, put, _delete, _get, _put, _deleteID } from './service'

const headers = { 'Content-Type': 'application/json;charset=UTF-8' }
const headers1 = { 'Content-Type': 'multipart/form-data;charset=utf-8' }
const headers2 = { 'Content-Type': 'form-data;charset=utf-8' }

const login = post('/login/loginCheck', headers1) // 登录
const loginOut = post('/login/loginOut') // 退出

const postResource = get('/resource/getResource') // 获取菜单资源
const getAllResource = get('/resource/getAllResource') // 获取所有菜单资源
const getResourceById = get('/resource/findById') // 查询单个菜单接口
const EditResource = post('/role/getEditResource') // 修改

const rolePage = get('/role/page') // 角色管理-角色列表
const roleAdd = post('/role/add', headers) // 角色管理-添加
const roleUpdate = post('/role/update', headers) // 角色管理-更新
const roleDelete = get('/role/delete') // 角色管理-删除

const adminlist = get('/admin/page') // 用户-列表
const adminadd = post('/admin/add', headers) // 用户-新增
const resetPasswd = get('/admin/resetPasswd') // 用户-重置密码
const adminUpdate = post('/admin/update', headers) // 用户-更新
const adminDelete = get('/admin/delete') // 用户-删除

const saveResource = post('/resource/save', headers) // 新增菜单资源接口
const deleteResource = get('/resource/delete') // 删除单个菜单接口
const updateResource = post('/resource/update', headers) // 更新菜单资源接口
const deleteResources = post('/resource/deleteByIds') // 批量删除菜单资源接口

const uploadFlie = post('/sys/upload/file', headers1) // 附件上传
const uploadIcon = post('/sys/upload/icon', headers1) // 图片上传-icon
const uploadBanner = post('/sys/upload/banner', headers1) // 图片上传-轮播图
const uploadUse = post('/sys/upload/use', headers1) // 图片上传-功能icon
const uploadUseHead = post('/sys/upload/usehead', headers1) // 图片上传-用户头像
const uploadGoodsPic = post('/sys/upload/goodspic', headers1) // 图片上传-商品图
const uploadCustomerIcon = post('/sys/upload/customerIcon', headers1) // 图片上传-客服头像
const uploadApk = post('/sys/upload/apk', headers1) // apk上传

const logPage = post('/log/page', headers2) // 管理员操作日志

const bannerPage = get('/banner/page') // 轮播图列表
const bannerUpdate = post('/banner/update', headers2) // 轮播图列表-更新
const bannerAdd = post('/banner/add', headers2) // 轮播图列表-新增
const bannerDelete = get('/banner/deleteById') // 轮播图列表-删除

const versionPage = post('/version/page', headers) // apk版本更新管理-查询-
const versionUpdate = post('/version/update', headers) // apk版本更新管理-更新-
const versionAdd = post('/version/add', headers) // apk版本更新管理-新增-
const versionDelete = get('/version/delete') // apk版本更新管理-删除-


const customerPage = get('/customer/page') // 人工服务配置-客服列表
const findCustomer = get('/customer/findById') // 人工服务配置-客服列表根据id查询
const customerUpdate = post('/customer/update', headers2) // 人工服务配置-客服列表-更新
const customerAdd = post('/customer/add', headers2) // 人工服务配置-客服列表-新增
const customerDelete = get('/customer/deleteById') // 人工服务配置-客服列表-删除
const customerDeletes = get('/customer/deleteByIds') // 人工服务配置-客服列表-批量删除

const permissionPage = get('/permission/page') // 功能业务配置-会员权限配置-查询
const permissionAdd = post('/permission/add', headers2) // 功能业务配置-会员权限配置-新增
const permissionUpdate = post('/permission/update', headers2) // 功能业务配置-会员权限配置-编辑
const permissionDelete = get('/permission/delete') // 功能业务配置-会员权限配置-删除

const chargePage = get('/charge/page') // 功能业务配置-统一诊断配置-查询
const chargeAdd = post('/charge/add', headers2) // 功能业务配置-统一诊断配置-新增
const chargeUpdate = post('/charge/update', headers2) // 功能业务配置-统一诊断配置-编辑
const chargeDelete = get('/charge/deleteByIds') // 功能业务配置-统一诊断配置-删除

const creditProPage = get('/creditPro/page') // 功能业务配置-信用提升规则配置-首页
const repaymentRule = get('/creditPro/page/repaymentRule') // 功能业务配置-信用提升规则配置-还款计划配置列表
const addRepaymentRule = post('/creditPro/addRepaymentRule', headers2) // 功能业务配置-信用提升规则配置-还款计划配置列表-新增
const updateRepaymentRule = post('/creditPro/updateRepaymentRule', headers2) // 功能业务配置-信用提升规则配置-还款计划配置列表-编辑
const deleteRepaymentRule = get('/creditPro/deleteRepaymentRule') // 功能业务配置-信用提升规则配置-还款计划配置列表-删除

const consumRule = get('/creditPro/page/consumRule') // 功能业务配置-信用提升规则配置-消费计划配置列表
const addConsumRule = post('/creditPro/addConsumRule', headers2) // 功能业务配置-信用提升规则配置-消费计划配置列表-新增
const updateConsumRule = post('/creditPro/updateConsumRule', headers2) // 功能业务配置-信用提升规则配置-消费计划配置列表-编辑
const deleteConsumRule = get('/creditPro/deleteConsumRule') // 功能业务配置-信用提升规则配置-消费计划配置列表-删除

const consumDefault = get('/creditPro/page/default') // 功能业务配置-信用提升规则配置-消费计划默认配置列表/还款计划默认配置列表
const updateRuleDefault = post('/creditPro/updateDefault', headers2) // 功能业务配置-信用提升规则配置-消费计划默认配置接口-编辑/还款计划默认配置列表-编辑 

const getConfig = get('/turnoverConfig/getConfig') // 功能业务配置-周转配置-周转分笔配置接口-获取
const updateConfig = post('/turnoverConfig/updateConfig', headers) // 功能业务配置-周转配置-周转分笔配置接口-更新
const addTurnover = post('/turnoverConfig/addConfig', headers) // 功能业务配置-周转配置-周转分笔配置接口-新增
const deleteTurnover = post('/turnoverConfig/deleteConfig') // 功能业务配置-周转配置-周转分笔配置接口-删除
const basicsPage = get('/basics/page') // 功能业务配置-周转配置-周转基础配置管理-获取
const basicsUpdate = post('/basics/update', headers2) // 功能业务配置-周转配置-周转基础配置管理-更新
const basicsAdd = post('/basics/add', headers2) // 功能业务配置-周转配置-周转基础配置管理-新增
const basicsDelete = get('/basics/delete') // 功能业务配置-周转配置-周转基础配置管理-删除
const basicsFindById = get('/basics/findById') // 功能业务配置-周转配置-周转基础配置管理-根据ID查询接口

const configs = get('/diag/configs') // 功能业务配置-信用诊断-获取配置列表
const updateAttr = post('/diag/updateAttr') // 功能业务配置-信用诊断-更新配置属性
const deleteConfig = post('/diag/deleteConfig') // 功能业务配置-信用诊断-删除配置
const saveConfig = post('/diag/saveConfig', headers) // 功能业务配置-信用诊断-新增配置属性

const bankList = get('/bank/list') // 银行卡列表
const bankNameList = get('/bank/nameList') // 银行列表(只包含ID与名称)接口
const bankDetail = get('/bank/detail') // 银行卡列表-查询-银行信息
const updateBank = post('/bank/update', headers) // 银行卡列表-更新-银行信息
const addBank = post('/bank/add', headers) // 银行卡列表-新增-银行信息
const deleteBank = get('/bank/delete') // 银行卡列表-删除-银行信息
const bankRule = get('/bankRule/findByBankId') // 银行卡列表-查询-银行提额规则
const deleteBankRule = get('/bankRule/delete') // 银行卡列表-删除-银行提额规则
const updateRule = post('/bankRule/update', headers) // 银行卡列表-更新-银行提额规则
const addBankRule = post('/bankRule/add', headers) // 银行卡列表-新增-银行提额规则
const parameter = get('/parameter/findByBankId') // 银行卡列表-查询-提示语信息
const updateParameter = post('/parameter/update', headers) // 银行卡列表-更新-银行提示语配置
const addParameter = post('/parameter/add', headers) // 银行卡列表-新增-银行提示语配置
const deleteParameter = get('/parameter/delete') // 银行卡列表-删除-银行提示语配置

const creditCardPage = post('/card/page', headers) // 信用卡管理-分页条件查询列表
const deleteCreditCard = get('/card/delete') // 信用卡管理-分页条件查询列表-删除
const updateCreditCard = post('/card/update', headers) // 信用卡管理-分页条件查询列表-更新
const addCreditCard = post('/card/add', headers) // 信用卡管理-分页条件查询列表-新增
const userDiagPage = get('/record/page') // 信用卡管理-诊断记录
const creditTurnoverPage = post('/turnover/page', headers) // 信用卡管理-信用卡周转计划管理-分页条件查询列表
const creditTurnoverGetSinglePlan = get('/turnover/getSinglePlan') // 信用卡管理-信用卡周转计划管理-单卡周转计划
const creditDetailPlan = get('/turnover/detailPlan') // 信用卡管理-信用卡周转计划管理-周转消费计划分笔
const creditSignPlan = get('/turnover/signPlan') // 信用卡管理-信用卡周转计划管理-标记周转计划完成
const creditSignDetail = get('/turnover/signDetail') // 信用卡管理-信用卡周转计划管理-标记分笔消费完成
const creditProPlan = post('/proPlan/page', headers) // 信用卡管理-信用卡提额计划管理-分页条件查询列表
const creditProPlanDetails = get('/proPlan/details') // 信用卡管理-信用卡提额计划管理-单卡计划详情列表
const creditSignCR = post('/proPlan/signConsumOrRepayment', headers2) // 信用卡管理-信用卡提额计划管理-标记状态与金额
const produceConsumPlan = get('/proPlan/produceConsumPlan') // 信用卡管理-信用卡提额计划管理-生成消费计划
const produceRepaymentPlan = get('/proPlan/produceRepaymentPlan') // 信用卡管理-信用卡提额计划管理-生成还款计划
const billPage = _get('/cardBill/billPage') // 信用卡管理-账单管理-分页条件查询列表
const signBill = _put('/cardBill/signBill') // 信用卡管理-账单管理-标记还款
const unSignBill = _put('/cardBill/unSignBill') // 信用卡管理-账单管理-取消标记还款
const quotaHistory = post('/card/quotaHistory', headers) // 信用卡管理-额度变动历史列表

const userList = post('/user/page', headers) // 会员列表-用户接口
const updateUserList = post('/user/update', headers) // 会员列表-更新
const UchangeStatu = get('/user/changeStatu') // 启用禁用-用户注册
const userInfoBase = get('/userInfo/findByUid') // 会员管理基本信息-根据会员ID查询
const updateUserInfoBase = post('/userInfo/update', headers) // 会员管理基本信息-更新
const findAddServicePage = post('/addService/page', headers) // 会员-增值服务查询
const updateAddServiceBySid = post('/addService/update', headers) // 会员-增值服务更新
const addAddService = post('/addService/add', headers) // 会员-增值服务添加
const creditNumPage = post('/creditNum/page', headers) // 会员-诚信分诊断记录P


const goodsInfo = post('/vipGoods/page', headers) // 商品管理-获取所有商品
const updateGoods = put('/vipGoods/update', headers) // 商品管理-修改商品属性
const addGoods = post('/vipGoods/add', headers) // 商品管理-添加商品
const deleteGoods = post('/vipGoods/delete') // 商品管理-删除商品

const serviceGoodsPage = get('/goods/page') // 商品管理-服务商商品管理-分页查询列表
const serviceGoodsID = _get('/goods') // 商品管理-服务商商品管理-根据ID查询
const updateServiceGoods = _put('/goods', headers) // 商品管理-服务商商品管理-更新商品
const deleteServiceGoods = _delete('/goods') // 商品管理-服务商商品管理-删除商品
const addServiceGoods = post('/goods/add', headers) // 商品管理-服务商商品管理-新增商品

const financeOrder = post('/order/page', headers) // 财务管理-订单列表
const updateOrder = _put('/order', headers) // 财务管理-修改订单信息

const transactionRecordPage = post('/transactionRecord/page', headers) // 财务管理-流水记录列表
const transactionRecordById = _get('/transactionRecord') // 财务管理-流水记录-根据ID查询
const deleteTransactionRecord = _deleteID('/transactionRecord') // 财务管理-流水记录-删除
const updateTransactionRecord = _put('/transactionRecord', headers) // 财务管理-流水记录-更新
const addTransactionRecord = post('/transactionRecord/add', headers) // 财务管理-流水记录-新增

const newOrderPage = post('/order1/page', headers) // 财务管理-新订单管理-订单列表
const deleteOrder1 = _deleteID('/order1') // 财务管理-新订单管理-删除
const updateOrder1 = _put('/order1', headers) // 财务管理-新订单管理-更新
const addOrder1 = post('/order1/add', headers) // 财务管理-新订单管理-新增

export {

    login,
    loginOut,

    postResource,
    getAllResource,
    EditResource,

    rolePage,
    roleAdd,
    roleUpdate,
    roleDelete,

    adminlist,
    adminadd,
    resetPasswd,
    adminUpdate,
    adminDelete,

    saveResource,
    deleteResource,
    updateResource,
    deleteResources,
    getResourceById,
    uploadFlie,
    uploadBanner,
    uploadIcon,
    uploadUse,
    uploadUseHead,
    uploadCustomerIcon,
    uploadGoodsPic,
    uploadApk,
    logPage,
    bannerPage,
    bannerUpdate,
    bannerAdd,
    bannerDelete,
    versionPage,
    versionUpdate,
    versionAdd,
    versionDelete,

    userList,
    UchangeStatu,
    findAddServicePage,
    updateAddServiceBySid,
    addAddService,
    userDiagPage,
    userInfoBase,
    updateUserInfoBase,
    updateUserList,

    bankList,
    bankNameList,
    bankDetail,
    parameter,
    bankRule,
    updateBank,
    deleteBank,
    addBank,
    updateParameter,
    updateRule,
    deleteParameter,
    deleteBankRule,
    addBankRule,
    addParameter,

    creditCardPage,
    deleteCreditCard,
    updateCreditCard,
    addCreditCard,
    creditTurnoverPage,
    creditTurnoverGetSinglePlan,
    creditDetailPlan,
    creditSignPlan,
    creditSignDetail,
    creditProPlan,
    creditSignCR,
    produceConsumPlan,
    produceRepaymentPlan,
    creditNumPage,
    creditProPlanDetails,
    billPage,
    signBill,
    unSignBill,
    quotaHistory,

    configs,
    updateAttr,
    deleteConfig,
    saveConfig,

    getConfig,
    updateConfig,

    goodsInfo,
    updateGoods,
    addGoods,
    deleteGoods,
    serviceGoodsPage,
    serviceGoodsID,
    updateServiceGoods,
    deleteServiceGoods,
    addServiceGoods,

    financeOrder,
    updateOrder,
    transactionRecordPage,
    transactionRecordById,
    deleteTransactionRecord,
    updateTransactionRecord,
    addTransactionRecord,
    newOrderPage,
    deleteOrder1,
    updateOrder1,
    addOrder1,

    customerPage,
    findCustomer,
    customerUpdate,
    customerAdd,
    customerDelete,
    customerDeletes,

    permissionPage,
    permissionAdd,
    permissionUpdate,
    permissionDelete,

    chargePage,
    chargeAdd,
    chargeUpdate,
    chargeDelete,

    basicsPage,
    basicsUpdate,
    basicsAdd,
    basicsDelete,
    basicsFindById,

    addTurnover,
    deleteTurnover,

    creditProPage,
    repaymentRule,
    addRepaymentRule,
    updateRepaymentRule,
    deleteRepaymentRule,
    consumRule,
    addConsumRule,
    updateConsumRule,
    deleteConsumRule,
    consumDefault,
    updateRuleDefault,


}