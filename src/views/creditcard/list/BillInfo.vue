<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>信用卡管理</a-breadcrumb-item>
            <a-breadcrumb-item>信用卡列表</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">账单信息</span>
          </div>
        </div>
      </div>
    </div>
    <div class="wrap-children-content">
      <a-layout-content
        :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }"
      >
        <div class="headButton" :style="{marginBottom:'20px'}">
          <a-button type="primary" icon="left" @click="back">返回</a-button>
          <div class="tongji">
            <a-icon type="exclamation-circle" style="color:#1899ff;font-size:15px;" theme="filled" />
            <span class="tongji-box">
              {{this.$route.params.bankName}} -
              卡号:
              <span
                class="mean-number"
              >{{this.$route.params.cardNumber}}</span>
            </span>
            <span class="tongji-box">
              总额度:
              <span class="mean-number">{{this.$route.params.quota}}</span> (元)
            </span>
            <span class="tongji-box">
              可用额度:
              <span class="mean-number">{{this.$route.params.availableQuota}}</span> (元)
            </span>
          </div>
        </div>
        <a-table
          :columns="columns"
          :dataSource="data"
          :rowKey="record => record.cardBill.bid"
          @expand="expand"
          :expandedRowKeys="expandedRowKeys"
          :pagination="pagination"
          @change="handleTableChange"
          :expandRowByClick="true"
          :scroll="{x:800}"
        >
          <template slot="billTime" slot-scope="text,record">{{billTimeF(record) }}</template>
          <template slot="everyBill" slot-scope="text,record">{{everyBillF(record)}}</template>
          <template
            slot="residueMoney"
            slot-scope="text,record"
          >{{(record.cardBill.totalMoney - record.cardBill.repayMoney).toFixed(2)}}</template>
          <template
            slot="residueMinMoney"
            slot-scope="text,record"
          >{{record.cardBill.minRepay > record.cardBill.repayMoney ? record.cardBill.minRepay > record.cardBill.repayMoney : 0}}</template>
          <template slot="action" slot-scope="text, record">
            <div @click.stop v-if="record.isNowBill">
              <template>
                <a-button
                  style="margin-right:10px;"
                  type="primary"
                  @click="() => signPart(record.cardBill.bid,record,)"
                >标记</a-button>
              </template>
              <a-button
                style="margin-right:10px;"
                type="primary"
                @click="() => signCancel(record.cardBill.bid,record)"
              >取消标记</a-button>
            </div>
          </template>
          <!-- 弹窗子表格 -->
          <a-table
            slot="expandedRowRender"
            :bordered="true"
            :columns="innerColumns"
            :dataSource="innerData"
            :pagination="paginationC"
            @change="handleTableChangeC"
            :rowKey="record => record.did"
          >
            <template slot="ctype" slot-scope="text">
              <span v-if="text == 1" style="color:#f5222d;">消费</span>
              <span v-else style="color:#52c41a;">还款</span>
            </template>
            <template slot="detailTime" slot-scope="text">{{text.substring(0,10)}}</template>
          </a-table>
        </a-table>
      </a-layout-content>
      <a-modal
        centered
        title="已还款金额确认"
        :visible="modify.visible"
        :confirmLoading="modify.confirmLoading"
        @cancel="modifyCancel"
        :footer="null"
      >
        <a-form :form="modifyform" @submit="modifySubmit">
          <a-form-item :wrapper-row="{ span: 8}">
            <a-radio-group
              name="radioGroup"
              @change="changePart"
              v-decorator="['partOrAll',{initialValue: 1}]"
            >
              <a-radio :value="1">标记部分</a-radio>
              <a-radio :value="2">标记全部</a-radio>
            </a-radio-group>
          </a-form-item>
          <a-form-item
            label="请输入已还款金额"
            :label-col="{ span: 7 }"
            :wrapper-col="{ span: 8 }"
            v-if="isPart"
          >
            <a-input-number
              :parser="value => (value.match(/^\d*(\.?\d{0,2})/g)[0]) || null"
              v-decorator="['signMoney',{initialValue: repayMoney}]"
            />
          </a-form-item>
          <a-form-item :wrapper-col="{ span: 8, offset: 10 }">
            <a-button type="primary" html-type="submit">保存</a-button>
          </a-form-item>
        </a-form>
      </a-modal>
    </div>
  </div>
