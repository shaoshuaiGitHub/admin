<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>信用卡管理</a-breadcrumb-item>
            <a-breadcrumb-item>提额计划</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span
              class="ant-page-header-heading-title"
            >{{(isCurrent ? '当月提额计划' : '历史提额计划') +' - '+ '信用卡'+ this.$route.params.cardNumber}}</span>
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
          <a-button type="primary" icon="left" @click="back">返回</a-button>
        </div>
        <div class="tongji">
          <span style="font-size:16px;color:orange">{{isCurrent ? '当月提额计划统计：' : '历史提额计划统计：'}}</span>
          <span class="tongji-box">
            计划总数:
            <span class="mean-number">{{infoData.totalSize}}</span>
          </span>
          <span class="tongji-box">
            计划消费总金额:
            <span
              class="mean-number"
            >{{infoData.totalMinMoney+' - '+infoData.totalMaxMoney}}</span>(元)
          </span>
          <span class="tongji-box">
            消费标记总金额:
            <span class="mean-number">{{infoData.totalConsumSignMoney}}</span>(元)
          </span>
          <span class="tongji-box">
            还款总金额:
            <span class="mean-number">{{infoData.totalRepaymentMoney}}</span>(元)
          </span>
          <span class="tongji-box">
            还款标记总金额:
            <span class="mean-number">{{infoData.totalRepaymentSignMoney}}</span>(元)
          </span>
        </div>
        <a-table
          :loading="tableLoading"
          :columns="isCurrent ? columns : columns1"
          :dataSource="data"
          :pagination="pagination"
          :rowKey="record => record.planDate"
          @change="handleTableChange"
          :bordered="true"
          :scroll="{x:500}"
        >
          <template slot="planDate" slot-scope="text">{{text.substring(0,10)}}</template>
          <template
            slot="minMoney"
            slot-scope="text,record"
          >{{ (record.minMoney ? record.minMoney: 0)+' - '+(record.maxMoney ? record.maxMoney: 0)}}</template>
          <template slot="action" slot-scope="text, record">
            <a-button
              class="status-detail"
              style="margin-right:10px;"
              :disabled="record.consumStatu == 1 || record.minMoney == null"
              @click="() => signPart(record.consumPlanId,record)"
            >标记消费</a-button>
            <a-button
              class="status-detailc"
              :disabled="record.consumStatu == 0 || record.minMoney == null"
              @click="() => signCancel(record.consumPlanId,record,'consum')"
            >取消标记</a-button>
          </template>
          <template slot="actionR" slot-scope="text, record">
            <a-button
              class="status-detail"
              style="margin-right:10px;"
              :disabled="record.repaymentStatu == 1 || record.money == null"
              @click="() => signPartR(record.repaymentPlanId,record)"
            >标记还款</a-button>
            <a-button
              class="status-detailc"
              :disabled="record.repaymentStatu == 0 || record.money == null"
              @click="() => signCancel(record.repaymentPlanId,record,'repay')"
            >取消标记</a-button>
          </template>
        </a-table>
        <a-modal
          centered
          title="已消费金额确认"
          :visible="modify.visible"
          :confirmLoading="modify.confirmLoading"
          @cancel="modifyCancel"
          :footer="null"
        >
          <a-form :form="modifyform" @submit="modifySubmit">
            <a-form-item label="请输入已消费金额" :label-col="{ span: 8 }" :wrapper-col="{ span: 8 }">
              <a-input-number
                :parser="value => (value.match(/^\d*(\.?\d{0,2})/g)[0]) || null"
                v-decorator="['signMoney',{ rules: [{
              validator: (rule, value, callback) => changeNum(rule, value, callback),
            }], initialValue: editValue.minMoney}]"
              />
            </a-form-item>
            <a-form-item :wrapper-col="{ span: 8, offset: 10 }">
              <a-button type="primary" html-type="submit">保存</a-button>
            </a-form-item>
          </a-form>
        </a-modal>
      </a-layout-content>
    </div>
  </div>
</template>
<script>
import { creditProPlanDetails, creditSignCR } from "api";
const columns = [
  {
    title: "计划日期",
    dataIndex: "planDate",
    scopedSlots: { customRender: "planDate" }
  },
  {
    title: "计划消费范围",
    dataIndex: "minMoney",
    scopedSlots: { customRender: "minMoney" }
  },

  {
    title: "实际消费",
    dataIndex: "consumSignMoney"
  },
  {
    title: "还款金额",
    dataIndex: "money"
  },

  {
    title: "实际还款",
    dataIndex: "repaymentSignMoney"
  },
  {
    title: "消费",
    dataIndex: "action",
    width: "18%",
    scopedSlots: { customRender: "action" }
  },
  {
    title: "还款",
    width: "18%",
    dataIndex: "actionR",
    scopedSlots: { customRender: "actionR" }
  }
];
const columns1 = [
  {
    title: "计划日期",
    dataIndex: "planDate",
    scopedSlots: { customRender: "planDate" }
  },
  {
    title: "计划消费范围",
    dataIndex: "minMoney",
    scopedSlots: { customRender: "minMoney" }
  },
  {
    title: "实际消费",
    dataIndex: "consumSignMoney"
  },
  {
    title: "还款金额",
    dataIndex: "money"
  },
  {
    title: "实际还款",
    dataIndex: "repaymentSignMoney"
  }
];

