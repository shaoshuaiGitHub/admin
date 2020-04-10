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
            <span class="ant-page-header-heading-title">提额计划</span>
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
                  <a-select-option value="userName">用户名</a-select-option>
                  <a-select-option value="phone">电话号码</a-select-option>
                  <a-select-option value="realName">真实姓名</a-select-option>
                </a-select>
              </a-input>
            </a-form-item>
            <a-form-item label="银行">
              <a-input v-decorator="['bankName']"></a-input>
            </a-form-item>
            <a-form-item label="卡号">
              <a-input v-decorator="['cardNumber']"></a-input>
            </a-form-item>
            <a-form-item>
              <a-button type="primary" html-type="submit">搜索</a-button>
            </a-form-item>
          </a-form>
          <div>
            <a-button type="primary" style="margin-right:50px;" @click="createConsum">生成消费计划</a-button>
            <a-button type="primary" @click="createRepay">生成还款计划</a-button>
          </div>
        </div>
        <a-table
          :loading="tableLoading"
          :columns="columns"
          :dataSource="data"
          :pagination="pagination"
          :rowKey="record => record.cardId+record.months"
          @change="handleTableChange"
          :bordered="true"
        >
          <template slot="consumPlan" slot-scope="text,record">
            <span class="active" v-if="record.totalMinMoney != null">已生成</span>
            <span class="unactive" v-else>未生成</span>
          </template>
          <template slot="repayPlan" slot-scope="text,record">
            <span class="active" v-if="record.totalRepaymentMoney != null">已生成</span>
            <span class="unactive" v-else>未生成</span>
          </template>
          <template slot="vType" slot-scope="text">{{ filterType(text)}}</template>
          <template
            slot="totalMinMoney"
            slot-scope="text,record"
          >{{ text ? record.totalMinMoney+' - '+record.totalMaxMoney :null}}</template>
          <template slot="action" slot-scope="text, record">
            <a-button
              class="status-detail"
              style="margin-right:10px;"
              type="primary"
              @click="() => consum(record.cardId,record.months)"
            >消费计划</a-button>
            <a-button
              type="primary"
              class="status-detail"
              @click="() => repay(record.cardId,record.months)"
            >还款计划</a-button>
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
    dataIndex: "vType",
    scopedSlots: { customRender: "vType" }
  },
  {
    title: "信用卡卡号",
    dataIndex: "cardNum",
    scopedSlots: { customRender: "cardNum" }
  },
  {
    title: "归属银行",
    dataIndex: "bankName",
    scopedSlots: { customRender: "bankName" }
  },
  {
    title: "提额计划周期",
    dataIndex: "months",
    scopedSlots: { customRender: "months" }
  },
  {
    title: "计划消费金额",
    dataIndex: "totalMinMoney",
    scopedSlots: { customRender: "totalMinMoney" }
  },
  {
    title: "实际消费",
    dataIndex: "totalConsumSignMoney",
    scopedSlots: { customRender: "totalConsumSignMoney" }
  },
  {
    title: "计划还款",
    dataIndex: "totalRepaymentMoney",
    scopedSlots: { customRender: "totalRepaymentMoney" }
  },
  {
    title: "实际还款",
    dataIndex: "totalRepaymentSignMoney",
    scopedSlots: { customRender: "totalRepaymentSignMoney" }
  },
  {
    title: "消费计划",
    dataIndex: "consumPlan",
    scopedSlots: { customRender: "consumPlan" }
  },
  {
    title: "还款计划",
    dataIndex: "repayPlan",
    scopedSlots: { customRender: "repayPlan" }
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
      goodData: [],
      confirmDirty: false,
      columns,
      ModalText: "Content of the modal",
      visible: false,
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
      searchform: this.$form.createForm(this)
    };
  },
  created() {
    this._goodsInfo();
    this._creditProPlan();
  },
  methods: {
    _creditProPlan() {
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
      creditProPlan(that.queryParam).then(res => {
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
    consum(id, date) {
      //消费计划
      this.$router.push({
        name: "creditconsum",
        params: {
          id: id,
          date: date
        }
      });
    },
    repay(id, date) {
      //还款计划
      this.$router.push({
        name: "creditrepey",
        params: {
          id: id,
          date: date
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
      //搜索提交
      this.queryParam = this.firstParam;
      e.preventDefault();
      this.searchform.validateFields((err, values) => {
        const str = values.selKey;
        let target = {};
        if (values.inValue) {
          target[str] = values.inValue;
        }
        if (values.bankName) {
          target.bankName = values.bankName;
        }
        if (values.cardNumber) {
          target.cardNumber = values.cardNumber;
        }
        console.log(target);
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