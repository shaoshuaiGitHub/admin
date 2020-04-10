<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>功能业务配置</a-breadcrumb-item>
            <a-breadcrumb-item>提额规则配置</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">{{name+'提额计划'}}</span>
          </div>
        </div>
      </div>
    </div>
    <div class="wrap-children-content">
      <template>
        <a-tabs :defaultActiveKey="''+typeKey" type="card">
          <a-tab-pane key="1">
            <span slot="tab">
              <a-icon type="ant-design" />消费计划
            </span>
            <consum-view></consum-view>
          </a-tab-pane>
          <a-tab-pane key="2">
            <span slot="tab">
              <a-icon type="slack" />还款计划
            </span>
            <a-layout-content
              :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }"
            >
              <div
                class="headButton"
                :style="{display:'flex',flexDirection:'row',justifyContent:'space-between',marginTop:'15px'}"
              > 
              <a-button type="primary" icon="left" @click="back">返回</a-button>
                <div class="pages-list-table-list" >
                  <a-button type="primary" icon="edit" style="margin-right:50px" @click="saveall">保存修改</a-button>
                  <a-button type="primary" icon="plus" @click="addModal">新增配置</a-button>
                </div>
              </div>
              <a-table
                :loading="tableLoading"
                :pagination="pagination"
                :showHeader="true"
                :dataSource="data"
                :columns="columns"
                :rowKey="record => record.rid"
                @change="handleTableChange"
                :scroll="{x:500}"
              >
                <template slot="moneyPer" slot-scope="text, record">
                  <a-input-number
                  
                    style="width:60px"
                    :defaultValue="text"
                    class="sort-input"
                    @change="value => changeInput(value, record.rid,'moneyPer')"
                  />
                </template>
                <template slot="operation" slot-scope="text, record">
                  <div class="editable-row-operations">
                    <span>
                      <a class="delete" @click="() => deletes(record.rid)">删除</a>
                    </span>
                  </div>
                </template>
              </a-table>
              <a-modal
                centered
                title="新增还款计划"
                :visible="adduser.visible"
                :confirmLoading="adduser.confirmLoading"
                @cancel="userCancel"
                :footer="null"
              >
                <a-form :form="useraddform" @submit="adduserSubmit">
                  <a-form-item
                    label="账单日前X天还款"
                    :label-col="{ span: 8}"
                    :wrapper-col="{ span: 5}"
                  >
                    <a-input
                      v-decorator="['dateBefore',{rules: [{ required: true, pattern: new RegExp(/^([12][0-9]|30|[1-9])$/, 'g'), message: '输入1-30正整数' }]}]"
                    />
                  </a-form-item>
                  <a-form-item
                    label="还款金额比例（Y%）"
                    :label-col="{ span: 8 }"
                    :wrapper-col="{ span: 12 }"
                  >
                    <a-input-number
                      v-decorator="['moneyPer',{rules: [{ required: true, message: '还款金额比例（Y' }]}]"
                    />
                  </a-form-item>
                  <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
                    <a-button type="primary" html-type="submit">保存</a-button>
                  </a-form-item>
                </a-form>
              </a-modal>
            </a-layout-content>
          </a-tab-pane>
        </a-tabs>
      </template>
    </div>
  </div>
</template>
<script>
import {
  repaymentRule,
  addRepaymentRule,
  updateRepaymentRule,
  deleteRepaymentRule
} from "api";
import ConsumRule from "../newquota/ConsumRule.vue";

const columns = [
  {
    title: "更新时间",
    // width: "18%",
    dataIndex: "updateTime",
    scopedSlots: { customRender: "updateTime" }
  },
  {
    title: "账单日前X天还款",
    // width: "18%",
    dataIndex: "dateBefore",
    scopedSlots: { customRender: "dateBefore" }
  },
  {
    title: "还款金额比例（Y%）",
    // width: "18%",
    dataIndex: "moneyPer",
    scopedSlots: { customRender: "moneyPer" }
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
        bankId: this.$route.params.id,
        pageNum: 1, //第几页
        pageSize: 10 //每页中显示数据的条数
      },
      adduser: {
        visible: false,
        confirmLoading: true
      },
      useraddform: this.$form.createForm(this),
      typeKey: this.$route.params.typeKey,
      name: this.$route.params.name
    };
  },
   components: {
    "consum-view": ConsumRule
  },
  created() {
    this._repaymentRule();
  },
  methods: {
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
      repaymentRule(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    _repaymentRule() {
      //获取会员商品列表
      this.getTableList();
    },

    addModal() {
      //打开新增服务
      this.adduser.visible = true;
    },
    adduserSubmit(e) {
      //新增服务保存
      let that = this;
      e.preventDefault();
      that.useraddform.validateFields((err, values) => {
        console.log(values);
        
        let formData = new FormData();
        formData.append("dateBefore", values.dateBefore);
        formData.append("moneyPer", values.moneyPer);
        formData.append("bankId", this.$route.params.id);
        if (!err) {
          addRepaymentRule(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.adduser.visible = false;
              that.useraddform.resetFields();
              that._repaymentRule();
            }
          });
        }
      });
    },
    userCancel() {
      //关闭新增服务页面
      this.adduser.visible = false;
    },
    changeInput(value, id, column) {
      //监听值变化
      const newData = [...this.data];
      const target = newData.filter(item => id === item.rid)[0];
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
        formData.append("rid", target[i].rid);
        formData.append("moneyPer", target[i].moneyPer);
        updateRepaymentRule(formData).then(res => {
          if (res.code) {
            this.$message.success(res.msg);
          }
        });
        delete target[i].editable;
      }
    },
    handleOk() {
      //确定删除
      let that = this;
      deleteRepaymentRule({ rids: this.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          that.tableLoading = true;
          setTimeout(() => {
            that.visible = false;
            that.confirmLoading = false;
            that._repaymentRule();
          }, 200);
        }
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
    handleCancel() {
      //取消删除
      this.visible = false;
    },
    back(){
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
.delete{
    color: #f5222d;
}
</style>