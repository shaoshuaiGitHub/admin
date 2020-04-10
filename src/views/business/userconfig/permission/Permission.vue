<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>功能业务配置</a-breadcrumb-item>
            <a-breadcrumb-item>会员相关配置</a-breadcrumb-item>
            <a-breadcrumb-item>会员权限配置</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">会员权限配置</span>
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
          <a-form layout="inline" :form="searchform" @submit="searchSubmit" style="margin-top:8px">
            <!-- 搜索框 -->

            <a-form-item label="功能名称">
              <a-input v-decorator="['pmsName']" />
            </a-form-item>
            <a-form-item label="时间">
              <a-date-picker v-decorator="['date',{rules: [{ required: false }]}]" />
            </a-form-item>
            <a-form-item>
              <a-button type="primary" html-type="submit">搜索</a-button>
               <a-button :style="{marginLeft:'10px'}" @click="resetSearch">重置</a-button>
            </a-form-item>
          </a-form>
        </div>
        <div style="margin:20px 0;display:flex;flexDirection:row;justifyContent:flex-start">
          <a-button type="primary" style="margin-right:50px" @click="saveall">保存修改</a-button>
          <a-button type="primary" icon="form" @click="addModal">新增配置</a-button>
        </div>
        <a-table
          :loading="tableLoading"
          :columns="columns"
          :dataSource="data"
          :pagination="pagination"
          :rowKey="record => record.permissionId"
          @change="handleTableChange"
          :scroll="{x:900}"
        >
          <template slot="sort" slot-scope="text, record">
            <a-input
              style="width:50px"
              :defaultValue="text"
              class="sort-input"
              @change="e => changeInput(e.target.value, record.permissionId,'sort')"
            />
          </template>
          <template slot="pmsIcon" slot-scope="text">
            <img :src="text" alt="未找到图片" class="pms-icon" @click="() => imgClick(text)" />
          </template>
          <template slot="goodsIds" slot-scope="text,record">
            <a-checkbox-group
              :options="checks"
              :defaultValue="text"
              @change="value => changeInput(value, record.permissionId,'goodsIds')"
              :style="{'width':'180px'}"
            />
          </template>
          <template slot="pmsStatus" slot-scope="text,record">
            <a-switch
              checkedChildren="启用"
              unCheckedChildren="停用"
              :defaultChecked="record.pmsStatus === 1"
              @change="() => stopbution(record.permissionId, record.pmsStatus)"
            />
          </template>
          <template slot="action" slot-scope="text, record">
            <a
              style="margin-right:10px;"
              slot="action"
              @click="() => editor(record.permissionId,record)"
            >编辑</a>
            <a
              style="margin-right:10px;"
              class="deletes"
              @click="() => deletes(record.permissionId)"
            >删除</a>
          </template>
        </a-table>
      </a-layout-content>
      <a-modal
        centered
        title="修改会员权限配置"
        :visible="modify.visible"
        :confirmLoading="modify.confirmLoading"
        @cancel="modifyCancel"
        :footer="null"
      >
        <a-form :form="modifyform" @submit="modifySubmit">
          <a-form-item label="功能名称" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input
              v-decorator="['pmsName',{rules: [{ required: true, message: '请输入功能名称' }],initialValue: editValue.pmsName}]"
            />
          </a-form-item>
          <a-form-item label="功能key" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input
              v-decorator="['pmsKey',{rules: [{ required: true, message: '请输入功能key' }],initialValue: editValue.pmsKey}]"
            />
          </a-form-item>
          <a-form-item label="功能描述" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input
              v-decorator="['description',{rules: [{ required: true, message: '请输入功能描述' }],initialValue: editValue.description}]"
            />
          </a-form-item>
          <a-form-item label="图片" :label-col="{ span: 5 }" :wrapper-col="{ span: 4}">
            <div>
              <a-upload
                listType="picture"
                :fileList="fileListE"
                class="upload-list-inline"
                @preview="handlePreview"
                @change=" value => handleChange(value, this.editValue.permissionId)"
                :customRequest=" value => customRequest(value, this.editValue.permissionId)"
                v-decorator="['pmsIcon', {rules: [{ required: false, message: '请上传图片' }]}]"
              >
                <a-button v-if="fileListE.length < 1">
                  <a-icon type="upload" />upload
                </a-button>
              </a-upload>
            </div>
            <a-modal :visible="previewVisible" :footer="null" @cancel="handleCancelImg">
              <img alt="example" style="width: 100%" :src="previewImage" />
            </a-modal>
          </a-form-item>
          <a-form-item label="服务状态" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch
              checkedChildren="启用"
              unCheckedChildren="停用"
              v-decorator="['pmsStatus',{ initialValue: editValue.pmsStatus === 1,valuePropName: 'checked'}]"
            />
          </a-form-item>
          <a-form-item label="适用会员" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-checkbox
              v-decorator="['check1',{ initialValue: editValue.check1,valuePropName: 'checked'}]"
              @change=" value => onCheckAllChange(value, this.editValue.permissionId)"
            >全选</a-checkbox>
            <a-form-item>
              <a-checkbox-group
                :options="checks"
                v-decorator="['goodsIds',{ initialValue: editValue.goodsIds}]"
                @change=" value => onChange(value, this.editValue.permissionId)"
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
        title="新增功能权限配置"
        :visible="addservice.visible"
        :confirmLoading="addservice.confirmLoading"
        @cancel="serviceCancel"
        :footer="null"
      >
        <a-form :form="serviceaddform" @submit="addserviceSubmit">
          <a-form-item label="功能名称" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['pmsName',{rules: [{ required: true, message: '请输入功能名称' }]}]" />
          </a-form-item>
          <a-form-item label="功能key" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['pmsKey',{rules: [{ required: true, message: '请输入功能key' }]}]" />
          </a-form-item>
          <a-form-item label="功能描述" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input
              v-decorator="['description',{rules: [{ required: true, message: '请输入功能描述' }]}]"
            />
          </a-form-item>
          <a-form-item label="图片" :label-col="{ span: 5 }" :wrapper-col="{ span: 4}">
            <div>
              <a-upload
                listType="picture"
                :fileList="fileList"
                class="upload-list-inline"
                @preview="handlePreview"
                @change="handleChange"
                :customRequest="customRequest"
                v-decorator="['pmsIcon', {rules: [{ required: true, message: '请上传图片' }]}]"
              >
                <a-button v-if="fileList.length < 1">
                  <a-icon type="upload" />upload
                </a-button>
              </a-upload>
            </div>
            <a-modal :visible="previewVisible" :footer="null" @cancel="handleCancelImg">
              <img alt="example" style="width: 100%" :src="previewImage" />
            </a-modal>
          </a-form-item>
          <a-form-item label="服务状态" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch
              checkedChildren="启用"
              unCheckedChildren="停用"
              defaultChecked
              v-decorator="['pmsStatus']"
            />
          </a-form-item>
          <a-form-item label="适用会员" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-checkbox v-decorator="['checked']" @change="onCheckAllChange" :checked="checkAll">全选</a-checkbox>
            <a-checkbox-group :options="checks" :value="checkedList" @change="onChange" />
          </a-form-item>
          <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
            <a-button type="primary" html-type="submit">保存</a-button>
          </a-form-item>
        </a-form>
      </a-modal>
      <a-modal :visible="imgVisible" :footer="null" @cancel="cancelImg">
        <img alt="example" style="width: 100%" :src="showImage" />
      </a-modal>
    </div>
  </div>
