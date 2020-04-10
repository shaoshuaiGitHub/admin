<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>功能业务配置</a-breadcrumb-item>
            <a-breadcrumb-item>周转规则配置</a-breadcrumb-item>
          </a-breadcrumb>
          <!-- <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">周转分笔计划配置</span>
          </div>-->
        </div>
      </div>
    </div>
    <div class="wrap-children-content">
      <template>
        <a-tabs defaultActiveKey="1" type="card">
          <a-tab-pane key="1">
            <span slot="tab">
              <a-icon type="ant-design" />信用卡周转基础配置
            </span>
            <bease-view></bease-view>
          </a-tab-pane>
          <a-tab-pane key="2">
            <span slot="tab">
             <a-icon type="slack" />周转生成多比计划配置
            </span>
            <a-layout-content
              :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }"
            >
              <div
                class="headButton"
                :style="{display:'flex',flexDirection:'row',justifyContent:'flex-start'}"
              >
                <div class="pages-list-table-list" style="margin-top:15px">
                  <a-button type="primary" style="margin-right:50px" @click="saveall">保存修改</a-button>
                  <a-button type="primary" icon="form" @click="addModal">新增计划</a-button>
                </div>
              </div>
              <a-list itemLayout="vertical" size="large" :dataSource="data">
                <a-list-item slot="renderItem" slot-scope="item" :rowKey="item.cid">
                  <template>
                    <div
                      :style="{display:'flex',flexDirection:'row',justifyContent:'flex-start',alignItems:'center'}"
                    >
                      <div>{{'分'+item.times+'笔'}}</div>
                      <a-button
                        :style="{marginLeft:'20px'}"
                        type="danger"
                        @click="() => deletes(item.cid)"
                      >删除</a-button>
                    </div>
                  </template>
                  <template>
                    <div style="minHeight:40px">
                      <ul>
                        <template v-for="(pro, index) in item.eachProportion.split(',')">
                          <li :key="index">
                            <a-input
                              :defaultValue="pro"
                              style="width:90px"
                              size="small"
                              addonAfter="%"
                              @change="e => handleChange2(e.target.value, item.cid, index)"
                            ></a-input>
                          </li>
                        </template>
                      </ul>
                    </div>
                  </template>
                </a-list-item>
              </a-list>
            </a-layout-content>
          </a-tab-pane>
        </a-tabs>
      </template>
    </div>
  </div>
</template>
<script>
import { getConfig, updateConfig, addTurnover, deleteTurnover } from "api";
import TurnBase from "../newturnover/TurnBase.vue";
export default {
  data() {
    return {
      data: [],
      delmsg: null,
      confirmLoading: false,
      tableloading: true
    };
  },
   components: {
    "bease-view": TurnBase
  },
  created() {
    this._getConfig();
  },
  methods: {
    addModal() {
      //新增
      const times = this.data.length + 2;
      const arr = [].concat(Array(times).fill(""));
      const newStr = arr.join(",");
      addTurnover({ times: times, eachProportion: newStr }).then(res => {
        if (res.code) {
          this.$message.success(res.msg);
          this._getConfig();
        }
      });
    },
    _getConfig() {
      //获取会员列表
      let that = this;
      getConfig({}).then(response => {
        const newData = response.data.content.map(item => ({ ...item }));
        that.data = newData;
        setTimeout(() => {
          that.tableloading = false;
        }, 200);
      });
    },
    handleChange2(value, cid, index) {
      //input事件
      const newData = [...this.data].map(function(item) {
        if (cid === item.cid) {
          const newStrdata = item.eachProportion.split(",");
          newStrdata[index] = value;
          item.eachProportion = newStrdata.join(",");
        }
        return item;
      });
      this.data = newData;
    },
    saveall() {
      //保存修改
      updateConfig([...this.data]).then(res => {
        if (res.code) {
          this.$message.success(res.msg);
        }
      });
    },
    deletes(id) {
      //删除事件
      let that = this;
      that.delID = id;
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
    handleOk() {
      //确定删除
      let that = this;
      deleteTurnover({ cids: that.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          that.tableLoading = true;
          setTimeout(() => {
            that.confirmLoading = false;
            that._getConfig();
          }, 200);
        }
      });
    }
  }
};
</script>
<style scoped>
li {
  float: left;
  list-style: none;
  margin: 5px 0px 5px 50px;
}
</style>