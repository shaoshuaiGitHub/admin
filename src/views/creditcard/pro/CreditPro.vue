<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>信用卡管理</a-breadcrumb-item>
            <a-breadcrumb-item>提额计划</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">提额计划列表</span>
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
                  <a-select-option value="userName">用户名</a-select-option>
                  <a-select-option value="phone">电话号码</a-select-option>
                  <a-select-option value="realName">真实姓名</a-select-option>
                </a-select>
              </a-input>
            </a-form-item>
            <a-form-item label="银行">
              <a-input v-decorator="['bankName',{initialValue: searchValueT.bankName || null}]"></a-input>
            </a-form-item>
            <a-form-item label="卡号">
              <a-input v-decorator="['cardNumber',{initialValue: searchValueT.cardNumber || null}]"></a-input>
            </a-form-item>
            <a-form-item>
              <a-button type="primary" html-type="submit">搜索</a-button>
              <a-button :style="{marginLeft:'10px'}" @click="reloadFun">重置</a-button>
            </a-form-item>
          </a-form>
        </div>
        <div style="margin:20px 0;display:flex;flexDirection:row;justifyContent:flex-start">
          <a-button type="primary" style="margin-right:50px;" @click="createConsum">生成消费计划</a-button>
          <a-button type="primary" @click="createRepay">生成还款计划</a-button>
        </div>
        <a-table
          :loading="tableLoading"
          :columns="columns"
          :dataSource="data"
          :pagination="pagination"
          :rowKey="record => record.cardId"
          @change="handleTableChange"
          :bordered="true"
          :scroll="{x:800}"
        >
          <template slot="bankIcon" slot-scope="text">
            <img class="bankIcon" :src="text" alt="xxxx" />
          </template>
          <template slot="consumPlan" slot-scope="text">
            <span class="active" v-if="text > 0">已生成</span>
            <span class="unactive" v-else>未生成</span>
          </template>
          <template slot="repayPlan" slot-scope="text">
            <span class="active" v-if="text > 0">已生成</span>
            <span class="unactive" v-else>未生成</span>
          </template>
          <template slot="vType" slot-scope="text">{{ filterType(text)}}</template>
          <template slot="billDate" slot-scope="text">每月{{text}}日</template>
          <template slot="action" slot-scope="text, record">
            <a-button
              class="status-detail"
              style="margin:0 10px 10px 0;"
              type="primary"
              @click="() => current(record.cardId,record.billDate,record.cardNumber,0)"
            >本期提额计划</a-button>
            <a-button
              type="primary"
              class="status-detail"
              @click="() => history(record.cardId,record.billDate,record.cardNumber,1)"
            >历史提额计划</a-button>
          </template>
        </a-table>
      </a-layout-content>
    </div>
  </div>
</template>
<script>
import {
  creditProPlan,
  produceConsumPlan,
  produceRepaymentPlan,
  goodsInfo
} from "api";
import {
  setContextData,
  getContextData,
  removeContextData
} from "../../../common/js/util";
const columns = [
  {
    title: "用户名称",
    dataIndex: "userName"
  },
  {
    title: "电话号码",
    dataIndex: "phone"
  },
  {
    title: "会员类型",
    dataIndex: "vtype",
    scopedSlots: { customRender: "vType" }
  },
  {
    title: "信用卡卡号",
    dataIndex: "cardNumber",
    scopedSlots: { customRender: "cardNum" }
  },
  {
    title: "归属银行",
    dataIndex: "bankName",
    scopedSlots: { customRender: "bankName" }
  },
  {
    title: "银行图标",
    dataIndex: "bankIcon",
    scopedSlots: { customRender: "bankIcon" }
  },
  {
    title: "账单日",
    dataIndex: "billDate",
    scopedSlots: { customRender: "billDate" }
  },
  {
    title: "消费计划",
    dataIndex: "countCurrentConsumePlan",
    scopedSlots: { customRender: "consumPlan" }
  },
  {
    title: "还款计划",
    dataIndex: "countCurrentRepaymentPlan",
    scopedSlots: { customRender: "repayPlan" }
  },
  {
    title: "操作",
    dataIndex: "action",
    scopedSlots: { customRender: "action" }
  }
];

