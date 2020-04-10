<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>功能业务配置</a-breadcrumb-item>
            <a-breadcrumb-item>信用卡诊断配置</a-breadcrumb-item>
            <a-breadcrumb-item>还款诊断配置</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">银行卡列表</span>
            <span class="ant-page-header-heading-title">银行列表</span>
            ————&nbsp;&nbsp;
            <a-button type="primary" icon="sync" :loading="reloadings" @click="reloadFun">刷新</a-button>&nbsp;&nbsp;————
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
          <template slot="bankIcon" slot-scope="text">
            <img class="bank-icon" :src="text" alt="未找到图片" />
          </template>
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
import {
  setContextData,
  getContextData,
  removeContextData
} from "../../../../common/js/util";
const columns = [
  {
    title: "银行图标",
    dataIndex: "bankIcon",
    scopedSlots: { customRender: "bankIcon" }
  },
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
  inject: ["reload"], //重载函数
  data() {
    return {
      reloadings: true,
      tableloading: true,
      data: null,
      columns,
      pagination: {
        total: 0,
        defaultCurrent: 1,
        defaultPageSize: 10,
        showTotal: total => `共 ${total} 条数据`,
        showSizeChanger: true,
        pageSizeOptions: ["5", "10", "15", "20"],
        showQuickJumper: true
      },
      queryParam: {},
      key:this.$route.meta.key[0],
    };
  },
  created() {
    this.pagination.current = getContextData("currentPage" + this.key) || 1;
    this.queryParam.pageNum = this.pagination.current;
    this._banklist();
  },
  mounted: function() {
    setContextData();
    getContextData();
    removeContextData();
  },
  methods: {
    // 刷新页面
    reloadFun() {
      this.reloadings = true;
      removeContextData("currentPage" + this.key);
      this.reload();
    },
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
      setContextData("currentPage" + this.key, this.pagination.current);
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
        that.tableloading = false;
        that.reloadings = false;
      });
    },
    score(id, name) {
      //消费事件
      this.$router.push({
        name: "rdscore",
        params: {
          id: id,
          name: name,
          configKey: "REPAYMENT_DIAG_SCORE"
        }
      });
    },
    proposal(id, name) {
      //还款事件
      this.$router.push({
        name: "rtproposal",
        params: {
          id: id,
          name: name,
          configKey: "REPAYMENT_TIMES_PROPOSAL"
        }
      });
    },
    repayManagerP(id, name) {
      //管理师建议
      this.$router.push({
        name: "repaymanagerp",
        params: {
          id: id,
          name: name,
          configKey: "REPAYMENT_MANAGER_PROPOSAL"
        }
      });
    },
    repayRate(id, name) {
      //额度使用率
      this.$router.push({
        name: "repayrate",
        params: {
          id: id,
          name: name,
          configKey: "REPAYMENT_QUOTA_RATE"
        }
      });
    }
  }
};
</script>
<style scoped>
.bank-icon {
  width: 60px;
  height: 60px;
}
</style>