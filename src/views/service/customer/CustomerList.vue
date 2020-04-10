<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>人工服务管理</a-breadcrumb-item>
            <a-breadcrumb-item>客服列表</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">客服列表</span>
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
            <!-- 搜索框 -->
            <a-form-item>
              <a-input v-decorator="['inValue']" placeholder="输入条件">
                <a-select v-decorator="['selKey',{initialValue: 'serviceName'}]" slot="addonBefore">
                  <a-select-option value="serviceName">会员名</a-select-option>
                  <a-select-option value="servicePhone">手机号</a-select-option>
                  <a-select-option value="qqNum">QQ号码</a-select-option>
                  <a-select-option value="wxNum">微信号</a-select-option>
                </a-select>
              </a-input>
            </a-form-item>
            <a-form-item label="状态">
              <a-select
                style="width:100px;"
                v-decorator="['serviceStatus', {rules: [{ required: false, message: '请选择状态' }]}]"
              >
                <a-select-option value="0">停用</a-select-option>
                <a-select-option value="1">启用</a-select-option>
                <a-select-option value="null">全部</a-select-option>
              </a-select>
            </a-form-item>

            <a-form-item>
              <a-button type="primary" html-type="submit">搜索</a-button>
            </a-form-item>
          </a-form>
          <div class="pages-list-table-list" style="margin-top:10px">
            <a-button type="primary" icon="form" @click="addModal">新增服务配置</a-button>
          </div>
        </div>

        <a-table
          :loading="tableLoading"
          :columns="columns"
          :dataSource="data"
          :pagination="pagination"
          :rowKey="record => record.sid"
          @change="handleTableChange"
        >
          <template slot="serviceStatus" slot-scope="text, record">
            <a-switch
              checkedChildren="启用"
              unCheckedChildren="停用"
              :defaultChecked="record.serviceStatus === 1"
              @change="() => stopbution(record.sid, record.serviceStatus)"
            />
          </template>
          <template slot="action" slot-scope="text, record">
            <a style="margin-right:10px;" slot="action" @click="() => editor(record.sid,record)">修改</a>
            <span>
              <a class="deletes" @click="() => deletes(record.sid)">删除</a>
            </span>
          </template>
        </a-table>
      </a-layout-content>
      <a-modal
        centered
        title="修改服务配置"
        :visible="modify.visible"
        :confirmLoading="modify.confirmLoading"
        @cancel="modifyCancel"
        :footer="null"
      >
        <a-form :form="modifyform" @submit="modifySubmit">
          <a-form-item label="客服名称" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input
              v-decorator="['serviceName',{rules: [{ required: true, message: '请输入客服名称!' }],initialValue: this.editValue.serviceName}]"
            />
          </a-form-item>
          <a-form-item label="客服热线" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['servicePhone',{initialValue: this.editValue.servicePhone}]" />
          </a-form-item>
          <a-form-item label="QQ号码" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['qqNum',{initialValue: this.editValue.qqNum}]" />
          </a-form-item>
          <a-form-item label="微信号" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['wxNum',{initialValue: this.editValue.wxNum}]" />
          </a-form-item>
          <a-form-item label="头像" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['headPic',{initialValue: this.editValue.headPic}]" />
          </a-form-item>
          <a-form-item label="排序" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['sort',{initialValue: this.editValue.sort}]" />
          </a-form-item>
          <a-form-item label="描述" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['description',{initialValue: this.editValue.description}]" />
          </a-form-item>
          <a-form-item label="服务状态" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch
              checkedChildren="启用"
              unCheckedChildren="停用"
              v-decorator="['serviceStatus',{initialValue: editValue.serviceStatus === 1,valuePropName: 'checked'}]"
            />
          </a-form-item>
          <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
            <a-button type="primary" html-type="submit">保存</a-button>
          </a-form-item>
        </a-form>
      </a-modal>
      <a-modal
        centered
        title="新增服务配置"
        :visible="addservice.visible"
        :confirmLoading="addservice.confirmLoading"
        @cancel="serviceCancel"
        :footer="null"
      >
        <a-form :form="serviceaddform" @submit="addserviceSubmit">
          <a-form-item label="客服名称" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input
              v-decorator="['serviceName',{rules: [{ required: true, message: '请输入客服名称!' }]}]"
            />
          </a-form-item>
          <a-form-item label="客服热线" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['servicePhone']" />
          </a-form-item>
          <a-form-item label="QQ号码" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['qqNum']" />
          </a-form-item>
          <a-form-item label="微信号" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['wxNum']" />
          </a-form-item>
          <a-form-item label="头像" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['headPic']" />
          </a-form-item>
          <a-form-item label="排序" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['sort']" />
          </a-form-item>
          <a-form-item label="描述" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['description']" />
          </a-form-item>
          <a-form-item label="服务状态" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch
              checkedChildren="启用"
              unCheckedChildren="停用"
              defaultChecked
              v-decorator="['serviceStatus']"
            />
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
  customerPage,
  findCustomer,
  customerUpdate,
  customerAdd,
  customerDelete,
  customerDeletes
} from "api";
const columns = [
  {
    title: "头像",
    dataIndex: "headPic",
    scopedSlots: { customRender: "headPic" }
  },
  {
    title: "客服名称",
    dataIndex: "serviceName"
  },
  {
    title: "客服热线",
    dataIndex: "servicePhone",
    scopedSlots: { customRender: "servicePhone" }
  },
  {
    title: "QQ号码",
    dataIndex: "qqNum",
    scopedSlots: { customRender: "qqNum" }
  },
  {
    title: "微信号",
    dataIndex: "wxNum",
    scopedSlots: { customRender: "wxNum" }
  },
  {
    title: "描述",
    dataIndex: "description",
    scopedSlots: { customRender: "description" }
  },
  {
    title: "排序",
    dataIndex: "sort",
    scopedSlots: { customRender: "sort" }
  },
  {
    title: "服务状态",
    dataIndex: "serviceStatus",
    scopedSlots: { customRender: "serviceStatus" }
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
      delmsg: null,
      data: null,
      addservice: {
        visible: false,
        confirmLoading: true
      },
      modify: {
        visible: false,
        confirmLoading: true
      },
      editValue: {},
      confirmDirty: false,
      columns,
      ModalText: "Content of the modal",
      visible: false,
      roleOption: null,
      confirmLoading: false,
      formLayout: "horizontal",
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
      serviceaddform: this.$form.createForm(this)
    };
  },
  created() {
    this._customerPage();
  },
  methods: {
    _customerPage() {
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
      customerPage(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        // console.log(res);
        // console.log(that.data);
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    addModal() {
      this.addservice.visible = true;
    },
    editor(id, editValue) {
      //点击修改按钮
      this.editValue = editValue;
      this.editId = id;
      this.modify.visible = true;
    },
    stopbution(id, status) {
      //状态切换
      let that = this;
      const newData = [...that.data];
      const target = newData.filter(item => id === item.sid)[0];
      if (status == 1) {
        status = 0;
      } else {
        status = 1;
      }
      let formData = new FormData();
      formData.append("sid", id);
      formData.append("serviceStatus", status);
      customerUpdate(formData).then(res => {
        if (res.code && target) {
          status === 1
            ? that.$message.success("已经启用了该账号")
            : that.$message.success("已经停用了该账号");
          target.serviceStatus = res.data.serviceStatus;
          that.data = newData;
        }
      });
    },

    // 修改用户
    modifySubmit(e) {
      let that = this;
      e.preventDefault();
      that.modifyform.validateFields((err, values) => {
        console.log(values);
        values.sid = that.editId;
        if (values.serviceStatus) {
          values.serviceStatus = 1;
        } else {
          values.serviceStatus = 0;
        }
        let formData = new FormData();
        formData.append("sid", values.sid);
        formData.append("serviceStatus", values.serviceStatus);
        formData.append("description", values.description);
        formData.append("headPic", values.headPic);
        formData.append("qqNum", values.qqNum);
        formData.append("serviceName", values.serviceName);
        formData.append("servicePhone", values.servicePhone);
        formData.append("sort", values.sort);
        formData.append("wxNum", values.wxNum);
        if (!err) {
          customerUpdate(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.modify.visible = false;
              this._customerPage();
            }
          });
        }
      });
    },

    addserviceSubmit(e) {
      let that = this;
      e.preventDefault();
      that.serviceaddform.validateFields((err, values) => {
        if (values.serviceStatus) {
          values.serviceStatus = 1;
        } else {
          values.serviceStatus = 0;
        }
        let formData = new FormData();
        formData.append("serviceStatus", values.serviceStatus);
        formData.append("description", values.description);
        formData.append("headPic", values.headPic);
        formData.append("qqNum", values.qqNum);
        formData.append("serviceName", values.serviceName);
        formData.append("servicePhone", values.servicePhone);
        formData.append("sort", values.sort);
        formData.append("wxNum", values.wxNum);
        if (!err) {
          customerAdd(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.addservice.visible = false;
              this._customerPage();
            }
          });
        }
      });
    },
    searchSubmit(e) {
      this.queryParam = this.firstParam;
      e.preventDefault();
      this.searchform.validateFields((err, values) => {
        console.log(values);
        const str = values.selKey;
        let target = {};
        target[str] = values.inValue;
        if (values.serviceStatus === "null") {
          values.serviceStatus = null;
        }
        target.serviceStatus = values.serviceStatus;
        this.queryParam = Object.assign({},this.queryParam, target);
        this.getTableList();
      });
    },

    modifyCancel() {
      this.modify.visible = false;
    },
    serviceCancel() {
      this.addservice.visible = false;
    },
    handleOk() {
      //确定删除
      let that = this;
      customerDelete({ sid: this.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          //   that.tableLoading = true;
          setTimeout(() => {
            that.visible = false;
            that.confirmLoading = false;
            that._customerPage();
          }, 200);
        }
      });
    },
    deletes(id) {
      //删除事件
      let that = this;
      this.delID = id;
      that.$modal.confirm({
        centered: true,
        title: "请确定",
        content: "确定删除该服务？",
        cancelText: "取消",
        okText: "确定",
        onOk() {
          that.handleOk();
        },
        onCancel() {}
      });
    },
    handleCancel() {
      //取消删除
      this.visible = false;
    }
  }
};
</script>
<style scoped>
.deletes{
    color: #f5222d;
}
</style>