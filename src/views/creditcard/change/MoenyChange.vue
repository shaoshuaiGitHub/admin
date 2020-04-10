<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>信用卡管理</a-breadcrumb-item>
            <a-breadcrumb-item>信用卡额度变动记录</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">信用卡额度变动记录</span>
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
              <a-input v-decorator="['inValue']">
                <a-select v-decorator="['selKey',{initialValue: 'userName'}]" slot="addonBefore">
                  <a-select-option value="userName">用户名称</a-select-option>
                  <a-select-option value="phone">手机号</a-select-option>
                  <a-select-option value="realName">真实姓名</a-select-option>
                </a-select>
              </a-input>
            </a-form-item>
            <a-form-item label="银行">
              <a-input v-decorator="['bankName']"></a-input>
            </a-form-item>
            <a-row v-if="isCollapse">
              <a-form-item label="卡号">
                <a-input v-decorator="['cardNumber']"></a-input>
              </a-form-item>
              <a-form-item label="更新时间">
                <a-date-picker
                  v-decorator="['date',{rules: [{ required: false, message: '请输入更新时间' }]}]"
                />
              </a-form-item>
            </a-row>
            <a-form-item>
              <a-button type="primary" html-type="submit">查询</a-button>
              <a-button :style="{marginLeft:'10px'}" @click="resetSearch">重置</a-button>
              <span style="margin-left:10px;cursor: pointer; color:#1899ff;" @click="openSearch">
                {{isCollapse ? '收起':'展开'}}
                <a-icon style="margin-left:3px;" :type="isCollapse ? 'up':'down'" />
              </span>
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
          <template slot="vType" slot-scope="text">{{orderStatu(text)}}</template>
          <template slot="bankId" slot-scope="text">{{bankType(text)}}</template>
          <template slot="oldQuota" slot-scope="text,record">{{text+' -> '+record.newQuota}}</template>
        </a-table>
      </a-layout-content>
    </div>
  </div>
</template>
<script>
import { quotaHistory, goodsInfo, bankNameList } from "api";
import { match } from "minimatch";

const columns = [
  {
    title: "用户ID",
    dataIndex: "uid"
  },
  {
    title: "用户名称",
    dataIndex: "userName"
  },
  {
    title: "手机号",
    dataIndex: "phone"
  },
  {
    title: "会员类型",
    dataIndex: "vType",
    scopedSlots: { customRender: "vType" }
  },
  {
    title: "真实姓名",
    dataIndex: "realName"
  },
  {
    title: "归属银行",
    dataIndex: "bankId",
    scopedSlots: { customRender: "bankId" }
  },
  {
    title: "信用卡卡号",
    dataIndex: "cardNumber"
  },
  {
    title: "额度变动时间",
    dataIndex: "updateTime"
  },
  {
    title: "额度",
    dataIndex: "oldQuota",
    scopedSlots: { customRender: "oldQuota" }
  }
];

export default {
  data() {
    return {
      isCollapse: false,
      data: [],
      goodData: [],
      bankData: [],
      columns,
      delmsg: null,
      visible: false,
      confirmLoading: false,
      tableLoading: true,
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
      searchform: this.$form.createForm(this),
      queryParam: {},
      firstParam: {
        pageNum: 0, //第几页
        pageSize: 10 //每页中显示数据的条数
      }
    };
  },
  created() {
    this.queryParam = this.firstParam;
    this._bankNameList();
    this._goodsInfo();
    this._quotaHistory();
  },
  methods: {
    //会员类型数
    _goodsInfo() {
      goodsInfo({}).then(res => {
        if (res.code) {
          this.goodData = res.data.list;
        }
      });
    },
    //银行归属
    _bankNameList() {
      bankNameList({}).then(res => {
        if (res.code) {
          this.bankData = res.data.list;
        }
      });
    },
    //判断会员类型
    orderStatu(text) {
      if (text) {
        return this.goodData.filter(item => text == item.goodsId)[0].goodsName;
      }
    },
    //判断银行类型
    bankType(text) {
      if (text) {
        return this.bankData.filter(item => text == item.bankId)[0].bankName;
      }
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
      quotaHistory(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    _quotaHistory() {
      //获取得分数据
      this.getTableList();
    },
    //重置搜索
    resetSearch() {
      this.searchform.resetFields();
      this._quotaHistory();
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
        if (values.date) {
          target.updateTime = values.date
            .format("YYYY-MM-DD")
            .concat(" 00:00:00");
        }
        target.cardNumber = values.cardNumber;
        target.bankName = values.bankName;
        target.endTime = values.endTime;
        target.startTime = values.startTime;
        if (values.inValue != null) {
          const str = values.selKey;
          target[str] = values.inValue;
        }
        this.queryParam = Object.assign({}, this.queryParam, target);
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
.tongji {
  margin: 20px 0;
  padding: 20px;
  border: 0.5px dotted #faad14;
  border-radius: 5px;
}
.tongji-box {
  display: inline;
  font-size: 16px;
  margin: 0 20px;
  padding: 10px;
  border: 0.5px solid rgba(0, 0, 0, 0.25);
  border-radius: 5px;
}

.mean-number {
  color: #f5222d;
}
</style>

