<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>银行管理</a-breadcrumb-item>
            <a-breadcrumb-item>银行列表</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">银行列表</span>
            ————&nbsp;&nbsp;
            <a-button type="primary" icon="sync" :loading="reloadings" @click="reloadFun">刷新</a-button>&nbsp;&nbsp;————
          </div>
        </div>
      </div>
    </div>
    <div class="wrap-children-content">
      <a-layout-content
        :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }"
      >
        <!-- 头部按钮 -->
        <div
          class="headButton"
          :style="{display:'flex',flexDirection:'row',justifyContent:'flex-start',marginBottom:'20px'}"
        >
          <a-button type="primary" icon="plus" @click="addModal">新增配置</a-button>
        </div>
        
        <!-- 主表格 -->
        <a-table
          bordered
          :loading="tableLoading"
          :pagination="pagination"
          :columns="columns"
          :dataSource="data"
          :rowKey="record => record.bankId"
          @change="handleTableChange"
          :scroll="{x:700}"
        >
          <template slot="bankIcon" slot-scope="text">
            <img :src="text" alt="未找到图片" class="bank-icon" />
          </template>
          <template slot="bankBg" slot-scope="text,record">
            <div>{{text}}</div>
            <div
              :style="{'width':'80px','height':'40px','borderRadius':'5px','backgroundColor':record.bankBg}"
            ></div>
          </template>
          <template slot="bankIcon" slot-scope="text">
            <img :src="text" alt="未找到图片" class="bank-icon"/>
          </template>
          <template slot="iconBg" slot-scope="text">
            <img :src="text" alt="未找到图片" class="bank-bg" @click="() => imgClick(text)" />
          </template>
          <template slot="bankStatus" slot-scope="text,record">
            <a-switch
              checkedChildren="启用"
              unCheckedChildren="停用"
              :defaultChecked="record.bankStatus == 0"
              @change="() => stopbution(record.bankId, record.bankStatus)"
            />
          </template>
          <template slot="action" slot-scope="text, record">
            <a-button
              type="primary"
              slot="action"
              style="margin:10px 5px;"
              @click="() => editor(record.bankId,record)"
            >编辑</a-button>
            <a-button
              type="primary"
              slot="action"
              style="margin:10px 5px;"
              @click="() => parameter(record.bankId,record.bankName)"
            >提示语信息</a-button>
            <a-button class="deletes" type="danger" @click="() => deletes(record.bankId)" style="margin:10px 5px;">删除</a-button>
          </template>
        </a-table>
        <!-- 修改弹窗 -->
        <a-modal
          centered
          title="修改银行信息配置"
          :visible="modify.visible"
          :confirmLoading="modify.confirmLoading"
          @cancel="modifyCancel"
          :footer="null"
        >
          <a-form :form="modifyform" @submit="modifySubmit">
            <a-form-item label="银行名称" :label-col="{ span: 5 }" :wrapper-col="{ span: 8 }">
              <a-input v-decorator="['bankName',{initialValue: this.editValue.bankName}]" />
            </a-form-item>
            <a-form-item label="银行缩写" :label-col="{ span: 5 }" :wrapper-col="{ span: 8 }">
              <a-input v-decorator="['bankVal',{initialValue: this.editValue.bankVal}]" />
            </a-form-item>
            <a-form-item label="背景颜色" :label-col="{ span: 5 }" :wrapper-col="{ span: 16 }">
              <template>
                <colorPicker class="color" v-model="color" @change="headleChangeColor" />
              </template>
            </a-form-item>
            <a-form-item label="新图标" :label-col="{ span: 5 }" :wrapper-col="{ span: 4}">
              <div>
                <a-upload
                  listType="picture"
                  :defaultFileList="fileListE"
                  class="upload-list-inline"
                  @preview="handlePreview"
                  @change=" value => handleChange(value, 'bankIcon')"
                  :customRequest=" value => customRequest(value, 'bankIcon')"
                  v-decorator="['bankIcon']"
                >
                  <a-button v-if="fileListE.length < 1">
                    <a-icon type="uploadicon" />upload
                  </a-button>
                </a-upload>
              </div>
              <a-modal :visible="previewVisible" :footer="null" @cancel="handleCancelImg">
                <img alt="example" style="width: 100%" :src="previewImage" />
              </a-modal>
            </a-form-item>
            <a-form-item label="新背景图" :label-col="{ span: 5 }" :wrapper-col="{ span: 4}">
              <div>
                <a-upload
                  listType="picture"
                  :defaultFileList="fileList"
                  class="upload-list-inline"
                  @preview="handlePreview"
                  @change=" value => handleChange(value, 'iconBg')"
                  :customRequest=" value => customRequest(value, 'iconBg')"
                  v-decorator="['iconBg']"
                >
                  <a-button v-if="fileList.length < 1">
                    <a-icon type="uploadImg" />upload
                  </a-button>
                </a-upload>
              </div>
              <a-modal :visible="previewVisible" :footer="null" @cancel="handleCancelImg">
                <img alt="example" style="width: 100%" :src="previewImage" />
              </a-modal>
            </a-form-item>
            <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
              <a-button type="primary" html-type="submit">保存</a-button>
            </a-form-item>
          </a-form>
        </a-modal>
        <!-- 新增弹窗 -->
        <a-modal
          centered
          title="新增银行"
          :visible="addservice.visible"
          :confirmLoading="addservice.confirmLoading"
          @cancel="serviceCancel"
          :footer="null"
        >
          <a-form :form="serviceaddform" @submit="addserviceSubmit">
            <a-form-item label="银行名称" :label-col="{ span: 5 }" :wrapper-col="{ span: 8 }">
              <a-input v-decorator="['bankName']" />
            </a-form-item>
            <a-form-item label="银行缩写" :label-col="{ span: 5 }" :wrapper-col="{ span: 8 }">
              <a-input v-decorator="['bankVal']" />
            </a-form-item>
            <a-form-item label="平均卡额度" :label-col="{ span: 5 }" :wrapper-col="{ span: 8 }">
              <a-input v-decorator="['averageQuota']" />
            </a-form-item>
            <a-form-item label="最高卡额度" :label-col="{ span: 5 }" :wrapper-col="{ span: 8 }">
              <a-input v-decorator="['maxQuota']" />
            </a-form-item>
            <a-form-item label="背景颜色" :label-col="{ span: 5 }" :wrapper-col="{ span: 8 }">
              <template>
                <colorPicker class="color" v-model="color" @change="headleChangeColor" />
              </template>
            </a-form-item>
            <a-form-item label="银行状态" :label-col="{ span: 5 }" :wrapper-col="{ span: 8 }">
              <a-switch checkedChildren="启用" unCheckedChildren="停用" v-decorator="['bankStatus']" />
            </a-form-item>
            <a-form-item label="图标" :label-col="{ span: 5 }" :wrapper-col="{ span: 4}">
              <div>
                <a-upload
                  listType="picture"
                  :defaultFileList="fileListEN"
                  class="upload-list-inline"
                  @preview="handlePreview"
                  @change=" value => handleChange(value, 'bankIcon','add')"
                  :customRequest=" value => customRequest(value, 'bankIcon','add')"
                  v-decorator="['bankIcon']"
                >
                  <a-button v-if="fileListEN.length < 1">
                    <a-icon type="uploadicon" />upload
                  </a-button>
                </a-upload>
              </div>
              <a-modal :visible="previewVisible" :footer="null" @cancel="handleCancelImg">
                <img alt="example" style="width: 100%" :src="previewImage" />
              </a-modal>
            </a-form-item>
            <a-form-item label="背景图" :label-col="{ span: 5 }" :wrapper-col="{ span: 4}">
              <div>
                <a-upload
                  listType="picture"
                  :defaultFileList="fileListN"
                  class="upload-list-inline"
                  @preview="handlePreview"
                  @change=" value => handleChange(value, 'iconBg','add')"
                  :customRequest=" value => customRequest(value, 'iconBg','add')"
                  v-decorator="['iconBg']"
                >
                  <a-button v-if="fileListN.length < 1">
                    <a-icon type="uploadImg" />upload
                  </a-button>
                </a-upload>
              </div>
              <a-modal :visible="previewVisible" :footer="null" @cancel="handleCancelImg">
                <img alt="example" style="width: 100%" :src="previewImage" />
              </a-modal>
            </a-form-item>
            <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
              <a-button type="primary" html-type="submit">保存</a-button>
            </a-form-item>
          </a-form>
        </a-modal>
        <a-modal :visible="imgVisible" :footer="null" @cancel="cancelImg">
          <img alt="example" style="width: 100%" :src="showImage" />
        </a-modal>
      </a-layout-content>
    </div>
  </div>
