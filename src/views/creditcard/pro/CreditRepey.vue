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
            <span class="ant-page-header-heading-title">还款计划</span>
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
        <a-table
          :loading="tableLoading"
          :columns="columns"
          :dataSource="data"
          :pagination="pagination"
          :rowKey="record => record.pid"
          @change="handleTableChange"
          :bordered="true"
        >
          <template slot="repaymentDate" slot-scope="text">{{ text.substring(0,11)}}</template>
          <template slot="stype" slot-scope="text,record">{{ dateCompare(record.repaymentDate) }}</template>
          <template slot="action" slot-scope="text, record">
            <a-button
              class="status-detail"
              style="margin-right:10px;"
              :disabled="record.signMoney >= record.money || record.statu == 1"
              @click="() => signPart(record.pid,record)"
            >标记部分</a-button>
            <a-button
              class="status-detail"
              v-if="record.statu == 0"
              @click="() => signAll(record.pid,record)"
            >标记全部</a-button>
            <span class="wancheng" v-else>已完成</span>
          </template>
        </a-table>
        <a-modal
          centered
          title="已还款金额确认"
          :visible="modify.visible"
          :confirmLoading="modify.confirmLoading"
          @cancel="modifyCancel"
          :footer="null"
        >
          <a-form :form="modifyform" @submit="modifySubmit">
            <a-form-item label="请输入已还金额" :label-col="{ span: 8 }" :wrapper-col="{ span: 12 }">
              <a-input v-decorator="['signMoney']" />
            </a-form-item>
            <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
              <a-button type="primary" html-type="submit">保存</a-button>
            </a-form-item>
          </a-form>
        </a-modal>
      </a-layout-content>
    </div>
  </div>
</template>
<script>
import { creditCRPage, creditSignCR } from "api";
const columns = [
  {
    title: "创建时间",
    dataIndex: "createTime"
  },
  {
    title: "卡Id",
    dataIndex: "cardId"
  },
  {
    title: "计划日期",
    dataIndex: "repaymentDate",
    scopedSlots: { customRender: "repaymentDate" }
  },
  {
    title: "还款金额",
    dataIndex: "money",
    scopedSlots: { customRender: "money" }
  },

  {
    title: "实际还款",
    dataIndex: "signMoney",
    scopedSlots: { customRender: "signMoney" }
  },
  {
    title: "状态",
    dataIndex: "stype",
    scopedSlots: { customRender: "stype" }
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
      tableLoading: true,
      data: [],
      goodData: [],
      confirmDirty: false,
      columns,
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
      modify: {
        visible: false,
        confirmLoading: true
      },
      queryParam: {},
      firstParam: {
        pageNum: 0, //第几页
        pageSize: 10, //每页中显示数据的条数
        cardId: this.$route.params.id,
        type: 2,
        startDate: "",
        endDate: ""
      },
      modifyform: this.$form.createForm(this)
    };
  },
  created() {
    this._dateCreate();
    this._creditCRPage();
  },
  methods: {
    _creditCRPage() {
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
      this.tableLoading = true;
      this.getTableList();
    },
    getTableList() {
      //获取列表
      let that = this;
      creditCRPage(that.queryParam).then(res => {
        if (res.code) {
          const pagination = { ...that.pagination };
          pagination.total = res.data.total;
          that.pagination = pagination;
          that.data = res.data.list;
          console.log(that.data);
          setTimeout(() => {
            that.tableLoading = false;
          }, 200);
          that.queryParam = that.firstParam;
        }
      });
    },
    _dateCreate() {
      let date = new Date();
      let year = this.$route.params.date.substring(0, 4);
      let month = this.$route.params.date.substring(5, 7);
      // 第一天日期
      this.firstParam.startDate = year + "-" + month + "-01";
      // 最后一天日期
      let lastDateOfCurrentMonth = new Date(year, month, 0);
      this.firstParam.endDate =
        year + "-" + month + "-" + lastDateOfCurrentMonth.getDate();
    },
    dateCompare(time) {
      if (time) {
        let date = new Date();
        let nowTime = new Date();
        let startTime = new Date(Date.parse(time));
        return nowTime < startTime ? "未过期" : "已过期";
      }
    },
    signPart(id, record) {
      //点击标记部分按钮
      this.editId = id;
      this.editValue = record;
      this.modify.visible = true;
    },
    // 标记部分弹窗
    modifySubmit(e) {
      let that = this;
      e.preventDefault();
      that.modifyform.validateFields((err, values) => {
        console.log(values);
        let formData = new FormData();
        formData.append("pid", that.editId);
        formData.append("type", 2);
        formData.append("signMoney", values.signMoney);
        console.log( that.editValue.money)
        Number(values.signMoney) > that.editValue.money
          ? formData.append("statu", 1)
          : formData.append("statu", 0);
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
    signAll(id, record) {
      //点击标记全部事件
      let that = this;
      that.delID = id;
      that.delValue = record;
      that.$modal.confirm({
        centered: true,
        title: "账单确认",
        content: "确定已还清本次还款计划？",
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
    back() {
      //返回上一页
      this.$router.back();
    }
  }
};
</script>
<style scoped>
.status-detail {
  border-radius: 5px;
  padding: 5px;
  border: 1px solid #52c41a;
  color: #52c41a;
}
.wancheng {
  padding: 5px 10px;
  border-radius: 5px;
  border: 1px solid #000;
}
</style>