<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>系统管理</a-breadcrumb-item>
            <a-breadcrumb-item>系统用户管理</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">系统用户管理</span>
          </div>
        </div>
      </div>
    </div>
    <div class="wrap-children-content">
      <a-layout-content
        :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }"
      >
        <a-form layout="inline" :form="searchform" @submit="searchSubmit">
          <a-form-item label="姓名">
            <a-input v-decorator="['name',{rules: [{ required: false, message: '请输入姓名！' }]}]" />
          </a-form-item>
          <a-form-item label="账号">
            <a-input v-decorator="['account',{rules: [{ required: false, message: '请输入账号！' }]}]" />
          </a-form-item>
          <a-form-item label="状态">
            <a-select
              style="width:100px;"
              v-decorator="['statu', {rules: [{ required: false, message: '请选择状态' }]}]"
            >
              <a-select-option :value="0">停用</a-select-option>
              <a-select-option :value="1">启用</a-select-option>
              <a-select-option value="null">全部</a-select-option>
            </a-select>
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
          <a-button type="primary" icon="form" @click="addModal">新增用户</a-button>
        </div>
        <a-table
          :loading="tableLoading"
          :pagination="pagination"
          @change="handleTableChange"
          :showHeader="true"
          :columns="columns"
          :dataSource="data"
          :rowKey="record => record.adminId"
          :scroll="{x:690}"
        >
          <template slot="userName" slot-scope="text">{{text}}</template>
          <template slot="roleId" slot-scope="text">{{filterRole(text)}}</template>
          <template slot="statu" slot-scope="text,record">
            <a-switch
              checkedChildren="启用"
              unCheckedChildren="停用"
              :checked="text === 1"
              @change="() => stopbution(record.adminId, record.statu)"
            />
          </template>
          <template slot="action" slot-scope="text, record">
            <a @click="() => editor(record.adminId,record)">修改</a>
            <a class="reset" @click="() => reset(record.adminId)">重置密码</a>
            <a class="deletes" @click="() => deletes(record.adminId)">删除</a>
          </template>
        </a-table>
      </a-layout-content>
      <a-modal
        centered
        title="修改用户"
        :visible="modify.visible"
        :confirmLoading="modify.confirmLoading"
        @cancel="modifyCancel"
        :footer="null"
      >
        <a-form :form="modifyform" @submit="modifySubmit">
          <a-form-item label="用户名" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input
              v-decorator="['username',{rules: [{ required: false, message: '请输入用户名!' }],initialValue: editValue.name}]"
            />
          </a-form-item>
          <a-form-item label="角色名称" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-select
              style="min-width:100px;"
              v-decorator="['roleId', {rules: [{ required: false, message: '请选择角色名称' }],initialValue: editValue.roleId}]"
            >
              <a-select-option
                v-for="(item, index) in roleOption"
                :key="index"
                :value="item.roleId"
              >{{item.name}}</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="登录密码" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input
              v-decorator="['passwd',{rules: [{ required: false, message: '请输入登录密码!' },{
              validator: validateToNextPassword,
            }]}]"
              type="password"
            />
          </a-form-item>
          <a-form-item
            label="确认密码"
            :label-col="{ span: 5 }"
            :wrapper-col="{ span: 12 }"
            @blur="handleConfirmBlur"
          >
            <a-input
              v-decorator="['passwd2',{rules: [{ required: false, message: '请输入确认密码!' },{
              validator: compareToFirstPassword,
            }]}]"
              type="password"
            />
            <a-icon slot="prefix" type="lock" style="color: rgba(0,0,0,.25)" />
          </a-form-item>
          <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
            <a-button type="primary" html-type="submit">保存</a-button>
          </a-form-item>
        </a-form>
      </a-modal>
      <a-modal
        centered
        title="新增用户"
        :visible="adduser.visible"
        :confirmLoading="adduser.confirmLoading"
        @cancel="userCancel"
        :footer="null"
      >
        <a-form :form="useraddform" @submit="adduserSubmit">
          <a-form-item label="用户名" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input
              v-decorator="['username',{rules: [{ required: true, message: '请输入用户名!' }],initialValue: '新'}]"
              placeholder="username"
            />
          </a-form-item>
          <a-form-item label="角色名称" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-select
              style="min-width:100px;"
              v-decorator="['roleId', {rules: [{ required: true, message: '请选择角色名称' }]}]"
            >
              <a-select-option
                v-for="(item, index) in roleOption"
                :key="index"
                :value="item.roleId"
              >{{item.name}}</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <h3>用户账号</h3>
          </a-form-item>
          <a-form-item label="登录账号" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['account',{rules: [{ required: true, message: '请输入登录账号!' }]}]" />
          </a-form-item>
          <a-form-item label="登录密码" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input
              v-decorator="['passwd',{rules: [{ required: true, message: '请输入登录密码!' },{
              validator: (rule, value, callback) => validateToNextPassword(rule, value, callback, 'add'),
            }]}]"
              type="password"
            />
          </a-form-item>
          <a-form-item
            label="确认密码"
            :label-col="{ span: 5 }"
            :wrapper-col="{ span: 12 }"
            @blur="handleConfirmBlur"
          >
            <a-input
              v-decorator="['passwd2',{rules: [{ required: true, message: '请输入确认密码!' },{
              validator: (rule, value, callback) => compareToFirstPassword(rule, value, callback, 'add'),
            }]}]"
              type="password"
            />
          </a-form-item>
          <a-form-item label="状态" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch checkedChildren="启用" unCheckedChildren="停用" v-decorator="['statu']" />
          </a-form-item>
          <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
            <a-button type="primary" html-type="submit">保存</a-button>
          </a-form-item>
        </a-form>
      </a-modal>
    </div>
  </div>
