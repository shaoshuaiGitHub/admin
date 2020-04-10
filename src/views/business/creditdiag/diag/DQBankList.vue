<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>功能业务配置</a-breadcrumb-item>
            <a-breadcrumb-item>信用卡诊断配置</a-breadcrumb-item>
            <a-breadcrumb-item>额度诊断配置</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">银行卡列表</span>
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
          :scroll="{x:650}"
        >
          <template slot="bankIcon" slot-scope="text">
            <img class="bank-icon" :src="text" alt="未找到图片" />
          </template>
          <template slot="action" slot-scope="text, record">
            <a-button
              type="primary"
              slot="action"
              style="margin:10px 5px;"
              @click="() => qdScore(record.bankId,record.bankName)"
            >额度诊断得分</a-button>
            <a-button
              type="primary"
              slot="action"
              style="margin:10px 5px;"
              @click="() => qpForecast(record.bankId,record.bankName)"
            >预测提额率</a-button>
            <a-button
              type="primary"
              slot="action"
              style="margin:10px 5px;"
              @click="() => cpForecast(record.bankId,record.bankName)"
            >预计下期可提额度</a-button>
            <a-button
              type="primary"
              slot="action"
              style="margin:10px 5px;"
              @click="() => pdForecast(record.bankId,record.bankName)"
            >预计提额日期</a-button>
            <a-button
              type="primary"
              slot="action"
              style="margin:10px 5px;"
              @click="() => cardQuota(record.bankId,record.bankName)"
            >信用卡平均额度</a-button>
            <a-button
              type="primary"
              slot="action"
              style="margin:10px 5px;"
              @click="() => proRules(record.bankId,record.bankName)"
            >提额规则</a-button>
            <a-button
              type="primary"
              slot="action"
              style="margin:10px 5px;"
              @click="() => qpProposal(record.bankId,record.bankName)"
            >逾期建议</a-button>
            <a-button
              type="primary"
              slot="action"
              style="margin:10px 5px;"
              @click="() => qrProposal(record.bankId,record.bankName)"
            >额度保留率</a-button>
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
    this.pagination.current = getContextData("currentPage"+this.key) || 1;
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
      removeContextData("currentPage"+this.key);
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
      setContextData("currentPage"+this.key, this.pagination.current);
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
    qdScore(id, name) {
      //额度诊断得分
      this.$router.push({
        name: "qds",
        params: {
          id: id,
          name: name,
          configKey: "QUOTA_DIAG_SCORE"
        }
      });
    },
    qpForecast(id, name) {
      //预测提额率
      this.$router.push({
        name: "qpf",
        params: {
          id: id,
          name: name,
          configKey: "QUOTA_PRO_FORECAST"
        }
      });
    },
    cpForecast(id, name) {
      //可提额率
      this.$router.push({
        name: "cpf",
        params: {
          id: id,
          name: name,
          configKey: "CAN_PRO_FORECAST"
        }
      });
    },
    pdForecast(id, name) {
      //预提时间
      this.$router.push({
        name: "pdf",
        params: {
          id: id,
          name: name,
          configKey: "PRO_DATE_FORECAST"
        }
      });
    },
    qpProposal(id, name) {
      //逾期建议
      this.$router.push({
        name: "qpp",
        params: {
          id: id,
          name: name,
          configKey: "QUOTA_PRO_PROPOSAL"
        }
      });
    },
    qrProposal(id, name) {
      //额度保留率建议
      this.$router.push({
        name: "qrp",
        params: {
          id: id,
          name: name,
          configKey: "QUOTA_RETAIN_PROPOSAL"
        }
      });
    },
    cardQuota(id, name) {
      //信用卡平均额度
      this.$router.push({
        name: "cardquota",
        params: {
          id: id,
          name: name
        }
      });
    },
    proRules(id, name) {
      //提额规则
      this.$router.push({
        name: "prorules",
        params: {
          id: id,
          name: name
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