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
        <div
          class="headButton"
          :style="{display:'flex',flexDirection:'row',justifyContent:'space-between',marginBottom:'40px'}"
        >
          <a-form layout="inline" :form="searchform" @submit="searchSubmit">
            <a-form-item>
              <a-input v-decorator="['inValue']" style="width:300px;">
                <a-select v-decorator="['selKey',{initialValue: 'userName'}]" slot="addonBefore">
                  <a-select-option value="userName">会员名称</a-select-option>
                  <a-select-option value="phone">手机号</a-select-option>
                </a-select>
              </a-input>
            </a-form-item>
            <a-form-item label="商品名称">
              <a-input v-decorator="['goodsName']" style="width:100%;"></a-input>
            </a-form-item>
            <template v-if="isCollapse">
              <a-row>
                <a-col>
                  <a-form-item label="订单号">
                    <a-input v-decorator="['orderNumber']" style="width:100%;"></a-input>
                  </a-form-item>
                </a-col>
                <a-col>
                  <a-form-item label="订单状态">
                    <a-select v-decorator="['orderStatus']" style="width:160px;">
                      <a-select-option value="1">待付款</a-select-option>
                      <a-select-option value="2">已付款</a-select-option>
                      <a-select-option value="3">已取消</a-select-option>
                      <a-select-option value="null">全部</a-select-option>
                    </a-select>
                  </a-form-item>
                </a-col>
                <a-col>
                  <a-form-item label="商品类型">
                    <a-select style="width:160px;" v-decorator="['goodsType']">
                      <a-select-option value="1">VIP订单</a-select-option>
                      <a-select-option value="2">实物订单</a-select-option>
                      <a-select-option value="3">应用订单</a-select-option>
                      <a-select-option value="4">信用点订单</a-select-option>
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
                      v-decorator="['startValue']"
                    />&nbsp;~
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
                </a-col>
              </a-row>
            </template>
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
        <div class="tongji">
          <a-icon type="exclamation-circle" style="color:#1899ff;font-size:15px;" theme="filled" />
          <span class="tongji-box">
            全部订单:
            <span class="mean-number">{{countResult.totalOrder}}</span>
          </span>
          <span class="tongji-box">
            总金额:
            <span class="mean-number">{{countResult.totalMoney}}</span>(元)
          </span>
          <span class="tongji-box">
            已支付订单:
            <span class="mean-number">{{countResult.totalPaymentOrder}}</span>
          </span>
          <span class="tongji-box">
            未支付订单:
            <span class="mean-number">{{countResult.totalNonPaymentOrder}}</span>
          </span>
          <span class="tongji-box">
            取消支付订单:
            <span class="mean-number">{{countResult.totalCancelOrder}}</span>
          </span>
          <span class="tongji-box">
            有效支付金额:
            <span class="mean-number">{{countResult.totalPaymentMoney}}</span>(元)
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
          :scroll="{x:1460}"
        >
          <template slot="orderStatus" slot-scope="text">{{orderFilter(text,'orderStatus')}}</template>
          <template slot="goodsType" slot-scope="text">{{orderFilter(text,'goodsType')}}</template>
          <template slot="action" slot-scope="text, record">
            <a slot="action" @click="() => editor(record.orderId,record)">编辑</a>
          </template>
        </a-table>
      </a-layout-content>
      <a-modal
        centered
        title="修改配置"
        :visible="modify.visible"
        :confirmLoading="modify.confirmLoading"
        @cancel="modifyCancel"
        :footer="null"
      >
        <a-form :form="modifyform" @submit="modifySubmit">
          <a-form-item label="订单编号" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['orderNumber',{initialValue: editValue.orderNumber}]" />
          </a-form-item>
          <a-form-item label="订单金额" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['money',{initialValue: editValue.money}]" />
          </a-form-item>
          <a-form-item label="实际付款金额" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['totalFee',{initialValue: editValue.totalFee}]" />
          </a-form-item>
          <a-form-item label="商品数量" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['goodsNum',{initialValue: editValue.goodsNum}]" />
          </a-form-item>
          <a-form-item label="订单状态" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-select
              style="width:100px;"
              v-decorator="['orderStatus',{initialValue: editValue.orderStatus}]"
            >
              <a-select-option :value="1">待付款</a-select-option>
              <a-select-option :value="2">已付款</a-select-option>
              <a-select-option :value="3">已取消</a-select-option>
              <a-select-option :value="null">全部</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="下单时间" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-date-picker
              showTime
              format="YYYY-MM-DD HH:mm:ss"
              v-decorator="['orderTime',{initialValue: editValue.orderTime ? moment( editValue.orderTime,'YYYY-MM-DD HH:mm:ss') : null}]"
            />
          </a-form-item>
          <a-form-item label="支付时间" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-date-picker
              showTime
              format="YYYY-MM-DD HH:mm:ss"
              v-decorator="['payTime',{initialValue: editValue.payTime ? moment( editValue.payTime,'YYYY-MM-DD HH:mm:ss') : null}]"
            />
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
import { financeOrder, updateOrder } from "api";
import { match } from "minimatch";
import moment from "moment";

