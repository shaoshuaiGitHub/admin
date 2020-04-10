<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>系统管理</a-breadcrumb-item>
            <a-breadcrumb-item>角色管理</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">角色管理</span>
          </div>
        </div>
      </div>
    </div>
    <div class="wrap-children-content">
      <a-layout-content
        :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }"
      >
        <a-form layout="inline" :form="searchform" @submit="searchSubmit">
          <a-form-item label="角色名称">
            <a-input v-decorator="['name',{rules: [{ required: false, message: '请输入角色名称！' }]}]" />
          </a-form-item>
          <a-form-item>
            <a-button type="primary" html-type="submit">搜索</a-button>
            <a-button :style="{marginLeft:'10px'}" @click="resetSearch">重置</a-button>
          </a-form-item>
        </a-form>
        <div
          class="pages-list-table-list"
          :style="{marginTop:'10px',display:'flex',flexDirection:'row',justifyContent:'flex-start'}"
        >
          <a-button type="primary" icon="form" @click="showModal">新增角色</a-button>
        </div>
        <a-table
          :rowSelection="rowSelection"
          :loading="tableLoading"
          :pagination="pagination"
          @change="handleTableChange"
          :columns="columns"
          :dataSource="data"
          :rowKey="record => record.roleId"
          :scroll="{x:600}"
        >
          <template slot="action" slot-scope="text, record">
            <a style="margin-right:10px;" slot="action" @click="() => editor(record.roleId)">修改权限内容</a>
            <a class="deletes" @click="() => deletes(record.roleId)">删除</a>
          </template>
        </a-table>
      </a-layout-content>
    </div>
  </div>
</template>
<script>
import { rolePage, roleDelete } from "api";
const columns = [
  {
    title: "角色名称",
    dataIndex: "name",
    scopedSlots: { customRender: "roleName" }
  },
  {
    title: "角色说明",
    dataIndex: "descr",
    scopedSlots: { customRender: "descr" }
  },
  {
    title: "创建时间",
    dataIndex: "createTime"
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
      columns,
      ModalText: "Content of the modal",
      visible: false,
      confirmLoading: false,
      formLayout: "horizontal",
      searchform: this.$form.createForm(this),
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
      }
    };
  },
  created() {
    this._rolePage();
  },
  methods: {
    _rolePage() {
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
      rolePage(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    //编辑
    editor(id) {
      this.$router.push("/system/roleeditor/" + id);
    },
    //新增
    showModal() {
      this.$router.push("/system/roleadd");
    },
    //重置搜索
    resetSearch() {
      this.searchform.resetFields();
      this._rolePage();
    },
    searchSubmit(e) {
      //搜索
      this.queryParam = this.firstParam;
      e.preventDefault();
      this.searchform.validateFields((err, values) => {
        this.queryParam = Object.assign({}, this.queryParam, values);
        this.getTableList();
      });
    },
    deletes(id) {
      //删除按钮
      let that = this;
      this.delID = id;
      that.$modal.confirm({
        centered: true,
        title: "请确定",
        content: "确定要删除该数据吗，删除后不可恢复？",
        cancelText: "取消",
        okText: "确定",
        onOk() {
          that.handleOk();
        },
        onCancel() {}
      });
    },
    handleOk() {
      // 确认删除
      let that = this;
      roleDelete({ roleId: this.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          that.tableLoading = true;
          setTimeout(() => {
            that.visible = false;
            that.confirmLoading = false;
            that._rolePage();
          }, 500);
        }
      });
    }
  },
  computed: {
    rowSelection() {
      const { selectedRowKeys } = this;
      return {
        onChange: (selectedRowKeys, selectedRows) => {},
        getCheckboxProps: record => ({
          props: {
            disabled: record.name === "Disabled User",
            name: record.name
          }
        })
      };
    }
  }
};
</script>
<style scoped>
.deletes {
  color: #f5222d;
}
</style>