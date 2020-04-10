<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>银行管理</a-breadcrumb-item>
            <a-breadcrumb-item>银行列表</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">银行列表</span>
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
          :loading="tableLoading"
          :pagination="pagination"
          :columns="columns"
          :dataSource="data"
          :rowKey="record => record.bankId"
          @change="handleTableChange"
        >
         <template slot="bankIcon" slot-scope="text">
            <img
              :src="text"
              alt="未找到图片"
              class="bank-icon"
            />
          </template>
          <template slot="action" slot-scope="text, record">
            <a-button
              type="primary"
              slot="action"
              style="margin-right:10px;"
              @click="() => bankMessage(record.bankId,record.bankName)"
            >银行信息</a-button>
            <a-button
              type="primary"
              slot="action"
              style="margin-right:10px;"
              @click="() => parameter(record.bankId,record.bankName)"
            >提示语信息</a-button>
            <a-button
              type="primary"
              slot="action"
              style="margin-right:10px;"
              @click="() => bankRules(record.bankId,record.bankName)"
            >提额规则</a-button>
          </template>
        </a-table>
      </a-layout-content>
    </div>
  </div>
</template>
<script>
import {
  bankList
} from "api";
const columns = [
 
  {
    title: "银行图标",
    dataIndex: "bankIcon",
    width:'5%',
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
  data() {
    return {
      tableLoading: true,
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
      },
      firstParam: {
        pageNum: 0, //第几页
        pageSize: 10 //每页中显示数据的条数
      },
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
      this.tableLoading = true;
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
        console.log(that.data);
        this.queryParam = this.firstParam;
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    bankMessage(id, name) {
      //银行信息
      this.$router.push({
        name: "bankmessage",
        params: {
          id: id,
          name: name
        }
      });
    },
    parameter(id, name) {
      //提示语信息
      this.$router.push({
        name: "parameter",
        params: {
          id: id,
          name: name
        }
      });
    },
    bankRules(id, name) {
      //提额
      this.$router.push({
        name: "bankrules",
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