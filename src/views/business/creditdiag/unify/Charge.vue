<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>功能业务配置</a-breadcrumb-item>
            <a-breadcrumb-item>信用卡诊断配置</a-breadcrumb-item>
            <a-breadcrumb-item>诊断统一配置</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">诊断统一配置</span>
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
          :style="{display:'flex',flexDirection:'row',justifyContent:'flex-end'}"
        >
          <div class="pages-list-table-list" style="margin-top:15px">
            <a-button type="primary" style="margin-right:50px" @click="saveall">保存修改</a-button>
            <a-button type="primary" icon="form" @click="addModal">新增配置</a-button>
          </div>
        </div>
        <a-table
          bordered
          :loading="tableLoading"
          :pagination="pagination"
          :showHeader="true"
          :dataSource="data"
          :columns="columns"
          :rowKey="record => record.chargeId"
          @change="handleTableChange"
        >
          <template
            v-for="col in ['chargeRuleName', 'chargeNormal','chargeMember']"
            :slot="col"
            slot-scope="text, record"
          >
            <div :key="col">
              <a-input
                style="width:150px"
                :defaultValue="text"
                class="sort-input"
                @change="e => changeInput(e.target.value, record.chargeId,col)"
              />
            </div>
          </template>
          <template slot="memberFreeTime" slot-scope="text,record">
            <a-input-number
              style="width:150px"
              :defaultValue="Number(text)"
              class="sort-input"
              :min="0"
              @change="value => changeInput(value, record.chargeId,'memberFreeTime')"
            />
          </template>
          <template slot="chargeStatus" slot-scope="text, record">
            <a-switch
              checkedChildren="启用"
              unCheckedChildren="停用"
              :checked="text === 1"
              @change="() => stopbution( record.chargeId,record.chargeStatus,'chargeStatus')"
            />
          </template>
          <template slot="operation" slot-scope="text, record">
            <div class="editable-row-operations">
              <span>
                <a class="deletes" @click="() => deletes(record.chargeId)">删除</a>
              </span>
            </div>
          </template>
        </a-table>
      </a-layout-content>
    </div>

    <a-modal
      centered
      title="新增诊断费用配置"
      :visible="adduser.visible"
      :confirmLoading="adduser.confirmLoading"
      @cancel="userCancel"
      :footer="null"
    >
      <a-form :form="useraddform" @submit="adduserSubmit">
        <a-form-item label="收费规则名称" :label-col="{ span: 7 }" :wrapper-col="{ span: 12 }">
          <a-input
            v-decorator="['chargeRuleName',{rules: [{ required: true, message: '请输入收费规则名称!' }]}]"
          />
        </a-form-item>
        <a-form-item label="普通用户收费" :label-col="{ span: 7 }" :wrapper-col="{ span: 12 }">
          <a-input
            v-decorator="['chargeNormal',{rules: [{ required: false, message: '普通用户收费!' }]}]"
          />
        </a-form-item>
        <a-form-item label="会员收费" :label-col="{ span: 7 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['chargeMember',{rules: [{ required: false, message: '会员收费!' }]}]" />
        </a-form-item>
        <a-form-item label="会员用户免费次数" :label-col="{ span: 7 }" :wrapper-col="{ span: 12 }">
          <a-input
            v-decorator="['memberFreeTime',{rules: [{ required: false, message: '会员用户免费次数!' }]}]"
          />
        </a-form-item>

        <a-form-item label="是否启用" :label-col="{ span: 7 }" :wrapper-col="{ span: 12 }">
          <a-switch checkedChildren="启用" unCheckedChildren="停用" v-decorator="['chargeStatus']" />
        </a-form-item>
        <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
          <a-button type="primary" html-type="submit">保存</a-button>
        </a-form-item>
      </a-form>
    </a-modal>
  </div>
</template>
<script>
import { chargePage, chargeAdd, chargeUpdate, chargeDelete } from "api";

