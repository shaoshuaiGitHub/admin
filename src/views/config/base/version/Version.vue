<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>系统配置</a-breadcrumb-item>
            <a-breadcrumb-item>基础配置</a-breadcrumb-item>
            <a-breadcrumb-item>APK版本更新管理</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">APK版本更新管理</span>
          </div>
        </div>
      </div>
    </div>
    <div class="wrap-children-content">
      <div :style="{marginLeft:'80px'}">
        <a-radio-group @change="onChange">
          <a-radio-button class="tab-btn1" :value="1">Android</a-radio-button>
          <a-radio-button class="tab-btn2" :value="2">IOS</a-radio-button>
        </a-radio-group>
      </div>
      <a-layout-content
        :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }"
      >
        <div
          class="headButton"
          :style="{display:'flex',flexDirection:'row',justifyContent:'space-between',marginBottom:'20px'}"
        >
          <a-form layout="inline" :form="searchform" @submit="searchSubmit">
            <!-- 搜索框 -->
            <a-form-item label="版本号">
              <a-input v-decorator="['versionNum']"></a-input>
            </a-form-item>
            <a-form-item label="是否上架">
              <a-select
                style="width:150px;"
                v-decorator="['isUse', {rules: [{ required: false, message: '请选择状态' }]}]"
              >
                <a-select-option :value="0">否</a-select-option>
                <a-select-option :value="1">是</a-select-option>
                <a-select-option value="null">全部</a-select-option>
              </a-select>
            </a-form-item>
            <a-row v-if="isCollapse">
              <a-col>
                <a-form-item label="是否强制升级">
                  <a-select
                    style="width:150px;"
                    v-decorator="['isMandatory', {rules: [{ required: false, message: '请选择状态' }]}]"
                  >
                    <a-select-option :value="0">否</a-select-option>
                    <a-select-option :value="1">是</a-select-option>
                    <a-select-option value="null">全部</a-select-option>
                  </a-select>
                </a-form-item>
              </a-col>
              <a-col>
                <a-form-item label="时间">
                  <a-date-picker
                    :disabledDate="disabledStartDate"
                    format="YYYY-MM-DD"
                    placeholder="开始日期"
                    @change="date => dateChangeStart(date)"
                    @openChange="handleStartOpenChange"
                    v-decorator="['startValue']"
                  />&nbsp;~
                  <a-form-item>
                    <a-date-picker
                      :disabledDate="disabledEndDate"
                      format="YYYY-MM-DD"
                      placeholder="结束日期"
                      @change="date => dateChangeEnd(date)"
                      :open="endOpen"
                      @openChange="handleEndOpenChange"
                      v-decorator="['endValue']"
                    />
                  </a-form-item>
                </a-form-item>
              </a-col>
            </a-row>
            <a-form-item>
              <a-button type="primary" html-type="submit">查询</a-button>
              <a-button :style="{marginLeft:'10px'}" @click="resetSearch">重置</a-button>
              <span style="margin-left:10px;cursor: pointer; color:#1899ff;" @click="openSearch">
                {{isCollapse ? '收起':'展开'}}
                <a-icon style="margin-left:3px;" :type="isCollapse ? 'up':'down'" />
              </span>
            </a-form-item>
          </a-form>
        </div>
        <div style="margin:20px 0;display:flex;flexDirection:row;justifyContent:flex-start">
          <a-button type="primary" icon="plus" @click="addModal">新增配置</a-button>
        </div>
        <a-table
          :loading="tableLoading"
          :columns="columns"
          :dataSource="data"
          :pagination="pagination"
          :rowKey="record => record.versionId"
          @change="handleTableChange"
          :scroll="{x:650}"
        >
          <template slot="type" slot-scope="text">
            <img
              v-if="text === 1"
              src="../../../../assets/Android1.png"
              alt="未找到图片"
              :style="{width:'25px',height:'25px'}"
            />
            <img
              v-else
              src="../../../../assets/iOS1.png"
              alt="未找到图片"
              :style="{width:'25px',height:'25px'}"
            />
          </template>
          <template slot="url" slot-scope="text,record">
            <span class="col-sql" @click="()=>versionUrl(record.versionId,record)">{{text}}</span>
          </template>
          <template slot="isUse" slot-scope="text, record">
            <a-switch
              checkedChildren="是"
              unCheckedChildren="否"
              :checked="text === 1"
              @change="() => stopbution(record.versionId, record.isUse,'isUse')"
            />
          </template>
          <template slot="isMandatory" slot-scope="text, record">
            <a-switch
              checkedChildren="是"
              unCheckedChildren="否"
              :defaultChecked="record.isMandatory === 1"
              @change="() => stopbution(record.versionId, record.isMandatory,'isMandatory')"
            />
          </template>
          <template slot="action" slot-scope="text, record">
            <a
              style="margin-right:10px;"
              slot="action"
              @click="() => editor(record.versionId,record)"
            >编辑</a>
            <span>
              <a class="deletes" @click="() => deletes(record.versionId)">删除</a>
            </span>
          </template>
        </a-table>
      </a-layout-content>
      <a-modal
        centered
        title="修改版本配置"
        :visible="modify.visible"
        :confirmLoading="modify.confirmLoading"
        @cancel="modifyCancel"
        :footer="null"
      >
        <a-form :form="modifyform" @submit="modifySubmit">
          <a-form-item label="版本号" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input
              v-decorator="['versionNum',{rules: [{ required: true, message: '请输入版本号!' }],initialValue: this.editValue.versionNum}]"
            />
          </a-form-item>
          <a-form-item label="版本类型" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-select
              style="width:100px;"
              v-decorator="['type',{rules: [{ required: true, message: '请选择版本类型!' }],initialValue: editValue.type }]"
            >
              <a-select-option :value="1">Android</a-select-option>
              <a-select-option :value="2">IOS</a-select-option>
            </a-select>
          </a-form-item>

          <a-form-item label="版本描述" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['description',{initialValue: this.editValue.description}]" />
          </a-form-item>
          <a-form-item label="上传apk" :label-col="{ span: 5 }" :wrapper-col="{ span: 12}">
            <div>
              <a-upload
                listType="text"
                :fileList="fileListE"
                class="upload-list-inline"
                @change=" value => handleChange(value, editValue.versionId)"
                :customRequest=" value => customRequest(value,editValue.versionId)"
                v-decorator="['url']"
              >
                <a-button v-if="fileListE.length < 1">
                  <a-icon type="upload" />上传
                </a-button>
              </a-upload>
            </div>
          </a-form-item>
          <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
            <a-button type="primary" html-type="submit">保存</a-button>
          </a-form-item>
        </a-form>
      </a-modal>
      <a-modal
        centered
        title="新增版本"
        :visible="addservice.visible"
        :confirmLoading="addservice.confirmLoading"
        @cancel="serviceCancel"
        :footer="null"
      >
        <a-form :form="serviceaddform" @submit="addserviceSubmit">
          <a-form-item label="版本号" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input
              v-decorator="['versionNum',{rules: [{ required: true, message: '请输入版本号!' }]}]"
            />
          </a-form-item>
          <a-form-item label="版本类型" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-select
              style="width:100px;"
              v-decorator="['type',{rules: [{ required: true, message: '请选择版本类型!' }]}]"
            >
              <a-select-option :value="1">Android</a-select-option>
              <a-select-option :value="2">IOS</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="版本描述" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['description']" />
          </a-form-item>
          <a-form-item label="上传apk" :label-col="{ span: 5 }" :wrapper-col="{ span: 12}">
            <div>
              <a-upload
                listType="text"
                :fileList="fileList"
                class="upload-list-inline"
                @change="handleChange"
                :customRequest="customRequest"
                v-decorator="['url',{rules: [{ required: true, message: '请上传apk文件!' }]}]"
              >
                <a-button v-if="fileList.length < 1">
                  <a-icon type="upload" />上传
                </a-button>
              </a-upload>
            </div>
          </a-form-item>

          <a-form-item label="是否强制升级" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch checkedChildren="是" unCheckedChildren="否" v-decorator="['isMandatory']" />
          </a-form-item>
          <!-- <a-form-item label="是否上架 " :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch checkedChildren="是" unCheckedChildren="否" v-decorator="['isUse']" />
          </a-form-item>-->
          <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
            <a-button type="primary" html-type="submit">保存</a-button>
          </a-form-item>
        </a-form>
      </a-modal>
    </div>
  </div>