</template>
<script>
import { bankList, addBank, updateBank, uploadIcon, deleteBank } from "api";
import {
  setContextData,
  getContextData,
  removeContextData
} from "../../../common/js/util";
import { Photoshop } from "vue-color";
const columns = [
  {
    title: "银行图标",
    dataIndex: "bankIcon",
    width: "5%",
    scopedSlots: { customRender: "bankIcon" }
  },
  {
    title: "银行名称",
    dataIndex: "bankName",
    scopedSlots: { customRender: "bankName" }
  },
  {
    title: "背景图片",
    dataIndex: "iconBg",
    width: "10%",
    scopedSlots: { customRender: "iconBg" }
  },
  {
    title: "背景颜色",
    dataIndex: "bankBg",
    scopedSlots: { customRender: "bankBg" }
  },
  {
    title: "银行ID",
    dataIndex: "bankId",
    scopedSlots: { customRender: "bankId" }
  },
  {
    title: "银行英文缩写",
    dataIndex: "bankVal",
    scopedSlots: { customRender: "bankVal" }
  },
  {
    title: "银行卡状态",
    dataIndex: "bankStatus",
    scopedSlots: { customRender: "bankStatus" }
  },
  {
    title: "操作",
    dataIndex: "action",
    scopedSlots: { customRender: "action" }
  }
];

