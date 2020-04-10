<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>系统管理</a-breadcrumb-item>
            <a-breadcrumb-item>管理员操作日志</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">管理员操作日志</span>
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
          <a-form layout="inline" :form="searchform" @submit="searchSubmit">
            <a-form-item>
              <a-input v-decorator="['inValue']" placeholder="请输入条件">
                <a-select v-decorator="['selKey',{initialValue: 'name'}]" slot="addonBefore">
                  <a-select-option value="name">用户名称</a-select-option>
                  <a-select-option value="account">用户账户</a-select-option>
                  <a-select-option value="modular">模块</a-select-option>
                  <a-select-option value="functionPoint">功能</a-select-option>
                </a-select>
              </a-input>
            </a-form-item>
            <a-form-item label="更新时间">
              <a-date-picker
                v-decorator="['date',{rules: [{ required: false, message: '请输入更新时间' }]}]"
              />
            </a-form-item>
            <a-form-item>
              <a-button type="primary" html-type="submit">搜索</a-button>
              <a-button :style="{marginLeft:'10px'}" @click="resetSearch">重置</a-button>
            </a-form-item>
          </a-form>
        </div>
        <a-table
          bordered
          :loading="tableLoading"
          :pagination="pagination"
          :showHeader="true"
          :dataSource="data"
          :columns="columns"
          :rowKey="record => record.lid"
          :scroll="{x:590}"
        ></a-table>
      </a-layout-content>
    </div>
  </div>
</template>
<script>
import { logPage } from "api";
import { match } from "minimatch";
import moment from "moment";

const columns = [
  {
    title: "用户名称",
    // width: "18%",
    dataIndex: "name"
  },
  {
    title: "用户账户",
    // width: "18%",
    dataIndex: "account"
  },
  {
    title: "用户ID",
    // width: "18%",
    dataIndex: "adminId"
  },
  {
    title: "模块",
    // width: "18%",
    dataIndex: "modular"
  },
  {
    title: "功能",
    // width: "18%",
    dataIndex: "functionPoint"
  },
  {
    title: "IP地址",
    // width: "18%",
    dataIndex: "ipaddr"
  },
  {
    title: "内容",
    // width: "18%",
    dataIndex: "remark"
  },
  {
    title: "更新时间",
    // width: "18%",
    dataIndex: "createTime",
    scopedSlots: { customRender: "createTime" }
  }
];
export default {
  data() {
    return {
      data: [],
      cacheData: [],
      columns,
      delmsg: null,
      visible: false,
      confirmLoading: false,
      tableLoading: true,
      goodData: null,
      pagination: {
        pageNo: 1,
        defaultPageSize: 10,
        showTotal: total => `共 ${total} 条数据`,
        showSizeChanger: true,
        pageSizeOptions: ["5", "10", "15", "20"],
        onShowSizeChange: (current, pageSize) => (this.pageSize = pageSize),
        showQuickJumper: true
      },
      searchform: this.$form.createForm(this)
    };
  },
  created() {
    this._logPage();
  },
  methods: {
    moment,
    _logPage() {
      //获取日志列表
      let that = this;
      logPage().then(res => {
        that.data = res.data.list;
        this.pagination.total = res.data.total;
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    //重置搜索
    resetSearch() {
      this.searchform.resetFields();
      this._logPage();
    },
    searchSubmit(e) {
      //搜索
      let that = this;
      e.preventDefault();
      that.searchform.validateFields((err, values) => {
        const str = values.selKey;
        let formData = new FormData();
        console.log(values);
        if (values.inValue == null && values.date != null) {
          values.date = values.date.format('YYYY-MM-DD').concat(' 00:00:00');
          formData.append("createTime", values.date);
        } else if (values.date == null && values.inValue != null) {
          formData.append(str, values.inValue);
        } else if (values.inValue != null && values.date != null) {
          values.date = values.date.format('YYYY-MM-DD').concat(' 00:00:00');
          formData.append(str, values.inValue);
          formData.append("createTime", values.date);
        }
        logPage(formData).then(res => {
          that.tableLoading = true;
          that.data = res.data.list;
          setTimeout(() => {
            that.tableLoading = false;
          }, 200);
        });
      });
    }
  }
};
</script>
<style scoped>
.editable-row-operations a {
  margin-right: 8px;
}
</style>