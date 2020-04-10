<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>信用诊断配置</a-breadcrumb-item>
            <a-breadcrumb-item>其他诊断配置</a-breadcrumb-item>
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
          :pagination="false"
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
            >基础诊断配置</a-button>
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
      columns
    };
  },

  created() {
    this._banklist();
  },

  methods: {
    _banklist() {
      //获取会员列表
      let that = this;
      bankList({}).then(response => {
        that.data = response.data.list;
        setTimeout(() => {
          that.tableloading = false;
        }, 200);
      });
    },
    score(id, name) {
      //基础诊断
      this.$router.push({
        name: "basescore",
        params: {
          id: id,
          name: name,
          configKey: 'ALL_RESULT'
        }
      });
    },
  }
};
</script>