</template>
<script>
import { billPage, signBill, unSignBill } from "api";
import moment from "moment";
const columns = [
  {
    title: "每月账单",
    dataIndex: "everyBill",
    scopedSlots: { customRender: "everyBill" }
  },
  {
    title: "出账日期",
    dataIndex: "billTime",
    scopedSlots: { customRender: "billTime" }
  },
  {
    title: "消费总额",
    dataIndex: "cardBill.totalMoney"
  },
  {
    title: "笔数",
    dataIndex: "billDetailSize",
    scopedSlots: { customRender: "billDetailSize" }
  },
  {
    title: "最低还款金额",
    dataIndex: "cardBill.minRepay",
    scopedSlots: { customRender: "minRepay" }
  },
  {
    title: "已还金额",
    dataIndex: "cardBill.repayMoney",
    scopedSlots: { customRender: "repayMoney" }
  },
  {
    title: "剩余应还金额",
    dataIndex: " residueMoney",
    scopedSlots: { customRender: "residueMoney" }
  },
  {
    title: "剩余最低应还金额",
    dataIndex: "residueMinMoney",
    scopedSlots: { customRender: "residueMinMoney" }
  },
  {
    title: "操作",
    dataIndex: "action",
    scopedSlots: { customRender: "action" }
  }
];
const innerColumns = [
  {
    title: "明细类型",
    dataIndex: "ctype",
    scopedSlots: { customRender: "ctype" }
  },
  {
    title: "详细内容",
    dataIndex: "detailTitle"
  },
  {
    title: "日期",
    dataIndex: "detailTime",
    scopedSlots: { customRender: "detailTime" }
  },
  {
    title: "数据来源",
    dataIndex: "detailFrom"
  },
  {
    title: "单笔金额（元）",
    dataIndex: "money"
  }
];