export default {
  inject: ["reload"], //重载函数
  data() {
    return {
      reloadings: true,
      tableLoading: true,
      data: [],
      goodData: [],
      confirmDirty: false,
      columns,
      ModalText: "Content of the modal",
      visible: false,
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
      searchValueT: {},
      key: this.$route.meta.key[0],
      searchform: this.$form.createForm(this)
    };
  },
  created() {
    this._goodsInfo();
    //缓存中获取当前页码（详情页回退时候当前主页的时候）
    this.pagination.current = getContextData("currentPage" + this.key) || 1;
    this.searchValue = getContextData("searchValue" + this.key) || {
      userName: null
    };
    this.searchValueT = getContextData("searchValueT" + this.key) || {};
    this.queryParam = Object.assign({}, this.queryParam, this.searchValue);
    this.queryParam = Object.assign({}, this.queryParam, this.searchValueT);
    this.queryParam.pageNum = this.pagination.current;
    this._creditProPlan();
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
      removeContextData("searchValueT" + this.key);
      this.reload();
    },
    _creditProPlan() {
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
      creditProPlan(that.queryParam).then(res => {
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
    _goodsInfo() {
      //获取会员列表
      goodsInfo({}).then(res => {
        if (res.code) {
          this.goodData = res.data.list;
        }
      });
    },
    filterType(text) {
      //展示会员类型
      if (text) {
        const target = this.goodData.filter(item => text == item.goodsId)[0];
        return target.goodsName;
      }
    },
    current(id, date, cardNumber, col) {
      //当月
      this.$router.push({
        name: "creditHorC",
        params: {
          id: id,
          billDate: date,
          cardNumber: cardNumber,
          col: col
        }
      });
    },
    history(id, date, cardNumber, col) {
      //历史
      this.$router.push({
        name: "creditHorC",
        params: {
          id: id,
          billDate: date,
          cardNumber: cardNumber,
          col: col
        }
      });
    },
    //生成消费计划
    createConsum() {
      let that = this;
      that.$modal.confirm({
        centered: true,
        title: "消费计划生成确认",
        content: "确定要生成消费计划，之前如果已生成的会被覆盖？",
        cancelText: "取消",
        okText: "确定",
        onOk() {
          produceConsumPlan().then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.getTableList();
            }
          });
        },
        onCancel() {}
      });
    },
    //生成还款计划
    createRepay() {
      let that = this;
      that.$modal.confirm({
        centered: true,
        title: "还款计划生成确认",
        content: "确定要生成还款计划，之前如果已生成的会被覆盖？",
        cancelText: "取消",
        okText: "确定",
        onOk() {
          produceRepaymentPlan().then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.getTableList();
            }
          });
        },
        onCancel() {}
      });
    },

    searchSubmit(e) {
      //重置搜索条件
      this.queryParam = {};
      removeContextData("currentPage" + this.key);
      removeContextData("searchValue" + this.key);
      removeContextData("searchValueT" + this.key);
      this.pagination.current = 1;
      this.searchValue = {};
      this.searchValueT = {};
      //搜索提交
      e.preventDefault();
      this.searchform.validateFields((err, values) => {
        const str = values.selKey;
        let target = {};
        target[str] = values.inValue;
        this.searchValue[str] = values.inValue;
        if (values.bankName) {
          target.bankName = values.bankName;
          this.searchValueT.bankName = values.bankName;
        }
        if (values.cardNumber) {
          target.cardNumber = values.cardNumber;
          this.cardNumber.bankName = values.cardNumber;
        }
        setContextData("searchValue" + this.key, this.searchValue);
        setContextData("searchValueT" + this.key, this.searchValueT);
        this.queryParam = Object.assign({}, this.queryParam, target);
        this.getTableList();
      });
    }
  }
};
</script>
<style scoped>
.status-detail {
  padding: 5px;
}
.bankIcon {
  width: 60px;
  height: 60px;
}
.unactive {
  background-color: #faad14;
  border-radius: 5px;
  padding: 5px;

  /* color: #faad14; */
}
.active {
  background-color: #52c41a;
  border-radius: 5px;
  padding: 5px;
}
</style>