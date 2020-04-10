<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>财务管理</a-breadcrumb-item>
            <a-breadcrumb-item>流水记录</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">流水记录</span>
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
          :style="{display:'flex',flexDirection:'row',justifyContent:'space-between'}"
        >
          <a-form layout="inline" :form="searchform" @submit="searchSubmit">
            <!-- 搜索框 -->
            <a-form-item>
              <a-input v-decorator="['inValue']">
                <a-select v-decorator="['selKey',{initialValue: 'userName'}]" slot="addonBefore">
                  <a-select-option value="userName">会员名称</a-select-option>
                  <a-select-option value="phone">手机号</a-select-option>
                  <a-select-option value="uid">会员UID</a-select-option>
                </a-select>
              </a-input>
            </a-form-item>
            <a-form-item label="类型">
              <a-select
                style="width:200px;"
                v-decorator="['changeType', {rules: [{ required: false, message: '请选择类型' }]}]"
              >
                <a-select-option value="1">转入</a-select-option>
                <a-select-option value="2">转出</a-select-option>
                <a-select-option value="null">全部</a-select-option>
              </a-select>
            </a-form-item>

            <a-row v-if="isCollapse">
              <a-col>
                <a-form-item label="消费类型">
                  <a-select
                    style="width:200px;"
                    v-decorator="['payType', {rules: [{ required: false, message: '请选择消费类型' }]}]"
                  >
                    <a-select-option value="0">信用点</a-select-option>
                    <a-select-option value="1">微信支付</a-select-option>
                    <a-select-option value="null">全部</a-select-option>
                  </a-select>
                </a-form-item>
              </a-col>
              <a-col>
                <a-form-item label="生成时间">
                  <a-date-picker
                    :disabledDate="disabledStartDate"
                    format="YYYY-MM-DD"
                    placeholder="开始日期"
                    @change="date => dateChangeStart(date)"
                    @openChange="handleStartOpenChange"
                    v-decorator="['startValue']"
                  />&nbsp;~
                  <a-form-item>
                    <a-date-picker
                      :disabledDate="disabledEndDate"
                      format="YYYY-MM-DD"
                      placeholder="结束日期"
                      @change="date => dateChangeEnd(date)"
                      :open="endOpen"
                      @openChange="handleEndOpenChange"
                      v-decorator="['endValue']"
                    />
                  </a-form-item>
                </a-form-item>
              </a-col>
            </a-row>
            <a-form-item>
              <a-button type="primary" html-type="submit">查询</a-button>
              <a-button :style="{marginLeft:'10px'}" @click="resetSearch">重置</a-button>
              <span style="margin-left:10px;cursor: pointer; color:#1899ff;" @click="openSearch">
                {{isCollapse ? '收起':'展开'}}
                <a-icon style="margin-left:3px;" :type="isCollapse ? 'up':'down'" />
              </span>
              <!-- <a-button type="primary" html-type="submit">搜索</a-button>
              <a-button :style="{marginLeft:'10px'}" @click="resetSearch">重置</a-button> -->
            </a-form-item>
          </a-form>
        </div>
        <div style="margin:20px 0;display:flex;flexDirection:row;justifyContent:flex-start">
          <a-button type="primary" icon="plus" @click="addModal">新增配置</a-button>
        </div>
        <a-table
          bordered
          :loading="tableLoading"
          :pagination="pagination"
          @change="handleTableChange"
          :showHeader="true"
          :dataSource="data"
          :columns="columns"
          :rowKey="record => record.recordId"
          :scroll="{x:900}"
        >
          <template slot="changeType" slot-scope="text">{{text == 1 ? '转入' : '转出'}}</template>
          <template slot="payType" slot-scope="text">{{text == 0 ? '信用点' : '微信支付'}}</template>
          <template slot="operation" slot-scope="text, record">
            <div class="editable-row-operations">
              <a
                style="margin-right:10px;"
                slot="action"
                @click="() => editor(record.recordId,record)"
              >编辑</a>
              <span>
                <a class="deletes" @click="() => deletes(record.recordId)">删除</a>
              </span>
            </div>
          </template>
        </a-table>
      </a-layout-content>
    </div>
    <a-modal
      centered
      title="修改流水记录配置"
      :visible="modify.visible"
      :confirmLoading="modify.confirmLoading"
      @cancel="modifyCancel"
      :footer="null"
    >
      <a-form :form="modifyform" @submit="modifySubmit">
        <a-form-item label="消费类型" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-select
            style="width:100px;"
            v-decorator="['payType',{initialValue: editValue.payType }]"
          >
            <a-select-option :value="0">信用点</a-select-option>
            <a-select-option :value="1">微信支付</a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item label="类型" :label-col="{ span: 5 }" :wrapper-col="{ span: 10 }">
          <a-select
            style="width:100px;"
            v-decorator="['changeType',{initialValue: editValue.changeType }]"
          >
            <a-select-option :value="1">转入</a-select-option>
            <a-select-option :value="2">转出</a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item label="变更数" :label-col="{ span: 5 }" :wrapper-col="{ span: 10 }">
          <a-input v-decorator="['change',{initialValue: editValue.change}]" />
        </a-form-item>
        <a-form-item label="余额" :label-col="{ span: 5 }" :wrapper-col="{ span: 10 }">
          <a-input v-decorator="['balance',{initialValue: editValue.balance}]" />
        </a-form-item>
        <a-form-item label="变更时间" :label-col="{ span: 5 }" :wrapper-col="{ span: 10 }">
          <a-date-picker
            showTime
            v-decorator="['changeTime',{initialValue:moment( editValue.changeTime, 'YYYY-MM-DD HH:mm:ss')}]"
            format="YYYY-MM-DD HH:mm:ss"
          />
        </a-form-item>
        <a-form-item label="说明" :label-col="{ span: 5 }" :wrapper-col="{ span: 16 }">
          <a-textarea
            placeholder="流水记录描述"
            :rows="4"
            v-decorator="['description',{initialValue: editValue.description}]"
          />
        </a-form-item>
        <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
          <a-button type="primary" html-type="submit">保存</a-button>
        </a-form-item>
      </a-form>
    </a-modal>
    <a-modal
      centered
      title="新增流水记录配置"
      :visible="addservice.visible"
      :confirmLoading="addservice.confirmLoading"
      @cancel="serviceCancel"
      :footer="null"
    >
      <a-form :form="serviceaddform" @submit="addserviceSubmit">
        <a-form-item label="消费类型" :label-col="{ span: 5 }" :wrapper-col="{ span: 10 }">
          <a-select
            style="width:100px;"
            v-decorator="['payType',{rules:[{required: true, message: '请选择消费类型'}]}]"
          >
            <a-select-option :value="0">信用点</a-select-option>
            <a-select-option :value="1">微信支付</a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item label="类型" :label-col="{ span: 5 }" :wrapper-col="{ span: 10 }">
          <a-select
            style="width:100px;"
            v-decorator="['changeType',{rules:[{required: true, message: '请选择写类型'}]}]"
          >
            <a-select-option :value="1">转入</a-select-option>
            <a-select-option :value="2">转出</a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item label="会员ID" :label-col="{ span: 5 }" :wrapper-col="{ span: 10 }">
          <a-input v-decorator="['userId',{rules:[{required: true, message: '请填写会员ID'}]}]" />
        </a-form-item>
        <a-form-item label="变更数" :label-col="{ span: 5 }" :wrapper-col="{ span: 10 }">
          <a-input v-decorator="['change',{rules:[{required: true, message: '请填写变更数'}]}]" />
        </a-form-item>
        <a-form-item label="余额" :label-col="{ span: 5 }" :wrapper-col="{ span: 10 }">
          <a-input v-decorator="['balance']" />
        </a-form-item>
        <a-form-item label="变更时间" :label-col="{ span: 5 }" :wrapper-col="{ span: 10 }">
          <a-date-picker showTime v-decorator="['changeTime']" format="YYYY-MM-DD HH:mm:ss" />
        </a-form-item>
        <a-form-item label="说明" :label-col="{ span: 5 }" :wrapper-col="{ span: 16 }">
          <a-textarea
            placeholder="流水记录说明"
            :rows="4"
            v-decorator="['description',{rules:[{required: true, message: '请填写说明'}]}]"
          />
        </a-form-item>
        <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
          <a-button type="primary" html-type="submit">保存</a-button>
        </a-form-item>
      </a-form>
    </a-modal>
  </div>
