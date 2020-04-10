<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>信用诊断配置</a-breadcrumb-item>
            <a-breadcrumb-item>还款诊断配置</a-breadcrumb-item>
          </a-breadcrumb>
           <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">银行卡列表</span>
          </div>
        </div>
      </div>
    </div>
    <div class="wrap-children-content">
      <a-layout-content
        :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }"
      >
        <a-table
          bordered
          :loading="tableloading"
          :pagination="pagination"
          @change="handleTableChange"
          :columns="columns"
          :dataSource="data"
          :rowKey="record => record.bankId"
        >
          <template slot="action" slot-scope="text, record">
            <a-button
              type="primary"
              slot="action"
              style="margin-right:10px;"
              @click="() => score(record.bankId,record.bankName)"
            >还款诊断得分配置</a-button>
            <a-button
              type="primary"
              slot="action"
              style="margin-right:10px;"
              @click="() => proposal(record.bankId,record.bankName)"
            >每月还款笔数建议配置</a-button>
            <a-button
              type="primary"
              slot="action"
              style="margin-right:10px;"
              @click="() => repayManagerP(record.bankId,record.bankName)"
            >管理师建议</a-button>
            <a-button
              type="primary"
              slot="action"
              style="margin-right:10px;"
              @click="() => repayRate(record.bankId,record.bankName)"
            >额度使用率</a-button>
          </template>
        </a-table>
      </a-layout-content>
    </div>
  </div>
</template>
<script>
import { bankList } from "api";
const columns = [
  {
    title: "银行名称",
    dataIndex: "bankName",
    scopedSlots: { customRender: "bankName" }
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
      tableloading: true,
      data: null,
      columns,
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
      }
    };
  },

  created() {
    this._banklist();
  },

  methods: {
    _banklist() {
      //周期获取
      this.getTableList();
    },
    handleTableChange(pagination) {
      //分页跳转
      this.pagination.current = pagination.current;
      this.pagination.pageSize = pagination.pageSize;
      this.queryParam.pageNum = pagination.current;
      this.queryParam.pageSize = pagination.pageSize;
      this.tableloading = true;
      this.getTableList();
    },
    getTableList() {
      //获取列表
      let that = this;
      bankList(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        setTimeout(() => {
          that.tableloading = false;
        }, 200);
      });
    },
    score(id, name) {
      //消费事件
      this.$router.push({
        name: "rdscore",
        params: {
          id: id,
          name: name,
          configKey: 'REPAYMENT_DIAG_SCORE'
        }
      });
    },
    proposal(id, name) {//还款事件
      this.$router.push({
        name: "rtproposal",
        params: {
          id: id,
          name: name,
          configKey: 'REPAYMENT_TIMES_PROPOSAL'
        }
      });
    },
    repayManagerP(id, name) {//管理师建议
      this.$router.push({
        name: "repaymanagerp",
        params: {
          id: id,
          name: name,
          configKey: 'REPAYMENT_MANAGER_PROPOSAL'
        }
      });
    },
    repayRate(id, name) {//额度使用率
      this.$router.push({
        name: "repayrate",
        params: {
          id: id,
          name: name,
          configKey: 'REPAYMENT_QUOTA_RATE'
        }
      });
    },
  }
};
</script>