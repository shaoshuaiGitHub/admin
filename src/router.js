import Vue from "vue"
import Router from "vue-router"
import Home from "./views/Home"
import Role from "./views/system/role/Role" // 系统管理--权限
import RoleAdd from "./views/system/role/RoleAdd" // 系统管理--权限 添加
import RoleEditor from "./views/system/role/RoleEditor" // 系统管理--权限  编辑
import RoleAdmin from "./views/system/role/RoleAdmin" // 系统管理--权限  编辑
import SystemAdmin from "./views/system/admin/index" // 系统管理--用户  编辑
import Menu from "./views/system/menu/Menu" // 系统管理--菜单管理
import UpLoad from "./views/system/upload/UpLoad" // 系统管理--图片上传
import SystemLog from "./views/system/syslog/SystemLog" // 系统管理--管理员操作日志
import Banner from "./views/system/banner/Banner" // 系统管理--轮播图管理
import Version from "./views/system/version/Version.vue" // 系统管理--apk版本更新

import MemberList from "./views/user/list/MemberList" //会员管理-会员列表
import AddService from "./views/user/service/AddService" //会员管理-增值服务


import BankList from "./views/bank/list/BankList" //银行管理-银行列表
import BankMessage from "./views/bank/list/BankMessage" //银行管理-银行信息
import Parameter from "./views/bank/list/Parameter" //银行管理-银行提示语
import BankRules from "./views/bank/list/BankRules" //银行管理-银行提额规则

import CreditCard from "./views/creditcard/list/CreditCard.vue" //信用卡管理-信用卡列表
import UserDiag from "./views/creditcard/udiag/UserDiag.vue" //信用卡管理-会员评分列表
import CreditTurn from "./views/creditcard/turn/CreditTurn.vue" //信用卡管理-周转计划
import TurnDetail from "./views/creditcard/turn/TurnDetail.vue" //信用卡管理-周转计划-计划详情
import CreditPro from "./views/creditcard/pro/CreditPro.vue" //信用卡管理-提额计划
import CreditConsum from "./views/creditcard/pro/CreditConsum.vue" //信用卡管理-提额计划-消费计划
import CreditRepey from "./views/creditcard/pro/CreditRepey.vue" //信用卡管理-提额计划-还款计划

import Permission from "./views/business/permission/Permission" //功能业务配置-会员权限管理
import Charge from "./views/business/unify/Charge" //功能业务配置-统一诊断收费
import NewTurnover from "./views/business/newturnover/NewTurnover" //功能业务配置-周转规则
import Quota from "./views/business/newquota/Quota" //功能业务配置-提额规则配置
import QuotaConfig from "./views/business/newquota/QuotaConfig.vue" //功能业务配置-提额规则配置-计划表
import DefaultQuota from "./views/business/newquota/DefaultQuota.vue" //功能业务配置-提额规则配置-默认计划表
import DQBankList from "./views/business/diag/DQBankList" //功能业务配置-额度诊断配置-银行列表
import QDS from "./views/business/diag/QDS" //功能业务配置-额度诊断配置-额度诊断得分配置
import QPF from "./views/business/diag/QPF" //功能业务配置-额度诊断配置-预测提额率配置
import CPF from "./views/business/diag/CPF" //功能业务配置-额度诊断配置-可提额率配置
import PDF from "./views/business/diag/PDF" //功能业务配置-额度诊断配置-预提时间配置
import QPP from "./views/business/diag/QPP" //功能业务配置-额度诊断配置-逾期建议配置
import QRP from "./views/business/diag/QRP.vue" //功能业务配置-额度诊断配置-逾期建议配置
import CardQuota from "./views/business/diag/CardQuota.vue" //功能业务配置-额度诊断配置-信用卡平均额度
import ProRules from "./views/business/diag/ProRules.vue" //功能业务配置-额度诊断配置-提额规则
import DCBankList from "./views/business/consum/DCBankList" //功能业务配置-消费诊断配置-银行列表
import CTProPosal from "./views/business/consum/CTProPosal" //功能业务配置-消费诊断配置-消费诊断得分配置
import CDScore from "./views/business/consum/CDScore" //功能业务配置-消费诊断配置-消费时间建议
import ConsumEssay from "./views/business/consum/ConsumEssay.vue" //功能业务配置-消费诊断配置-取现消费建议
import ConsumManagerP from "./views/business/consum/ConsumManagerP.vue" //功能业务配置-消费诊断配置-消费诊断管理师建议配置
import DRBankList from "./views/business/repayment/DRBankList" //功能业务配置-还款诊断配置-银行列表
import RDScore from "./views/business/repayment/RDScore" //功能业务配置-还款诊断配置-还款诊断得分配置
import RepayManagerP from "./views/business/repayment/RepayManagerP.vue" //功能业务配置-还款诊断配置-管理师建议
import RepayRate from "./views/business/repayment/RepayRate.vue" //功能业务配置-还款诊断配置-额度使用率
import RTProPosal from "./views/business/repayment/RTProPosal" //功能业务配置-还款诊断配置-每月还款笔数建议配置
import BaseBankList from "./views/business/other/BaseBankList.vue" //功能业务配置-其他诊断配置-银行列表
import BaseScore from "./views/business/other/BaseScore.vue" //功能业务配置-其他诊断配置-银行列表

