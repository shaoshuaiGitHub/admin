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
            <a-breadcrumb-item>信用卡平均额度</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">{{name+'_'+'信用卡平均额度'}}</span>
          </div>
        </div>
      </div>
    </div>
    <div class="wrap-children-content">
      <a-layout-content
        :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }"
      >
        <div :style="{display:'flex',flexDirection:'row',justifyContent:'space-between',marginBottom:'20px'}">
          <a-button type="primary" icon="rollback" @click="back">返回</a-button>
          <a-button type="primary" :style="{ margin: '0 0 10px 0 ' }" @click="saveall">保存修改</a-button>
        </div>
        <a-table
          bordered
          :loading="tableLoading"
          :showHeader="true"
          :columns="columns"
          :dataSource="data"
          :rowKey="record => record.bankId"
        >
          <template slot="averageQuota" slot-scope="text, record">
            <a-input
              :value="text"
              style="width:100px"
              class="sort-input"
              @change="e => handleChange2(e.target.value,record.bankId, 'averageQuota')"
            />
          </template>
          <template slot="maxQuota" slot-scope="text, record">
            <a-input
            class="sort-input"
            style="width:100px"
              :value="text"
              @change="e => handleChange2(e.target.value,record.bankId, 'maxQuota')"
            />
          </template>
        </a-table>
      </a-layout-content>
    </div>
  </div>
</template>
<script>
import { bankDetail, updateBank } from "api";
import { match } from "minimatch";
const columns = [
  {
    title: "平均卡片额度（元）",
    dataIndex: "averageQuota",
    scopedSlots: { customRender: "averageQuota" }
  },
  {
    title: "当前银行最高授权额度（元）",
    dataIndex: "maxQuota",
    scopedSlots: { customRender: "maxQuota" }
  },
 
];

export default {
  data() {
    return {
      data: [],
      columns,
      delmsg: null,
      visible: false,
      confirmLoading: false,
      tableLoading: true,
      
      name: this.$route.params.name
    };
  },
  created() {
    this._bankDetail();
  },

  methods: {
    _bankDetail() {
      //获取银行提示语列表
      let that = this;
      bankDetail({
        bankId: that.$route.params.id
      }).then(response => {
        that.data.push(response.data);
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },

    handleChange2(value, rid, col) {
      //监听输入内容
      const newData = [...this.data];
      const target = newData.filter(item => rid === item.bankId)[0];
      if (target) {
        target[col] = value;
        target.editable = true;
        this.data = newData;
      }
    },
    saveall() {
      //保存修改
      const newData = [...this.data];
      const target = newData.filter(item => true === item.editable)[0];
        updateBank({
          bankId: this.$route.params.id,
          averageQuota: target.averageQuota,
          maxQuota: target.maxQuota
        }).then(res => {
          if (res.code) {
            this.tableLoading = true;
            this.$message.success(res.msg);
            setTimeout(() => {
              this.tableLoading = false;
            }, 200);
            delete target.editable;
          }
        });
          this.data = newData;
    },
    
    back() {
      this.$router.back();
    }
  }
};
</script>
<style scoped>
.editable-row-operations a {
  margin-right: 8px;
}
.sort-input {
  color: #1890ff;
  border: none;
  border-bottom: 1px solid white !important;
  box-shadow: none;
}
</style>