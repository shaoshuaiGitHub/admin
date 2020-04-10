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
          <a-form layout="inline" :form="searchform" @submit="searchSubmit">
            <!-- 搜索框 -->
            <a-form-item>
              <a-input
                v-decorator="['inValue',{initialValue: Object.values(searchValue)[0]}]"
                placeholder="输入条件"
              >
                <a-select
                  v-decorator="['selKey',{initialValue: Object.keys(searchValue)[0]}]"
                  slot="addonBefore"
                >
                  <a-select-option value="userName">会员名</a-select-option>
                  <a-select-option value="phone">电话号码</a-select-option>
                  <a-select-option value="realName">真实姓名</a-select-option>
                  <a-select-option value="cardNumber">卡号</a-select-option>
                  <a-select-option value="uid">UID</a-select-option>
                </a-select>
              </a-input>
            </a-form-item>
            <a-form-item>
              <a-button type="primary" html-type="submit">搜索</a-button>
              <a-button :style="{marginLeft:'10px'}" @click="reloadFun">重置</a-button>
            </a-form-item>
          </a-form>
          
        </div>
        <div style="margin:20px 0;display:flex;flexDirection:row;justifyContent:flex-start">
          <a-button type="primary" icon="plus" @click="addModal">新增配置</a-button>
        </div>
        <a-table
          :loading="tableLoading"
          :columns="columns"
          :dataSource="data"
          :rowKey="record => record.cid"
          :pagination="pagination"
          @change="handleTableChange"
          :scroll="{x:1000}"
        >
          <template slot="status" slot-scope="text,record">
            <a class="status-detail" @click="() => detailStatus(record.cid,record)">状态详情</a>
          </template>
          <template slot="action" slot-scope="text, record">
            <a-button
              style="margin:10px 10px 10px 0"
              slot="action"
              type="primary"
              @click="() => editor(record.cid,record)"
            >编辑信息</a-button>
            <a-button
             
              type="primary"
              slot="action"
              @click="() => billInfo(record.cid,record)"
            >账单信息</a-button>
            <!-- <a-button class="deletes" type="danger" @click="() => deletes(record.cid)">删除</a-button> -->
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
              v-decorator="['cardStatus',{initialValue: statusValue.cardStatus === 0,valuePropName: 'checked'}]"
            />
          </a-form-item>
          <a-form-item label="导卡途径" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch
              checkedChildren="自动"
              unCheckedChildren="手动"
              v-decorator="['isManual',{initialValue: statusValue.isManual === 1,valuePropName: 'checked'}]"
            />
          </a-form-item>
          <a-form-item label="真实姓名" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <span>{{statusValue.realName}}</span>
          </a-form-item>
          <a-form-item label="昵称" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <span>{{statusValue.nickName}}</span>
          </a-form-item>
          <a-form-item label="申请日期" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <span>{{statusValue.cardBirthday}}</span>
          </a-form-item>
          <a-form-item label="绑卡时间" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <span>{{statusValue.bindTime}}</span>
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
      <a-modal
        centered
        title="新增信用卡"
        :visible="addservice.visible"
        :confirmLoading="addservice.confirmLoading"
        @cancel="serviceCancel"
        :footer="null"
      >
        <a-form :form="serviceaddform" @submit="addserviceSubmit">
          <a-form-item label="卡主用户名" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['userName']" />
          </a-form-item>
          <a-form-item label="用户id" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['userId',{ rules: [{required: true,message: '请输入存在的用户id'}]}]" />
          </a-form-item>
          <a-form-item label="卡名称" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['cardName']" />
          </a-form-item>
          <a-form-item label="银行归属" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-select
              style="width:100px;"
              v-decorator="['bankId',{ rules: [{required: true,message: '请输入归属银行'}]}]"
            >
              <a-select-option
                v-for="item in bankData"
                :value="item.bankId"
                :key="item.bankId"
              >{{item.bankName}}</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="卡号" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['cardNumber',{ rules: [{required: true,message: '请输入卡号'}]}]" />
          </a-form-item>
          <a-form-item label="账单日" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['billDate']" />
          </a-form-item>
          <a-form-item label="还款日" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['repayDate']" />
          </a-form-item>
          <a-form-item label="总额度" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['quota',{ rules: [{required: true,message: '请输入总额度'}]}]" />
          </a-form-item>
          <a-form-item label="可用额度" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input
              v-decorator="['availableQuota',{ rules: [{required: true,message: '请输入可用额度'}]}]"
            />
          </a-form-item>
          <a-form-item label="是否隐藏" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch checkedChildren="是" unCheckedChildren="否 " v-decorator="['isHide']" />
          </a-form-item>
          <a-form-item label="是否开启提额" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch checkedChildren="是" unCheckedChildren="否 " v-decorator="['isProplan']" />
          </a-form-item>
          <a-form-item label="是否开启周转" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch checkedChildren="是" unCheckedChildren="否 " v-decorator="['isTurnover']" />
          </a-form-item>
          <a-form-item label="是否开启诊断" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch checkedChildren="是" unCheckedChildren="否 " v-decorator="['isDiagnosis']" />
          </a-form-item>
          <a-form-item label="还款状态" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch checkedChildren="已还清" unCheckedChildren="未还清" v-decorator="['paystatus']" />
          </a-form-item>
          <a-form-item label="卡状态" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch checkedChildren="启用" unCheckedChildren="停用" v-decorator="['cardStatus']" />
          </a-form-item>
          <a-form-item label="导卡途径" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch checkedChildren="自动" unCheckedChildren="手动" v-decorator="['isManual']" />
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
  creditCardPage,
  deleteCreditCard,
  updateCreditCard,
  addCreditCard,
  bankNameList
} from "api";
import {
  setContextData,
  getContextData,
  removeContextData
} from "../../../common/js/util";
const columns = [
  {
    title: "会员名",
    dataIndex: "userName"
  },
  {
    title: "UID",
    dataIndex: "uid"
  },
  {
    title: "手机号",
    dataIndex: "phone",
    scopedSlots: { customRender: "phone" }
  },

  {
    title: "银行归属",
    dataIndex: "bankName",
    scopedSlots: { customRender: "bankName" }
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
    centered: true,
    dataIndex: "action",
    scopedSlots: { customRender: "action" },
    width: "19%"
  }
];