const columns = [
  {
    title: "会员名",
    // width: 100,
    dataIndex: "userName"
  },
  {
    title: "手机号",
    // width: 120,
    dataIndex: "phone"
  },
  {
    title: "订单编号",
    // width: 200,
    dataIndex: "orderNumber"
  },
  {
    title: "会员ID",
    // width: 70,
    dataIndex: "uid"
  },
  {
    title: "下单时间",
    // width: 110,
    dataIndex: "orderTime",
    sorter: (a, b) =>
      moment(a.orderTime).format("YYYY-MM-DD HH:mm:ss") >
      moment(b.orderTime).format("YYYY-MM-DD HH:mm:ss")
  },
  {
    title: "支付时间",
    // width: 110,
    dataIndex: "payTime"
  },
  {
    title: "支付单号",
    // width: 250,
    dataIndex: "payNo"
  },
  {
    title: "订单金额",
    // width: 100,
    dataIndex: "money"
  },
  {
    title: "实付金额",
    // width: 100,
    dataIndex: "totalFee"
  },
  {
    title: "商品名称",
    // width: 100,
    dataIndex: "goodsName"
  },
  {
    title: "订单状态",
    // width: 100,
    dataIndex: "orderStatus",
    scopedSlots: { customRender: "orderStatus" }
  },
  {
    title: "订购年限",
    // width: 100,
    dataIndex: "term"
  },
  {
    title: "订单类型",
    // width: 100,
    dataIndex: "goodsType",
    scopedSlots: { customRender: "goodsType" }
  },
  {
    title: "商品售价(RMB)",
    // width: 100,
    dataIndex: "goodsAmount",
    sorter: (a, b) => a.goodsAmount - b.goodsAmount
  },
  {
    title: "商品数量",
    // width: 100,
    dataIndex: "goodsNum",
    sorter: (a, b) => a.goodsNum - b.goodsNum
  },
  {
    title: "操作",
    width: "4%",
    dataIndex: "action",
    scopedSlots: { customRender: "action" }
  }
];

export default {
  data() {
    return {
      isCollapse: false,
      data: [],
      countResult: {},
      columns,
      delmsg: null,
      visible: false,
      confirmLoading: false,
      tableLoading: true,
      goodData: null,
      startValue: null,
      endValue: null,
      endOpen: false,
      modifyform: this.$form.createForm(this),
      orderTypeList: [
        { name: "VIP订单", value: 1 },
        { name: "实物订单", value: 2 },
        { name: "应用订单", value: 3 },
        { name: "信用点订单", value: 4 }
      ],
      orderStatuList: [
        { name: "待付款", value: 1 },
        { name: "已付款", value: 2 },
        { name: "已取消", value: 3 }
      ],
      editValue: {},
      modify: {
        visible: false,
        confirmLoading: true
      },
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
      firstParam: {},
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
    moment,
    orderFilter(text, col) {
      if (col == "orderStatus") {
        if (text) {
          const item = this.orderTypeList.filter(item => text == item.value)[0];
          return item.name;
        }
      }else{
         if (text) {
          const item = this.orderStatuList.filter(item => text == item.value)[0];
          return item.name;
        }
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
        pagination.total = res.data.pageInfo.total;
        that.pagination = pagination;
        that.data = res.data.pageInfo.list;
        that.countResult = res.data.countResult;
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
    //重置搜索
    resetSearch() {
      this.searchform.resetFields();
      this.queryParam = this.firstParam;
      this._financeOrder();
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

        if (values.orderNumber) {
          formData.orderNumber = values.orderNumber;
        }
        if (values.money) {
          formData.money = values.money;
        }
        if (values.totalFee) {
          formData.totalFee = values.totalFee;
        }
        if (values.goodsNum) {
          formData.goodsNum = values.goodsNum;
        }
        if (values.orderStatus) {
          formData.orderStatus = values.orderStatus;
        }
        if (values.orderTime) {
          formData.orderTime = values.orderTime.format("YYYY-MM-DD HH:mm:ss");
        }
        if (values.payTime) {
          formData.payTime = values.payTime.format("YYYY-MM-DD HH:mm:ss");
        }

        if (!err) {
          updateOrder(formData).then(res => {
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
.tongji .anticon {
  margin-right: 5px;
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
</style>

