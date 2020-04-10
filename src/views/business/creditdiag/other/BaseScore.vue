<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>功能业务配置</a-breadcrumb-item>
            <a-breadcrumb-item>信用卡诊断配置</a-breadcrumb-item>
            <a-breadcrumb-item>其他诊断配置</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">{{name+'_'+'基础诊断得分配置'}}</span>
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
          <a-button type="primary" icon="rollback" @click="back">返回</a-button>
          <div>
            <a-button
              type="primary"
              icon="plus"
              :style="{ margin: '0 0 24px 0 ' }"
              @click="newPlan"
            >新增配置</a-button>
          </div>
        </div>
        <a-table
          bordered
          :loading="tableLoading"
          :pagination="pagination"
          :showHeader="true"
          :dataSource="data"
          :columns="columns"
          :rowKey="record => record.cid"
        >
          <template slot="score" slot-scope="text, record">
            <div>
              <span style="margin:0 5px">{{"基础诊断得分是"}}</span>
              <a-input
                style="width:50px"
                :defaultValue="text"
                @change="e => handleChange2(e.target.value, record.cid, record.attributes[0].aid)"
              />
              <span style="margin-left:5px">{{'分'}}</span>
            </div>
          </template>
          <template slot="result" slot-scope="text,record">
            <a-select
              :defaultValue="text"
              style="width: 120px"
              @change="value=>handleChange2(value,record.cid,record.attributes[1].aid)"
            >
              <a-select-option
                v-for="(item,index) in selectValue"
                :value="item"
                :key="index"
              >{{item}}</a-select-option>
            </a-select>
          </template>
          <template slot="operation" slot-scope="text, record">
            <div class="editable-row-operations">
              <span>
                <a class="deletes" @click="() => deletes(record.cid)">删除</a>
              </span>
            </div>
          </template>
        </a-table>
        <a-button type="primary" :style="{ margin: '0 0 24px 0 ' }" @click="saveall">保存修改</a-button>
      </a-layout-content>
    </div>
    <a-modal
      title="请确定"
      okText="确定"
      cancelText="取消"
      :visible="visible"
      @ok="handleOk"
      :confirmLoading="confirmLoading"
      @cancel="handleCancel"
      html-type="submit"
    >
      <p>{{delmsg}}</p>
    </a-modal>
  </div>
</template>
<script>
import { configs, updateAttr, saveConfig, deleteConfig } from "api";
import { match } from "minimatch";

const columns = [
  {
    title: "基础诊断得分（A）",
    width: "30%",
    dataIndex: "attributes[0].attrValue",
    scopedSlots: { customRender: "score" }
  },
  {
    title: "诊断结果",
    width: "30%",
    dataIndex: "attributes[1].attrValue",
    scopedSlots: { customRender: "result" }
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
      selectValue: ["优秀", "良好", "一般", "不佳", "较差"],
      pagination: {
        pageNo: 1,
        defaultPageSize: 10,
        showTotal: total => `共 ${total} 条数据`,
        showSizeChanger: true,
        pageSizeOptions: ["5", "10", "15", "20"],
        onShowSizeChange: (current, pageSize) => (this.pageSize = pageSize),
        showQuickJumper: true
      },
      name: this.$route.params.name,
      configKey: this.$route.params.configKey
    };
  },
  created() {
    this._configs();
  },
  methods: {
    _configs() {
      //获取会员列表
      let that = this;
      configs({
        bankId: that.$route.params.id,
        configKey: this.$route.params.configKey
      }).then(res => {
        that.data = res.data.list;
        that.cacheData = that.data.map(item => ({ ...item })); // 初始缓存数据
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    newPlan() {
      // 新增配置
      const newConfig = {
        attributes: [
          {
            attrKey: "REPAYMENT_SCORE",
            attrValue: "100"
          },
          {
            attrKey: "REPAYMENT_RESULT",
            attrValue: "优秀"
          }
        ],
        bankId: this.$route.params.id,
        isDefault: "0",
        configKey: this.$route.params.configKey
      };
      var that = this;
      const jsonConfig = JSON.stringify(newConfig);
      saveConfig(jsonConfig).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.tableLoading = true;
          that._configs();
          setTimeout(() => {
            that.tableLoading = false;
          }, 200);
        }
      });
    },
    handleChange2(value, cid, aid) {
      // 监听输入内容
      const newData = [...this.data];
      const target = newData.filter(item => cid === item.cid)[0];
      const targetChild = target.attributes.filter(item => aid === item.aid)[0];
      if (target) {
        if (targetChild) {
          targetChild.attrValue = value;
          targetChild.editableChild = true;
          target.editable = true;
          this.data = newData;
        }
      }
    },

    saveall() {
      //保存修改
      const newData = [...this.data];
      const target = newData.filter(item => true === item.editable);
      for (var i = 0; i < target.length; i++) {
        if (target[i]) {
          const targetChild = target[i].attributes.filter(
            item => true === item.editableChild
          );
          for (var j = 0; j < targetChild.length; j++) {
            updateAttr({
              aid: targetChild[j].aid,
              configValue: targetChild[j].attrValue
            }).then(res => {
              if (res.code) {
                this.tableLoading = true;
                this.$message.success(res.msg);
                setTimeout(() => {
                  this.tableLoading = false;
                }, 200);
              }
            });
            delete target[i].editableChild;
          }
        }
        delete target[i].editable;
        this.data = newData;
      }
    },
    handleOk() {
      //确定删除
      let that = this;
      deleteConfig({ cid: this.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          that.tableLoading = true;
          setTimeout(() => {
            that.visible = false;
            that.confirmLoading = false;
            that._configs();
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