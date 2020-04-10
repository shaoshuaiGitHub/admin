// 额度保留率建议配置
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
            <a-breadcrumb-item>额度保留率建议配置</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">{{name+'_'+'额度保留率建议配置'}}</span>
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
            <template v-if="!hasDefaultL">
              <a-button
                type="primary"
                icon="plus"
                :style="{ margin: '0 24px 24px 0 ' }"
                @click="newPlan('default')"
              >默认配置</a-button>
            </template>
            <template v-else>
              <a-button
                type="primary"
                icon="plus"
                :style="{ margin: '0 24px 24px 0 ' }"
                disabled
              >默认配置</a-button>
            </template>
            <a-button
              type="primary"
              icon="plus"
              :style="{ margin: '0 0 24px 0 ' }"
              @click="newPlan('undefault')"
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
          @change="handleTableChange"
        >
          <template slot="attributes" slot-scope="text, record">
            <div>
              <template v-if="record.isDefault === 1">
                <a-icon
                  type="check-circle"
                  theme="twoTone"
                  twoToneColor="#52c41a"
                  :style="{ fontSize: '17px',marginLeft:'10px' }"
                />
                <span style="margin-left:5px">{{'默认'}}</span>
              </template>
              <template v-else>
                <span style="margin:0 5px">{{"额度保留率最小值"}}</span>
                <a-input
                  style="width:50px"
                  :defaultValue="text"
                  @change="e => handleChange2(e.target.value, record.cid, record.attributes[0].aid,'arrtibutes')"
                />
                <span style="margin-left:5px">{{'%'}}</span>
              </template>
            </div>
          </template>
          <template slot="attributes1" slot-scope="text, record">
            <div>
              <template v-if="record.isDefault === 1">
                <a-icon
                  type="check-circle"
                  theme="twoTone"
                  twoToneColor="#52c41a"
                  :style="{ fontSize: '17px',marginLeft:'10px' }"
                />
                <span style="margin-left:5px">{{'默认'}}</span>
              </template>
              <template v-else>
                <span style="margin:0 5px">{{"额度保留率最大值"}}</span>
                <a-input
                  style="width:50px"
                  :defaultValue="text"
                  @change="e => handleChange2(e.target.value, record.cid, record.attributes[1].aid,'arrtibutes1')"
                />
                <span style="margin-left:5px">{{'%'}}</span>
              </template>
            </div>
          </template>
          <template slot="attributest" slot-scope="text, record">
            <div>
              <a-input
                :defaultValue="text"
                @change="e => handleChange2(e.target.value, record.cid, record.attributes[2].aid,'attributest')"
              />
            </div>
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
    title: "额度最小保留率(近一年保留率)（X）",
    width: "20%",
    dataIndex: "attributes[0].attrValue",
    scopedSlots: { customRender: "attributes" }
  },
  {
    title: "额度最大保留率（近一年保留率）（Y）",
    width: "20%",
    dataIndex: "attributes[1].attrValue",
    scopedSlots: { customRender: "attributes1" }
  },
  {
    title: "提额建议内容",
    width: "20%",
    dataIndex: "attributes[2].attrValue",
    scopedSlots: { customRender: "attributest" }
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
      hasDefaultL: false,
      pagination: {
        total: 0,
        defaultCurrent: 1,
        defaultPageSize: 10,
        showTotal: total => `共 ${total} 条数据`,
        showSizeChanger: true,
        pageSizeOptions: ["5", "10", "15", "20"],
        showQuickJumper: true
      },
      name: this.$route.params.name,
      configKey: this.$route.params.configKey,
      bankId: this.$route.params.id,
      queryParam: {
        bankId: this.$route.params.id,
        configKey: this.$route.params.configKey,
        pageNum: 1, //第几页
        pageSize: 10 //每页中显示数据的条数
      }
    };
  },
  created() {
    this._configs();
  },
  methods: {
      handleTableChange(pagination) {
      //分页跳转
      this.pagination.current = pagination.current;
      this.pagination.pageSize = pagination.pageSize;
      this.tableLoading = true;
      const pagination1 = { ...this.pagination };
      pagination1.total = pagination1.total;
      this.pagination = pagination1;
      this.filterList();
    },
    _configs() {
      //获取会员商品列表
      let that = this;
      configs(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        that.filterList();
      });
    },
    filterList() {
      // 数据渲染前处理
      let that = this;
      let defaultConfig = that.data.filter(item => 1 === item.isDefault)[0];
      if (defaultConfig) {
        that.hasDefaultL = true;
        defaultConfig.attributes.unshift("", "");
      }
      setTimeout(() => {
        that.tableLoading = false;
      }, 200);
    },
    newPlan(status) {
      // 新增配置
      const newConfig = {
        attributes: [
          {
            attrKey: "RETAIN_MIX",
            attrValue: "0"
          },
          {
            attrKey: "RETAIN_MAX",
            attrValue: "100"
          },
          {
            attrKey: "RETAIN_PROPOSAL",
            attrValue: "请编辑"
          }
        ],
        bankId: this.$route.params.id,
        isDefault: 0,
        configKey: this.$route.params.configKey
      };
      if (status == "default") {
        newConfig.attributes.splice(0, 2);
        newConfig.isDefault = 1;
      }
      var that = this;
      saveConfig(newConfig).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.tableLoading = true;
          that._configs();
        }
      });
    },

    handleChange2(value, cid, aid, column) {
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
      console.log(target);
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