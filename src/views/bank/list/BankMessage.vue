<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>银行管理</a-breadcrumb-item>
            <a-breadcrumb-item>银行列表</a-breadcrumb-item>
            <a-breadcrumb-item>银行信息</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">{{name+'_'+'银行信息'}}</span>
          </div>
        </div>
      </div>
    </div>
    <div class="wrap-children-content">
      <a-layout-content
        :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }"
      >
        <div :style="{marginBottom:'20px'}">
          <a-button type="primary" icon="rollback" @click="back">返回</a-button>
        </div>
        <a-table
          bordered
          :loading="tableLoading"
          :showHeader="true"
          :dataSource="data"
          :columns="columns"
          :rowKey="record => record.bankId"
        >
          <template slot="bankIcon" slot-scope="text">
            <img :src="text" alt="未找到图片" class="bank-icon" />
          </template>
          <template slot="iconBg" slot-scope="text">
            <img :src="text" alt="未找到图片" class="bank-bg" />
          </template>
          <template slot="bankStatus" slot-scope="text,record">
            <a-switch
              checkedChildren="启用"
              unCheckedChildren="停用"
              :defaultChecked="record.bankStatus === 1"
              @change="() => stopbution(record.bankId, record.bankStatus)"
            />
          </template>
          <template v-for="col in ['averageQuota','maxQuota']" :slot="col" slot-scope="text,record">
            <a-input
              :key="col"
              style="width:80px"
              :defaultValue="text"
              @blur="e => handleBlur(e.target.value, record.bankId,col)"
            />
          </template>
          <template slot="operation" slot-scope="text, record">
            <a style="margin-right:10px;" @click="() => editor(record.bankId,record)">操作</a>
          </template>
        </a-table>
      </a-layout-content>
    </div>
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
        <a-form-item label="平均卡额度" :label-col="{ span: 5 }" :wrapper-col="{ span: 8 }">
          <a-input v-decorator="['averageQuota',{initialValue: this.editValue.averageQuota}]" />
        </a-form-item>
        <a-form-item label="最高卡额度" :label-col="{ span: 5 }" :wrapper-col="{ span: 8 }">
          <a-input v-decorator="['maxQuota',{initialValue: this.editValue.maxQuota}]" />
        </a-form-item>
        <a-form-item label="背景颜色" :label-col="{ span: 5 }" :wrapper-col="{ span: 8 }">
          <a-input v-decorator="['bankBg',{initialValue: this.editValue.bankBg}]" />
        </a-form-item>
        <a-form-item label="银行状态" :label-col="{ span: 5 }" :wrapper-col="{ span: 8 }">
          <a-switch
            checkedChildren="启用"
            unCheckedChildren="停用"
            :defaultChecked=" this.editValue.bankStatus === 1"
            v-decorator="['bankStatus']"
          />
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
  </div>
</template>
<script>
import { bankDetail, updateBank, uploadIcon } from "api";
import { match } from "minimatch";

const columns = [
  {
    title: "银行名称",
    dataIndex: "bankName",
    scopedSlots: { customRender: "bankName" }
  },
  {
    title: "银行图标",
    dataIndex: "bankIcon",
    width: "5%",
    scopedSlots: { customRender: "bankIcon" }
  },
  {
    title: "背景图片",
    dataIndex: "iconBg",
    width: "10%",
    scopedSlots: { customRender: "iconBg" }
  },
  {
    title: "背景颜色",
    dataIndex: "bankBg"
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
    title: "平均卡额度(元)",
    dataIndex: "averageQuota",
    scopedSlots: { customRender: "averageQuota" }
  },
  {
    title: "最高卡额度(元)",
    dataIndex: "maxQuota",
    scopedSlots: { customRender: "maxQuota" }
  },
  {
    title: "银行卡状态",
    dataIndex: "bankStatus",
    scopedSlots: { customRender: "bankStatus" }
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
      modify: {
        visible: false,
        confirmLoading: true
      },
      modifyform: this.$form.createForm(this),
      editValue: {},
      fileListE: [],
      fileList: [],
      previewImage: "",
      previewVisible: false,
      tableLoading: true,
      name: this.$route.params.name
    };
  },
  created() {
    this._bankDetail();
  },
  methods: {
    _bankDetail() {
      //获取银行信息
      let that = this;
      bankDetail({
        bankId: that.$route.params.id
      }).then(res => {
        if (res.code) {
          that.data.push(res.data);
          setTimeout(() => {
            that.tableLoading = false;
          }, 200);
        }
      });
    },
    customRequest(data, col) {
      // 自定义上传背景图片
      console.log(data);
      const formData = new FormData();
      formData.append("file", data.file);
      uploadIcon(formData).then(res => {
        if (res.code) {
          this.$message.success(res.msg);
          if (col === "bankIcon") {
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
    handleChange({ fileList }, col) {
      if (col === "bankIcon") {
        this.fileListE = fileList;
      } else {
        this.fileList = fileList;
      }
    },
    stopbution(id, status) {
      //状态切换
      let that = this;
      const newData = [...that.data];
      const target = newData.filter(item => id === item.bankId)[0];
      console.log(target);
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
          status === 1
            ? that.$message.success("已经启用了该银行")
            : that.$message.success("已经停用了该银行");
          target.bankStatus = status;
          that.data = newData;
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
        values.bankId = that.editId;

        if (values.bankStatus || values.bankStatus === 1) {
          values.bankStatus = 1;
        } else {
          values.bankStatus = 0;
        }
        let formData = {};
        formData.bankId = values.bankId;
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
          updateBank(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that.modify.visible = false;
              that.data = [];
              that.fileList.splice(0, that.fileList.length);
              that.fileListE.splice(0, that.fileListE.length);
              bankDetail({
                bankId: that.$route.params.id
              }).then(res => {
                if (res.code) {
                  that.data.push(res.data);
                  setTimeout(() => {
                    that.tableLoading = false;
                  }, 200);
                }
              });
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
    handleBlur(value, id, column) {
      //失去焦点input
      const target = this.data.filter(item => id === item.bankId)[0];
      if (value != target[column]) {
        let formData = {};
        formData.bankId = id;
        formData[column] = value;
        // formData.append("bannerId", id);
        // formData.append(column, value);
        updateBank(formData).then(res => {
          if (res.code) {
            this.$message.success(res.msg);
          }
        });
      }
    },
    back() {
      this.$router.back();
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
.bank-icon {
  width: 60px;
  height: 60px;
}
.bank-bg {
  width: 120px;
  height: 60px;
}
</style>