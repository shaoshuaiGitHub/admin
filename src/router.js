import Vue from "vue"
import Router from "vue-router"
import Home from "./views/Home"
import Role from "./views/system/role/Role" // 系统管理--权限
import RoleAdd from "./views/system/role/RoleAdd" // 系统管理--权限 添加
import RoleEditor from "./views/system/role/RoleEditor" // 系统管理--权限  编辑
import RoleAdmin from "./views/system/role/RoleAdmin" // 系统管理--权限  编辑
import SystemAdmin from "./views/system/admin/index" // 系统管理--用户  编辑
import Menu from "./views/system/menu/Menu" // 系统管理--菜单管理
import SystemLog from "./views/system/syslog/SystemLog" // 系统管理--管理员操作日志

import MemberList from "./views/user/list/MemberList" //会员管理-会员列表
import AddService from "./views/user/service/AddService" //会员管理-增值服务
import Integriy from "./views/user/diag/Integriy.vue" //会员管理-诚信分诊断记录


import BankList from "./views/bank/list/BankList" //银行管理-银行列表
import Parameter from "./views/bank/list/Parameter" //银行管理-银行提示语

import CreditCard from "./views/creditcard/list/CreditCard.vue" //信用卡管理-信用卡列表
import BillInfo from "./views/creditcard/list/BillInfo.vue" //信用卡管理-账单信息
import UserDiag from "./views/creditcard/udiag/UserDiag.vue" //信用卡管理-会员评分列表
import CreditTurn from "./views/creditcard/turn/CreditTurn.vue" //信用卡管理-周转计划
import TurnDetail from "./views/creditcard/turn/TurnDetail.vue" //信用卡管理-周转计划-计划详情
import CreditPro from "./views/creditcard/pro/CreditPro.vue" //信用卡管理-提额计划-首页
import CreditHorC from "./views/creditcard/pro/CreditHorC.vue" //信用卡管理-提额计划-当月或者历史
import MoenyChange from "./views/creditcard/change/MoenyChange.vue" //信用卡管理-信用卡额度变动历史

import NewTurnover from "./views/business/newturnover/NewTurnover" //功能业务配置-周转规则
import Quota from "./views/business/newquota/Quota" //功能业务配置-提额规则配置
import QuotaConfig from "./views/business/newquota/QuotaConfig.vue" //功能业务配置-提额规则配置-计划表
import DefaultQuota from "./views/business/newquota/DefaultQuota.vue" //功能业务配置-提额规则配置-默认计划表
import Permission from "./views/business/userconfig/permission/Permission.vue" //功能业务配置-会员权限管理
import Charge from "./views/business/creditdiag/unify/Charge" //功能业务配置-统一诊断收费
import DQBankList from "./views/business/creditdiag/diag/DQBankList" //功能业务配置-额度诊断配置-银行列表
import QDS from "./views/business/creditdiag/diag/QDS" //功能业务配置-额度诊断配置-额度诊断得分配置
import QPF from "./views/business/creditdiag/diag/QPF" //功能业务配置-额度诊断配置-预测提额率配置
import CPF from "./views/business/creditdiag/diag/CPF" //功能业务配置-额度诊断配置-可提额率配置
import PDF from "./views/business/creditdiag/diag/PDF" //功能业务配置-额度诊断配置-预提时间配置
import QPP from "./views/business/creditdiag/diag/QPP" //功能业务配置-额度诊断配置-逾期建议配置
import QRP from "./views/business/creditdiag/diag/QRP.vue" //功能业务配置-额度诊断配置-逾期建议配置
import CardQuota from "./views/business/creditdiag/diag/CardQuota.vue" //功能业务配置-额度诊断配置-信用卡平均额度
import ProRules from "./views/business/creditdiag/diag/ProRules.vue" //功能业务配置-额度诊断配置-提额规则
import DCBankList from "./views/business/creditdiag/consum/DCBankList" //功能业务配置-消费诊断配置-银行列表
import CTProPosal from "./views/business/creditdiag/consum/CTProPosal" //功能业务配置-消费诊断配置-消费诊断得分配置
import CDScore from "./views/business/creditdiag/consum/CDScore" //功能业务配置-消费诊断配置-消费时间建议
import ConsumEssay from "./views/business/creditdiag/consum/ConsumEssay.vue" //功能业务配置-消费诊断配置-取现消费建议
import ConsumManagerP from "./views/business/creditdiag/consum/ConsumManagerP.vue" //功能业务配置-消费诊断配置-消费诊断管理师建议配置
import DRBankList from "./views/business/creditdiag/repayment/DRBankList" //功能业务配置-还款诊断配置-银行列表
import RDScore from "./views/business/creditdiag/repayment/RDScore" //功能业务配置-还款诊断配置-还款诊断得分配置
import RepayManagerP from "./views/business/creditdiag/repayment/RepayManagerP.vue" //功能业务配置-还款诊断配置-管理师建议
import RepayRate from "./views/business/creditdiag/repayment/RepayRate.vue" //功能业务配置-还款诊断配置-额度使用率
import RTProPosal from "./views/business/creditdiag/repayment/RTProPosal" //功能业务配置-还款诊断配置-每月还款笔数建议配置
import BaseBankList from "./views/business/creditdiag/other/BaseBankList.vue" //功能业务配置-其他诊断配置-银行列表
import BaseScore from "./views/business/creditdiag/other/BaseScore.vue" //功能业务配置-其他诊断配置-银行列表