import Goods from "./views/goods/goodsInfo/Goods" //商品管理-商品信息
import OrderList from "./views/finance/order/OrderList" //财务管理-订单列表
import PayMode from "./views/finance/pay/PayMode" //财务管理-支付方式配置
import CustomerList from "./views/service/customer/CustomerList" //人工服务配置-客服列表

import Login from "./views/Login"
import { login, consumPlans } from "./api"

Vue.use(Router);

const router = new Router({
    routes: [

        { //登录
            path: '/login',
            name: 'login',
            component: Login

        },
        { //根目录
            path: "/",
            name: "home",
            component: Home,
            redirect: '/system/admin',
            children: [{ //系统菜单管理
                    path: "/system/menu",
                    name: "menu",
                    component: Menu,
                    meta: {
                        key: ['SYS_MENU_MANAGE'],
                        parentkey: ['SYS_MANAGE']
                    }
                },
                { //系统用户管理
                    path: "/system/admin",
                    name: "systemAdmin",
                    component: SystemAdmin,
                    meta: {
                        key: ['SYS_ADMIN_MANAGE'],
                        parentkey: ['SYS_MANAGE']
                    }
                },
                { //角色权限管理
                    path: "/system/role",
                    name: "role",
                    component: Role,
                    meta: {
                        key: ['SYS_ROLE_MANEGE'],
                        parentkey: ['SYS_MANAGE']
                    }
                },
                { //角色权限管理-新增
                    path: "/system/roleadd",
                    name: "roleadd",
                    component: RoleAdd,
                    meta: {
                        key: ['SYS_ROLE_MANEGE'],
                        parentkey: ['SYS_MANAGE']
                    }
                },
                { //角色权限管理-修改权限
                    path: "/system/roleeditor/:id",
                    name: "roleeditor",
                    component: RoleEditor,
                    meta: {
                        key: ['SYS_ROLE_MANEGE'],
                        parentkey: ['SYS_MANAGE']
                    }
                },

                { //图片上传
                    path: "/system/upload",
                    name: "upload",
                    component: UpLoad,
                    meta: {
                        key: ['SYS_UP_LOAD'],
                        parentkey: ['SYS_MANAGE']
                    }
                },
                { //管理员操作日志
                    path: "/system/syslog",
                    name: "systemlog",
                    component: SystemLog,
                    meta: {
                        key: ['SYS_LOG_MANAGE'],
                        parentkey: ['SYS_MANAGE']
                    }
                },
                { //轮播图管理
                    path: "/system/banner",
                    name: "banner",
                    component: Banner,
                    meta: {
                        key: ['SYS_BANNER_LIST'],
                        parentkey: ['SYS_MANAGE']
                    }
                },
                { //apk版本更新管理
                    path: "/system/version",
                    name: "version",
                    component: Version,
                    meta: {
                        key: ['SYS_VERSION_UPDATE_MANAGE'],
                        parentkey: ['SYS_MANAGE']
                    }
                },
                { //银行管理-银行列表
                    path: "/bank/list",
                    name: "banklist",
                    component: BankList,
                    meta: {
                        key: ['SYS_BANK_LIST'],
                        parentkey: ['SYS_BANK_MANAGE']
                    }
                },
                { //银行管理-银行信息
                    path: "/bank/list/:id/:phone",
                    name: "bankmessage",
                    component: BankMessage,
                    meta: {
                        key: ['SYS_BANK_LIST'],
                        parentkey: ['SYS_BANK_MANAGE']
                    }
                },
                { //银行管理-银行提示语
                    path: "/bank/list/:id/:name",
                    name: "parameter",
                    component: Parameter,
                    meta: {
                        key: ['SYS_BANK_LIST'],
                        parentkey: ['SYS_BANK_MANAGE']
                    }
                },
                { //银行管理-银行提额规则
                    path: "/bank/list/:id/:name",
                    name: "bankrules",
                    component: BankRules,
                    meta: {
                        key: ['SYS_BANK_LIST'],
                        parentkey: ['SYS_BANK_MANAGE']
                    }
                },
                { //信用卡管理-信用卡列表
                    path: "/creditcard/list",
                    name: "creditcard",
                    component: CreditCard,
                    meta: {
                        key: ['SYS_CREDIT_CARD_USERLIST'],
                        parentkey: ['SYS_CREDIT_CARD']
                    }
                },
                { //信用卡管理-信用评分列表
                    path: "/creditcard/udiag",
                    name: "userdiag",
                    component: UserDiag,
                    meta: {
                        key: ['SYS_CREDIT_DIAG'],
                        parentkey: ['SYS_CREDIT_CARD']
                    }
                },
                { //信用卡管理-周转计划
                    path: "/creditcard/turn",
                    name: "creditturn",
                    component: CreditTurn,
                    meta: {
                        key: ['SYS_CREDIT_TURNOVER'],
                        parentkey: ['SYS_CREDIT_CARD']
                    }
                },
                { //信用卡管理-周转计划-计划详情
                    path: "/creditcard/turn/:id/:name",
                    name: "turndetail",
                    component: TurnDetail,
                    meta: {
                        key: ['SYS_CREDIT_TURNOVER'],
                        parentkey: ['SYS_CREDIT_CARD']
                    }
                },
                { //信用卡管理-提额计划
                    path: "/creditcard/pro",
                    name: "creditpro",
                    component: CreditPro,
                    meta: {
                        key: ['SYS_CREDIT_PRO'],
                        parentkey: ['SYS_CREDIT_CARD']
                    }
                },
                { //信用卡管理-提额计划-消费计划
                    path: "/creditcard/pro/:id/:date",
                    name: "creditconsum",
                    component: CreditConsum,
                    meta: {
                        key: ['SYS_CREDIT_PRO'],
                        parentkey: ['SYS_CREDIT_CARD']
                    }
                },
                { //信用卡管理-提额计划-还款计划
                    path: "/creditcard/pro/:id/:date",
                    name: "creditrepey",
                    component: CreditRepey,
                    meta: {
                        key: ['SYS_CREDIT_PRO'],
                        parentkey: ['SYS_CREDIT_CARD']
                    }
                },

                { //会员管理-会员列表
                    path: "/user/list",
                    name: "userlist",
                    component: MemberList,
                    meta: {
                        key: ['SYS_USER_LIST'],
                        parentkey: ['SYS_USER_MANAGE']
                    }
                },
                { //会员管理-增值服务
                    path: "/user/service",
                    name: "addservice",
                    component: AddService,
                    meta: {
                        key: ['SYS_ADD_SERVICE'],
                        parentkey: ['SYS_USER_MANAGE']
                    }
                },


                { //功能业务配置-会员权限管理
                    path: "/business/permission",
                    name: "permission",
                    component: Permission,
                    meta: {
                        key: ['SYS_MEMBER_PERM'],
                        parentkey: ['SYS_BUSINESS_MANAGE']
                    }
                },
                { //功能业务配置-统一诊断收费
                    path: "/business/unify",
                    name: "charge",
                    component: Charge,
                    meta: {
                        key: ['SYS_DIAG_UNIFY'],
                        parentkey: ['SYS_BUSINESS_MANAGE']
                    }
                },
                { //功能业务配置-周转规则
                    path: "/business/newturnover",
                    name: "newturnover",
                    component: NewTurnover,
                    meta: {
                        key: ['SYS_NEW_TURNOVER'],
                        parentkey: ['SYS_BUSINESS_MANAGE']
                    }
                },
                { //功能业务配置-提额规则配置
                    path: "/business/newquota",
                    name: "quota",
                    component: Quota,
                    meta: {
                        key: ['SYS_QUOTA_PROP'],
                        parentkey: ['SYS_BUSINESS_MANAGE']
                    }
                },
                { //功能业务配置-计划表
                    path: "/quotaconfig/:id/:name/:typeKey",
                    name: "quotaconfig",
                    component: QuotaConfig,
                    meta: {
                        key: ['SYS_QUOTA_PROP'],
                        parentkey: ['SYS_BUSINESS_MANAGE']
                    }
                },
                { //功能业务配置-默认计划表
                    path: "/defaultquota",
                    name: "defaultquota",
                    component: DefaultQuota,
                    meta: {
                        key: ['SYS_QUOTA_PROP'],
                        parentkey: ['SYS_BUSINESS_MANAGE']
                    }
                },

                { //功能业务配置-额度诊断配置-银行列表
                    path: "/business/diag",
                    name: "quotabank",
                    component: DQBankList,
                    meta: {
                        key: ["SYS_DIAG_QUOTA_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },
                { //功能业务配置-额度诊断配置-额度诊断得分配置
                    path: "/quota/:id/:name/:configKey",
                    name: "qds",
                    component: QDS,
                    meta: {
                        key: ["SYS_DIAG_QUOTA_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },
                { //功能业务配置-额度诊断配置-预测提额率配置
                    path: "/quota/:id/:name/:configKey",
                    name: "qpf",
                    component: QPF,
                    meta: {
                        key: ["SYS_DIAG_QUOTA_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },
                { //功能业务配置-额度诊断配置-可提额率配置
                    path: "/quota/:id/:name/:configKey",
                    name: "cpf",
                    component: CPF,
                    meta: {
                        key: ["SYS_DIAG_QUOTA_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },
                { //功能业务配置-额度诊断配置-预提时间配置
                    path: "/quota/:id/:name/:configKey",
                    name: "pdf",
                    component: PDF,
                    meta: {
                        key: ["SYS_DIAG_QUOTA_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },
                { //功能业务配置-额度诊断配置-逾期建议配置
                    path: "/quota/:id/:name/:configKey",
                    name: "qpp",
                    component: QPP,
                    meta: {
                        key: ["SYS_DIAG_QUOTA_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },
                { //功能业务配置-额度诊断配置-额度保留率建议配置
                    path: "/quota/:id/:name/:configKey",
                    name: "qrp",
                    component: QRP,
                    meta: {
                        key: ["SYS_DIAG_QUOTA_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },
                { //功能业务配置-额度诊断配置-信用卡平均额度
                    path: "/quota/:id/:name",
                    name: "cardquota",
                    component: CardQuota,
                    meta: {
                        key: ["SYS_DIAG_QUOTA_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },
                { //功能业务配置-额度诊断配置-提额规则
                    path: "/quota/:id/:name",
                    name: "prorules",
                    component: ProRules,
                    meta: {
                        key: ["SYS_DIAG_QUOTA_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },
                { //功能业务配置-消费诊断配置-银行列表
                    path: "/business/consum",
                    name: "consumbank",
                    component: DCBankList,
                    meta: {
                        key: ["SYS_DIAG_CONSUM_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },
                { //功能业务配置-消费诊断配置-消费诊断得分配置
                    path: "/consum/:id/:name/:configKey",
                    name: "cdscore",
                    component: CDScore,
                    meta: {
                        key: ["SYS_DIAG_CONSUM_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },
                { //功能业务配置-消费诊断配置-消费时间建议
                    path: "/consum/:id/:name/:configKey",
                    name: "ctproposal",
                    component: CTProPosal,
                    meta: {
                        key: ["SYS_DIAG_CONSUM_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },
                { //功能业务配置-消费诊断配置-取现消费建议
                    path: "/consum/:id/:name/:configKey",
                    name: "consumessay",
                    component: ConsumEssay,
                    meta: {
                        key: ["SYS_DIAG_CONSUM_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },
                { //功能业务配置-消费诊断配置-消费诊断管理师建议配置
                    path: "/consum/:id/:name/:configKey",
                    name: "consummanagerp",
                    component: ConsumManagerP,
                    meta: {
                        key: ["SYS_DIAG_CONSUM_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },
                { //功能业务配置-还款诊断配置-银行列表
                    path: "/business/repayment",
                    name: "repaymentbank",
                    component: DRBankList,
                    meta: {
                        key: ["SYS_DIAG_REPAYMENT_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },
                { //功能业务配置-还款诊断配置-还款诊断得分配置
                    path: "/repayment/:id/:name/:configKey",
                    name: "rdscore",
                    component: RDScore,
                    meta: {
                        key: ["SYS_DIAG_REPAYMENT_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },
                { //功能业务配置-还款诊断配置-每月还款笔数建议配置
                    path: "/repayment/:id/:name/:configKey",
                    name: "rtproposal",
                    component: RTProPosal,
                    meta: {
                        key: ["SYS_DIAG_REPAYMENT_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },
                { //功能业务配置-还款诊断配置-管理师建议
                    path: "/repayment/:id/:name/:configKey",
                    name: "repaymanagerp",
                    component: RepayManagerP,
                    meta: {
                        key: ["SYS_DIAG_REPAYMENT_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },
                { //功能业务配置-还款诊断配置-额度使用率
                    path: "/repayment/:id/:name/:configKey",
                    name: "repayrate",
                    component: RepayRate,
                    meta: {
                        key: ["SYS_DIAG_REPAYMENT_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },
                { //功能业务配置-其他诊断配置-银行列表
                    path: "/business/other",
                    name: "basebanklist",
                    component: BaseBankList,
                    meta: {
                        key: ["SYS_DIAG_OTHER_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },
                { //功能业务配置-其他诊断配置-基础诊断
                    path: "/other/:id/:name/:configKey",
                    name: "basescore",
                    component: BaseScore,
                    meta: {
                        key: ["SYS_DIAG_OTHER_CONFIG"],
                        parentkey: ["SYS_BUSINESS_MANAGE"]
                    }
                },

                { //商品管理-商品信息
                    path: "/goods/goodsInfo",
                    name: "goods",
                    component: Goods,
                    meta: {
                        key: ["SYS_GOODS_INFO"],
                        parentkey: ["SYS_GOODS"]
                    }
                },
                { //财务管理-订单列表
                    path: "/finance/order",
                    name: "orderlist",
                    component: OrderList,
                    meta: {
                        key: ["SYS_FINANCE_ORDER"],
                        parentkey: ["SYS_FINANCE_MANAGE"]
                    }
                },
                { //财务管理-支付方式配置
                    path: "/finance/pay",
                    name: "paymode",
                    component: PayMode,
                    meta: {
                        key: ["SYS_FINANCE_PAY"],
                        parentkey: ["SYS_FINANCE_MANAGE"]
                    }
                },
                { //人工服务配置-客服列表
                    path: "/service/customer",
                    name: "customerlist",
                    component: CustomerList,
                    meta: {
                        key: ["SYS_CUSTOMER_SERVICE"],
                        parentkey: ["SYS_HUMAN_SERVICE_MANAGE"]
                    }
                },
            ]
        },

    ]
})

// 注册一个全局守卫， 作用是在路由跳转前， 对路由进行判断， 防止未登录的用户跳转到其他需要登录的页面去
router.beforeEach((to, from, next) => {
    let userinfo = localStorage.getItem('userinfo')
        // 如果已经登录，那我不干涉你，让你随便访问
    if (userinfo) {
        next()
    } else {
        if (to.path !== '/login') {
            // 如果没有登录，但你访问其他需要登录的页面，那我就让你跳到登录页面去
            next({ path: '/login' })
        } else {
            // 如果没有登录，但你访问的login，那就不干涉你，让你访问
            next()
        }
    }
})

export default router