</template>
<script>
import {
  transactionRecordPage,
  transactionRecordById,
  deleteTransactionRecord,
  updateTransactionRecord,
  addTransactionRecord
} from "api";
import moment from "moment";
import { match } from "minimatch";

const columns = [
  {
    title: "会员名称",
    // width: "18%",
    dataIndex: "userName",
    scopedSlots: { customRender: "userName" }
  },
  {
    title: "会员ID",
    // width: "18%",
    dataIndex: "userId",
    scopedSlots: { customRender: "userId" }
  },
  {
    title: "手机号",
    // width: "18%",
    dataIndex: "phone",
    scopedSlots: { customRender: "phone" }
  },
  {
    title: "类型",
    // width: "18%",
    dataIndex: "changeType",
    scopedSlots: { customRender: "changeType" }
  },
  {
    title: "消费类型",
    // width: "18%",
    dataIndex: "payType",
    scopedSlots: { customRender: "payType" }
  },
  {
    title: "变更数",
    // width: "18%",
    dataIndex: "change",
    scopedSlots: { customRender: "change" }
  },
  {
    title: "余额",
    // width: "18%",
    dataIndex: "balance",
    scopedSlots: { customRender: "balance" }
  },
  {
    title: "变更时间",
    // width: "18%",
    dataIndex: "changeTime",
    scopedSlots: { customRender: "changeTime" },
    sorter: (a, b) =>
      moment(a.changeTime).format("YYYY-MM-DD HH:mm:ss") >
      moment(b.changeTime).format("YYYY-MM-DD HH:mm:ss")
  },
  {
    title: "说明",
    // width: "18%",
    dataIndex: "description",
    scopedSlots: { customRender: "description" }
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
      isCollapse: false,
      data: [],
      cacheData: [],
      columns,
      delmsg: null,
      visible: false,
      confirmLoading: false,
      tableLoading: true,
      modify: {
        visible: false,
        confirmLoading: true
      },
      addservice: {
        visible: false,
        confirmLoading: true
      },
      editValue: {},
      startValue: null,
      endValue: null,
      endOpen: false,
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
      modifyform: this.$form.createForm(this),
      serviceaddform: this.$form.createForm(this),
      searchform: this.$form.createForm(this)
    };
  },
  created() {
    this._transactionRecordPage();
  },
  methods: {
    moment,
    _transactionRecordPage() {
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
      transactionRecordPage(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    // 时间范围模块
    dateChangeStart(value) {
      this.startValue = value;
    },
    dateChangeEnd(value) {
      this.endValue = value;
    },
    disabledStartDate(startValue) {
      const endValue = this.endValue;
      if (!startValue || !endValue) {
        return false;
      }
      return startValue.valueOf() > endValue.valueOf();
    },
    disabledEndDate(endValue) {
      const startValue = this.startValue;
      if (!endValue || !startValue) {
        return false;
      }
      return startValue.valueOf() >= endValue.valueOf();
    },
    handleStartOpenChange(open) {
      if (!open) {
        this.endOpen = true;
      }
    },
    handleEndOpenChange(open) {
      this.endOpen = open;
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
        let formData = {};
        values.changeTime = moment(values.changeTime).format(
          "YYYY-MM-DD HH:mm:ss"
        );
        if (values.userId) {
          formData.userId = values.userId;
        }
        if (values.payType || values.payType == 0) {
          formData.payType = values.payType;
        }
        if (values.changeType) {
          formData.changeType = values.changeType;
        }
        if (values.change) {
          formData.change = values.change;
        }
        if (values.balance) {
          formData.balance = values.balance;
        }
        if (values.changeTime) {
          formData.changeTime = values.changeTime;
        }
        if (values.description) {
          formData.description = values.description;
        }
        console.log(formData);
        if (!err) {
          addTransactionRecord(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that._transactionRecordPage();
              that.addservice.visible = false;
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
        let formData = {};
        formData.paramsId = that.editId;
        values.changeTime = moment(values.changeTime).format(
          "YYYY-MM-DD HH:mm:ss"
        );
        if (values.payType || values.payType == 0) {
          formData.payType = values.payType;
        }
        if (values.changeType) {
          formData.changeType = values.changeType;
        }
        if (values.change) {
          formData.change = values.change;
        }
        if (values.balance) {
          formData.balance = values.balance;
        }
        if (values.changeTime) {
          formData.changeTime = values.changeTime;
        }
        if (values.description) {
          formData.description = values.description;
        }
        if (!err) {
          updateTransactionRecord(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that._transactionRecordPage();
              that.modify.visible = false;
            }
          });
        }
      });
    },
    modifyCancel() {
      this.modify.visible = false;
    },
    //重置搜索
    resetSearch() {
      this.searchform.resetFields();
      this._transactionRecordPage();
    },
    // 搜索框展开
    openSearch() {
      this.isCollapse = !this.isCollapse;
    },
    searchSubmit(e) {
      //搜索
      this.queryParam = this.firstParam;
      e.preventDefault();
      this.searchform.validateFields((err, values) => {
        let target = {};
        if (values.startValue) {
          values.startTime = values.startValue
            .format("YYYY-MM-DD")
            .concat(" 00:00:00");
        }
        if (values.endValue) {
          values.endTime = values.endValue
            .format("YYYY-MM-DD")
            .concat(" 23:59:59");
        }
        target.endTime = values.endTime;
        target.startTime = values.startTime;
        if (values.inValue != null) {
          const str = values.selKey;
          target[str] = values.inValue;
        }
        if (values.changeType == "null") {
          values.changeType == null;
        }
        target.changeType = values.changeType;
        if (values.payType == "null") {
          values.payType == null;
        }
        target.payType = values.payType;
        this.queryParam = Object.assign({}, this.queryParam, target);
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
      deleteTransactionRecord({ paramsId: this.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          that.tableLoading = true;
          setTimeout(() => {
            that.visible = false;
            that.confirmLoading = false;
            that._transactionRecordPage();
          }, 200);
        }
      });
    },

    back() {
      this.$router.back();
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