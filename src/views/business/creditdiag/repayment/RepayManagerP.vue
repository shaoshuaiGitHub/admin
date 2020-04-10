<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>功能业务配置</a-breadcrumb-item>
            <a-breadcrumb-item>信用卡诊断配置</a-breadcrumb-item>
            <a-breadcrumb-item>还款诊断配置</a-breadcrumb-item>
            <a-breadcrumb-item>管理师建议</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">管理师建议</span>
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
          <div class="pages-list-table-list" style="margin-top:12px">
            <a-button type="primary" @click="back">返回</a-button>
          </div>
          <template v-if="!hasDefaultL">
            <a-button
              type="primary"
              icon="plus"
              :style="{ margin: '12px 100px 24px 0 ' }"
              @click="newPlan('default')"
            >默认配置</a-button>
          </template>
          <template v-else>
            <a-button
              type="primary"
              icon="plus"
              :style="{ margin: '12px 100px 24px 0 ' }"
              disabled
            >默认配置</a-button>
          </template>
        </div>

        <a-form :form="searchform" @submit="searchSubmit" style="margin-top:8px">
          <a-form-item label="还款日期建议" :label-col="{ span: 3}" :wrapper-col="{ span: 12 }">
            <a-input
              placeholder="建议文字内容在500个字符串以内"
              v-decorator="['configValue[0]',{initialValue: hasDefaultL ? data.attributes[0].attrValue : null}]"
            />
            <span class="tishi">还款日期管理师建议</span>
          </a-form-item>
          <a-form-item label="还款金额建议" :label-col="{ span:3 }" :wrapper-col="{ span: 12 }">
            <a-input
              placeholder="建议文字内容在500个字符串以内"
              v-decorator="['configValue[1]',{initialValue: hasDefaultL ? data.attributes[1].attrValue : null}]"
            />
            <span class="tishi">还款金额分析管理师建议</span>
          </a-form-item>
          <a-form-item label="分期数据建议" :label-col="{ span: 3}" :wrapper-col="{ span: 12 }">
            <a-input
              placeholder="建议文字内容在500个字符串以内"
              v-decorator="['configValue[2]',{initialValue: hasDefaultL ? data.attributes[2].attrValue : null}]"
            />
            <span class="tishi">分期数据管理师建议</span>
          </a-form-item>
          <a-form-item :wrapper-col="{ span: 15, offset: 6 }">
            <a-button :style="{marginRight:'20px'}" @click="cancle">取消</a-button>
            <template v-if="hasDefaultL">
              <a-button type="primary" html-type="submit">保存</a-button>
            </template>
            <template v-else>
              <a-button type="primary" html-type="submit" disabled>保存</a-button>
            </template>
          </a-form-item>
        </a-form>
      </a-layout-content>
    </div>
  </div>
</template>
<script>
import { configs, updateAttr, saveConfig } from "api";

export default {
  data() {
    return {
      tableloading: true,
      data: [],
      searchform: this.$form.createForm(this),
      hasDefaultL: false,
      queryParam: {
        bankId: this.$route.params.id,
        configKey: this.$route.params.configKey,
        pageNum: 0, //第几页
        pageSize: 10 //每页中显示数据的条数
      }
    };
  },

  created() {
    this._configs();
  },

  methods: {
    _configs() {
      //周期获取
      this.getTableList();
    },

    getTableList() {
      //获取列表
      let that = this;
      configs(that.queryParam).then(res => {
        that.data = res.data.list.filter(item => 1 === item.isDefault)[0];
        if (that.data) {
          that.hasDefaultL = true;
        }
        setTimeout(() => {
          that.tableloading = false;
        }, 200);
      });
    },
    cancle() {
      this.searchform.resetFields();
    },
    newPlan(status) {
      // 新增配置
      const newConfig = {
        attributes: [
          {
            attrKey: "REPAY_DATE_PROPOSAL",
            attrValue: "请编辑"
          },
          {
            attrKey: "REPAY_MONEY_PROPOSAL",
            attrValue: "请编辑"
          },
          {
            attrKey: "DATA_BY_STAGES_PROPOSAL",
            attrValue: "请编辑"
          }
        ],
        bankId: this.$route.params.id,
        isDefault: 1,
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
    searchSubmit(e) {
      e.preventDefault();
      this.searchform.validateFields((err, values) => {
        console.log(values);
        const target = this.data.attributes;
        for (let i = 0; i < this.data.attributes.length; i++) {
          if (
            values.configValue[i] &&
            values.configValue[i] != target[i].attrValue
          ) {
            updateAttr({
              aid: this.data.attributes[i].aid,
              configValue: values.configValue[i]
            }).then(res => {
              if (res.code) {
                this.$message.success(res.msg);
                target[i].attrValue = values.configValue[i];
              }
            });
          }
        }
      });
    },
    back() {
      this.$router.back();
    }
  }
};
</script>
<style scoped>
.bank-icon {
  width: 60px;
  height: 60px;
}

.tishi {
  color: rgba(132, 213, 91, 0.85);
}
</style>