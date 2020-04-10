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
                  <a-select-option value="userName">用户名</a-select-option>
                  <a-select-option value="phone">电话号码</a-select-option>
                  <a-select-option value="realName">真实姓名</a-select-option>
                </a-select>
              </a-input>
            </a-form-item>
            <a-form-item>
              <a-button type="primary" html-type="submit">搜索</a-button>
              <a-button :style="{marginLeft:'10px'}" @click="reloadFun">重置</a-button>
            </a-form-item>
          </a-form>
        </div>
        <a-table
          :loading="tableLoading"
          :columns="columns"
          :dataSource="data"
          :pagination="pagination"
          :rowKey="record => record.user.uid"
          @change="handleTableChange"
          :bordered="true"
          :scroll="{x:800}"
        >
          <template slot="vType" slot-scope="text">{{filterType(text)}}</template>
          <template slot="longSurplus" slot-scope="text">{{Number(text).toFixed(2)}}</template>
          <template slot="action" slot-scope="text, record">
            <a-button
              type="primary"
              class="status-detail"
              @click="() => detail(record.user.uid,record.user.phone)"
            >周转详情</a-button>
          </template>
        </a-table>
      </a-layout-content>
    </div>
  </div>
</template>
<script>
import { creditTurnoverPage, goodsInfo } from "api";
import {
  setContextData,
  getContextData,
  removeContextData
} from "../../../common/js/util";
const columns = [
  {
    title: "用户名称",
    dataIndex: "user.userName"
  },
  {
    title: "会员类型",
    dataIndex: "user.vType",
    scopedSlots: { customRender: "vType" }
  },
  {
    title: "手机号",
    dataIndex: "user.phone",
    scopedSlots: { customRender: "phone" }
  },
  {
    title: "真实姓名",
    dataIndex: "user.realName",
    scopedSlots: { customRender: "realName" }
  },
  {
    title: "卡片数（张）",
    dataIndex: "planData.totalInfo.cardNumber",
    scopedSlots: { customRender: "cardNumber" }
  },
  {
    title: "总额度（元）",
    dataIndex: "planData.totalInfo.totalQuota",
    scopedSlots: { customRender: "totalQuota" }
  },
  {
    title: "总可用额度（元）",
    dataIndex: "planData.totalInfo.totalAvailable",
    scopedSlots: { customRender: "totalAvailable" }
  },
  {
    title: "长期可用剩余（元）",
    dataIndex: "planData.totalInfo.longSurplus",
    scopedSlots: { customRender: "longSurplus" }
  },
  {
    title: "需预留周转（元）",
    dataIndex: "planData.totalInfo.turnoverMoney",
    scopedSlots: { customRender: "turnoverMoney" }
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
    this.queryParam = Object.assign({}, this.queryParam, this.searchValue);
    this.queryParam.pageNum = this.pagination.current;
    this._creditTurnoverPage();
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
    _creditTurnoverPage() {
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
      creditTurnoverPage(that.queryParam).then(res => {
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
    detail(id, phone) {
      //周转详情
      this.$router.push({
        name: "turndetail",
        params: {
          id: id,
          phone: phone
        }
      });
    },
    searchSubmit(e) {
      //重置搜索条件
      this.queryParam = {};
      removeContextData("currentPage" + this.key);
      removeContextData("searchValue" + this.key);
      this.pagination.current = 1;
      this.searchValue = {};
      //搜索提交
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
    }
  }
};
</script>
<style scoped>
.status-detail {
  padding: 5px;
}
</style>