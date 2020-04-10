<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>系统配置</a-breadcrumb-item>
            <a-breadcrumb-item>基础配置</a-breadcrumb-item>
            <a-breadcrumb-item>轮播图管理</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">轮播图管理</span>
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
          <a-form layout="inline" :form="searchform" @submit="searchSubmit">
            <!-- 搜索框 -->

            <a-form-item label="类型">
              <a-select
                style="width:100px;"
                v-decorator="['type', {rules: [{ required: false, message: '请选择类型' }]}]"
              >
                <a-select-option :value="1">1</a-select-option>
                <a-select-option :value="2">2</a-select-option>
              </a-select>
            </a-form-item>
            <a-form-item label="名称">
              <a-input v-decorator="['bannerName']" placeholder="请输入名称"></a-input>
            </a-form-item>
            <a-form-item label="时间">
              <a-date-picker
                v-decorator="['date',{rules: [{ required: false, message: '请输入更新时间' }]}]"
              />
            </a-form-item>
            <a-form-item>
              <a-button type="primary" html-type="submit">搜索</a-button>
              <a-button :style="{marginLeft:'10px'}" @click="resetSearch">重置</a-button>
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
          :rowKey="record => record.bannerId"
          @change="handleTableChange"
          :scroll="{x:700}"
        >
          <template slot="picBanner" slot-scope="text,record">
            <img
              :src="text"
              alt="未找到图片"
              class="banner-image"
              @click="() => imgClick(record.bannerId,text)"
            />
          </template>
          <template slot="sort" slot-scope="text,record">
            <a-input
              style="width:50px"
              :defaultValue="text"
              @blur="e => handleBlur(e.target.value, record.bannerId,'sort')"
            />
          </template>
          <template slot="state" slot-scope="text,record">
            <a-switch
              checkedChildren="启用"
              unCheckedChildren="停用"
              :checked="text === 1"
              @change="() => stopbution(record.bannerId, record.state)"
            />
          </template>
          <template slot="action" slot-scope="text, record">
            <a
              style="margin-right:10px;"
              slot="action"
              @click="() => editor(record.bannerId,record)"
            >编辑</a>
            <span>
              <a class="deletes" @click="() => deletes(record.bannerId)">删除</a>
            </span>
          </template>
        </a-table>
      </a-layout-content>
      <a-modal
        centered
        title="修改轮播图配置"
        :visible="modify.visible"
        :confirmLoading="modify.confirmLoading"
        @cancel="modifyCancel"
        :footer="null"
      >
        <a-form :form="modifyform" @submit="modifySubmit">
          <a-form-item label="名称" :label-col="{ span: 5 }" :wrapper-col="{ span: 8 }">
            <a-input v-decorator="['bannerName',{initialValue: this.editValue.bannerName}]" />
          </a-form-item>
          <a-form-item label="类型" :label-col="{ span: 5 }" :wrapper-col="{ span: 8 }">
            <a-select v-decorator="['type', {initialValue: this.editValue.type}]">
              <a-select-option value="1">未知1</a-select-option>
              <a-select-option value="2">未知2</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="原图片" :label-col="{ span: 5 }">
            <img :src="editValue.pic" alt="未找到图片" class="banner-image" />
          </a-form-item>
          <a-form-item label="新图片" :label-col="{ span: 5 }">
            <div>
              <a-upload
                listType="picture"
                :fileList="fileListE"
                class="upload-list-inline"
                @preview="handlePreview"
                @change=" value => handleChange(value, editValue.bannerId)"
                :customRequest=" value => customRequest(value,editValue.bannerId)"
                v-decorator="['pic']"
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
          <a-form-item label="链接地址" :label-col="{ span: 5 }" :wrapper-col="{ span: 12}">
            <a-input v-decorator="['extFiled',{initialValue: this.editValue.extFiled}]" />
          </a-form-item>
          <a-form-item label="排序" :label-col="{ span: 5 }" :wrapper-col="{ span: 4}">
            <a-input v-decorator="['sort',{initialValue: this.editValue.sort}]" />
          </a-form-item>
          <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
            <a-button type="primary" html-type="submit">保存</a-button>
          </a-form-item>
        </a-form>
      </a-modal>
      <a-modal
        centered
        title="新增轮播图"
        :visible="addservice.visible"
        :confirmLoading="addservice.confirmLoading"
        @cancel="serviceCancel"
        :footer="null"
      >
        <a-form :form="serviceaddform" @submit="addserviceSubmit">
          <a-form-item label="名称" :label-col="{ span: 5 }" :wrapper-col="{ span: 8 }">
            <a-input v-decorator="['bannerName']" />
          </a-form-item>
          <a-form-item label="类型" :label-col="{ span: 5 }" :wrapper-col="{ span: 8 }">
            <a-select v-decorator="['type', {rules: [{ required: true, message: '请选择类型' }]}]">
              <a-select-option value="1">未知1</a-select-option>
              <a-select-option value="2">未知2</a-select-option>
            </a-select>
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
                v-decorator="['pic', {rules: [{ required: true, message: '请上传图片' }]}]"
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
          <a-form-item label="链接地址" :label-col="{ span: 5 }" :wrapper-col="{ span: 12}">
            <a-input v-decorator="['extFiled']" />
          </a-form-item>
          <a-form-item label="排序" :label-col="{ span: 5 }" :wrapper-col="{ span: 4}">
            <a-input v-decorator="['sort']" />
          </a-form-item>
          <a-form-item label="状态" :label-col="{ span: 5 }" :wrapper-col="{ span: 4}">
            <a-switch
              checkedChildren="启用"
              unCheckedChildren="停用"
              v-decorator="['state',{ initialValue: true,valuePropName: 'checked'}]"
            />
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
  bannerPage,
  bannerUpdate,
  bannerAdd,
  bannerDelete,
  uploadBanner
} from "api";
import moment from "moment";
const columns = [
  {
    title: "创建时间",
    dataIndex: "createTime",
    width: "10%",
    scopedSlots: { customRender: "createTime" },
    sorter: (a, b) =>
      moment(a.createTime).format("YYYY-MM-DD HH:mm:ss") >
      moment(b.createTime).format("YYYY-MM-DD HH:mm:ss")
  },
  {
    title: "名称",
    width: "10%",
    dataIndex: "bannerName"
  },
  {
    title: "类型",
    dataIndex: "type",
    width: "10%",
    scopedSlots: { customRender: "type" }
  },
  {
    title: "排序",
    dataIndex: "sort",
    width: "8%",
    scopedSlots: { customRender: "sort" }
  },
  {
    title: "图片",
    dataIndex: "pic",
    width: "10%",
    scopedSlots: { customRender: "picBanner" },
    key: "bannerId"
  },
  {
    title: "链接地址",
    dataIndex: "extFiled"
  },
  {
    title: "状态",
    dataIndex: "state",
    width: 100,
    scopedSlots: { customRender: "state" }
  },
  {
    title: "操作",
    dataIndex: "action",
    width: "10%",
    scopedSlots: { customRender: "action" }
  }
];

