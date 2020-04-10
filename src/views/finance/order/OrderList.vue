<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>财务管理</a-breadcrumb-item>
            <a-breadcrumb-item>订单列表</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">订单列表</span>
          </div>
        </div>
      </div>
    </div>
    <div class="wrap-children-content">
      <a-layout-content
        :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }"
      >
        <div class="tongji">
          <div class="tongji-box">
            全部订单(
            <span class="mean-number">{{totalOrder}}</span>)
          </div>
          <div class="tongji-box">
            总金额(
            <span class="mean-number">{{totalMoney}}</span>)元
          </div>
          <div class="tongji-box">
            已支付订单(
            <span class="mean-number">{{totalPaymentOrder}}</span>)
          </div>
          <div class="tongji-box">
            未支付订单(
            <span class="mean-number">{{totalNonPaymentOrder}}</span>)
          </div>
          <div class="tongji-box">
            取消支付订单(
            <span class="mean-number">{{totalCancelOrder}}</span>)
          </div>
          <div class="tongji-box">
            有效支付金额(
            <span class="mean-number">{{totalPaymentMoney}}</span>)元
          </div>
        </div>
        <div
          class="headButton"
          :style="{display:'flex',flexDirection:'row',justifyContent:'space-between',marginBottom:'20px'}"
        >
          <a-form layout="inline" :form="searchform" @submit="searchSubmit">
            <a-form-item>
              <a-input v-decorator="['inValue']">
                <a-select v-decorator="['selKey',{initialValue: 'userName'}]" slot="addonBefore">
                  <a-select-option value="userName">会员名称</a-select-option>
                  <a-select-option value="phone">手机号</a-select-option>
                </a-select>
              </a-input>
            </a-form-item>
            <a-form-item label="商品名称">
              <a-input v-decorator="['goodsName']"></a-input>
            </a-form-item>
            <a-form-item label="订单号">
              <a-input v-decorator="['orderNumber']"></a-input>
            </a-form-item>
            <a-form-item label="订单状态">
              <a-select style="width:100px;" v-decorator="['orderStatus']">
                <a-select-option value="1">待付款</a-select-option>
                <a-select-option value="2">已付款</a-select-option>
                <a-select-option value="3">已取消</a-select-option>
                <a-select-option value="null">全部</a-select-option>
              </a-select>
            </a-form-item>
            <a-form-item label="商品类型">
              <a-select style="width:100px;" v-decorator="['goodsType']">
                <a-select-option value="1">VIP订单</a-select-option>
                <a-select-option value="2">实物订单</a-select-option>
                <a-select-option value="3">应用订单</a-select-option>
                <a-select-option value="4">信用点订单</a-select-option>
                <a-select-option value="null">全部</a-select-option>
              </a-select>
            </a-form-item>
            <a-form-item label="下单时间">
              <a-date-picker
                :disabledDate="disabledStartDate"
                format="YYYY-MM-DD"
                placeholder="开始日期"
                @change="date => dateChangeStart(date)"
                @openChange="handleStartOpenChange"
                v-decorator="['startValue']"
              />~
              <a-form-item>
                <a-date-picker
                  :disabledDate="disabledEndDate"
                  format="YYYY-MM-DD"
                  placeholder="结束日期"
                  @change="date => dateChangeEnd(date)"
                  :open="endOpen"
                  @openChange="handleEndOpenChange"
                  v-decorator="['endValue']"
                />
              </a-form-item>
            </a-form-item>
            <a-form-item>
              <a-button type="primary" html-type="submit">搜索</a-button>
            </a-form-item>
          </a-form>
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
        >
          <template slot="orderStatus" slot-scope="text">{{orderStatu(text)}}</template>
          <template slot="goodsType" slot-scope="text">{{orderType(text)}}</template>
        </a-table>
      </a-layout-content>
    </div>
  </div>
</template>
<script>
import { financeOrder } from "api";
import { match } from "minimatch";

const columns = [
  {
    title: "会员名",
    width: 100,
    dataIndex: "userName"
  },
  {
    title: "手机号",
    width: 120,
    dataIndex: "phone"
  },
  {
    title: "订单编号",
    width: 200,
    dataIndex: "orderNumber"
  },
  {
    title: "会员ID",
    width: 70,
    dataIndex: "uid"
  },

  {
    title: "下单时间",
    width: 110,
    dataIndex: "orderTime"
  },
  {
    title: "支付时间",
    width: 110,
    dataIndex: "payTime"
  },
  {
    title: "支付单号",
    width: 250,
    dataIndex: "payNo"
  },
  {
    title: "实付金额",
    width: 100,
    dataIndex: "totalFee"
  },
  {
    title: "商品名称",
    width: 100,
    dataIndex: "goodsName"
  },
  {
    title: "订单状态",
    width: 100,
    dataIndex: "orderStatus",
    scopedSlots: { customRender: "orderStatus" }
  },
  {
    title: "订购年限",
    width: 100,
    dataIndex: "term"
  },
  {
    title: "订单类型",
    width: 100,
    dataIndex: "goodsType",
    scopedSlots: { customRender: "goodsType" }
  },
  {
    title: "商品售价(元)",
    width: 100,
    dataIndex: "goodsAmount"
  },
  {
    title: "商品数量",
    width: 100,
    dataIndex: "goodsNum"
  }
];

