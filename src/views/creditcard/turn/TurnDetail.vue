<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>信用卡管理</a-breadcrumb-item>
            <a-breadcrumb-item>周转计划</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">周转详情</span>
          </div>
        </div>
      </div>
    </div>
    <div class="wrap-children-content">
      <a-layout-content
        :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }"
      >
        <!-- 顶部数据 -->
        <a-button type="primary" icon="left" @click="back">返回</a-button>
        <div class="tongji">
          <a-icon type="exclamation-circle" style="color:#1899ff;font-size:15px;" theme="filled" />
          <span class="tongji-box">
            卡数:
            <span class="mean-number">{{planInfo.totalInfo ? planInfo.totalInfo.cardNumber : 0}}</span>(张)
          </span>
          <span class="tongji-box">
            总额度:
            <span
              class="mean-number"
            >{{planInfo.totalInfo ? planInfo.totalInfo.totalQuota : ''}}</span>(元)
          </span>
          <span class="tongji-box">
            总可用额度:
            <span
              class="mean-number"
            >{{planInfo.totalInfo? planInfo.totalInfo.totalQuota : ''}}</span>(元)
          </span>
          <span class="tongji-box">
            长期可用剩余:
            <span
              class="mean-number"
            >{{planInfo.totalInfo ? planInfo.totalInfo.totalQuota : ''}}</span>(元)
          </span>

          <span class="tongji-box">
            需预留周转:
            <span
              class="mean-number"
            >{{planInfo.totalInfo ? planInfo.totalInfo.totalQuota : ''}}</span>(元)
          </span>
        </div>
        <!-- 主表格部分 -->
        <a-table
          :loading="tableLoading"
          :columns="columns"
          :dataSource="data"
          :pagination="pagination"
          :rowKey="record => record.card.cid"
          @change="handleTableChange"
          :bordered="true"
          :scroll="{x:700}"
        >
          <template
            slot="cardNumber"
            slot-scope="text,record"
          >{{record.card.tbank.bankName+'（'+text.substring(text.length-4,text.length)+'）'}}</template>
          <template slot="billDateStr" slot-scope="text">{{'每月'+text+'日'}}</template>
          <template slot="repayDate" slot-scope="text">{{'每月'+text+'日'}}</template>
          <template slot="paystatus" slot-scope="text">
            <template v-if="text == 1">
              <span class="active">已还清</span>
            </template>
            <template v-else>
              <span class="uncative">未还清</span>
            </template>
          </template>
          <template slot="plans" slot-scope="text,record">
            <a
              class="col-sql"
              @click="() => turnMsg(record.card.cid,record)"
            >{{text.length>0 ? '周转信息': '暂无周转信息'}}</a>
          </template>
          <template slot="footer">
            <span class="biaoji">周转提示：</span>
            <template v-for="(item,index) in planInfo.notice">
              <div class="tishi-content" :key="index">{{item}}</div>
            </template>
          </template>
        </a-table>
      </a-layout-content>
      <!-- 周转信息弹窗 -->
      <a-modal
        centered
        width="1500"
        :title="'周转详情'"
        :visible="status.visible"
        :confirmLoading="status.confirmLoading"
        @cancel="statusCancel"
        :footer="null"
      >
        <!-- 弹窗内周转信息表格 -->
        <a-table
          :columns="secondColumns"
          :dataSource="secondData"
          :rowKey="record => record.planId"
          @expand="expand"
          :expandedRowKeys="expandedRowKeys"
          :pagination="false"
          :expandRowByClick="true"
        >
          <template slot="planType" slot-scope="text">{{text == 1 ? '还款计划' : '消费计划'}}</template>
          <template slot="details" slot-scope="text">{{text.length}}</template>
          <template slot="action" slot-scope="text, record">
            <div @click.stop>
              <template>
                <a-button
                  v-if="record.isSign == 0"
                  style="margin-right:10px;"
                  type="primary"
                  :disabled="record.isDetail == 0"
                  @click="() => signPlans(record.planId,record,'planId')"
                >标记</a-button>
                <a-button v-else style="margin-right:10px;" type="dashed" :disabled="true">完成</a-button>
              </template>
              <a-button
                style="margin-right:10px;"
                type="primary"
                :disabled="record.isDetail == 1"
                @click="() => createPlans(record.planId,record)"
              >生成多笔计划</a-button>
            </div>
          </template>
          <!-- 弹窗子表格 -->
          <a-table
            slot="expandedRowRender"
            :bordered="true"
            :columns="innerColumns"
            :dataSource="innerData"
            :pagination="false"
            :rowKey="record => record.did"
          >
            <template slot="footer">
              <span class="biaoji">提示：</span>
              <div class="tishi-content">{{nMsg}}</div>
            </template>
            <template slot="action" slot-scope="text, record">
              <template>
                <a
                  v-if="record.isSign == 0"
                  style="margin-right:10px;"
                  @click="() => signPlans(record.did,record,'did')"
                >标记</a>
                <span class="wancheng" v-else style="margin-right:10px;" slot="action">完成</span>
              </template>
            </template>
          </a-table>
        </a-table>
      </a-modal>
      <!-- 生成计划弹窗 -->
      <a-modal
        centered
        title="生成多笔计划"
        :visible="modify.visible"
        :confirmLoading="modify.confirmLoading"
        @cancel="modifyCancel"
        :footer="null"
      >
        <a-form :form="modifyform" @submit="modifySubmit">
          <a-form-item :label-col="{ span: 5 }" :wrapper-col="{ span: 18 }">
            <h3>{{'当前信用卡可用额度为：'+editValue+'元，您希望分几次消费用于周转还款?'}}</h3>
          </a-form-item>
          <a-form-item label="选择笔数" :label-col="{ span: 5 }" :wrapper-col="{ span: 18 }">
            <a-radio-group name="radioGroup" v-decorator="['detailNum']">
              <a-radio :value="2">2笔</a-radio>
              <a-radio :value="3">3笔</a-radio>
              <a-radio :value="4">4笔</a-radio>
              <a-radio :value="5">5笔</a-radio>
              <br />
              <a-radio :value="6">6笔</a-radio>
              <a-radio :value="7">7笔</a-radio>
              <a-radio :value="8">8笔</a-radio>
              <a-radio :value="9">9笔</a-radio>
            </a-radio-group>
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
  creditTurnoverPage,
  creditTurnoverGetSinglePlan,
  creditDetailPlan,
  creditSignPlan,
  creditSignDetail
} from "api";
const columns = [
  {
    title: "信用卡",
    dataIndex: "card.cardNumber",
    scopedSlots: { customRender: "cardNumber" }
  },
  {
    title: "信用额度（元）",
    dataIndex: "card.quota"
  },
  {
    title: "可用额度（元）",
    dataIndex: "card.availableQuota"
  },
  {
    title: "出账日",
    dataIndex: "card.billDate",
    scopedSlots: { customRender: "billDateStr" }
  },
  {
    title: "还款日",
    dataIndex: "card.repayDate",
    scopedSlots: { customRender: "repayDate" }
  },
  {
    title: "账单金额（元）",
    dataIndex: "card.newBill.totalMoney"
  },
  {
    title: "还款状态",
    dataIndex: "card.paystatus",
    scopedSlots: { customRender: "paystatus" }
  },
  {
    title: "周转信息",
    dataIndex: "plans",
    scopedSlots: { customRender: "plans" }
  }
];
const secondColumns = [
  {
    title: "计划日期",
    dataIndex: "planDate",
    scopedSlots: { customRender: "planDate" }
  },
  {
    title: "计划方式(本卡)",
    dataIndex: "planType",
    scopedSlots: { customRender: "planType" }
  },
  {
    title: "计划金额（元）",
    dataIndex: "planMoney"
  },
  {
    title: "分X笔数",
    dataIndex: "details",
    scopedSlots: { customRender: "details" }
  },
  {
    title: "操作",
    dataIndex: "action",
    scopedSlots: { customRender: "action" }
  }
];
const innerColumns = [
  {
    title: "单笔金额（元）",
    dataIndex: "planMoney"
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
      innerloading: false,
      data: [], //首页表格数据
      secondData: [], //周转弹窗表格数据
      innerData: [], //周转弹窗子表格数据
      expandedRowKeys: [], //周转弹窗表格展开行key
      planInfo: [], //周转计划信息
      columns,
      secondColumns,
      innerColumns,
      status: {
        //周转弹窗属性
        visible: false,
        confirmLoading: true
      },
      modify: {
        //分笔表单弹窗属性
        visible: false,
        confirmLoading: true
      },
      editValue: "",
      nMsg: "", //主表格提示内容
      statusValue: {},
      visible: false,
      confirmLoading: false,
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
        pageSize: 10, //每页中显示数据的条数
        phone: this.$route.params.phone
      },
      firstParam: {
        pageNum: 0, //第几页
        pageSize: 10, //每页中显示数据的条数
        phone: this.$route.params.phone
      },
      statusform: this.$form.createForm(this),
      modifyform: this.$form.createForm(this)
    };
  },
  created() {
    this._creditTurnoverPage();
  },
  methods: {
    _creditTurnoverPage() {
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
      creditTurnoverPage(that.queryParam).then(res => {
        if (res.code) {
          const pagination = { ...that.pagination };
          pagination.total = res.data.total;
          that.pagination = pagination;
          that.data = res.data.list[0].planData
            ? res.data.list[0].planData.content
            : [];
          that.planInfo = res.data.list[0].planData
            ? res.data.list[0].planData
            : {};
          setTimeout(() => {
            that.tableLoading = false;
          }, 200);
          that.queryParam = that.firstParam;
        }
      });
    },

    turnMsg(id, record) {
      // 点击周转详情
      creditTurnoverGetSinglePlan({ cid: id, uid: this.$route.params.id }).then(
        res => {
          if (res.code) {
            this.secondData = res.data.result;
          }
        }
      );
      this.status.visible = true;
      this.statusId = id;
    },
    statusCancel() {
      //关闭周转详情弹窗
      this.status.visible = false;
    },
    expand(expanded, record) {
      //展开行事件
      this.expandedRowKeys = [];
      if (expanded) {
        this.expandedRowKeys = [record.planId];
        this.innerData = this.secondData.filter(
          item => record.planId == item.planId
        )[0].details; // 获取表格内部数据
        const targetData = this.data.filter(
          item => this.statusId == item.card.cid
        )[0];
        const target = targetData.plans.filter(
          item => record.planId == item.planId
        )[0];
        this.nMsg = target.msg; // 提示信息
      }
    },
    signPlans(id, record, col) {
      //点击标记
      col == "planId"
        ? creditSignPlan({ planId: id }).then(res => {
            if (res.code) {
              this.$message.success(res.msg);
              record.isSign = 1;
              record.details.forEach(function(item, index) {
                item.isSign = 1;
                return item;
              });
            }
          })
        : creditSignDetail({ did: id }).then(res => {
            if (res.code) {
              this.$message.success(res.msg);
              record.isSign = 1;
            }
          });
    },
    createPlans(id, record) {
      //点击生成分笔
      this.editId = id;
      this.editValue = this.data.filter(
        item => this.statusId == item.card.cid
      )[0].card.availableQuota;
      this.modify.visible = true;
    },
    modifySubmit(e) {
      //分笔表单提交
      let that = this;
      let target = that.secondData.filter(
        item => that.editId == item.planId
      )[0];
      e.preventDefault();
      that.modifyform.validateFields((err, values) => {
        creditDetailPlan({
          planId: that.editId,
          detailNum: values.detailNum
        }).then(res => {
          if (res.code) {
            that.$message.success(res.msg);
            creditTurnoverGetSinglePlan({
              cid: this.statusId,
              uid: this.$route.params.id
            }).then(res => {
              this.secondData = res.data.result;
            });
            that.modify.visible = false;
          }
        });
      });
    },
    modifyCancel() {
      //关闭分笔表单
      this.modify.visible = false;
    },
    back() {
      //返回上一页
      this.$router.back();
    }
  }
};
</script>
<style scoped>
.status-detail {
  color: #faad14;
}
.col-sql {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  display: inline-block;
  width: 200px;
  cursor: pointer;
  color: #faad14;
}
.biaoji {
  font-size: 15px;
  color: #faad14;
}
.wancheng {
  color: #52c41a;
}
.tishi-content {
  margin: 10px 0;
  color: darkslategrey;
  font-size: 15px;
}
.tongji {
  margin: 20px 0;
  padding: 10px 15px 8px 15px;
  border: 1px solid #91d5ff;
  background-color: #e6f7ff;
  border-radius: 5px;
}

.tongji-box {
  font-size: 15px;
  margin-right: 12px;
  color: rgba(0, 0, 0, 0.65);
}
.mean-number {
  color: #1899ff;
  font-weight: 600;
}
.deletes {
  color: #f5222d;
}
.uncative {
  color: #f5222d;
}
.active {
  color: #52c41a;
}
</style>