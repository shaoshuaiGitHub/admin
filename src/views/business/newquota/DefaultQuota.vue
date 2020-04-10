<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-gdfId-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>功能业务配置</a-breadcrumb-item>
            <a-breadcrumb-item>提额规则配置</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">{{'全局默认提额计划'}}</span>
          </div>
        </div>
      </div>
    </div>
    <div class="wrap-children-content">
      <template>
        <a-tabs defaultActiveKey="1" type="card">
          <a-tab-pane key="1">
            <span slot="tab">
              <a-icon type="ant-design" />默认消费计划
            </span>
            <a-layout-content
              :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }"
            >
              <div
                class="headButton"
                :style="{display:'flex',flexDirection:'row',justifyContent:'space-between',marginTop:'15px'}"
              >
                <a-button type="primary" icon="left" @click="back">返回</a-button>
                <div class="pages-list-table-list">
                  <a-button
                    type="primary"
                    icon="edit"
                    style="margin-right:50px"
                    @click="saveall"
                  >保存修改</a-button>
                </div>
              </div>
              <a-table
                :loading="tableLoading"
                :pagination="pagination"
                :showHeader="true"
                :dataSource="data"
                :columns="columns"
                :rowKey="record => record.dfId"
                @change="handleTableChange"
                :scroll="{x:700}"
              >
                <template slot="quotaPer" slot-scope="text, record">
                  <a-input-number
                    style="width:60px"
                    :defaultValue="text"
                    class="sort-input"
                    @change="value => changeInput(value, record.dfId,'quotaPer')"
                  />
                </template>
                <template
                  :slot="col"
                  v-for="col in ['beginTime','endTime']"
                  slot-scope="text,record"
                >
                  <div :key="col">
                    <a-time-picker
                      :defaultValue="moment( sliceTime(text), 'HH:mm')"
                      format="HH:mm"
                      @change="(time,timeString) => changeInput(timeString, record.dfId,col)"
                    />
                  </div>
                </template>
              </a-table>
            </a-layout-content>
          </a-tab-pane>
          <a-tab-pane key="2">
            <span slot="tab">
              <a-icon type="slack" />默认还款计划
            </span>
            <repay-view></repay-view>
          </a-tab-pane>
        </a-tabs>
      </template>
    </div>
  </div>
</template>
<script>
import { consumDefault, updateRuleDefault } from "api";
import DefaultRepay from "../newquota/DefaultRepay.vue";
import moment from "moment";
const columns = [
    {
    title: "更新时间",
    // width: "18%",
    dataIndex: "updateTime",
    scopedSlots: { customRender: "updateTime" }
  },
  {
    title: "账单日后X天",
    // width: "18%",
    dataIndex: "dateAfter",
    scopedSlots: { customRender: "dateAfter" }
  },
  {
    title: "最低消费百分比（Y%）",
    // width: "18%",
    dataIndex: "quotaPer",
    scopedSlots: { customRender: "quotaPer" }
  },
  {
    title: "消费时间起始（时/分）",
    // width: "18%",
    dataIndex: "beginTime",
    scopedSlots: { customRender: "beginTime" }
  },
  {
    title: "消费时间终止（时/分）",
    // width: "18%",
    dataIndex: "endTime",
    scopedSlots: { customRender: "endTime" }
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
      pagination: {
        total: 0,
        defaultCurrent: 1,
        defaultPageSize: 10,
        showTotal: total => `共 ${total} 条数据`,
        showSizeChanger: true,
        pageSizeOptions: ["5", "10", "15", "20"],
        showQuickJumper: true
      },
      queryParam: {
        pageNum: 0, //第几页
        pageSize: 10 //每页中显示数据的条数
      }
    };
  },
  components: {
    "repay-view": DefaultRepay
  },
  created() {
    this._consumDefault();
  },

  methods: {
    moment,
    sliceTime(time) {
      //时间字符串截取
      if (time) {
        return (time = time.substring(11, 16));
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
      consumDefault(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    _consumDefault() {
      //获取会员商品列表
      this.getTableList();
    },
    changeInput(value, id, column) {
      //监听值变化
      const newData = [...this.data];
      const target = newData.filter(item => id === item.dfId)[0];
      if (target) {
        target[column] = value;
        target.editable = true;
        this.data = newData;
      }
    },
    saveall() {
      //保存修改
      const target = this.data.filter(item => true === item.editable);
      for (var i = 0; i < target.length; i++) {
        const formData = new FormData();
        formData.append("dfId", target[i].dfId);
        formData.append("quotaPer", target[i].quotaPer);
        if (target[i].beginTime.length > 5) {
          target[i].beginTime = this.sliceTime(target[i].beginTime);
        }
        if (target[i].endTime.length > 5) {
          target[i].endTime = this.sliceTime(target[i].endTime);
        }
        formData.append("beginTime", target[i].beginTime);
        formData.append("endTime", target[i].endTime);
        updateRuleDefault(formData).then(res => {
          if (res.code) {
            this.$message.success(res.msg);
          }
        });
        delete target[i].editable;
      }
    },
    back() {
      this.$router.back();
    }
  }
};
</script>
<style scoped>
.sort-input {
  color: #1890ff;
  border: none;
  border-bottom: 1px solid white !important;
  box-shadow: none;
  padding: 0 0 0 5px;
}
.delete {
  color: #f5222d;
}
</style>