const columns = [
  {
    title: "创建时间",
    // width: "18%",
    dataIndex: "chargeCreateTime",
    scopedSlots: { customRender: "chargeCreateTime" }
  },
  {
    title: "收费规则",
    // width: "18%",
    dataIndex: "chargeRuleName",
    scopedSlots: { customRender: "chargeRuleName" }
  },
  {
    title: "普通会员诊断费用/次（元）",
    // width: "18%",
    dataIndex: "chargeNormal",
    scopedSlots: { customRender: "chargeNormal" }
  },

  {
    title: "会员免费诊断次数(0为无限次数)",
    // width: "18%",
    dataIndex: "memberFreeTime",
    scopedSlots: { customRender: "memberFreeTime" }
  },
  {
    title: "会员收费",
    // width: "18%",
    dataIndex: "chargeMember",
    scopedSlots: { customRender: "chargeMember" }
  },
  {
    title: "状态",
    // width: "18%",
    dataIndex: "chargeStatus",
    scopedSlots: { customRender: "chargeStatus" }
  },
  {
    title: "操作",
    dataIndex: "operation",
    scopedSlots: { customRender: "operation" }
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
      switchChecked: false,
      pagination: {
        total: 0,
        defaultCurrent: 1,
        defaultPageSize: 10,
        showTotal: total => `共 ${total} 条数据`,
        showSizeChanger: true,
        pageSizeOptions: ["5", "10", "15", "20"],
        showQuickJumper: true
      },
      adduser: {
        visible: false,
        confirmLoading: true
      },
      useraddform: this.$form.createForm(this),
      queryParam: {
        pageNum: 1, //第几页
        pageSize: 10 //每页中显示数据的条数
      }
    };
  },
  created() {
    this._chargePage();
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
      chargePage(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    _chargePage() {
      //获取会员商品列表
      this.getTableList();
    },

    addModal() {
      //打开新增服务
      this.adduser.visible = true;
    },
    adduserSubmit(e) {
      //新增服务保存
      let that = this;
      e.preventDefault();
      that.useraddform.validateFields((err, values) => {
        if (values.chargeStatus) {
          values.chargeStatus = 1;
        } else {
          values.chargeStatus = 0;
        }
        let formData = new FormData();
        formData.append("chargeStatus", values.chargeStatus);
        formData.append("chargeRuleName", values.chargeRuleName);
        formData.append("chargeNormal", values.chargeNormal);
        formData.append("chargeMember", values.chargeMember);
        formData.append("memberFreeTime", values.memberFreeTime);
        if (!err) {
          chargeAdd(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.adduser.visible = false;
              that.useraddform.resetFields();
              that._chargePage();
            }
          });
        }
      });
    },
    userCancel() {
      //关闭新增服务页面
      this.adduser.visible = false;
    },

    stopbution(id, status, col) {
      //状态切换
      let that = this;
      const target = that.data.filter(item => id === item.chargeId)[0];
      if (status == 1) {
        status = 0;
      } else {
        status = 1;
      }
      let formData = new FormData();
      formData.append("chargeId", id);
      formData.append("chargeStatus", status);
      chargeUpdate(formData).then(res => {
        if (res.code && target) {
          if (res.code === 11111) {
            that.$message.success(res.msg);
            target.chargeStatus = 0;
          } else {
            status === 1
              ? that.$message.success("已经启用了该配置")
              : that.$message.success("已经停用了该配置");
            target.chargeStatus = status;
          }
        }
      });
    },
    changeInput(value, id, column) {
      //监听值变化
      const newData = [...this.data];
      const target = newData.filter(item => id === item.chargeId)[0];
      console.log(value, id, column);
      if (target) {
        target[column] = value;
        target.editable = true;
        this.data = newData;
      }
    },
    saveall() {
      //保存修改
      const target = this.data.filter(item => true === item.editable);
      //   console.log(target);
      for (var i = 0; i < target.length; i++) {
        const formData = new FormData();
        formData.append("chargeId", target[i].chargeId);
        formData.append("chargeRuleName", target[i].chargeRuleName);
        formData.append("chargeNormal", target[i].chargeNormal);
        formData.append("chargeMember", target[i].chargeMember);
        formData.append("memberFreeTime", target[i].memberFreeTime);
        chargeUpdate(formData).then(res => {
          if (res.code) {
            this.$message.success(res.msg);
          }
        });
        delete target[i].editable;
      }
    },
    handleOk() {
      //确定删除
      let that = this;
      chargeDelete({ chargeIds: this.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          that.tableLoading = true;
          setTimeout(() => {
            that.visible = false;
            that.confirmLoading = false;
            that._chargePage();
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
        content: "确定删除该配置？",
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
.editable-row-operations a {
  margin-right: 8px;
}
.sort-input {
  color: #1890ff;
  border: none;
  border-bottom: 1px solid white !important;
  box-shadow: none;
}
.deletes {
  color: #f5222d;
}
</style>