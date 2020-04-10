<template>
  <a-layout-content
    :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }"
  >
    <div
      class="headButton"
      :style="{display:'flex',flexDirection:'row',justifyContent:'space-between',marginTop:'15px'}"
    >
      <a-button type="primary" icon="left" @click="back">返回</a-button>
      <div class="pages-list-table-list">
        <a-button type="primary" icon="edit" style="margin-right:50px" @click="saveall">保存修改</a-button>
        <a-button type="primary" icon="plus" @click="addModal">新增配置</a-button>
      </div>
    </div>
    <a-table
      :loading="tableLoading"
      :columns="columns"
      :dataSource="data"
      :pagination="pagination"
      :rowKey="record => record.rid"
      @change="handleTableChange"
      :scroll="{x:700}"
    >
      <template slot="quotaPer" slot-scope="text, record">
        <a-input-number
        
          style="width:60px"
          :defaultValue="text"
          class="sort-input"
          @change="value => changeInput(value, record.rid,'quotaPer')"
        />
        
      </template>
      <template :slot="col" v-for="col in ['beginTime','endTime']" slot-scope="text,record">
        <div :key="col">
          <a-time-picker
            :defaultValue="moment( sliceTime(text), 'HH:mm')"
            format="HH:mm"
            @change="(time,timeString) => changeInput(timeString, record.rid,col)"
          />
        </div>
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
      title="新增消费计划"
      :visible="adduser.visible"
      :confirmLoading="adduser.confirmLoading"
      @cancel="userCancel"
      :footer="null"
    >
      <a-form :form="useraddform" @submit="adduserSubmit">
        <a-form-item label="账单日后X天消费" :label-col="{ span: 8}" :wrapper-col="{ span: 5}">
          <a-input
            v-decorator="['dateAfter',{rules: [{ required: true, pattern: new RegExp(/^([12][0-9]|30|[1-9])$/, 'g'), message: '输入1-30正整数' }]}]"
          />
        </a-form-item>
        <a-form-item label="消费金额比例（Y%）" :label-col="{ span: 8 }" :wrapper-col="{ span: 12 }">
          <a-input-number
            v-decorator="['quotaPer',{rules: [{ required: true, message: '消费金额比例!' }]}]"
          />
        </a-form-item>

        <a-form-item label="消费时间起始（时/分）" :label-col="{ span: 8 }" :wrapper-col="{ span: 12 }">
          <a-time-picker use24Hours format="HH:mm" v-decorator="['beginTime',{rules: [{ required: true, message: '请选择消费起始时间！' }]}]" />
        </a-form-item>
        <a-form-item label="消费时间终止（时/分）" :label-col="{ span: 8 }" :wrapper-col="{ span: 12 }">
          <a-time-picker use24Hours format="HH:mm" v-decorator="['endTime',{rules: [{ required: true, message: '请选择消费起始终止！' }]}]" />
        </a-form-item>
        <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
          <a-button type="primary" html-type="submit">保存</a-button>
        </a-form-item>
      </a-form>
    </a-modal>
  </a-layout-content>
</template>
<script>
import {
  consumRule,
  addConsumRule,
  updateConsumRule,
  deleteConsumRule
} from "api";
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
      bankid: this.$route.params.id
    };
  },

  created() {
    this._consumRule();
  },
  methods: {
    moment,
    sliceTime(time) {
      //时间字符串截取
      if(time){
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
      consumRule(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    _consumRule() {
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
         if (values.beginTime) {
          values.beginTime = values.beginTime.format("HH:mm");
        }
        if (values.endTime) {
          values.endTime = values.endTime.format("HH:mm");
        }
        let formData = new FormData();
        formData.append("dateAfter", values.dateAfter);
        formData.append("quotaPer", values.quotaPer);
        formData.append("bankId", that.$route.params.id);
        formData.append("beginTime",  values.beginTime);
        formData.append("endTime",  values.endTime);
        if (!err) {
          addConsumRule(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.adduser.visible = false;
              that.useraddform.resetFields();
              that._consumRule();
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
      console.log(value);
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
        formData.append("quotaPer", target[i].quotaPer);
        if (target[i].beginTime.length > 5) {
          target[i].beginTime = this.sliceTime(target[i].beginTime);
        }
        if (target[i].endTime.length > 5) {
          target[i].endTime = this.sliceTime(target[i].endTime);
        }
        formData.append("beginTime", target[i].beginTime);
        formData.append("endTime", target[i].endTime);
        updateConsumRule(formData).then(res => {
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
      deleteConsumRule({ rids: this.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          that.tableLoading = true;
          setTimeout(() => {
            that.visible = false;
            that.confirmLoading = false;
            that._consumRule();
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