export default {
  data() {
    return {
      data: [],
      cacheData: [],
      columns,
      delmsg: null,
      visible: false,
      confirmLoading: false,
      tableLoading: true,
      goodData: null,
      startValue: null,
      endValue: null,
      endOpen: false,
      pagination: {
        total: 0,
        defaultCurrent: 0,
        defaultPageSize: 10,
        showTotal: total => `共 ${total} 条数据`,
        showSizeChanger: true,
        pageSizeOptions: ["5", "10", "15", "20"],
        showQuickJumper: true
      },
      searchform: this.$form.createForm(this),
      queryParam: {
        pageNum: 0, //第几页
        pageSize: 10 //每页中显示数据的条数
      },
      firstParam: {
        pageNum: 0, //第几页
        pageSize: 10 //每页中显示数据的条数
      },
      totalOrder: null,
      totalMoney: null,
      totalPaymentMoney: null,
      totalPaymentOrder: null,
      totalNonPaymentOrder: null,
      totalCancelOrder: null
    };
  },
  created() {
    this.queryParam = this.firstParam;
    this._financeOrder();
  },
  methods: {
    orderStatu(text) {
      if (text == 1) {
        return "待付款";
      } else if (text == 2) {
        return "已付款";
      } else {
        return "已取消";
      }
    },
    orderType(text) {
      //订单类型
      if (text == 1) {
        return "VIP订单";
      } else if (text == 2) {
        return "实物订单";
      } else if (text == 3) {
        return "应用订单";
      } else {
        return "信用点订单";
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
      financeOrder(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        that.totalOrder = res.data.totalOrder;
        that.totalMoney = res.data.totalMoney;
        that.totalPaymentMoney = res.data.totalPaymentMoney;
        that.totalPaymentOrder = res.data.totalPaymentOrder;
        that.totalNonPaymentOrder = res.data.totalNonPaymentOrder;
        that.totalCancelOrder = res.data.totalCancelOrder;
        console.log(res);
        console.log(that.data);
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    _financeOrder() {
      //获取日志列表
      this.getTableList();
    },

    // 时间范围模块
    dateChangeStart(value) {
      this.startValue = value;
    },
    dateChangeEnd(value) {
      this.endValue = value;
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
    handleStartOpenChange(open) {
      if (!open) {
        this.endOpen = true;
      }
    },
    handleEndOpenChange(open) {
      this.endOpen = open;
    },

    searchSubmit(e) {
      //搜索
      this.queryParam = this.firstParam;
      e.preventDefault();
      this.searchform.validateFields((err, values) => {
        let target = {};
        if (values.startValue) {
          values.startTime = values.startValue
            .format("YYYY-MM-DD")
            .concat(" 00:00:00");
        }
        if (values.endValue) {
          values.endTime = values.endValue
            .format("YYYY-MM-DD")
            .concat(" 23:59:59");
        }
        if (values.orderStatus === "null") {
          values.orderStatus = null;
        }
        if (values.goodsType === "null") {
          values.goodsType = null;
        }
        target.endTime = values.endTime;
        target.startTime = values.startTime;
        target.orderStatus = values.orderStatus;
        target.goodsType = values.goodsType;
        target.orderNumber = values.orderNumber;
        target.goodsName = values.goodsName;
        if (values.inValue != null) {
          const str = values.selKey;
          target[str] = values.inValue;
        }
        this.queryParam = Object.assign({}, this.queryParam, target);
        this.getTableList();
      });
    }
  }
};
</script>
<style scoped>
.editable-row-operations a {
  margin-right: 8px;
}
.tongji {
  margin: 20px 0;
  padding: 20px;
  border: 0.5px dotted #faad14;
  border-radius: 5px;
}
.tongji-box {
  display: inline;
  font-size: 16px;
  margin: 0 20px;
  padding: 10px;
  border: 0.5px solid rgba(0, 0, 0, 0.25);
  border-radius: 5px;
}

.mean-number {
  color: #f5222d;
}
</style>

