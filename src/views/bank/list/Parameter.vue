<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>银行管理</a-breadcrumb-item>
            <a-breadcrumb-item>银行列表</a-breadcrumb-item>
            <a-breadcrumb-item>提示语信息</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">{{name+'_'+'提示语信息'}}</span>
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
          <a-button type="primary" icon="rollback" @click="back">返回</a-button>
          <a-button type="primary" icon="plus" @click="addModal">新增提示语</a-button>
        </div>
        <a-table
          bordered
          :loading="tableLoading"
          :pagination="pagination"
          :showHeader="true"
          :columns="columns"
          :dataSource="data"
          :rowKey="record => record.parameterId"
          :scroll="{x:650}"
        >
          <template slot="name">
            <span>{{name}}</span>
          </template>
          <template
            v-for="col in [ 'parameterName',  'parameterTitle']"
            :slot="col"
            slot-scope="text, record"
          >
            <a-input
              :key="col"
              :value="text"
              @change="e => handleChange2(e.target.value,record.parameterId, col)"
            />
          </template>

          <template slot="isMust" slot-scope="text,record">
            <a-select
              :defaultValue="filterType(text)"
              style="width: 120px"
              @change="value=>handleChange2(value,record.parameterId,'isMust')"
            >
              <a-select-option
                v-for="(item,index) in selectValue"
                :value="index"
                :key="index"
              >{{item}}</a-select-option>
            </a-select>
          </template>
          <template slot="operation" slot-scope="text, record">
            <div class="editable-row-operations">
              <span>
                <a class="deletes" @click="() => deletes(record.parameterId)">删除</a>
              </span>
            </div>
          </template>
        </a-table>
        <a-button type="primary" :style="{ margin: '0 0 10px 0 ' }" @click="saveall">保存修改</a-button>
      </a-layout-content>
      <a-modal
        centered
        title="新增提示语"
        :visible="addservice.visible"
        :confirmLoading="addservice.confirmLoading"
        @cancel="serviceCancel"
        :footer="null"
      >
        <a-form :form="serviceaddform" @submit="addserviceSubmit">
          <a-form-item label="提示名称" :label-col="{ span: 5 }" :wrapper-col="{ span: 8 }">
            <a-input v-decorator="['parameterName']" />
          </a-form-item>
          <a-form-item label="提示内容" :label-col="{ span: 5 }" :wrapper-col="{ span: 8 }">
            <a-input v-decorator="['parameterTitle']" />
          </a-form-item>
          <a-form-item label="是否必填" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-select style="width:100px;" v-decorator="['isMust']">
              <a-select-option :value="1">是</a-select-option>
              <a-select-option :value="0">否</a-select-option>
            </a-select>
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
import { parameter, updateParameter, deleteParameter, addParameter } from "api";
import { match } from "minimatch";
const columns = [
  {
    title: "银行名称",
    dataIndex: "name",
    scopedSlots: { customRender: "name" }
  },
  {
    title: "银行ID",
    dataIndex: "bankId"
  },
  {
    title: "提示语名称",
    dataIndex: "parameterName",
    scopedSlots: { customRender: "parameterName" }
  },
  {
    title: "提示语信息",
    dataIndex: "parameterTitle",
    scopedSlots: { customRender: "parameterTitle" }
  },
  {
    title: "是否必填",
    dataIndex: "isMust",
    scopedSlots: { customRender: "isMust" }
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
      selectValue: ["否", "是"],
      addservice: {
        //新增页面属性
        visible: false,
        confirmLoading: true
      },
      serviceaddform: this.$form.createForm(this), //新增form表单创建
      pagination: {
        total: 30,
        defaultCurrent: 0,
        defaultPageSize: 10
      },
      name: this.$route.params.name
    };
  },
  created() {
    this._parameter();
  },

  methods: {
    _parameter() {
      //获取银行提示语列表
      let that = this;
      parameter({
        bankId: that.$route.params.id
      }).then(response => {
        that.data = response.data.content;
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    //判断默认选项类型
    filterType(text) {
      if (text == 1) {
        return "是";
      } else {
        return "否";
      }
    },
    handleChange2(value, parameterId, col) {
      //监听输入内容
      const newData = [...this.data];
      const target = newData.filter(
        item => parameterId === item.parameterId
      )[0];
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
      for (var i = 0; i < target.length; i++) {
        updateParameter({
          parameterId: target[i].parameterId,
          parameterName: target[i].parameterName,
          parameterTitle: target[i].parameterTitle,
          isMust: target[i].isMust
        }).then(res => {
          if (res.code) {
            this.tableLoading = true;
            this.$message.success(res.msg);
            setTimeout(() => {
              this.tableLoading = false;
            }, 200);
          }
        });
        delete target[i].editable;
      }
      if (target.length == 0) {
        this.data = newData;
      }
    },
    addModal() {
      //新增按钮
      this.addservice.visible = true;
    },
    addserviceSubmit(e) {
      // 新增提交按钮
      let that = this;
      e.preventDefault();
      that.serviceaddform.validateFields((err, values) => {
        let formData = {};
        formData.bankId = that.$route.params.id;
        formData.parameterName = values.parameterName;
        formData.parameterTitle = values.parameterTitle;
        formData.isMust = values.isMust;
        if (!err) {
          addParameter(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.addservice.visible = false;
              that._parameter();
              that.serviceaddform.resetFields();
            }
          });
        }
      });
    },
    serviceCancel() {
      //新增页面撤销
      this.addservice.visible = false;
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
    handleOk() {
      //确定删除
      let that = this;
      deleteParameter({ parameterId: this.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          that.tableLoading = true;
          setTimeout(() => {
            that.visible = false;
            that.confirmLoading = false;
            that._parameter();
          }, 200);
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
.editable-row-operations a {
  margin-right: 8px;
}
.deletes {
  color: #f5222d;
}
</style>