export default {
  inject: ["reload"], //重载函数
  data() {
    return {
      reloadings: true,
      tableLoading: true,
      delmsg: null,
      data: null,
      bankData: [],
      modify: {
        visible: false,
        confirmLoading: true
      },
      status: {
        visible: false,
        confirmLoading: true
      },
      addservice: {
        //新增页面属性
        visible: false,
        confirmLoading: true
      },
      serviceaddform: this.$form.createForm(this), //新增form表单创建
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
        defaultCurrent: 1,
        defaultPageSize: 10,
        showTotal: total => `共 ${total} 条数据`,
        showSizeChanger: true,
        pageSizeOptions: ["5", "10", "15", "20"],
        showQuickJumper: true
      },
      queryParam: {},
      searchValue: {},
      key: this.$route.meta.key[0],
      searchform: this.$form.createForm(this),
      modifyform: this.$form.createForm(this),
      statusform: this.$form.createForm(this)
    };
  },
  created() {
    this._bankNameList();
    //缓存中获取当前页码（详情页回退时候当前主页的时候）
    this.pagination.current = getContextData("currentPage" + this.key) || 1;
    this.searchValue = getContextData("searchValue" + this.key) || {
      userName: null
    };
    this.queryParam = Object.assign({}, this.queryParam, this.searchValue);
    this.queryParam.pageNum = this.pagination.current;
    //
    this._creditCardPage();
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
      removeContextData("currentPage" + this.key);
      removeContextData("searchValue" + this.key);
      this.reload();
    },
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
      setContextData("currentPage" + this.key, this.pagination.current);
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
          that.tableLoading = false;
          that.reloadings = false;
        }
      });
    },
    _bankNameList() {
      //银行名获取
      bankNameList({}).then(res => {
        if (res.code) {
          this.bankData = res.data.list;
        }
      });
    },
    detailStatus(id, statusValue) {
      // 点击状态管理
      this.status.visible = true;
      this.statusId = id;
      this.statusValue = statusValue;
      this.statusform.resetFields();
    },

    statusSubmit(e) {
      // 状态管理
      let that = this;
      e.preventDefault();
      that.statusform.validateFields((err, values) => {
        if (values.cardStatus) {
          values.cardStatus = 0;
        } else {
          values.cardStatus = 1;
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
        if (values.isManual) {
          values.isManual = 1;
        } else {
          values.isManual = 0;
        }
        if (values.paystatus) {
          values.paystatus = 1;
        } else {
          values.paystatus = 0;
        }
        let formData = {};
        formData.cid = that.statusId;
        formData.cardStatus = values.cardStatus;
        formData.isDiagnosis = values.isDiagnosis;
        formData.isHide = values.isHide;
        formData.isProplan = values.isProplan;
        formData.isTurnover = values.isTurnover;
        formData.isManual = values.isManual;
        formData.paystatus = values.paystatus;
        if (!err) {
          updateCreditCard(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.status.visible = false;
              that.getTableList();
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
      this.modifyform.resetFields();
    },
    // 修改用户
    modifySubmit(e) {
      let that = this;
      e.preventDefault();
      that.modifyform.validateFields((err, values) => {
        values.cid = that.editId;
        let formData = {};
        formData.cid = values.cid;
        formData.availableQuota = values.availableQuota;
        formData.billDate = values.billDate;
        formData.cardName = values.cardName;
        formData.cardNumber = values.cardNumber;
        formData.quota = values.quota;
        formData.repayDate = values.repayDate;
        formData.userName = values.userName;
        if (!err) {
          updateCreditCard(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.modify.visible = false;
              that.editValue = {};
              that.getTableList();
            }
          });
        }
      });
    },
    modifyCancel() {
      this.modify.visible = false;
    },
  
    searchSubmit(e) {
      //重置搜索条件
      this.queryParam = {};
      removeContextData("currentPage" + this.key);
      removeContextData("searchValue" + this.key);
      this.pagination.current = 1;
      this.searchValue = {};
      //
      e.preventDefault();
      this.searchform.validateFields((err, values) => {
        const str = values.selKey;
        let target = {};
        target[str] = values.inValue;
        this.searchValue = target;
        setContextData("searchValue" + this.key, this.searchValue);
        this.queryParam = Object.assign({}, this.queryParam, target);
        this.getTableList();
      });
    },
    addModal() {
      //新增按钮
      this.addservice.visible = true;
    },
    addserviceSubmit(e) {
      // 新增提交按钮
      let that = this;
      e.preventDefault();
      that.serviceaddform.validateFields((err, values) => {
        console.log(values);
        if (values.cardStatus) {
          values.cardStatus = 0;
        } else {
          values.cardStatus = 1;
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
        if (values.isManual) {
          values.isManual = 1;
        } else {
          values.isManual = 0;
        }
        if (values.paystatus) {
          values.paystatus = 1;
        } else {
          values.paystatus = 0;
        }
        let formData = {};
        formData.availableQuota = values.availableQuota;
        formData.userId = values.userId;
        formData.bankId = values.bankId;
        formData.billDate = values.billDate;
        formData.cardName = values.cardName;
        formData.cardNumber = values.cardNumber;
        formData.quota = values.quota;
        formData.repayDate = values.repayDate;
        formData.userName = values.userName;
        formData.cardStatus = values.cardStatus;
        formData.isDiagnosis = values.isDiagnosis;
        formData.isHide = values.isHide;
        formData.isProplan = values.isProplan;
        formData.isTurnover = values.isTurnover;
        formData.isManual = values.isManual;
        formData.paystatus = values.paystatus;
        if (!err) {
          addCreditCard(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.addservice.visible = false;
              that._creditCardPage();
              that.serviceaddform.resetFields();
            }
          });
        }
      });
    },
    serviceCancel() {
      //新增页面撤销
      this.addservice.visible = false;
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
    },
    billInfo(id, record) {
      this.$router.push({
        name: "billinfo",
        params: {
          id: id,
          quota: record.quota,
          bankName: record.bankName,
          availableQuota: record.availableQuota,
          cardNumber: record.cardNumber
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