</template>
<script>
import {
  adminlist,
  adminadd,
  resetPasswd,
  adminUpdate,
  adminDelete,
  rolePage
} from "api";
import crypto from "crypto";
const columns = [
  {
    title: "用户名",
    dataIndex: "name",
    scopedSlots: { customRender: "userName" }
  },
  {
    title: "账号",
    dataIndex: "account"
  },

  {
    title: "角色名称",
    dataIndex: "roleId",
    scopedSlots: { customRender: "roleId" }
  },

  {
    title: "创建时间",
    dataIndex: "createTime",
    scopedSlots: { customRender: "createTime" }
  },
  {
    title: "状态",
    dataIndex: "statu",
    scopedSlots: { customRender: "statu" }
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
      adduser: {
        visible: false,
        confirmLoading: true
      },
      modify: {
        visible: false,
        confirmLoading: true
      },
      confirmDirty: false,
      columns,
      ModalText: "Content of the modal",
      visible: false,
      roleOption: [],
      confirmLoading: false,
      formLayout: "horizontal",
      editValue: {},
      selectValue: ["VIP订单", "实物订单", "应用订单", "信用点订单"],
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
      searchform: this.$form.createForm(this),
      modifyform: this.$form.createForm(this),
      useraddform: this.$form.createForm(this)
    };
  },

  created() {
    this._adminlist();
    this._rolePage();
  },
  methods: {
    _adminlist() {
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
      adminlist(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    _rolePage() {
      //获取角色列表
      let that = this;
      rolePage({}).then(res => {
        if (res.code) {
          that.roleOption = res.data.list;
        }
      });
    },
    //判断角色名称
    filterRole(text) {
      let that = this;
      const target = that.roleOption.filter(item => text === item.roleId)[0];
      if (target) {
        return target.name;
      }
    },

    stopbution(id, status) {
      //状态切换
      let that = this;
      const target = that.data.filter(item => id === item.adminId)[0];
      if (status == 1) {
        status = 0;
      } else {
        status = 1;
      }
      let formData = {};
      formData.adminId = id;
      formData.statu = status;
      adminUpdate(formData).then(res => {
        if (res.code) {
          status === 1
            ? that.$message.success("已启用")
            : that.$message.success("已停用");
          target.statu = status;
        }
      });
    },
    editor(id, editValue) {
      //点击修改按钮
      this.editValue = editValue;
      this.editId = id;
      this.modify.visible = true;
    },
    // 修改用户表单提交
    modifySubmit(e) {
      let that = this;
      e.preventDefault();
      that.modifyform.validateFields((err, values) => {
        let formData = {};
        const md5 = crypto.createHash("md5");

        formData.adminId = that.editId;
        if (values.username) {
          formData.name = values.username;
        }
        if (values.roleId) {
          formData.roleId = values.roleId;
        }
        if (values.passwd) {
          md5.update(values.passwd);
          formData.passwd = md5.digest("hex");
        }
        if (!err) {
          adminUpdate(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.modify.visible = false;
              that._adminlist();
              that.modifyform.resetFields();
            }
          });
        }
      });
    },
    //退出修改界面
    modifyCancel() {
      this.modify.visible = false;
      this.modifyform.resetFields();
    },

    //前后两次密码输入校验
    handleConfirmBlur(e) {
      const value = e.target.value;
      this.confirmDirty = this.confirmDirty || !!value;
    },
    compareToFirstPassword(rule, value, callback, col) {
      if (col === "add") {
        const form = this.useraddform;
        if (value && value !== form.getFieldValue("passwd")) {
          callback("两个密码输入不一致!");
        } else {
          callback();
        }
      } else {
        const form = this.modifyform;
        if (value && value !== form.getFieldValue("passwd")) {
          callback("两个密码输入不一致!");
        } else {
          callback();
        }
      }
    },
    validateToNextPassword(rule, value, callback, col) {
      if (col === "add") {
        const form = this.useraddform;
        if (value && this.confirmDirty) {
          form.validateFields(["passwd2"], { force: true });
        }
      } else {
        const form = this.modifyform;
        if (value && this.confirmDirty) {
          form.validateFields(["passwd2"], { force: true });
        }
      }

      callback();
    },

    addModal() {
      //点击新增按钮
      this.adduser.visible = true;
    },
    adduserSubmit(e) {
      //新增表单提交
      let that = this;
      e.preventDefault();
      that.useraddform.validateFields((err, values) => {
        let formData = {};
        const md5 = crypto.createHash("md5");
        if (values.username) {
          formData.name = values.username;
        }
        if (values.roleId) {
          formData.roleId = values.roleId;
        }
        if (values.account) {
          formData.account = values.account;
        }
        if (values.passwd) {
          md5.update(values.passwd);
          formData.passwd = md5.digest("hex");
        }
        if (values.statu) {
          if (values.statu === true) {
            values.statu = 1;
            formData.statu = values.statu;
          } else {
            values.statu = 0;
            formData.statu = values.statu;
          }
        }
        if (!err) {
          adminadd(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that._adminlist();
              that.useraddform.resetFields();
            }
          });
        }
      });
    },
    userCancel() {
      //退出新增界面
      this.adduser.visible = false;
    },
    //重置搜索
    resetSearch() {
      this.searchform.resetFields();
      this._adminlist();
    },
    searchSubmit(e) {
      //搜索
      this.queryParam = this.firstParam;
      e.preventDefault();
      this.searchform.validateFields((err, values) => {
        if (values.statu === "all") {
          values.statu = null;
        }
        this.queryParam = Object.assign({}, this.queryParam, values);
        this.getTableList();
      });
    },

    reset(id) {
      //重置密码
      let that = this;
      that.$modal.confirm({
        centered: true,
        title: "请确定",
        content: "是否确认将此账号密码重置为123456？",
        cancelText: "取消",
        okText: "确定",
        onOk() {
          resetPasswd({ adminId: id }).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
            }
          });
        },
        onCancel() {}
      });
    },
    deletes(id) {
      //删除事件
      let that = this;
      this.delID = id;
      that.$modal.confirm({
        centered: true,
        title: "请确定",
        content: "确定删除该配置？",
        cancelText: "取消",
        okText: "确定",
        onOk() {
          that.handleOk();
        },
        onCancel() {}
      });
    },
    handleOk() {
      //确定删除
      let that = this;
      adminDelete({ adminId: this.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          that.tableLoading = true;
          setTimeout(() => {
            that.visible = false;
            that.confirmLoading = false;
            that.modifyform.resetFields();
            that._adminlist();
          }, 200);
        }
      });
    }
  }
};
</script>
<style scoped>
.deletes {
  color: #f5222d;
}
.reset {
  color: #faad14;
  margin: 0 10px;
}
</style>