export default {
  data() {
    return {
      tableLoading: true,
      data: null,
      innerData: null,
      innerColumns,
      isPart: true,
      repayMoney: null,
      columns,
      editValue: {},
      visible: false,
      confirmLoading: false,
      expandedRowKeys: [],
      pagination: {
        total: 0,
        defaultCurrent: 0,
        defaultPageSize: 10,
        showTotal: total => `共 ${total} 条数据`,
        showSizeChanger: true,
        pageSizeOptions: ["5", "10", "15", "20"],
        showQuickJumper: true
      },
      paginationC: {
        total: 0,
        defaultCurrent: 0,
        defaultPageSize: 10,
        showTotal: total => `共 ${total} 条数据`,
        showSizeChanger: true,
        pageSizeOptions: ["5", "10", "15", "20"],
        showQuickJumper: true,
        size: "small"
      },
      queryParam: {
        pageNum: 0, //第几页
        pageSize: 10, //每页中显示数据的条数
        paramsId: this.$route.params.id
      },
      firstParam: {
        pageNum: 0, //第几页
        pageSize: 10, //每页中显示数据的条数
        paramsId: this.$route.params.id
      },
      modify: {
        visible: false,
        confirmLoading: true
      },
      modifyform: this.$form.createForm(this)
    };
  },
  created() {
    this._billPage();
  },
  methods: {
    _billPage() {
      //周期获取
      this.queryParam = this.firstParam;
      this.getTableList();
    },
    handleTableChange(pagination) {
      //分页跳转
      this.pagination.current = pagination.current;
      this.pagination.pageSize = pagination.pageSize;
      this.queryParam.pageNum = pagination.current;
      this.queryParam.pageSize = pagination.pageSize;
      this.queryParam.paramsId = this.$route.params.id;
      this.tableLoading = true;
      this.getTableList();
    },
    getTableList() {
      //获取列表
      let that = this;
      billPage(that.queryParam).then(res => {
        if (res.code) {
          const pagination = { ...that.pagination };
          pagination.total = res.data.billSize;
          that.pagination = pagination;
          console.log(res.data);
          that.data = res.data.bill.map((item, index, arr) => {
            let str1 = item.cardBill.billDate.substring(0, 7);
            const m = moment()
              .startOf("month")
              .format("YYYY-MM");
            if (str1 == m) {
              item.isNowBill = true;
            }
            return item;
          });
          setTimeout(() => {
            that.tableLoading = false;
          }, 200);
        }
      });
    },
    handleTableChangeC(pagination) {
      //分页跳转
      const paginationC = { ...this.paginationC };
      paginationC.current = pagination.current;
      paginationC.pageSize = pagination.pageSize;
      this.paginationC = paginationC;
    },
    expand(expanded, record) {
      //展开行事件
      this.expandedRowKeys = [];
      if (expanded) {
        this.expandedRowKeys = [record.cardBill.bid];
        const target = this.data.filter(
          item => record.cardBill.bid == item.cardBill.bid
        )[0];
        const pagination = { ...this.paginationC };
        this.innerData = target.billDetails; // 获取表格内部数据
        pagination.total = target.billDetailSize; //获取表格内部数据总数
        this.paginationC = pagination;
      }
    },
    changePart(e) {
      if (e.target.value == 1) {
        this.isPart = true;
      } else {
        this.isPart = false;
      }
    },
    everyBillF(record) {
      if (record) {
        let str1 = record.cardBill.billDate.substring(0, 10);
        let str2 = record.cardBill.billDate.substring(0, 7);
        let num = record.cardBill.billDate.substring(5, 7);
        let endTime = moment(str1, "YYYY-MM-DD");
        let startTime = moment(endTime).subtract(1, "month");
        let isBefore1 = moment(startTime).isBefore(new Date());
        const m = moment()
          .startOf("month")
          .format("YYYY-MM");
        if (isBefore1) {
          if (str2 == m) {
            return "本月账单";
          } else {
            return num + "月账单";
          }
        } else {
          return "待出账单";
        }
      }
    },
    billTimeF(record) {
      if (record) {
        let str1 = record.cardBill.billDate.substring(0, 10);
        let endTime = moment(str1, "YYYY-MM-DD");
        let startTime = moment(endTime).subtract(30, "days");
        return (
          startTime.format("YYYY/MM/DD") + "-" + endTime.format("YYYY/MM/DD")
        );
      }
    },
    signPart(id) {
      this.modifyform.resetFields();
      //点击标记消费按钮
      this.editId = id;

      this.modify.visible = true;
      this.repayMoney = record.cardBill.repayMoney;
    },

    // 标记消费弹窗
    modifySubmit(e) {
      let that = this;
      e.preventDefault();
      that.modifyform.validateFields((err, values) => {
        let formData = {};
        formData.paramsId = that.editId;
        if (values.partOrAll == 1 && values.signMoney) {
          formData.signMoney = values.signMoney;
        }
        if (!err) {
          signBill(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.modify.visible = false;
              that.getTableList();
            }
          });
        }
      });
    },
    modifyCancel() {
      this.modify.visible = false;
    },
    signCancel(id, record) {
      //点击取消事件
      let that = this;
      that.delID = id;
      that.delValue = record;
      that.$modal.confirm({
        centered: true,
        title: "取消标记",
        content: "确定撤销该还款标记？",
        cancelText: "取消",
        okText: "确定",
        onOk() {
          let formData = {};
          formData.paramsId = that.delID;
          unSignBill(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.confirmLoading = true;
              setTimeout(() => {
                that.visible = false;
                that.confirmLoading = false;
                that.getTableList();
              }, 200);
            }
          });
        },
        onCancel() {}
      });
    },

    back() {
      //返回上一页
      this.$router.back();
    }
  }
};
</script>
<style scoped>
.status-detail {
  color: #faad14;
}
.deletes {
  color: #f5222d;
}
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
</style>