export default {
  data() {
    return {
      fileListE: [],
      fileList: [],
      previewVisible: false,
      previewImage: "",
      imgVisible: false,
      showImage: "",
      tableLoading: false,
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
      searchform: this.$form.createForm(this),
      modifyform: this.$form.createForm(this),
      serviceaddform: this.$form.createForm(this)
    };
  },

  created() {
    this._customerPage();
  },
  methods: {
    customRequest(data, id) {
      //自定义上传
      const formData = new FormData();
      formData.append("file", data.file);
      uploadBanner(formData).then(res => {
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
    handleCancelImg() {
      //取消放大图片
      this.previewVisible = false;
    },
    handlePreview(file) {
      //点击图片放大
      this.previewImage = file.url || file.thumbUrl;
      this.previewVisible = true;
    },
    handleChange(value, id) {
      // 上传片列表回调
      if (id) {
        this.fileListE = value.fileList;
      } else {
        this.fileList = value.fileList;
      }
    },
    cancelImg() {
      //取消放大图片外
      this.imgVisible = false;
    },
    imgClick(id, text) {
      //点击图片放大外
      this.imgVisible = true;
      this.showImage = text;
    },
    moment,
    _customerPage() {
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
      bannerPage(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        // console.log(res);
        // console.log(that.data);
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    handleBlur(value, id, column) {
      //失去焦点input
      const target = this.data.filter(item => id === item.bannerId)[0];
      if (value != target[column]) {
        let formData = new FormData();
        formData.append("bannerId", id);
        formData.append(column, value);
        bannerUpdate(formData).then(res => {
          if (res.code) {
            this.$message.success(res.msg);
          }
        });
      }
    },
    stopbution(id, status) {
      //状态切换
      let that = this;
      let target = that.data.filter(item => id === item.bannerId)[0];
      if (status == 1) {
        status = 0;
      } else {
        status = 1;
      }
      let formData = new FormData();
      formData.append("bannerId", id);
      formData.append("state", status);
      bannerUpdate(formData).then(res => {
        if (res.code) {
          status === 1
            ? that.$message.success("启用")
            : that.$message.success("停用");
          target.state = status;
        }
      });
    },
    addModal() {
      this.addservice.visible = true;
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
        values.bannerId = that.editId;
        let formData = new FormData();
        formData.append("bannerId", values.bannerId);
        formData.append("bannerName", values.bannerName);
        formData.append("extFiled", values.extFiled);
        formData.append("sort", values.sort);
        formData.append("type", values.type);
        if (values.pic) {
          if (values.pic.fileList[0]) {
            formData.append("pic", values.pic.fileList[0].url);
          } else {
            formData.append("pic", that.editValue.pic);
          }
        }
        if (!err) {
          bannerUpdate(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.modify.visible = false;
              that._customerPage();
              that.fileListE.splice(0, that.fileListE.length);
            }
          });
        }
      });
    },
    addserviceSubmit(e) {
      // 新增提交
      let that = this;
      e.preventDefault();
      that.serviceaddform.validateFields((err, values) => {
        let formData = new FormData();
        formData.append("bannerName", values.bannerName);
        formData.append("extFiled", values.extFiled);
        formData.append("sort", values.sort);
        formData.append("type", values.type);
        if (values.state) {
          formData.append("state", 1);
        } else {
          formData.append("state", 0);
        }

        if (values.pic) {
          if (values.pic.fileList[0]) {
            formData.append("pic", values.pic.fileList[0].url);
          }
        }
        if (!err) {
          bannerAdd(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.addservice.visible = false;
              that._customerPage();
              that.fileList.splice(0, that.fileList.length);
            }
          });
        }
      });
    },
    //重置搜索
    resetSearch() {
      this.searchform.resetFields();
      this._customerPage();
    },
    searchSubmit(e) {
      // 搜索提交
      e.preventDefault();
      this.searchform.validateFields((err, values) => {
        let target = {};
        if (values.bannerName) {
          target.bannerName = values.bannerName;
        }
        if (values.type) {
          target.type = values.type;
        }
        if (values.date) {
          target.createTime = values.date
            .format("YYYY-MM-DD")
            .concat(" 00:00:00");
        }
        Object.assign(this.queryParam, target);
        this.getTableList();
      });
    },

    modifyCancel() {
      //修改取消
      this.modify.visible = false;
      this.fileListE.splice(0, this.fileListE.length);
    },
    serviceCancel() {
      this.addservice.visible = false;
    },
    handleOk() {
      //确定删除
      let that = this;
      bannerDelete({ bannerId: this.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          setTimeout(() => {
            that.visible = false;
            that.confirmLoading = false;
            that._customerPage();
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
        content: "确定删除轮播图？",
        cancelText: "取消",
        okText: "确定",
        onOk() {
          that.handleOk();
        },
        onCancel() {}
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
.banner-image {
  width: 110px;
  height: 70px;
}
.deletes {
  color: #f5222d;
}
</style>