import Goods from "./views/goods/goodsInfo/Goods" //商品管理-商品信息
import ServerGoods from "./views/goods/servergoods/ServerGoods.vue" //商品管理-商品信息
import OrderList from "./views/finance/order/OrderList" //财务管理-订单列表
import RunLog from "./views/finance/run/RunLog.vue" //财务管理-流水记录
import NewOrder from "./views/finance/neworder/NewOrder.vue" //财务管理-流水记录
import CustomerList from "./views/service/customer/CustomerList" //人工服务配置-客服列表

import Base from "./components/Base.vue" //基础viewPage
import Banner from "./views/config/base/banner/Banner.vue" //系统配置-轮播图管理
import UpLoad from "./views/config/base/upload/UpLoad.vue" //系统配置-附件上传
import Version from "./views/config/base/version/Version.vue" // 系统配置--apk版本更新

import Login from "./views/Login"
import { login, consumPlans } from "./api"

Vue.use(Router);

const routerPush = Router.prototype.push //解决版本冲突    3.1.0用的是in promise 
Router.prototype.push = function push(location) {
    return routerPush.call(this, location).catch(error => error)
}
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
            // redirect: '/system/admin',
            children: [{ //系统菜单管理
                    path: "/system/menu",
                    name: "menu",
                    component: Menu,
                    meta: {
                        key: ['SYS_MENU_MANAGE'],
                        parentkey: ['SYS_MANAGE'],
                        keepAlive: true,
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

                        parentkey: ['SYS_MANAGE'],
                        keepAlive: true,
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
                { //管理员操作日志
                    path: "/system/syslog",
                    name: "systemlog",
                    component: SystemLog,
                    meta: {
                        key: ['SYS_LOG_MANAGE'],
                        parentkey: ['SYS_MANAGE']
                    }
                },
                { //银行管理-银行列表
                    path: "/bank/list",
                    name: "banklist",
                    component: BankList,
                    meta: {
                        key: ['SYS_BANK_LIST'],
                        parentkey: ['SYS_BANK_MANAGE'],
                        keepAlive: true,

                    }
                },
                { //银行管理-银行提示语
                    path: "/bank/list/:id/:name",
                    name: "parameter",
                    component: Parameter,
                    meta: {
                        key: ['SYS_BANK_LIST'],
                        parentkey: ['SYS_BANK_MANAGE'],
                        keepAlive: false,
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
                { //信用卡管理-信用卡额度变动记录
                    path: "/creditcard/change",
                    name: "moenychange",
                    component: MoenyChange,
                    meta: {
                        key: ['SYS_CREDIT_CHANGE'],
                        parentkey: ['SYS_CREDIT_CARD']
                    }
                },
                { //信用卡管理-账单信息
                    path: "/creditcard/list/:id/:quota/:bankName/:availableQuota/:cardNumber",
                    name: "billinfo",
                    component: BillInfo,
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
                        parentkey: ['SYS_CREDIT_CARD'],
                        keepAlive: true,
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
                { //信用卡管理-提额计划-首页
                    path: "/creditcard/pro",
                    name: "creditpro",
                    component: CreditPro,
                    meta: {
                        key: ['SYS_CREDIT_PRO'],
                        parentkey: ['SYS_CREDIT_CARD'],
                        keepAlive: true,
                    }
                },
                { //信用卡管理-提额计划-当月或历史
                    path: "/creditcard/pro/:id/:billDate/:col",
                    name: "creditHorC",
                    component: CreditHorC,
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
                { //会员管理-诚信分诊断记录
                    path: "/user/diag",
                    name: "integriy",
                    component: Integriy,
                    meta: {
                        key: ['SYS_INTEGRIY_DIAG'],
                        parentkey: ['SYS_USER_MANAGE']
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
                        parentkey: ['SYS_BUSINESS_MANAGE'],
                        keepAlive: true,
                    }
                },
                { //功能业务配置-计划表
                    path: "/quotaconfig/:id/:name/:typeKey",
                    name: "quotaconfig",
                    component: QuotaConfig,
                    meta: {
                        key: ['SYS_QUOTA_PROP'],
                        parentkey: ['SYS_BUSINESS_MANAGE'],
                        keepAlive: false,
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
                { //功能业务配置-会员相关配置
                    path: "/business/userconfig",
                    name: "userconfig",
                    component: Base,
                    meta: {
                        key: ['SYS_BUSINESS_USER_CONFIG'],
                        parentkey: ['SYS_BUSINESS_MANAGE']
                    },
                    redirect: '/business/userconfig/permission',
                    children: [{ //会员权限管理
                        path: "permission",
                        name: "permission",
                        component: Permission,
                        meta: {
                            key: ['SYS_BUSINESS_USER_CONFIG_PERM'],
                            parentkey: ['SYS_BUSINESS_USER_CONFIG']
                        },
                    }]
                },
                { //功能业务配置-信用诊断得分配置
                    path: "/business/creditdiag",
                    name: "creditdiag",
                    component: Base,
                    meta: {
                        key: ['SYS_BUSINESS_CREDIT_DIAG'],
                        parentkey: ['SYS_BUSINESS_MANAGE']
                    },
                    children: [{ //功能业务配置-统一诊断收费
                            path: "unify",
                            name: "charge",
                            component: Charge,
                            meta: {
                                key: ['SYS_DIAG_UNIFY'],
                                parentkey: ['SYS_BUSINESS_CREDIT_DIAG']
                            }
                        },
                        { //功能业务配置-额度诊断配置-银行列表
                            path: "diag",
                            name: "quotabank",
                            component: DQBankList,
                            meta: {
                                key: ["SYS_DIAG_QUOTA_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"],
                                keepAlive: true,
                            }
                        },
                        { //功能业务配置-额度诊断配置-额度诊断得分配置
                            path: "quota/:id/:name/:configKey",
                            name: "qds",
                            component: QDS,
                            meta: {
                                key: ["SYS_DIAG_QUOTA_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"]
                            }
                        },
                        { //功能业务配置-额度诊断配置-预测提额率配置
                            path: "quota/:id/:name/:configKey",
                            name: "qpf",
                            component: QPF,
                            meta: {
                                key: ["SYS_DIAG_QUOTA_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"]
                            }
                        },
                        { //功能业务配置-额度诊断配置-可提额率配置
                            path: "quota/:id/:name/:configKey",
                            name: "cpf",
                            component: CPF,
                            meta: {
                                key: ["SYS_DIAG_QUOTA_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"]
                            }
                        },
                        { //功能业务配置-额度诊断配置-预提时间配置
                            path: "quota/:id/:name/:configKey",
                            name: "pdf",
                            component: PDF,
                            meta: {
                                key: ["SYS_DIAG_QUOTA_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"]
                            }
                        },
                        { //功能业务配置-额度诊断配置-逾期建议配置
                            path: "quota/:id/:name/:configKey",
                            name: "qpp",
                            component: QPP,
                            meta: {
                                key: ["SYS_DIAG_QUOTA_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"]
                            }
                        },
                        { //功能业务配置-额度诊断配置-额度保留率建议配置
                            path: "quota/:id/:name/:configKey",
                            name: "qrp",
                            component: QRP,
                            meta: {
                                key: ["SYS_DIAG_QUOTA_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"]
                            }
                        },
                        { //功能业务配置-额度诊断配置-信用卡平均额度
                            path: "quota/:id/:name",
                            name: "cardquota",
                            component: CardQuota,
                            meta: {
                                key: ["SYS_DIAG_QUOTA_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"]
                            }
                        },
                        { //功能业务配置-额度诊断配置-提额规则
                            path: "quota/:id/:name",
                            name: "prorules",
                            component: ProRules,
                            meta: {
                                key: ["SYS_DIAG_QUOTA_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"]
                            }
                        },
                        { //功能业务配置-消费诊断配置-银行列表
                            path: "consum",
                            name: "consumbank",
                            component: DCBankList,
                            meta: {
                                key: ["SYS_DIAG_CONSUM_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"],
                                keepAlive: true,
                            }
                        },
                        { //功能业务配置-消费诊断配置-消费诊断得分配置
                            path: "consum/:id/:name/:configKey",
                            name: "cdscore",
                            component: CDScore,
                            meta: {
                                key: ["SYS_DIAG_CONSUM_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"]
                            }
                        },
                        { //功能业务配置-消费诊断配置-消费时间建议
                            path: "consum/:id/:name/:configKey",
                            name: "ctproposal",
                            component: CTProPosal,
                            meta: {
                                key: ["SYS_DIAG_CONSUM_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"]
                            }
                        },
                        { //功能业务配置-消费诊断配置-取现消费建议
                            path: "consum/:id/:name/:configKey",
                            name: "consumessay",
                            component: ConsumEssay,
                            meta: {
                                key: ["SYS_DIAG_CONSUM_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"]
                            }
                        },
                        { //功能业务配置-消费诊断配置-消费诊断管理师建议配置
                            path: "consum/:id/:name/:configKey",
                            name: "consummanagerp",
                            component: ConsumManagerP,
                            meta: {
                                key: ["SYS_DIAG_CONSUM_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"]
                            }
                        },
                        { //功能业务配置-还款诊断配置-银行列表
                            path: "repayment",
                            name: "repaymentbank",
                            component: DRBankList,
                            meta: {
                                key: ["SYS_DIAG_REPAYMENT_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"],
                                keepAlive: true,
                            }
                        },
                        { //功能业务配置-还款诊断配置-还款诊断得分配置
                            path: "repayment/:id/:name/:configKey",
                            name: "rdscore",
                            component: RDScore,
                            meta: {
                                key: ["SYS_DIAG_REPAYMENT_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"]
                            }
                        },
                        { //功能业务配置-还款诊断配置-每月还款笔数建议配置
                            path: "repayment/:id/:name/:configKey",
                            name: "rtproposal",
                            component: RTProPosal,
                            meta: {
                                key: ["SYS_DIAG_REPAYMENT_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"]
                            }
                        },
                        { //功能业务配置-还款诊断配置-管理师建议
                            path: "repayment/:id/:name/:configKey",
                            name: "repaymanagerp",
                            component: RepayManagerP,
                            meta: {
                                key: ["SYS_DIAG_REPAYMENT_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"]
                            }
                        },
                        { //功能业务配置-还款诊断配置-额度使用率
                            path: "repayment/:id/:name/:configKey",
                            name: "repayrate",
                            component: RepayRate,
                            meta: {
                                key: ["SYS_DIAG_REPAYMENT_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"]
                            }
                        },
                        { //功能业务配置-其他诊断配置-银行列表
                            path: "other",
                            name: "basebanklist",
                            component: BaseBankList,
                            meta: {
                                key: ["SYS_DIAG_OTHER_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"],
                                keepAlive: true,
                            }
                        },
                        { //功能业务配置-其他诊断配置-基础诊断
                            path: "other/:id/:name/:configKey",
                            name: "basescore",
                            component: BaseScore,
                            meta: {
                                key: ["SYS_DIAG_OTHER_CONFIG"],
                                parentkey: ["SYS_BUSINESS_CREDIT_DIAG"]
                            }
                        },
                    ]
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
                { //商品管理-服务商商品管理
                    path: "/goods/servergoods",
                    name: "servergoods",
                    component: ServerGoods,
                    meta: {
                        key: ["SYS_SERVER_GOODS"],
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
                { //财务管理-流水记录
                    path: "/finance/run",
                    name: "runlog",
                    component: RunLog,
                    meta: {
                        key: ["SYS_RUN_LOG"],
                        parentkey: ["SYS_FINANCE_MANAGE"]
                    }
                },
                { //财务管理-新订单管理
                    path: "/finance/neworder",
                    name: "neworder",
                    component: NewOrder,
                    meta: {
                        key: ["SYS_FINANCE_NEW_ORDER"],
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
                //基础设置
                {
                    path: "/config/base",
                    name: "base",
                    component: Base,
                    redirect: '/config/base/upload',
                    meta: {
                        key: ["SYS_CONFIG_BASE"],
                        parentkey: ["SYS_CONFIG"]
                    },
                    children: [{ //轮播图管理
                            path: "banner",
                            name: "banner",
                            component: Banner,
                            meta: {
                                key: ['SYS_BANNER_LIST'],
                                parentkey: ['SYS_CONFIG_BASE']
                            }
                        },
                        { //图片上传
                            path: "upload",
                            name: "upload",
                            component: UpLoad,
                            meta: {
                                key: ['SYS_UP_LOAD'],
                                parentkey: ['SYS_CONFIG_BASE']
                            }
                        },
                        { //apk版本更新管理
                            path: "version",
                            name: "version",
                            component: Version,
                            meta: {
                                key: ['SYS_VERSION_UPDATE_MANAGE'],
                                parentkey: ['SYS_CONFIG_BASE']

                            }
                        },
                    ]
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