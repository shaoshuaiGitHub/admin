<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>信用卡管理</a-breadcrumb-item>
            <a-breadcrumb-item>信用卡列表</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">信用卡列表</span>
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
                <a-select v-decorator="['selKey',{initialValue: 'userName'}]" slot="addonBefore">
                  <a-select-option value="userName">卡主用户名</a-select-option>
                  <a-select-option value="phone">电话号码</a-select-option>
                  <a-select-option value="realName">真实姓名</a-select-option>
                  <a-select-option value="cardNumber">卡号</a-select-option>
                </a-select>
              </a-input>
            </a-form-item>
            <a-form-item>
              <a-button type="primary" html-type="submit">搜索</a-button>
            </a-form-item>
          </a-form>
        </div>
        <a-table
          :loading="tableLoading"
          :columns="columns"
          :dataSource="data"
          :pagination="pagination"
          :rowKey="record => record.cid"
          @change="handleTableChange"
        >
          <template slot="status" slot-scope="text,record">
            <a class="status-detail" @click="() => detailStatus(record.cid,record)">状态详情</a>
          </template>
          <template slot="action" slot-scope="text, record">
            <a style="margin-right:10px;" slot="action" @click="() => editor(record.cid,record)">修改</a>
            <span>
              <a class="deletes" @click="() => deletes(record.cid)">删除</a>
            </span>
          </template>
        </a-table>
      </a-layout-content>
      <a-modal
        centered
        :title="statusValue.bankName+':'+statusValue.cardNumber+'-状态详情'"
        :visible="status.visible"
        :confirmLoading="status.confirmLoading"
        @cancel="statusCancel"
        :footer="null"
      >
        <a-form :form="statusform" @submit="statusSubmit">
          <a-form-item label="是否隐藏" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch
              checkedChildren="是"
              unCheckedChildren="否 "
              v-decorator="['isHide',{initialValue: statusValue.isHide === 1,valuePropName: 'checked'}]"
            />
          </a-form-item>
          <a-form-item label="是否开启提额" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch
              checkedChildren="是"
              unCheckedChildren="否 "
              v-decorator="['isProplan',{initialValue: statusValue.isProplan === 1,valuePropName: 'checked'}]"
            />
          </a-form-item>
          <a-form-item label="是否开启周转" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch
              checkedChildren="是"
              unCheckedChildren="否 "
              v-decorator="['isTurnover',{initialValue: statusValue.isTurnover === 1,valuePropName: 'checked'}]"
            />
          </a-form-item>
          <a-form-item label="是否开启诊断" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch
              checkedChildren="是"
              unCheckedChildren="否 "
              v-decorator="['isDiagnosis',{initialValue: statusValue.isDiagnosis === 1,valuePropName: 'checked'}]"
            />
          </a-form-item>
          <a-form-item label="还款状态" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch
              checkedChildren="已还清"
              unCheckedChildren="未还清"
              v-decorator="['paystatus',{initialValue: statusValue.paystatus === 1,valuePropName: 'checked'}]"
            />
          </a-form-item>
          <a-form-item label="卡状态" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch
              checkedChildren="启用"
              unCheckedChildren="停用"
              v-decorator="['cardStatus',{initialValue: statusValue.cardStatus === 1,valuePropName: 'checked'}]"
            />
          </a-form-item>
          <a-form-item label="导卡途径" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch
              checkedChildren="自动"
              unCheckedChildren="手动"
              v-decorator="['manualOrAuto',{initialValue: statusValue.manualOrAuto === 1,valuePropName: 'checked'}]"
            />
          </a-form-item>
          <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
            <a-button type="primary" html-type="submit">保存</a-button>
          </a-form-item>
        </a-form>
      </a-modal>
      <a-modal
        centered
        title="修改信用卡配置"
        :visible="modify.visible"
        :confirmLoading="modify.confirmLoading"
        @cancel="modifyCancel"
        :footer="null"
      >
        <a-form :form="modifyform" @submit="modifySubmit">
          <a-form-item label="卡主用户名" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['userName',{initialValue: editValue.userName}]" />
          </a-form-item>
          <a-form-item label="卡名称" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['cardName',{initialValue: editValue.cardName}]" />
          </a-form-item>
          <a-form-item label="卡号" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['cardNumber',{initialValue: editValue.cardNumber}]" />
          </a-form-item>
          <a-form-item label="账单日" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['billDate',{initialValue: editValue.billDate}]" />
          </a-form-item>
          <a-form-item label="还款日" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['repayDate',{initialValue: editValue.repayDate}]" />
          </a-form-item>
          <a-form-item label="总额度" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['quota',{initialValue: editValue.quota}]" />
          </a-form-item>
          <a-form-item label="可用额度" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['availableQuota',{initialValue: editValue.availableQuota}]" />
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
import { creditCardPage, deleteCreditCard, updateCreditCard } from "api";
const columns = [
  {
    title: "卡主用户名",
    dataIndex: "userName"
  },
  {
    title: "手机号",
    dataIndex: "phone",
    scopedSlots: { customRender: "phone" }
  },
  {
    title: "真实姓名",
    dataIndex: "realName",
    scopedSlots: { customRender: "realName" }
  },
  {
    title: "银行名称",
    dataIndex: "bankName",
    scopedSlots: { customRender: "bankName" }
  },
  {
    title: "卡名称",
    dataIndex: "cardName",
    scopedSlots: { customRender: "cardName" }
  },
  {
    title: "卡号",
    dataIndex: "cardNumber",
    scopedSlots: { customRender: "cardNumber" }
  },
  {
    title: "总额度",
    dataIndex: "quota",
    scopedSlots: { customRender: "quota" }
  },
  {
    title: "可用额度",
    dataIndex: "availableQuota",
    scopedSlots: { customRender: "availableQuota" }
  },
  {
    title: "卡申请日期",
    dataIndex: "cardBirthday",
    scopedSlots: { customRender: "cardBirthday" }
  },
  {
    title: "绑卡时间",
    dataIndex: "bindTime",
    scopedSlots: { customRender: "bindTime" }
  },
  {
    title: "账单日",
    dataIndex: "billDate",
    scopedSlots: { customRender: "billDate" }
  },
  {
    title: "还款日",
    dataIndex: "repayDate",
    scopedSlots: { customRender: "repayDate" }
  },
  {
    title: "状态管理",
    dataIndex: "status",
    scopedSlots: { customRender: "status" }
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
      modify: {
        visible: false,
        confirmLoading: true
      },
      status: {
        visible: false,
        confirmLoading: true
      },
      editValue: {},
      statusValue: {},
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
      statusform: this.$form.createForm(this)
    };
  },
  created() {
    this._creditCardPage();
  },
  methods: {
    _creditCardPage() {
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
      creditCardPage(that.queryParam).then(res => {
        if (res.code) {
          const pagination = { ...that.pagination };
          pagination.total = res.data.total;
          that.pagination = pagination;
          that.data = res.data.list;
          setTimeout(() => {
            that.tableLoading = false;
          }, 200);
          that.queryParam = that.firstParam;
        }
      });
    },
    detailStatus(id, statusValue) {
      // 点击状态管理
      this.status.visible = true;
      this.statusId = id;
      this.statusValue = statusValue;
    },

    statusSubmit(e) {
      // 状态管理
      let that = this;
      e.preventDefault();
      that.statusform.validateFields((err, values) => {
        console.log(values);
        if (values.cardStatus) {
          values.cardStatus = 1;
        } else {
          values.cardStatus = 0;
        }
        if (values.isDiagnosis) {
          values.isDiagnosis = 1;
        } else {
          values.isDiagnosis = 0;
        }
        if (values.isHide) {
          values.isHide = 1;
        } else {
          values.isHide = 0;
        }
        if (values.isProplan) {
          values.isProplan = 1;
        } else {
          values.isProplan = 0;
        }
        if (values.isTurnover) {
          values.isTurnover = 1;
        } else {
          values.isTurnover = 0;
        }
        if (values.manualOrAuto) {
          values.manualOrAuto = 1;
        } else {
          values.manualOrAuto = 0;
        }
        if (values.paystatus) {
          values.paystatus = 1;
        } else {
          values.paystatus = 0;
        }
        let formData = new FormData();
        formData.append("cid", that.statusId);
        formData.append("cardStatus", values.cardStatus);
        formData.append("isDiagnosis", values.isDiagnosis);
        formData.append("isHide", values.isHide);
        formData.append("isProplan", values.isProplan);
        formData.append("isTurnover", values.isTurnover);
        formData.append("manualOrAuto", values.manualOrAuto);
        formData.append("paystatus", values.paystatus);
        if (!err) {
          updateCreditCard(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.status.visible = false;
              that._creditCardPage();
            }
          });
        }
      });
    },
    statusCancel() {
      this.status.visible = false;
    },
    editor(id, editValue) {
      //点击修改按钮
      this.editValue = editValue;
      this.editId = id;
      this.modify.visible = true;
    },
    // 修改用户
    modifySubmit(e) {
      let that = this;
      e.preventDefault();
      that.modifyform.validateFields((err, values) => {
        console.log(values);
        values.cid = that.editId;
        let formData = new FormData();
        formData.append("cid", values.cid);
        formData.append("availableQuota", values.availableQuota);
        formData.append("billDate", values.billDate);
        formData.append("cardName", values.cardName);
        formData.append("cardNumber", values.cardNumber);
        formData.append("quota", values.quota);
        formData.append("repayDate", values.repayDate);
        formData.append("userName", values.userName);
        if (!err) {
          updateCreditCard(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.modify.visible = false;
              that._creditCardPage();
            }
          });
        }
      });
    },
    modifyCancel() {
      this.modify.visible = false;
    },
    searchSubmit(e) {
      e.preventDefault();
      this.searchform.validateFields((err, values) => {
        // console.log(values);
        const str = values.selKey;
        let target = {};
        target[str] = values.inValue;
        this.queryParam = JSON.parse(JSON.stringify(target));
        this.getTableList();
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
      deleteCreditCard({ cid: this.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          setTimeout(() => {
            that.visible = false;
            that.confirmLoading = false;
            that._creditCardPage();
          }, 200);
        }
      });
    }
  }
};
</script>
<style scoped>
.status-detail {
  color: #faad14;
}
.deletes {
  color: #f5222d;
}
</style>