<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>功能业务配置</a-breadcrumb-item>
            <a-breadcrumb-item>提额规则配置</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">提额规则配置</span>
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
        <div
          class="headButton"
          :style="{display:'flex',flexDirection:'row',justifyContent:'space-between',marginBottom:'20px'}"
        >
          <a-form layout="inline" :form="searchform" @submit="searchSubmit" style="margin-top:8px">
            <!-- 搜索框 -->
            <a-form-item label="银行名称" :label-col="{ span: 7 }" :wrapper-col="{ span: 10 }">
              <a-input v-decorator="['bankName']" />
            </a-form-item>
            <a-form-item>
              <a-button type="primary" html-type="submit">搜索</a-button>
              <a-button :style="{marginLeft:'10px'}" @click="reloadFun">重置</a-button>
            </a-form-item>
          </a-form>
        
        </div>
        <div style="margin:20px 0;display:flex;flexDirection:row;justifyContent:flex-start">
          <a-button type="primary" icon="form" @click="defaultedPage">全局默认提额规则配置</a-button>
        </div>
        <a-table
          bordered
          :loading="tableloading"
          :columns="columns"
          :dataSource="data"
          :rowKey="record => record.bankId"
          :pagination="pagination"
          @change="handleTableChange"
          :scroll="{x:600}"
        >
          <template slot="bankIcon" slot-scope="text">
            <img class="bank-icon" :src="text" alt="未找到图片" />
          </template>
          <template slot="isHasConsumRule" slot-scope="text">
            <template v-if="text === true">
              <span class="active">已配置</span>
            </template>
            <template v-else>
              <span class="unactive">未配置</span>
            </template>
          </template>
          <template slot="isHasRepaymentRule" slot-scope="text">
            <template v-if="text === true">
              <span class="active">已配置</span>
            </template>
            <template v-else>
              <span class="unactive">未配置</span>
            </template>
          </template>
          <template slot="action" slot-scope="text, record">
            <a-button
              type="primary"
              slot="action"
              style="margin-right:10px;"
              @click="() => column(record.bankId,record.bankName)"
            >消费计划配置</a-button>
            <a-button
              type="primary"
              slot="action"
              style="margin-right:10px;"
              @click="() => repay(record.bankId,record.bankName)"
            >还款计划配置</a-button>
          </template>
        </a-table>
      </a-layout-content>
    </div>
  </div>
</template>
<script>
import { creditProPage } from "api";
import {
  setContextData,
  getContextData,
  removeContextData
} from "../../../common/js/util";
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
    title: "消费计划状态",
    dataIndex: "isHasConsumRule",
    scopedSlots: { customRender: "isHasConsumRule" }
  },
  {
    title: "还款计划状态",
    dataIndex: "isHasRepaymentRule",
    scopedSlots: { customRender: "isHasRepaymentRule" }
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
      searchform: this.$form.createForm(this),
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
      creditProPage(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        setTimeout(() => {
          that.tableloading = false;
          that.reloadings = false;
        }, 200);
      });
    },
   
    searchSubmit(e) {
      // 搜索提交
      this.queryParam = {};
      e.preventDefault();
      this.searchform.validateFields((err, values) => {
        let target = {};
        if (values.bankName) {
          target.bankName = values.bankName;
        } else {
          target.bankName = null;
        }
        Object.assign(this.queryParam, target);
        this.getTableList();
      });
    },
    column(id, name) {
      //消费事件
      this.$router.push({
        name: "quotaconfig",
        params: {
          id: id,
          name: name,
          typeKey: 1
        }
      });
    },
    repay(id, name) {
      //还款事件
      this.$router.push({
        name: "quotaconfig",
        params: {
          id: id,
          name: name,
          typeKey: 2
        }
      });
    },
    defaultedPage() {
      //还款事件
      this.$router.push({
        name: "defaultquota"
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
.unactive {
  background-color: #faad14;
  border-radius: 5px;
  padding: 5px 10px;
}
.active {
  background-color: #52c41a;
  border-radius: 5px;
  padding: 5px 10px;
}
</style>