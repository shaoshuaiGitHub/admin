<template>
  <a-layout-content
    :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }"
  >
    <div class="headButton" :style="{display:'flex',flexDirection:'row',justifyContent:'flex-start'}">
      <div class="pages-list-table-list" style="margin-top:15px">
        <a-button type="primary" icon="form" @click="addModal">新增配置</a-button>
      </div>
    </div>
    <a-table
      :loading="tableLoading"
      :columns="columns"
      :dataSource="data"
      :pagination="pagination"
      :rowKey="record => record.basicsId"
      @change="handleTableChange"
      :scroll="{x:620}"
    >
      <template
        v-for="col in ['quotaPercent', 'commissionPercent','availableTurnoverPercent']"
        :slot="col"
        slot-scope="text, record"
      >
        <div :key="col">
          <a-input
            style="width:50px"
            :defaultValue="text"
            class="sort-input"
            @blur="e => changeInput(e.target.value, record.basicsId,col,record.bankIds)"
          />%
        </div>
      </template>
      <template slot="bankIds" slot-scope="text,record">
        <span @click="()=>bankLists(record.bankIds,record)" class="col-sql">{{showBank(text)}}</span>
      </template>
      <template slot="basicsStatus" slot-scope="text, record">
        <a-switch
          checkedChildren="启用"
          unCheckedChildren="停用"
          :checked="text === 1"
          @change="() => stopbution(record.basicsId, record.basicsStatus,record.bankIds)"
        />
      </template>
      <template slot="action" slot-scope="text, record">
        <a style="margin-right:10px;" slot="action" @click="() => editor(record.basicsId,record)">编辑</a>
        <span>
          <a class="deletes" @click="() => deletes(record.basicsId)">删除</a>
        </span>
      </template>
    </a-table>
    <a-modal
      centered
      title="修改周转基础配置"
      :visible="modify.visible"
      :confirmLoading="modify.confirmLoading"
      @cancel="modifyCancel"
      :footer="null"
    >
      <a-form :form="modifyform" @submit="modifySubmit">
        <a-form-item label="规则名字" :label-col="{ span: 6}" :wrapper-col="{ span: 12 }">
          <a-input
            v-decorator="['basicsRuleName',{rules: [{ required: true, message: '请输入规则名字' }],initialValue: editValue.basicsRuleName}]"
          />
        </a-form-item>
        <a-form-item label="开启条件（%）" :label-col="{ span: 6 }" :wrapper-col="{ span: 12 }">
          <a-input
            v-decorator="['quotaPercent',{rules: [{ required: true, message: '请输入开启条件（%）' }],initialValue: editValue.quotaPercent}]"
          />
        </a-form-item>
        <a-form-item label="手续费（%）" :label-col="{ span: 6 }" :wrapper-col="{ span: 12 }">
          <a-input
            v-decorator="['commissionPercent',{rules: [{ required: true, message: '请输入手续费（%）' }],initialValue: editValue.commissionPercent}]"
          />
        </a-form-item>
        <a-form-item label="可用额度（%）" :label-col="{ span: 6 }" :wrapper-col="{ span: 12 }">
          <a-input
            v-decorator="['availableTurnoverPercent',{rules: [{ required: true, message: '请输入可用额度（%）作为周转金额' }],initialValue: editValue.availableTurnoverPercent}]"
          />
        </a-form-item>

        <a-form-item label="状态" :label-col="{ span: 6 }" :wrapper-col="{ span: 12 }">
          <a-switch
            checkedChildren="启用"
            unCheckedChildren="停用"
            v-decorator="['basicsStatus',{ initialValue: editValue.basicsStatus === 1,valuePropName: 'checked'}]"
          />
        </a-form-item>
        <a-form-item label="关联银行" :label-col="{ span: 6 }" :wrapper-col="{ span: 12 }">
          <a-checkbox
            v-decorator="['check1',{ initialValue: editValue.check1,valuePropName: 'checked'}]"
            @change=" value => onCheckAllChange(value, this.editValue.basicsId)"
          >全选</a-checkbox>
          <a-form-item>
            <a-checkbox-group
              :options="checks"
              v-decorator="['bankIds',{ initialValue: editValue.bankIds}]"
              @change=" value => onChange(value, this.editValue.basicsId)"
            />
          </a-form-item>
        </a-form-item>

        <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
          <a-button type="primary" html-type="submit">保存</a-button>
        </a-form-item>
      </a-form>
    </a-modal>
    <a-modal
      centered
      title="新增周转基础配置"
      :visible="addservice.visible"
      :confirmLoading="addservice.confirmLoading"
      @cancel="serviceCancel"
      :footer="null"
    >
      <a-form :form="serviceaddform" @submit="addserviceSubmit">
        <a-form-item label="规则名字" :label-col="{ span: 6 }" :wrapper-col="{ span: 12 }">
          <a-input
            v-decorator="['basicsRuleName',{rules: [{ required: true, message: '请输入规则名字' }]}]"
          />
        </a-form-item>
        <a-form-item label="开启条件（%）" :label-col="{ span: 6 }" :wrapper-col="{ span: 12 }">
          <a-input
            v-decorator="['quotaPercent',{rules: [{ required: true, message: '请输入开启条件（%）' }]}]"
          />
        </a-form-item>
        <a-form-item label="手续费（%）" :label-col="{ span: 6}" :wrapper-col="{ span: 12 }">
          <a-input
            v-decorator="['commissionPercent',{rules: [{ required: true, message: '请输入手续费（%）' }]}]"
          />
        </a-form-item>
        <a-form-item label="可用额度（%）" :label-col="{ span: 6 }" :wrapper-col="{ span: 12 }">
          <a-input
            v-decorator="['availableTurnoverPercent',{rules: [{ required: true, message: '请输入可用额度（%）作为周转金额' }]}]"
          />
        </a-form-item>
        <a-form-item label="服务状态" :label-col="{ span: 6 }" :wrapper-col="{ span: 12 }">
          <a-switch checkedChildren="启用" unCheckedChildren="停用" v-decorator="['basicsStatus']" />
        </a-form-item>
        <a-form-item label="关联银行" :label-col="{ span: 6 }" :wrapper-col="{ span: 12 }">
          <a-checkbox v-decorator="['checked']" @change="onCheckAllChange" :checked="checkAll">全选</a-checkbox>
          <a-checkbox-group :options="checks" :value="checkedList" @change="onChange" />
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
  basicsPage,
  basicsUpdate,
  basicsAdd,
  basicsDelete,
  basicsFindById
} from "api";
const columns = [
  {
    title: "规则名字",
    dataIndex: "basicsRuleName",
    scopedSlots: { customRender: "basicsRuleName" }
  },
  {
    title: "关联银行",
    dataIndex: "bankIds",
    scopedSlots: { customRender: "bankIds" }
  },
  {
    title: "开启条件（%）",
    dataIndex: "quotaPercent",
    scopedSlots: { customRender: "quotaPercent" }
  },
  {
    title: "手续费（%）",
    dataIndex: "commissionPercent",
    scopedSlots: { customRender: "commissionPercent" }
  },
  {
    title: "可用额度（%）作为周转金额",
    dataIndex: "availableTurnoverPercent",
    scopedSlots: { customRender: "availableTurnoverPercent" }
  },

  {
    title: "状态",
    dataIndex: "basicsStatus",
    scopedSlots: { customRender: "basicsStatus" }
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
      delmsg: null,
      data: null,
      addservice: {
        visible: false,
        confirmLoading: true
      },
      modify: {
        visible: false,
        confirmLoading: true
      },
      bankArr: {
        1: "中国银行",
        2: "建设银行",
        3: "招商银行",
        4: "光大银行",
        5: "民生银行",
        6: "中信银行",
        7: "浦发银行",
        8: "兴业银行",
        9: "华夏银行",
        10: "平安银行",
        11: "交通银行",
        12: "农业银行",
        13: "工商银行",
        14: "广发银行",
        15: "邮政储蓄"
      },
      checks: [
        { label: "中国银行", value: 1 },
        { label: "建设银行", value: 2 },
        { label: "招商银行", value: 3 },
        { label: "光大银行", value: 4 },
        { label: "民生银行", value: 5 },
        { label: "中信银行", value: 6 },
        { label: "浦发银行", value: 7 },
        { label: "兴业银行", value: 8 },
        { label: "华夏银行", value: 9 },
        { label: "平安银行", value: 10 },
        { label: "交通银行", value: 11 },
        { label: "农业银行", value: 12 },
        { label: "工商银行", value: 13 },
        { label: "广发银行", value: 14 },
        { label: "邮政储蓄", value: 15 }
      ],
      checkedList: [],
      allcheck: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
      checkAll: false,
      editValue: { check1: false },
      confirmDirty: false,
      columns,
      ModalText: "Content of the modal",
      visible: false,
      roleOption: null,
      confirmLoading: false,
      formLayout: "horizontal",
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
        pageSize: 10 //每页中显示数据的条数
      },
      modifyform: this.$form.createForm(this),
      serviceaddform: this.$form.createForm(this),
      tardata: []
    };
  },
  created() {
    this._basicsPage();
  },
  methods: {
    _basicsPage() {
      //周期获取
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
      basicsPage(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    showBank(ids) {
      //   this.tardata = ...ids;

      if (ids.length != 0) {
        let tardata = [...ids];
        for (let i = 0; i < tardata.length; i++) {
          tardata[i] = this.bankArr[tardata[i]];
        }
        return tardata.join("、");
      } else {
        return "";
      }
    },
    stopbution(id, status, bankIds) {
      //状态切换
      let that = this;
      let target = that.data.filter(item => id === item.basicsId)[0];
      if (status == 1) {
        status = 0;
      } else {
        status = 1;
      }
      let formData = new FormData();
      formData.append("basicsId", id);
      formData.append("basicsStatus", status);
      formData.append("bankIds", bankIds);

      basicsUpdate(formData).then(res => {
        if (res.code && target) {
          basicsFindById({ basicsId: id }).then(response => {
            if (response.code) {
                Object.assign(target,response.data)
            }
          if (target.basicsStatus === 1) {
            that.$message.success("已经启用该配置");
          } else {
            that.$message.success("已经停用该配置");
          }
          });
         
        }
      });
    },
    changeInput(value, id, column, bankIds) {
      if (value) {
        const formData = new FormData();
        formData.append("basicsId", id);
        formData.append("bankIds", bankIds);
        formData.append(column, value);
        basicsUpdate(formData).then(res => {
          if (res.code) {
            this.$message.success(res.msg);
          }
        });
      }
    },

    addModal() {
      //新增按钮
      this.addservice.visible = true;
    },
    editor(id, editValue) {
      console.log(editValue.bankIds);
      //点击修改按钮
      editValue.check1 =
        editValue.bankIds.length === this.allcheck.length ? true : false;
      this.editValue = editValue;
      this.editId = id;
      this.modify.visible = true;
      this.modifyform.resetFields();
    },
    onChange(checkedList, id) {
      //多选框子项回调
      if (id == this.editId) {
        this.editValue.bankIds = checkedList;
        this.editValue.check1 =
          this.editValue.bankIds.length === this.allcheck.length ? true : false;
        this.modifyform.resetFields();
      }
      this.checkedList = checkedList;
      this.checkAll =
        checkedList.length === this.allcheck.length ? true : false;
    },

    onCheckAllChange(e, id) {
      //全选回调
      if (id == this.editId) {
        this.editValue.bankIds = e.target.checked ? this.allcheck : [];
        this.editValue.check1 = e.target.checked;
        this.modifyform.resetFields();
      }
      this.checkedList = e.target.checked ? this.allcheck : [];
      this.checkAll = e.target.checked;
    },
    modifySubmit(e) {
      // 修改用户
      let that = this;
      e.preventDefault();
      that.modifyform.validateFields((err, values) => {
        // console.log(values);
        values.basicsId = that.editId;
        if (values.basicsStatus) {
          values.basicsStatus = 1;
        } else {
          values.basicsStatus = 0;
        }
        let formData = new FormData();
        formData.append("basicsId", values.basicsId);
        formData.append("commissionPercent", values.commissionPercent);
        formData.append("quotaPercent", values.quotaPercent);
        formData.append("basicsRuleName", values.basicsRuleName);
        formData.append("basicsStatus", values.basicsStatus);
        formData.append(
          "availableTurnoverPercent",
          values.availableTurnoverPercent
        );
        console.log(values.bankIds);
        formData.append("bankIds", values.bankIds);
        if (!err) {
          basicsUpdate(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.modify.visible = false;
              that.fileListE = [];
              that._basicsPage();
            }
          });
        }
      });
    },
    addserviceSubmit(e) {
      // 新增提交按钮
      let that = this;
      e.preventDefault();
      that.serviceaddform.validateFields((err, values) => {
        // console.log(that.tarImgUrl);
        if (values.basicsStatus) {
          values.basicsStatus = 1;
        } else {
          values.basicsStatus = 0;
        }
        let formData = new FormData();
        formData.append("commissionPercent", values.commissionPercent);
        formData.append("quotaPercent", values.quotaPercent);
        formData.append("basicsRuleName", values.basicsRuleName);
        formData.append("basicsStatus", values.basicsStatus);
        formData.append(
          "availableTurnoverPercent",
          values.availableTurnoverPercent
        );

        if (values.checked) {
          formData.append("bankIds", that.allcheck);
        } else {
          formData.append("bankIds", that.checkedList);
        }
        if (!err) {
          basicsAdd(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.addservice.visible = false;
              that.checkedList = [];
              that.checkAll = false;
              that.fileList = [];
              that._basicsPage();
            }
          });
        }
      });
    },
    modifyCancel() {
      //修改页面撤销
      this.modify.visible = false;
    },
    serviceCancel() {
      //新增页面撤销
      this.addservice.visible = false;
      this.checkedList = [];
      this.checkAll = false;
    },
    bankLists(bankLists, record) {
      // 关联银行展示
      let that = this;
      that.$modal.info({
        centered: true,
        title: record.basicsRuleName + "-关联银行",
        content: that.showBank(bankLists),
        maskClosable:true,
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
    handleOk() {
      //确定删除
      let that = this;
      basicsDelete({ basicsIds: this.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          //   that.tableLoading = true;
          setTimeout(() => {
            that.visible = false;
            that.confirmLoading = false;
            that._basicsPage();
          }, 200);
        }
      });
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
.col-sql {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  display: inline-block;
  width: 200px;
  cursor: pointer;
  color: #faad14;
}
.deletes {
  color: #f5222d;
}
</style>