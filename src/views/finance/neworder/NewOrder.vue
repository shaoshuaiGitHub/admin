<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>财务管理</a-breadcrumb-item>
            <a-breadcrumb-item>新订单列表</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">新订单列表</span>
          </div>
        </div>
      </div>
    </div>
    <div class="wrap-children-content">
      <a-layout-content
        :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }"
      >
        <div
          class="headButton"
          :style="{display:'flex',flexDirection:'row',justifyContent:'space-between',marginBottom:'20px'}"
        >
          <a-form layout="inline" :form="searchform" @submit="searchSubmit">
            <a-form-item>
              <a-input v-decorator="['inValue']">
                <a-select v-decorator="['selKey',{initialValue: 'username'}]" slot="addonBefore">
                  <a-select-option value="username">会员名称</a-select-option>
                  <a-select-option value="phone">手机号</a-select-option>
                  <a-select-option value="userId">会员ID</a-select-option>
                </a-select>
              </a-input>
            </a-form-item>
            <a-form-item label="商品名称">
              <a-input v-decorator="['goodsName']"></a-input>
            </a-form-item>
            <a-row v-if="isCollapse">
              <a-col>
                <a-form-item label="订单ID">
                  <a-input v-decorator="['orderId']"></a-input>
                </a-form-item>
              </a-col>
              <a-col>
                <a-form-item label="订单状态">
                  <a-select style="width:150px;" v-decorator="['orderStatus']">
                    <a-select-option value="0">未完成</a-select-option>
                    <a-select-option value="1">已完成</a-select-option>
                    <a-select-option value="null">全部</a-select-option>
                  </a-select>
                </a-form-item>

                <a-form-item label="支付方式">
                  <a-select style="width:150px;" v-decorator="['payType']">
                    <a-select-option value="0">信用点支付</a-select-option>
                    <a-select-option value="1">微信支付</a-select-option>
                    <a-select-option value="null">全部</a-select-option>
                  </a-select>
                </a-form-item>
              </a-col>
              <a-col>
                <a-form-item label="支付状态">
                  <a-select style="width:150px;" v-decorator="['payStatus']">
                    <a-select-option value="0">未支付</a-select-option>
                    <a-select-option value="1">已支付</a-select-option>
                    <a-select-option value="2">支付失败</a-select-option>
                    <a-select-option value="3">已关闭</a-select-option>
                    <a-select-option value="null">全部</a-select-option>
                  </a-select>
                </a-form-item>

                <a-form-item label="商品类型">
                  <a-select style="width:150px;" v-decorator="['goodsType']">
                    <a-select-option value="1">VIP商品</a-select-option>
                    <a-select-option value="2">实物商品</a-select-option>
                    <a-select-option value="3">应用商品</a-select-option>
                    <a-select-option value="4">服务商</a-select-option>
                    <a-select-option value="5">信用点充值</a-select-option>
                    <a-select-option value="null">全部</a-select-option>
                  </a-select>
                </a-form-item>
              </a-col>
              <a-col>
                <a-form-item label="下单时间">
                  <a-date-picker
                    :disabledDate="disabledStartDate"
                    format="YYYY-MM-DD"
                    placeholder="开始日期"
                    @change="date => dateChangeStart(date)"
                    @openChange="handleStartOpenChange"
                    v-decorator="['createStartTime']"
                  />&nbsp;~
                  <a-form-item>
                    <a-date-picker
                      :disabledDate="disabledEndDate"
                      format="YYYY-MM-DD"
                      placeholder="结束日期"
                      @change="date => dateChangeEnd(date)"
                      :open="endOpen"
                      @openChange="handleEndOpenChange"
                      v-decorator="['createEndTime']"
                    />
                  </a-form-item>
                </a-form-item>
              </a-col>
              <a-col>
                <a-form-item label="支付时间">
                  <a-date-picker
                    :disabledDate="disabledStartDate1"
                    format="YYYY-MM-DD"
                    placeholder="开始日期"
                    @change="date => dateChangeStart(date,'pay')"
                    @openChange="open => handleStartOpenChange(open,'pay')"
                    v-decorator="['payStartTime']"
                  />&nbsp;~
                  <a-form-item>
                    <a-date-picker
                      :disabledDate="disabledEndDate1"
                      format="YYYY-MM-DD"
                      placeholder="结束日期"
                      @change="date => dateChangeEnd(date,'pay')"
                      :open="endOpen1"
                      @openChange="open => handleEndOpenChange(open,'pay')"
                      v-decorator="['payEndTime']"
                    />
                  </a-form-item>
                </a-form-item>
              </a-col>
            </a-row>
            <a-form-item>
              <a-button type="primary" html-type="submit">查询</a-button>
              <a-button :style="{marginLeft:'10px'}" @click="resetSearch">重置</a-button>
              <span style="margin-left:10px;cursor: pointer; color:#1899ff;" @click="openSearch">
                {{isCollapse ? '收起':'展开'}}
                <a-icon style="margin-left:3px;" :type="isCollapse ? 'up':'down'" />
              </span>
            </a-form-item>
          </a-form>
        </div>
        <div style="margin:20px 0;display:flex;flexDirection:row;justifyContent:flex-start">
          <a-button type="primary" icon="plus" @click="addModal">新增配置</a-button>
        </div>
        <div class="tongji">
          <a-icon type="exclamation-circle" style="color:#1899ff;font-size:15px;" theme="filled" />
          <span class="tongji-box">
            未完成订单数
            <span class="mean-number">{{orderCount.totalUnfinishedOrder}}</span>
          </span>
          <span class="tongji-box">
            已完成订单数
            <span class="mean-number">{{orderCount.totalFinishOrder}}</span>
          </span>
          <span class="tongji-box">
            信用点支付总额
            <span class="mean-number">{{orderCount.totalCreditPointsPay}}</span>
          </span>
          <span class="tongji-box">
            现金支付总额
            <span class="mean-number">{{orderCount.totalCashMoneyPay}}</span>(元)
          </span>
          <span class="tongji-box">
            已支付订单数
            <span class="mean-number">{{orderCount.totalPaymentOrder}}</span>
          </span>
          <span class="tongji-box">
            未支付订单数
            <span class="mean-number">{{orderCount.totalNonPaymentOrder}}</span>
          </span>
          <span class="tongji-box">
            取消支付订单数
            <span class="mean-number">{{orderCount.totalPaymentCloseOrder}}</span>
          </span>
          <span class="tongji-box">
            支付失败订单数
            <span class="mean-number">{{orderCount.totalPaymentFailedOrder }}</span>
          </span>
        </div>
        <a-table
          bordered
          :loading="tableLoading"
          :pagination="pagination"
          :showHeader="true"
          :dataSource="data"
          :columns="columns"
          :rowKey="record => record.orderId"
          @change="handleTableChange"
          :scroll="{x:1400}"
        >
          <template slot="payStatus" slot-scope="text">{{orderFilter(text,'payStatus')}}</template>
          <template slot="goodsType" slot-scope="text">{{orderFilter(text,'goodsType')}}</template>
          <template slot="orderStatus" slot-scope="text">{{text == 0 ? '未完成' : '已完成'}}</template>
          <template slot="payType" slot-scope="text">{{text == 0 ? '信用点支付' : '微信支付'}}</template>
          <template slot="action" slot-scope="text, record">
            <a
              style="marginRight:10px;"
              slot="action"
              @click="() => editor(record.orderId,record)"
            >编辑</a>
            <a class="deletes" @click="() => deletes(record.orderId)">删除</a>
          </template>
        </a-table>
      </a-layout-content>
      <a-modal
        centered
        title="修改订单配置"
        :visible="modify.visible"
        :confirmLoading="modify.confirmLoading"
        @cancel="modifyCancel"
        :footer="null"
      >
        <a-form :form="modifyform" @submit="modifySubmit">
          <a-form-item label="订单状态" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-select
              style="width:100px;"
              v-decorator="['orderStatus',{initialValue: editValue.orderStatus, rules:[{required:true,message:'请选择订单状态'}]}]"
            >
              <a-select-option :value="0">未完成</a-select-option>
              <a-select-option :value="1">已完成</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="商品ID" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['goodsId',{initialValue: editValue.goodsId}]" />
          </a-form-item>
          <a-form-item label="会员ID" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['userId',{initialValue: editValue.userId}]" />
          </a-form-item>
          <a-form-item label="数量" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['num',{initialValue: editValue.num}]" />
          </a-form-item>
          <a-form-item label="支付方式" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-select
              style="width:100px;"
              v-decorator="['payType',{initialValue: editValue.payType}]"
            >
              <a-select-option :value="0">信用点支付</a-select-option>
              <a-select-option :value="1">微信支付</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="支付状态" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-select
              style="width:100px;"
              v-decorator="['payStatus',{initialValue: editValue.payStatus}]"
            >
              <a-select-option :value="0">未支付</a-select-option>
              <a-select-option :value="1">已支付</a-select-option>
              <a-select-option :value="2">支付失败</a-select-option>
              <a-select-option :value="3">已关闭</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="订单总额" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['money',{initialValue: editValue.money}]" />
          </a-form-item>
          <a-form-item label="付款金额" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['payMoney',{initialValue: editValue.payMoney}]" />
          </a-form-item>
          <a-form-item label="优惠金额" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['preMoney',{initialValue: editValue.preMoney}]" />
          </a-form-item>
          <a-form-item label="交易流水号" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['transactionId',{initialValue: editValue.transactionId}]" />
          </a-form-item>
          <a-form-item label="下单时间" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-date-picker
              showTime
              format="YYYY-MM-DD HH:mm:ss"
              v-decorator="['createTime',{initialValue: editValue.createTime ? moment( editValue.createTime,'YYYY-MM-DD HH:mm:ss') : null}]"
            />
          </a-form-item>
          <a-form-item label="支付时间" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-date-picker
              showTime
              format="YYYY-MM-DD HH:mm:ss"
              v-decorator="['payTime',{initialValue: editValue.payTime ? moment( editValue.payTime,'YYYY-MM-DD HH:mm:ss') : null}]"
            />
          </a-form-item>
          <a-form-item label="订单结束时间" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-date-picker
              showTime
              format="YYYY-MM-DD HH:mm:ss"
              v-decorator="['endTime',{initialValue: editValue.endTime ? moment( editValue.endTime,'YYYY-MM-DD HH:mm:ss') : null}]"
            />
          </a-form-item>
          <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
            <a-button type="primary" html-type="submit">保存</a-button>
          </a-form-item>
        </a-form>
      </a-modal>
      <a-modal
        centered
        title="新增订单配置"
        :visible="addservice.visible"
        :confirmLoading="addservice.confirmLoading"
        @cancel="serviceCancel"
        :footer="null"
      >
        <a-form :form="serviceaddform" @submit="addserviceSubmit">
          <a-form-item label="商品ID" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['goodsId',{rules:[{required:true,message:'请填写商品ID'}]}]" />
          </a-form-item>
          <a-form-item label="会员ID" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['userId',{rules:[{required:true,message:'请填写会员ID'}]}]" />
          </a-form-item>
          <a-form-item label="数量" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['num',{rules:[{required:true,message:'请填数量'}]}]" />
          </a-form-item>
          <a-form-item label="订单状态" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-select
              style="width:100px;"
              v-decorator="['orderStatus',{rules:[{required:true,message:'请选择订单状态'}]}]"
            >
              <a-select-option :value="0">未完成</a-select-option>
              <a-select-option :value="1">已完成</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="支付方式" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-select style="width:100px;" v-decorator="['payType']">
              <a-select-option :value="0">信用点支付</a-select-option>
              <a-select-option :value="1">微信支付</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="支付状态" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-select style="width:100px;" v-decorator="['payStatus']">
              <a-select-option :value="0">未支付</a-select-option>
              <a-select-option :value="1">已支付</a-select-option>
              <a-select-option :value="2">支付失败</a-select-option>
              <a-select-option :value="3">已关闭</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="订单总额" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['money']" />
          </a-form-item>
          <a-form-item label="付款金额" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['payMoney']" />
          </a-form-item>
          <a-form-item label="优惠金额" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['preMoney']" />
          </a-form-item>
          <a-form-item label="交易流水号" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['transactionId']" />
          </a-form-item>
          <a-form-item label="下单时间" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-date-picker showTime format="YYYY-MM-DD HH:mm:ss" v-decorator="['createTime']" />
          </a-form-item>
          <a-form-item label="支付时间" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-date-picker showTime format="YYYY-MM-DD HH:mm:ss" v-decorator="['payTime']" />
          </a-form-item>
          <a-form-item label="订单结束时间" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-date-picker showTime format="YYYY-MM-DD HH:mm:ss" v-decorator="['endTime']" />
          </a-form-item>
          <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
            <a-button type="primary" html-type="submit">保存</a-button>
          </a-form-item>
        </a-form>
      </a-modal>
    </div>
  </div>
