<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>功能业务配置</a-breadcrumb-item>
            <a-breadcrumb-item>信用卡诊断配置</a-breadcrumb-item>
            <a-breadcrumb-item>额度诊断配置</a-breadcrumb-item>
            <a-breadcrumb-item>提额规则</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">{{name+'_'+'提额规则'}}</span>
          </div>
        </div>
      </div>
    </div>
    <div class="wrap-children-content">
      <a-layout-content
        :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }"
      >
        <div
          :style="{display:'flex',flexDirection:'row',justifyContent:'space-between',marginBottom:'20px'}"
        >
          <a-button type="primary" icon="rollback" @click="back">返回</a-button>
          <div>
            <a-button type="primary" :style="{ margin: '0 0 10px 0 ' }" @click="saveall">保存修改</a-button>
            <a-button type="primary" :style="{ margin: '0 0 10px 50px ' }" @click="addModal">新增规则</a-button>
          </div>
        </div>
        <a-table
          bordered
          :loading="tableLoading"
          :showHeader="true"
          :columns="columns"
          :dataSource="data"
          :rowKey="record => record.rid"
        >
          <template slot="sort" slot-scope="text, record">
            <a-input
              :style="{width:'50px'}"
              :value="text"
              @change="e => handleChange2(e.target.value,record.rid, 'sort')"
            />
          </template>
          <template slot="mess" slot-scope="text, record">
            <a-input
              :value="text"
              @change="e => handleChange2(e.target.value,record.rid, 'title')"
            />
          </template>
          <template slot="operation" slot-scope="text, record">
            <div class="editable-row-operations">
              <span>
                <a class="deletes" @click="() => deletes(record.rid)">删除</a>
              </span>
            </div>
          </template>
        </a-table>
      </a-layout-content>
    </div>
  </div>
</template>
<script>
import { bankRule, updateRule, addBankRule, deleteBankRule } from "api";
import { match } from "minimatch";
const columns = [
  {
    title: "规则排序 ",
    dataIndex: "sort",
    scopedSlots: { customRender: "sort" }
  },
  {
    title: "规则信息",
    dataIndex: "title",
    scopedSlots: { customRender: "mess" }
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
      columns,
      delmsg: null,
      visible: false,
      confirmLoading: false,
      tableLoading: true,
      name: this.$route.params.name
    };
  },
  created() {
    this._bankRule();
  },

  methods: {
    _bankRule() {
      //获取银行提示语列表
      let that = this;
      bankRule({
        bankId: that.$route.params.id
      }).then(response => {
        that.data = response.data.content;
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },

    handleChange2(value, rid, col) {
      //监听输入内容
      const newData = [...this.data];
      const target = newData.filter(item => rid === item.rid)[0];
      if (target) {
        target[col] = value;
        target.editable = true;
        this.data = newData;
      }
    },
    saveall() {
      //保存修改
      const newData = [...this.data];
      const target = newData.filter(item => true === item.editable);
      console.log(target);
      for (var i = 0; i < target.length; i++) {
        updateRule({
          sort: target[i].sort,
          rid: target[i].rid,
          title: target[i].title
        }).then(res => {
          if (res.code) {
            this.tableLoading = true;
            this.$message.success(res.msg);
            setTimeout(() => {
              this.tableLoading = false;
            }, 200);
            delete target[i].editable;
          }
        });
      }
      if (target.length == 0) {
        this.data = newData;
      }
    },
    addModal() {
      addBankRule({
        bankId: this.$route.params.id,
        sort: this.data.length + 1,
        title: ""
      }).then(res => {
        if (res.code) {
            this.$message.success(res.msg);
            this._bankRule();
        }
      });
    },
    handleOk() {
      //确定删除
      let that = this;
      deleteBankRule({ rid: this.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          that.tableLoading = true;
          setTimeout(() => {
            that.visible = false;
            that.confirmLoading = false;
            that._bankRule();
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
.deletes {
  color: #f5222d;
}
</style>