<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>周转规则配置</a-breadcrumb-item>
            <a-breadcrumb-item>周转分笔计划配置</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">周转分笔计划配置</span>
          </div>
        </div>
      </div>
    </div>
    <div class="wrap-children-content">
      <a-layout-content
        :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }"
      >
        <a-list itemLayout="vertical" size="large" :dataSource="data" :pagination="pagination">
          <a-list-item slot="renderItem" slot-scope="item" :rowKey="item.cid">
            <template>
              <div>{{'分'+item.times+'笔'}}</div>
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
        <a-button type="primary" :style="{ margin: '0 0 24px 0 ' }" @click="saveall">保存修改</a-button>
      </a-layout-content>
    </div>
  </div>
</template>
<script>
import { getConfig, updateConfig } from "api"

export default {
  data() {
    return {
      tableloading: true,
      data: [],
      pagination: {
        pageNo: 1,
        defaultPageSize: 10,
        showTotal: total => `共 ${total} 条数据`,
        showSizeChanger: true,
        pageSizeOptions: ["5", "10", "15", "20"],
        onShowSizeChange: (current, pageSize) => (this.pageSize = pageSize),
        showQuickJumper: true
      },
    };
  },
  created() {
    this._getConfig()
  },
  methods: {
    _getConfig() {
      //获取会员列表
      let that = this
      getConfig({}).then(response => {
        const newData = response.data.content.map(item => ({ ...item }))
        that.data = newData
        setTimeout(() => {
          that.tableloading = false
        }, 200)
      })
    },
    handleChange2(value, cid, index) {
      //input事件
      const newData = [...this.data].map(function (item) {
        if (cid === item.cid) {
          const newStrdata = item.eachProportion.split(',')
          newStrdata[index] = value
          item.eachProportion = newStrdata.join(',')
        }
        return item
      })
      this.data = newData
    },
    saveall() {
      //保存修改
      updateConfig([...this.data]).then(res => {
        if (res.code) {
          this.$message.success(res.msg)
        }
      })
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