export default {
  data() {
    return {
      tableLoading: true,
      data: [],
      infoData: {},
      confirmDirty: false,
      columns,
      columns1,
      col: "",
      editValue: {},
      isCurrent: this.$route.params.col == 0,
      ModalText: "Content of the modal",
      visible: false,
      confirmLoading: false,
      formLayout: "horizontal",
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
        type: this.$route.params.col,
        billDate: this.$route.params.billDate,
        cardId: this.$route.params.id
      },
      modify: {
        visible: false,
        confirmLoading: true
      },
      modifyform: this.$form.createForm(this)
    };
  },
  created() {
    this._creditProPlan();
  },
  methods: {
    _creditProPlan() {
      this.getTableList();
    },
    handleTableChange(pagination) {
      //分页跳转
      let pagination1 = { ...this.pagination };
      pagination1.current = pagination.current;
      pagination1.pageSize = pagination.pageSize;
      this.pagination = pagination1;
    },
    getTableList() {
      //获取列表
      let that = this;
      creditProPlanDetails(that.queryParam).then(res => {
        if (res.code) {
          const pagination = { ...that.pagination };
          pagination.total = res.data.totalSize;
          that.pagination = pagination;
          that.data = res.data.proPlanList;
          that.infoData = res.data;
          setTimeout(() => {
            that.tableLoading = false;
          }, 200);
        }
      });
    },
    signPart(id, record) {
      this.modifyform.resetFields();
      //点击标记消费按钮
      this.editId = id;
      this.editValue = record;
      this.modify.visible = true;
    },
    changeNum(rule, value, callback) {
      //校验
      if (value < this.editValue.minMoney) {
        this.modifyform.setFieldsValue({ signMoney: this.editValue.minMoney });
      }
      if (value > this.editValue.maxMoney) {
        this.modifyform.setFieldsValue({ signMoney: this.editValue.maxMoney });
      }
    },
    // 标记消费弹窗
    modifySubmit(e) {
      let that = this;
      e.preventDefault();
      that.modifyform.validateFields((err, values) => {
        let formData = new FormData();
        formData.append("pid", that.editId);
        formData.append("type", 1);
        formData.append("signMoney", values.signMoney);
        formData.append("statu", 1);
        if (!err) {
          creditSignCR(formData).then(res => {
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
    signPartR(id, record, col) {
      //标记还款事件
      let that = this;
      that.delID = id;
      that.delValue = record;
      that.col = col;
      that.$modal.confirm({
        centered: true,
        title: "标记还款",
        content: "确定标记该还款计划",
        cancelText: "取消",
        okText: "确定",
        onOk() {
          // that.handleOkR();
          let formData = new FormData();
          formData.append("pid", that.delID);
          formData.append("type", 2);
          formData.append("statu", 1);
          formData.append("signMoney", that.delValue.money);
          creditSignCR(formData).then(res => {
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
    signCancel(id, record, col) {
      //点击取消事件
      let that = this;
      that.delID = id;
      that.delValue = record;
      that.col = col;
      that.$modal.confirm({
        centered: true,
        title: "取消标记",
        content:
          "确定撤销该" + (that.col == "consum" ? "消费" : "还款") + "计划？",
        cancelText: "取消",
        okText: "确定",
        onOk() {
          that.handleOk();
        },
        onCancel() {}
      });
    },
    handleOk() {
      //确定提交
      let that = this;
      let formData = new FormData();
      formData.append("pid", that.delID);
      that.col == "consum"
        ? formData.append("type", 1)
        : formData.append("type", 2);
      formData.append("statu", 0);
      formData.append("signMoney", 0);
      // if (that.col == "consum") {
      //   formData.append("signMoney", that.delValue.maxMoney);
      // } else {
      //   formData.append("signMoney", that.delValue.money);
      // }
      creditSignCR(formData).then(res => {
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

    back() {
      //返回上一页
      this.$router.back();
    }
  }
};
</script>
<style scoped>
.status-detail {
  padding: 5px;
}
.unactive {
  background-color: #faad14;
  border-radius: 5px;
  padding: 5px;

  /* color: #faad14; */
}
.active {
  background-color: #52c41a;
  border-radius: 5px;
  padding: 5px;
}
.status-detail {
  border-radius: 5px;
  padding: 5px;
  border: 1px solid #52c41a;
  color: #52c41a;
}
.status-detailc {
  border-radius: 5px;
  padding: 5px;
  border: 1px solid #f5222d;
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