</template>
<script>
import {
  versionPage,
  versionUpdate,
  versionAdd,
  versionDelete,
  uploadApk
} from "api";
import moment from "moment";
const columns = [
  {
    title: "创建时间",
    dataIndex: "createTime",
    scopedSlots: { customRender: "createTime" },
    sorter: (a, b) =>
      moment(a.createTime).format("YYYY-MM-DD HH:mm:ss") >
      moment(b.createTime).format("YYYY-MM-DD HH:mm:ss")
  },
  {
    title: "版本号",
    dataIndex: "versionNum"
  },
  {
    title: "版本类型",
    dataIndex: "type",
    scopedSlots: { customRender: "type" }
  },
  {
    title: "版本描述",
    dataIndex: "description",
    scopedSlots: { customRender: "description" }
  },
  {
    title: "更新地址",
    dataIndex: "url",
    scopedSlots: { customRender: "url" }
  },
  {
    title: "是否强制升级",
    dataIndex: "isMandatory",
    scopedSlots: { customRender: "isMandatory" }
  },
  {
    title: "是否上架 ",
    dataIndex: "isUse",
    scopedSlots: { customRender: "isUse" }
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
      isCollapse: false,
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
      editValue: {},
      confirmDirty: false,
      columns,
      ModalText: "Content of the modal",
      visible: false,
      roleOption: null,
      confirmLoading: false,
      formLayout: "horizontal",
      startValue: null,
      endValue: null,
      endOpen: false,
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
      firstParam: {
        pageNum: 0, //第几页
        pageSize: 10 //每页中显示数据的条数
      },
      typeParam: {
        pageNum: 0, //第几页
        pageSize: 10 //每页中显示数据的条数
      },
      searchform: this.$form.createForm(this),
      modifyform: this.$form.createForm(this),
      serviceaddform: this.$form.createForm(this),
      fileListE: [],
      fileList: []
    };
  },
  created() {
    this.queryParam = this.firstParam;
    this._versionPage();
  },
  methods: {
    moment,
    _versionPage() {
      //周期获取
      this.queryParam = this.typeParam;
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
      versionPage(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    onChange(e) {
      this.queryParam = this.firstParam;
      console.log(e.target.value);
      let target = {};
      target.type = e.target.value;
      this.queryParam = Object.assign({}, this.queryParam, target);
      this.typeParam = JSON.parse(JSON.stringify(this.queryParam));
      this.getTableList();
    },
    customRequest(data, id) {
      //自定义上传
      const formData = new FormData();
      formData.append("file", data.file);
      uploadApk(formData).then(res => {
        if (res.code) {
          if (id) {
            this.$message.success(res.msg);
            this.fileListE[0].status = "done";
            this.fileListE[0].url = res.data.url;
          } else {
            this.$message.success(res.msg);
            this.fileList[0].status = "done";
            this.fileList[0].url = res.data.url;
          }
        }
      });
    },
    handleChange(value, id) {
      // 上传片列表回调
      if (id) {
        this.fileListE = value.fileList;
      } else {
        this.fileList = value.fileList;
      }
    },

    stopbution(id, status, col) {
      //状态切换
      let that = this;
      const target = that.data.filter(item => id === item.versionId)[0];
      if (status == 1) {
        status = 0;
      } else {
        status = 1;
      }
      let formData = {};
      formData.versionId = id;
      formData[col] = status;
      versionUpdate(formData).then(res => {
        if (res.code && target) {
          if (res.code === 11111) {
            that.$message.success(res.msg);
            target[col] = 0;
          } else {
            status === 1
              ? that.$message.success("已经启用了该配置")
              : that.$message.success("已经停用了该配置");
            target[col] = status;
          }
        }
      });
    },
    editor(id, editValue) {
      //点击修改按钮
      this.editValue = editValue;
      this.editId = id;
      this.modify.visible = true;
    },
    // 修改用户
    modifySubmit(e) {
      let that = this;
      e.preventDefault();
      that.modifyform.validateFields((err, values) => {
        console.log(values);
        let formData = {};
        formData.versionId = that.editId;
        if (values.url) {
          if (values.url.fileList[0]) {
            formData.url = values.url.fileList[0].url;
          } else {
            formData.url = that.editValue.url;
          }
        }
        if (values.versionNum) {
          formData.versionNum = values.versionNum;
        }
        if (values.description) {
          formData.description = values.description;
        }
        if (values.type) {
          formData.type = values.type;
        }
        if (!err) {
          versionUpdate(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.modify.visible = false;
              that._versionPage();
              that.fileListE.splice(0, that.fileListE.length);
            }
          });
        }
      });
    },
    modifyCancel() {
      this.modify.visible = false;
      this.fileListE.splice(0, this.fileListE.length);
    },
    addModal() {
      this.addservice.visible = true;
    },
    addserviceSubmit(e) {
      let that = this;
      e.preventDefault();
      that.serviceaddform.validateFields((err, values) => {
        let formData = {};
        if (values.url) {
          if (values.url.fileList[0]) {
            formData.url = values.url.fileList[0].url;
          }
        }
        if (values.versionNum) {
          formData.versionNum = values.versionNum;
        }
        if (values.description) {
          formData.description = values.description;
        }
        if (values.type) {
          formData.type = values.type;
        }
        if (values.isMandatory) {
          if (values.isMandatory === true) {
            formData.isMandatory = 1;
          } else {
            formData.isMandatory = 0;
          }
        }
        console.log(formData);
        if (!err) {
          versionAdd(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.addservice.visible = false;
              that._versionPage();
              that.fileList.splice(0, that.fileList.length);
            }
          });
        }
      });
    },
    serviceCancel() {
      this.addservice.visible = false;
    },
    // 时间范围模块
    dateChangeStart(value) {
      this.startValue = value;
    },
    dateChangeEnd(value) {
      this.endValue = value;
    },
    disabledStartDate(startValue) {
      const endValue = this.endValue;
      if (!startValue || !endValue) {
        return false;
      }
      return startValue.valueOf() > endValue.valueOf();
    },
    disabledEndDate(endValue) {
      const startValue = this.startValue;
      if (!endValue || !startValue) {
        return false;
      }
      return startValue.valueOf() >= endValue.valueOf();
    },
    handleStartOpenChange(open) {
      if (!open) {
        this.endOpen = true;
      }
    },
    handleEndOpenChange(open) {
      this.endOpen = open;
    },
    //重置搜索
    resetSearch() {
      this.searchform.resetFields();
      this._versionPage();
    },
    // 搜索框展开
    openSearch() {
      this.isCollapse = !this.isCollapse;
    },
    searchSubmit(e) {
      this.queryParam = this.typeParam;
      e.preventDefault();
      this.searchform.validateFields((err, values) => {
        console.log(values);
        let target = {};
        if (values.isUse === "null") {
          values.isUse = null;
        }
        if (values.isMandatory === "null") {
          values.isMandatory = null;
        }
        if (values.startValue) {
          values.startTime = values.startValue
            .format("YYYY-MM-DD")
            .concat(" 00:00:00");
        }
        if (values.endValue) {
          values.endTime = values.endValue
            .format("YYYY-MM-DD")
            .concat(" 23:59:59");
        }
        target.isUse = values.isUse;
        target.isMandatory = values.isMandatory;
        target.endTime = values.endTime;
        target.startTime = values.startTime;
        target.versionNum = values.versionNum;
        this.queryParam = Object.assign({}, this.queryParam, target);
        this.getTableList();
      });
    },

    deletes(id) {
      //删除事件
      let that = this;
      this.delID = id;
      that.$modal.confirm({
        centered: true,
        title: "请确定",
        content: "确定删除该版本？",
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
      versionDelete({ versionId: this.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          //   that.tableLoading = true;
          setTimeout(() => {
            that.visible = false;
            that.confirmLoading = false;
            that._versionPage();
          }, 200);
        }
      });
    },
    versionUrl(versionId, record) {
      // 关联银行展示
      let that = this;
      that.$modal.info({
        centered: true,
        title: record.versionNum + "版本更新地址",
        content: record.url,
        maskClosable: true
      });
    }
  }
};
</script>
<style scoped>
.deletes {
  color: #f5222d;
}
.col-sql {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  display: inline-block;
  width: 200px;
  color: #faad14;
  cursor: pointer;
}
.tab-btn1 {
  margin-right: 100px;
  width: 150px;
  height: 50px;
  padding: 10px;
  font-family: Helvetica Neue, Helvetica, Roboto, Arial, sans-serif;
  font-size: 20px;
  background: url("../../../../assets/Android1.png") no-repeat 12px 4px;
  background-size: 40px 40px;
  background-color: rgba(226, 220, 198, 0.8);
  text-align: right;
  line-height: 30px;
}
.tab-btn2 {
  margin-right: 100px;
  width: 150px;
  height: 50px;
  padding: 10px 30px 10px 10px;
  font-family: Helvetica Neue, Helvetica, Roboto, Arial, sans-serif;
  font-size: 20px;
  background: url("../../../../assets/iOS1.png") no-repeat 20px 4px;
  background-size: 38px 38px;
  background-color: rgba(226, 220, 198, 0.8);
  text-align: right;
  line-height: 30px;
}
</style>