export default {
  inject: ["reload"], //重载函数
  data() {
    return {
      color: "",
      reloadings: true,
      tableLoading: true,
      data: null, //table数据源
      columns, //table模板
      modify: {
        // 编辑页面属性
        visible: false,
        confirmLoading: true
      },
      modifyform: this.$form.createForm(this), //编辑表单创建
      addservice: {
        //新增页面属性
        visible: false,
        confirmLoading: true
      },
      serviceaddform: this.$form.createForm(this), //新增form表单创建
      editValue: {}, //当前修改的一行数据
      fileListE: [], // 编辑 icon图片
      fileList: [], // 编辑 bg图片
      fileListEN: [], //新增图片
      fileListN: [],
      previewImage: "", //放大图片rul
      previewVisible: false, //以上传图片的放大页面key
      imgVisible: false,//以上传图片的放大页面key外
      showImage: "", //放大图片rul外
      pagination: {
        //分页
        total: 0,
        defaultCurrent: 1,
        defaultPageSize: 10,
        showTotal: total => `共 ${total} 条数据`,
        showSizeChanger: true,
        pageSizeOptions: ["5", "10", "15", "20"],
        showQuickJumper: true
      },
      queryParam: {}, //当前参数
      key: this.$route.meta.key[0]
    };
  },
  created() {
    this.pagination.current = getContextData("currentPage" + this.key) || 1;
    this.queryParam.pageNum = this.pagination.current;
    this._banklist();
  },
  mounted: function() {
    setContextData();
    getContextData();
    removeContextData();
  },
  methods: {
    // 刷新页面
    reloadFun() {
      this.reloadings = true;
      removeContextData("currentPage" + this.key);
      this.reload();
    },
    _banklist() {
      //周期获取
      this.getTableList();
    },
    handleTableChange(pagination) {
      //分页跳转
      this.pagination.current = pagination.current;
      this.pagination.pageSize = pagination.pageSize;
      this.queryParam.pageNum = pagination.current;
      this.queryParam.pageSize = pagination.pageSize;
      setContextData("currentPage" + this.key, this.pagination.current);
      this.tableLoading = true;
      this.getTableList();
    },
    getTableList() {
      //获取列表
      let that = this;
      bankList(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        that.tableLoading = false;
        that.reloadings = false;
      });
    },
    stopbution(id, status) {
      //状态切换
      let that = this;
      const newData = [...that.data];
      const target = newData.filter(item => id === item.bankId)[0];
      if (status == 1) {
        status = 0;
      } else {
        status = 1;
      }
      let formData = {};
      formData.bankId = id;
      formData.bankStatus = status;
      updateBank(formData).then(res => {
        if (res.code && target) {
          status === 0
            ? that.$message.success("已经启用了该银行")
            : that.$message.success("已经停用了该银行");
          target.bankStatus = status;
          that.data = newData;
        }
      });
    },
    customRequest(data, col, type) {
      // 自定义上传背景图片
      const formData = new FormData();
      formData.append("file", data.file);
      uploadIcon(formData).then(res => {
        if (res.code) {
          this.$message.success(res.msg);
          if (type == "add") {
            if (col === "bankIcon") {
              this.fileListEN[0].status = "done";
              this.fileListEN[0].url = res.data.url;
            } else {
              this.fileListN[0].status = "done";
              this.fileListN[0].url = res.data.url;
            }
          } else {
            if (col === "bankIcon") {
              this.fileListE[0].status = "done";
              this.fileListE[0].url = res.data.url;
            } else {
              this.fileList[0].status = "done";
              this.fileList[0].url = res.data.url;
            }
          }
        }
      });
    },
    handleChange({ fileList }, col, type) {
      if (type == "add") {
        if (col === "bankIcon") {
          this.fileListEN = fileList;
        } else {
          this.fileListN = fileList;
        }
      } else {
        if (col === "bankIcon") {
          this.fileListE = fileList;
        } else {
          this.fileList = fileList;
        }
      }
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
    editor(id, editValue) {
      this.modifyform.resetFields();
      this.color = editValue.bankBg;
      //点击修改按钮
      this.editValue = editValue;
      this.editId = id;
      this.modify.visible = true;
    },
    // 选择颜色
    headleChangeColor(color) {
      this.color = color;
    },
    // 修改银行信息
    modifySubmit(e) {
      let that = this;
      e.preventDefault();
      that.modifyform.validateFields((err, values) => {
        values.bankId = that.editId;
        let formData = {};
        formData.bankId = values.bankId;
        formData.bankName = values.bankName;
        formData.bankVal = values.bankVal;
        formData.bankBg = that.color;
        if (values.bankIcon) {
          if (values.bankIcon.fileList[0]) {
            formData.bankIcon = values.bankIcon.fileList[0].url;
          } else {
            formData.bankIcon = that.editValue.bankIcon;
          }
        }
        if (values.iconBg) {
          if (values.iconBg.fileList[0]) {
            formData.iconBg = values.iconBg.fileList[0].url;
          } else {
            formData.iconBg = that.editValue.iconBg;
          }
        }
        if (!err) {
          updateBank(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.modify.visible = false;
              that.fileList.splice(0, that.fileList.length);
              that.fileListE.splice(0, that.fileListE.length);
              that._banklist();
            }
          });
        }
      });
    },
    modifyCancel() {
      //修改取消
      this.modify.visible = false;
      this.fileList.splice(0, this.fileList.length);
      this.fileListE.splice(0, this.fileListE.length);
    },
    addModal() {
      //新增按钮
      this.addservice.visible = true;
      this.color = "";
    },
    addserviceSubmit(e) {
      // 新增提交按钮
      let that = this;
      e.preventDefault();
      that.serviceaddform.validateFields((err, values) => {
        if (values.bankStatus || values.bankStatus === 1) {
          values.bankStatus = 0;
        } else {
          values.bankStatus = 1;
        }
        let formData = {};
        formData.bankName = values.bankName;
        formData.bankVal = values.bankVal;
        formData.averageQuota = values.averageQuota;
        formData.maxQuota = values.maxQuota;
        formData.bankStatus = values.bankStatus;
        formData.bankBg = values.bankBg;
        if (values.bankIcon) {
          if (values.bankIcon.fileList[0]) {
            formData.bankIcon = values.bankIcon.fileList[0].url;
          } else {
            formData.bankIcon = that.editValue.bankIcon;
          }
        }
        if (values.iconBg) {
          if (values.iconBg.fileList[0]) {
            formData.iconBg = values.iconBg.fileList[0].url;
          } else {
            formData.iconBg = that.editValue.iconBg;
          }
        }
        if (!err) {
          addBank(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.addservice.visible = false;
              that.fileListN.splice(0, that.fileListN.length);
              that.fileListEN.splice(0, that.fileListEN.length);
              that._banklist();
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
      deleteBank({ bankId: this.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          that.tableLoading = true;
          setTimeout(() => {
            that.visible = false;
            that.confirmLoading = false;
            that._banklist();
          }, 200);
        }
      });
    },
    parameter(id, name) {
      //提示语信息
      console.log(id);
      this.$router.push({
        name: "parameter",
        params: {
          id: id,
          name: name
        }
      });
    }
  }
};
</script>
<style scoped>
.bank-icon {
  width: 60px;
  height: 60px;
}

.bank-bg {
  width: 120px;
  height: 60px;
}

.bank-bg,.color{
cursor: pointer;
}

.color {
  z-index: 1;
}
</style>