</template>
<script>
import { newOrderPage, deleteOrder1, updateOrder1, addOrder1 } from "api";
import { match } from "minimatch";
import moment from "moment";

const columns = [
  {
    title: "会员名",
  
    dataIndex: "username"
  },
  {
    title: "手机号",

    dataIndex: "phone"
  },
  {
    title: "订单ID",

    dataIndex: "orderId"
  },
  {
    title: "会员ID",
  
    dataIndex: "userId"
  },
  {
    title: "下单时间",
 
    dataIndex: "createTime"
  },
  {
    title: "订单结束时间",

    dataIndex: "endTime"
  },
  {
    title: "支付时间",
   
    dataIndex: "payTime"
  },
  {
    title: "交易流水号",

    dataIndex: "transactionId"
  },
  {
    title: "支付方式",

    dataIndex: "payType",
    scopedSlots: { customRender: "payType" }
  },
  {
    title: "优惠金额(仅限现金支付)",
    width:'5%',
    dataIndex: "preMoney"
  },
  {
    title: "订单总额",
    dataIndex: "money"
  },
  {
    title: "支付金额",
    dataIndex: "payMoney"
  },
  {
    title: "支付状态",
    dataIndex: "payStatus",
    scopedSlots: { customRender: "payStatus" }
  },
  {
    title: "商品名称",
    dataIndex: "goodsName"
  },
  {
    title: "订单状态",
    dataIndex: "orderStatus",
    scopedSlots: { customRender: "orderStatus" }
  },
  {
    title: "商品类型",
    dataIndex: "goodsType",
    scopedSlots: { customRender: "goodsType" }
  },
  {
    title: "现金单价",
    dataIndex: "cashPrice"
  },
  {
    title: "信用点单价",
    dataIndex: "pointsPrice"
  },
  {
    title: "数量",
    dataIndex: "num"
  },
  {
    title: "操作",
    dataIndex: "action",
    scopedSlots: { customRender: "action" }
  }
];