</template>
<script>
import {
  permissionPage,
  permissionAdd,
  permissionUpdate,
  permissionDelete,
  uploadUse
} from "api";
import moment from "moment";
const columns = [
  {
    title: "排序",
    dataIndex: "sort",
    scopedSlots: { customRender: "sort" }
  },
  {
    title: "创建时间",
    dataIndex: "pmsCreateTime",
    scopedSlots: { customRender: "pmsCreateTime" }
  },

  {
    title: "功能名称",
    dataIndex: "pmsName",
    scopedSlots: { customRender: "pmsName" }
  },
  {
    title: "功能描述",
    dataIndex: "description",
    scopedSlots: { customRender: "description" }
  },
  {
    title: "功能图标",
    dataIndex: "pmsIcon",
    scopedSlots: { customRender: "pmsIcon" }
  },
  {
    title: "适用会员",
    dataIndex: "goodsIds",
    scopedSlots: { customRender: "goodsIds" }
  },
  {
    title: "状态",
    dataIndex: "pmsStatus",
    scopedSlots: { customRender: "pmsStatus" }
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
      checks: [
        { label: "初级vip", value: 1 },
        { label: "中级vip", value: 2 },
        { label: "高级vip", value: 3 },
        { label: "至尊vip", value: 4 }
      ],
      checkedList: [],
      allcheck: [1, 2, 3, 4],
      checkAll: false,
      fileList: [],
      fileListE: [],
      previewVisible: false,
      previewImage: "",
      imgVisible: false, //以上传图片的放大页面key外
      showImage: "", //放大图片rul外
      tableLoading: true,
      data: null,
      addservice: {
        visible: false,
        confirmLoading: true
      },
      modify: {
        visible: false,
        confirmLoading: true
      },
      editValue: { check1: false },
      pmsType: false,
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
      firstParam: {
        pageNum: 0, //第几页
        pageSize: 10 //每页中显示数据的条数
      },
      searchform: this.$form.createForm(this),
      modifyform: this.$form.createForm(this),
      serviceaddform: this.$form.createForm(this)
    };
  },

  created() {
    this._permissionPage();
  },
  methods: {
    moment,
    _permissionPage() {
      //周期获取
      this.queryParam = this.firstParam;
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
      permissionPage(that.queryParam).then(res => {
        if (res.code) {
          const pagination = { ...that.pagination };
          pagination.total = res.data.total;
          that.pagination = pagination;
          that.data = res.data.list;
          setTimeout(() => {
            that.tableLoading = false;
          }, 200);
        }
      });
    },
    customRequest(data, id) {
      console.log(id);
      //自定义上传
      const formData = new FormData();
      formData.append("file", data.file);
      uploadUse(formData).then(res => {
        if (res.code) {
          this.$message.success(res.msg);
          if (id) {
            this.fileListE[0].status = "done";
            this.fileListE[0].url = res.data.url;
          } else {
            this.fileList[0].status = "done";
            this.fileList[0].url = res.data.url;
          }
        }
      });
    },

    handleCancelImg() {
      //取消放大图片
      this.previewVisible = false;
    },
    handlePreview(file) {
      //点击图片放大
      this.previewImage = file.url || file.thumbUrl;
      this.previewVisible = true;
    },
    cancelImg() {
      //取消放大图片外
      this.imgVisible = false;
    },
    imgClick(text) {
      //点击图片放大外
      this.imgVisible = true;
      this.showImage = text;
    },
    handleChange({ fileList }, id) {
      // 上传片列表回调
      if (id) {
        this.fileListE = fileList;
      } else {
        this.fileList = fileList;
      }
    },
    onChange(checkedList, id) {
      //多选框子项回调
      if (id == this.editId) {
        this.editValue.goodsIds = checkedList;
        this.editValue.check1 =
          this.editValue.goodsIds.length === this.allcheck.length
            ? true
            : false;
        this.modifyform.resetFields();
      }
      this.checkedList = checkedList;
      this.checkAll =
        checkedList.length === this.allcheck.length ? true : false;
    },

    onCheckAllChange(e, id) {
      //全选回调
      if (id == this.editId) {
        this.editValue.goodsIds = e.target.checked ? this.allcheck : [];
        this.editValue.check1 = e.target.checked;
        this.modifyform.resetFields();
      }
      this.checkedList = e.target.checked ? this.allcheck : [];
      this.checkAll = e.target.checked;
    },

    changeInput(value, id, column) {
      //监听值变化
      const newData = [...this.data];
      const target = newData.filter(item => id === item.permissionId)[0];
      console.log(value, id, column);
      if (target) {
        target[column] = value;
        target.editable = true;
        this.data = newData;
      }
    },

    stopbution(id, status) {
      //状态切换
      let that = this;
      const newData = [...that.data];
      const target = newData.filter(item => id === item.permissionId)[0];
      if (status == 1) {
        status = 0;
      } else {
        status = 1;
      }
      let formData = new FormData();
      formData.append("permissionId", id);
      formData.append("pmsStatus", status);
      permissionUpdate(formData).then(res => {
        if (res.code && target) {
          status === 1
            ? that.$message.success("已经启用了该账号")
            : that.$message.success("已经停用了该账号");
          target.pmsStatus = status;
        }
      });
    },
    editor(id, editValue) {
      //点击修改按钮
      editValue.check1 =
        editValue.goodsIds.length === this.allcheck.length ? true : false;
      this.editValue = editValue;
      this.editId = id;
      this.modify.visible = true;
      this.modifyform.resetFields();
    },
    modifySubmit(e) {
      // 修改用户
      let that = this;
      e.preventDefault();
      that.modifyform.validateFields((err, values) => {
        // console.log(values);
        values.permissionId = that.editId;
        if (values.pmsStatus) {
          values.pmsStatus = 1;
        } else {
          values.pmsStatus = 0;
        }
        let formData = new FormData();
        formData.append("permissionId", values.permissionId);
        formData.append("description", values.description);
        formData.append("pmsKey", values.pmsKey);
        formData.append("pmsName", values.pmsName);
        formData.append("pmsStatus", values.pmsStatus);

        formData.append("goodsIds", values.goodsIds);
        if (values.pmsIcon) {
          if (values.pmsIcon.fileList[0]) {
            formData.append("pmsIcon", values.pmsIcon.fileList[0].url);
          } else {
            formData.append("pmsIcon", that.editValue.pmsIcon);
          }
        }
        if (!err) {
          permissionUpdate(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.modify.visible = false;
              that._permissionPage();
              that.fileListE.splice(0, that.fileListE.length);
            }
          });
        }
      });
    },
    modifyCancel() {
      //修改页面撤销
      this.modify.visible = false;
      this.fileListE.splice(0, this.fileListE.length);
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
        // console.log(that.tarImgUrl);
        if (values.pmsStatus) {
          values.pmsStatus = 1;
        } else {
          values.pmsStatus = 0;
        }
        let formData = new FormData();
        formData.append("description", values.description);
        formData.append("pmsKey", values.pmsKey);
        formData.append("pmsName", values.pmsName);
        formData.append("pmsStatus", values.pmsStatus);
        if (values.pmsIcon) {
          if (values.pmsIcon.fileList[0]) {
            formData.append("pmsIcon", values.pmsIcon.fileList[0].url);
          }
        }
        if (values.checked) {
          formData.append("goodsIds", that.allcheck);
        } else {
          formData.append("goodsIds", that.checkedList);
        }
        if (!err) {
          permissionAdd(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.addservice.visible = false;
              that.checkedList = [];
              that.checkAll = false;
              that._permissionPage();
              that.fileList.splice(0, that.fileList.length);
            }
          });
        }
      });
    },
    serviceCancel() {
      //新增页面撤销
      this.addservice.visible = false;
      this.checkedList = [];
      this.checkAll = false;
    },
    //重置搜索
    resetSearch() {
      this.searchform.resetFields();
      this._permissionPage();
    },
    searchSubmit(e) {
      // 搜索提交
      this.queryParam = this.firstParam;
      e.preventDefault();
      this.searchform.validateFields((err, values) => {
        let target = {};
        if (values.pmsName) {
          target.pmsName = values.pmsName;
        }
        if (values.date) {
          target.pmsCreateTime = values.date
            .format("YYYY-MM-DD")
            .concat(" 00:00:00");
        }
        this.queryParam = Object.assign({}, this.queryParam, target);
        this.getTableList();
      });
    },
    saveall() {
      //保存修改
      const target = this.data.filter(item => true === item.editable);
      //   console.log(target);
      for (var i = 0; i < target.length; i++) {
        const formData = new FormData();
        formData.append("permissionId", target[i].permissionId);
        formData.append("sort", target[i].sort);
        formData.append("goodsIds", target[i].goodsIds);
        permissionUpdate(formData).then(res => {
          if (res.code) {
            this.$message.success(res.msg);
          }
        });
        delete target[i].editable;
      }
    },

    deletes(id) {
      //删除事件
      let that = this;
      this.delID = id;
      that.$modal.confirm({
        centered: true,
        title: "请确定",
        content: "确定删除该权限配置？",
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
      permissionDelete({ permissionIds: this.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          //   that.tableLoading = true;
          setTimeout(() => {
            that.visible = false;
            that.confirmLoading = false;
            that.modifyform.resetFields();
            that._permissionPage();
          }, 200);
        }
      });
    }
  }
};
</script>
<style scoped>
.upload-list-inline >>> .ant-upload-list-item {
  float: left;
  width: 200px;
  margin-right: 8px;
}
.upload-list-inline >>> .ant-upload-animate-enter {
  animation-name: uploadAnimateInlineIn;
}
.upload-list-inline >>> .ant-upload-animate-leave {
  animation-name: uploadAnimateInlineOut;
}
.pms-icon {
  width: 120px;
  height: 60px;
  cursor: pointer;
}
.sort-input {
  color: #1890ff;
  border: none;
  border-bottom: 1px solid white !important;
  box-shadow: none;
}
.deletes {
  color: #f5222d;
}
</style>