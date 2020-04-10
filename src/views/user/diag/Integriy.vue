<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>会员管理</a-breadcrumb-item>
            <a-breadcrumb-item>诚信分诊断记录</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">诚信分诊断记录</span>
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
                  <a-select-option value="userName">会员名称</a-select-option>
                  <a-select-option value="phone">手机号</a-select-option>
                  <a-select-option value="realName">真实姓名</a-select-option>
                </a-select>
              </a-input>
            </a-form-item>
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
            <a-form-item>
               <a-button type="primary" html-type="submit">查询</a-button>
              <a-button :style="{marginLeft:'10px'}" @click="resetSearch">重置</a-button>
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
          :rowKey="record => record.hId"
          @change="handleTableChange"
          :scroll="{x:600}"
        >
          <template slot="headPic" slot-scope="text">
            <img class="headPic" :src="text" alt="xxx" @click="() => imgClick(text)" />
          </template>
          <template slot="vType" slot-scope="text">{{orderStatu(text)}}</template>
        </a-table>
      </a-layout-content>
      <a-modal :visible="imgVisible" :footer="null" @cancel="cancelImg">
        <img alt="example" style="width: 100%" :src="showImage" />
      </a-modal>
    </div>
  </div>
</template>
<script>
import { creditNumPage, goodsInfo } from "api";
import { match } from "minimatch";

const columns = [
  {
    title: "用户头像",
    dataIndex: "headPic",
    scopedSlots: { customRender: "headPic" }
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
    title: "诊断时间",
    dataIndex: "createTime"
  },
  {
    title: "分数",
    dataIndex: "creditNum"
  }
];

export default {
  data() {
    return {
      data: [],
      goodData: [],
      columns,
      delmsg: null,
      visible: false,
      confirmLoading: false,
      tableLoading: true,
      startValue: null,
      endValue: null,
      endOpen: false,
      imgVisible: false, //以上传图片的放大页面key外
      showImage: "", //放大图片rul外
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
      },
      totalOrder: null,
      totalMoney: null,
      totalPaymentMoney: null,
      totalPaymentOrder: null,
      totalNonPaymentOrder: null,
      totalCancelOrder: null
    };
  },
  created() {
    this.queryParam = this.firstParam;
    this._goodsInfo();
    this._creditNumPage();
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
    //判断会员类型
    orderStatu(text) {
      if (text) {
        return this.goodData.filter(item => text == item.goodsId)[0].goodsName;
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
      creditNumPage(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        that.totalOrder = res.data.totalOrder;
        that.totalMoney = res.data.totalMoney;
        that.totalPaymentMoney = res.data.totalPaymentMoney;
        that.totalPaymentOrder = res.data.totalPaymentOrder;
        that.totalNonPaymentOrder = res.data.totalNonPaymentOrder;
        that.totalCancelOrder = res.data.totalCancelOrder;
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    _creditNumPage() {
      //获取得分数据
      this.getTableList();
    },
    cancelImg() {
      //取消放大图片外
      this.imgVisible = false;
    },
    imgClick(text) {
      //点击图片放大外
      this.imgVisible = true;
      this.showImage = text;
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
     //重置搜索
    resetSearch() {
      this.searchform.resetFields();
      this._findAddServicePage();
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
.headPic {
  width: 50px;
  height: 50px;
  cursor: pointer;
}
</style>

