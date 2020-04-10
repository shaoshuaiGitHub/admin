<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>信用卡管理</a-breadcrumb-item>
            <a-breadcrumb-item>诊断记录</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">诊断记录</span>
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
              <a-input v-decorator="['inValue']" placeholder="用户名">
                <a-select v-decorator="['selKey',{initialValue: 'userName'}]" slot="addonBefore">
                  <a-select-option value="userName">会员名</a-select-option>
                  <a-select-option value="phone">手机号</a-select-option>
                  <a-select-option value="userId">会员ID</a-select-option>
                </a-select>
              </a-input>
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
          :rowKey="record => record.rid"
          @change="handleTableChange"
          :scroll="{x:600}"
        >
        </a-table>
      </a-layout-content>
    </div>
  </div>
</template>
<script>
import { userDiagPage } from "api";
import { match } from "minimatch";
import moment from "moment";

const columns = [
  {
    title: "会员名",
    // width: "18%",
    dataIndex: "userName"
  },
  {
    title: "手机号",
    // width: "18%",
    dataIndex: "phone"
  },
  {
    title: "会员ID",
    // width: "18%",
    dataIndex: "userId"
  },
  {
    title: "信用卡ID",
    // width: "18%",
    dataIndex: "cardId"
  },

  {
    title: "评分分数",
    // width: "18%",
    dataIndex: "diagScore"
  },
  {
    title: "评分时间",
    // width: "18%",
    dataIndex: "diagTime",
    scopedSlots: { customRender: "createTime" }
  },
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
        total: 0,
        defaultCurrent: 1,
        defaultPageSize: 10,
        showTotal: total => `共 ${total} 条数据`,
        showSizeChanger: true,
        pageSizeOptions: ["5", "10", "15", "20"],
        showQuickJumper: true
      },
      searchform: this.$form.createForm(this),
      queryParam: {
        pageNum: 1, //第几页
        pageSize: 10 //每页中显示数据的条数
      },
      firstParam: {
        pageNum: 1, //第几页
        pageSize: 10 //每页中显示数据的条数
      }
    };
  },
  created() {
    this.queryParam = this.firstParam;
    this._userDiagPage();
  },
  methods: {
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
      userDiagPage(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        console.log(that.data);
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    moment,
    _userDiagPage() {
      //获取日志列表
      this.getTableList();
    },
    //重置搜索
    resetSearch() {
      this.searchform.resetFields();
      this._userDiagPage();
    },
    searchSubmit(e) {
      //搜索
      this.queryParam = this.firstParam;
      e.preventDefault();
      this.searchform.validateFields((err, values) => {
        const str = values.selKey;
        console.log(values);
        let target = {};
        if (values.inValue != null) {
          target[str] = values.inValue;
        }
        this.queryParam = Object.assign({}, this.queryParam, target);
        console;
        this.getTableList();
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