export default {
  data() {
    return {
      isCollapse: false,
      data: [],
      orderCount: {},
      columns,
      delmsg: null,
      visible: false,
      confirmLoading: false,
      tableLoading: true,
      goodData: null,
      startValue: null,
      endValue: null,
      endOpen: false,
      startValue1: null,
      endValue1: null,
      endOpen1: false,
      modifyform: this.$form.createForm(this),
      editValue: {},
      orderTypeList: [
        { name: "VIP商品", value: 1 },
        { name: "实物商品", value: 2 },
        { name: "应用商品", value: 3 },
        { name: "服务商", value: 4 },
        { name: "信用点充值", value: 5 }
      ],
      payStatusList: [
        { name: "未支付", value: 0 },
        { name: "已支付", value: 1 },
        { name: "支付失败", value: 2 },
        { name: "已关闭", value: 3 }
      ],
      modify: {
        visible: false,
        confirmLoading: true
      },
      addservice: {
        visible: false,
        confirmLoading: true
      },
      serviceaddform: this.$form.createForm(this),
      searchform: this.$form.createForm(this),
      pagination: {
        total: 0,
        defaultCurrent: 0,
        defaultPageSize: 10,
        showTotal: total => `共 ${total} 条数据`,
        showSizeChanger: true,
        pageSizeOptions: ["5", "10", "15", "20"],
        showQuickJumper: true
      },

      queryParam: {
        pageNum: 0, //第几页
        pageSize: 10 //每页中显示数据的条数
      },
      firstParam: {}
    };
  },
  created() {
    this.queryParam = this.firstParam;
    this._newOrderPage();
  },
  methods: {
    moment,
    orderFilter(text, col) {
      if (col == "goodsType") {
        if (text) {
          const item = this.orderTypeList.filter(item => text == item.value)[0];
          return item.name;
        }
      } else {
        const item = this.payStatusList.filter(item => text == item.value)[0];
        return item.name;
      }
    },
    handleTableChange(pagination) {
      //分页跳转
      this.pagination.current = pagination.current;
      this.pagination.pageSize = pagination.pageSize;
      this.queryParam.pageNum = pagination.current;
      this.queryParam.pageSize = pagination.pageSize;
      this.tableLoading = true;
      this.getTableList();
    },
    getTableList() {
      //获取列表
      let that = this;
      newOrderPage(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.pageInfo.total;
        that.pagination = pagination;
        that.data = res.data.pageInfo.list;
        that.orderCount = res.data.orderCount;
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    _newOrderPage() {
      //获取日志列表
      this.getTableList();
    },

    // 时间范围模块
    dateChangeStart(value, col) {
      if (col == "pay") {
        this.startValue1 = value;
      } else {
        this.startValue = value;
      }
    },
    dateChangeEnd(value, col) {
      if (col == "pay") {
        this.endValue1 = value;
      } else {
        this.endValue = value;
      }
    },
    disabledStartDate(startValue) {
      const endValue = this.endValue;
      if (!startValue || !endValue) {
        return false;
      }
      return startValue.valueOf() > endValue.valueOf();
    },
    disabledEndDate(endValue) {
      const startValue = this.startValue;
      if (!endValue || !startValue) {
        return false;
      }
      return startValue.valueOf() >= endValue.valueOf();
    },
    disabledStartDate1(startValue) {
      const endValue = this.endValue1;
      if (!startValue || !endValue) {
        return false;
      }
      return startValue.valueOf() > endValue.valueOf();
    },
    disabledEndDate1(endValue) {
      const startValue = this.startValue1;
      if (!endValue || !startValue) {
        return false;
      }
      return startValue.valueOf() >= endValue.valueOf();
    },
    handleStartOpenChange(open, col) {
      if (col == "pay") {
        if (!open) {
          this.endOpen1 = true;
        }
      } else {
        if (!open) {
          this.endOpen = true;
        }
      }
    },
    handleEndOpenChange(open, col) {
      if (col == "pay") {
        if (!open) {
          this.endOpen1 = open;
        }
      } else {
        if (!open) {
          this.endOpen = open;
        }
      }
    },
    //重置搜索
    resetSearch() {
      this.searchform.resetFields();
      this._newOrderPage();
    },
    // 搜索框展开
    openSearch() {
      this.isCollapse = !this.isCollapse;
    },
    searchSubmit(e) {
      //搜索
      this.queryParam = this.firstParam;
      e.preventDefault();
      this.searchform.validateFields((err, values) => {
        let target = {};
        if (values.createStartTime) {
          values.createStartTime = values.createStartTime
            .format("YYYY-MM-DD")
            .concat(" 00:00:00");
        }
        if (values.createEndTime) {
          values.createEndTime = values.createEndTime
            .format("YYYY-MM-DD")
            .concat(" 23:59:59");
        }
        if (values.payStartTime) {
          values.payStartTime = values.payStartTime
            .format("YYYY-MM-DD")
            .concat(" 00:00:00");
        }
        if (values.payEndTime) {
          values.payEndTime = values.payEndTime
            .format("YYYY-MM-DD")
            .concat(" 23:59:59");
        }
        if (values.orderStatus === "null") {
          values.orderStatus = null;
        }
        if (values.payStatus === "null") {
          values.payStatus = null;
        }
        if (values.goodsType === "null") {
          values.goodsType = null;
        }
        if (values.payType === "null") {
          values.payType = null;
        }
        target.createEndTime = values.createEndTime;
        target.createStartTime = values.createStartTime;
        target.payEndTime = values.payEndTime;
        target.payStartTime = values.payStartTime;
        target.orderStatus = values.orderStatus;
        target.goodsType = values.goodsType;
        target.payStatus = values.payStatus;
        target.payType = values.payType;
        target.orderId = values.orderId;
        target.goodsName = values.goodsName;
        if (values.inValue != null) {
          const str = values.selKey;
          target[str] = values.inValue;
        }
        this.queryParam = Object.assign({}, this.queryParam, target);
        this.getTableList();
      });
    },
    addModal() {
      //新增按钮
      this.addservice.visible = true;
    },
    addserviceSubmit(e) {
      // 新增提交按钮
      let that = this;
      e.preventDefault();
      that.serviceaddform.validateFields((err, values) => {
        let formData = {};
        if (values.goodsId) {
          formData.goodsId = values.goodsId;
        }
        if (values.userId) {
          formData.userId = values.userId;
        }
        if (values.num) {
          formData.num = values.num;
        }
        if (values.payType || values.payType == 0) {
          formData.payType = values.payType;
        }
        if (values.preMoney) {
          formData.preMoney = values.preMoney;
        }
        if (values.money) {
          formData.money = values.money;
        }
        if (values.transactionId) {
          formData.transactionId = values.transactionId;
        }
        if (values.payMoney) {
          formData.payMoney = values.payMoney;
        }
        if (values.payStatus || values.payStatus == 0) {
          formData.payStatus = values.payStatus;
        }
        if (values.orderStatus || values.orderStatus == 0) {
          formData.orderStatus = values.orderStatus;
        }
        if (values.createTime) {
          formData.createTime = values.createTime.format("YYYY-MM-DD HH:mm:ss");
        }
        if (values.payTime) {
          formData.payTime = values.payTime.format("YYYY-MM-DD HH:mm:ss");
        }
        if (values.endTime) {
          formData.endTime = values.endTime.format("YYYY-MM-DD HH:mm:ss");
        }
        if (!err) {
          addOrder1(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that._newOrderPage();
              that.addservice.visible = false;
              that.serviceaddform.resetFields();
            }
          });
        }
      });
    },
    serviceCancel() {
      //新增页面撤销
      this.addservice.visible = false;
    },
    editor(id, editValue) {
      //点击修改按钮
      this.editValue = editValue;
      this.editId = id;
      this.modify.visible = true;
    },
    // 修改用户
    modifySubmit(e) {
      let that = this;
      e.preventDefault();
      that.modifyform.validateFields((err, values) => {
        let formData = {};
        formData.paramsId = that.editId;
        if (values.goodsId) {
          formData.goodsId = values.goodsId;
        }
        if (values.userId) {
          formData.userId = values.userId;
        }
        if (values.num) {
          formData.num = values.num;
        }
        if (values.payType) {
          formData.payType = values.payType;
        }
        if (values.preMoney) {
          formData.preMoney = values.preMoney;
        }
        if (values.money) {
          formData.money = values.money;
        }
        if (values.transactionId) {
          formData.transactionId = values.transactionId;
        }
        if (values.payMoney) {
          formData.payMoney = values.payMoney;
        }
        if (values.payStatus) {
          formData.payStatus = values.payStatus;
        }
        if (values.orderStatus) {
          formData.orderStatus = values.orderStatus;
        }
        if (values.createTime) {
          formData.createTime = values.createTime.format("YYYY-MM-DD HH:mm:ss");
        }
        if (values.payTime) {
          formData.payTime = values.payTime.format("YYYY-MM-DD HH:mm:ss");
        }
        if (values.endTime) {
          formData.endTime = values.endTime.format("YYYY-MM-DD HH:mm:ss");
        }

        if (!err) {
          updateOrder1(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.getTableList();
              that.modify.visible = false;
            }
          });
        }
      });
    },
    modifyCancel() {
      this.modify.visible = false;
    },
    deletes(id) {
      //删除事件
      let that = this;
      this.delID = id;
      that.$modal.confirm({
        centered: true,
        title: "请确定",
        content: "确定删除该配置？",
        cancelText: "取消",
        okText: "确定",
        onOk() {
          that.handleOk();
        },
        onCancel() {}
      });
    },
    handleOk() {
      //确定删除
      let that = this;
      deleteOrder1({ paramsId: this.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          that.tableLoading = true;
          setTimeout(() => {
            that.visible = false;
            that.confirmLoading = false;
            that._newOrderPage();
          }, 200);
        }
      });
    }
  }
};
</script>
<style scoped>
.tongji {
  margin: 20px 0;
  padding: 10px 15px 8px 15px;
  border: 1px solid #91d5ff;
  background-color: #e6f7ff;
  border-radius: 5px;
}

.tongji-box {
  font-size: 15px;
  margin-right: 12px;
  color: rgba(0, 0, 0, 0.65);
}
.mean-number {
  color: #1899ff;
  font-weight: 600;
}
.deletes {
  color: #f5222d;
}
</style>

