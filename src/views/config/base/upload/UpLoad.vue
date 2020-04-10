<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>系统配置</a-breadcrumb-item>
            <a-breadcrumb-item>基础配置</a-breadcrumb-item>
            <a-breadcrumb-item>附件上传</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">{{'附件上传'}}</span>
          </div>
        </div>
      </div>
    </div>
    <div class="wrap-children-content">
      <a-layout-content
        :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }"
      >
        <div style="margin:10px">支持附件格式：jpg、gif、png、doc、docx、xls、xlsx、pdf、txt</div>
        <div style="margin:10px">附件上传大小:100M</div>
        <div  style="margin:10px">音视频格式:MP3、MP4</div>
        <template>
          <div class="clearfix">
            <a-upload-dragger
              :fileList="fileList"
              :remove="handleRemove"
              :beforeUpload="beforeUpload"
              listType="picture"
            >
              <p class="ant-upload-drag-icon">
                <a-icon type="inbox" />
              </p>
              <p class="ant-upload-text">单击或拖动文件到此区域上传</p>
            </a-upload-dragger>
            <a-button
              type="primary"
              @click="handleUpload(fileList)"
              :disabled="fileList.length === 0"
              :loading="uploading"
              style="margin-top: 16px"
            >{{uploading ? '上传中' : '开始上传' }}</a-button>
          </div>
        </template>
        <div class="file-box">
          <template v-for="item in fileUrl">
            <div :key="item.uid" class="box-content">
              <a-icon type="paper-clip" />
              <span :style="{color:'#1890ff',marginLeft:'10px'}">{{item.name}}</span>
              <div :style="{marginTop:'10px',color:'rgba(0, 0, 0, .65)'}">{{'文件地址：'+item.url}}</div>
            </div>
          </template>
        </div>
      </a-layout-content>
    </div>
  </div>
</template>
<script>
import { uploadFlie } from "api";
import { timeout } from "q";
export default {
  data() {
    return {
      fileList: [],
      uploading: false,
      fileUrl: []
    };
  },
  methods: {
    handleRemove(file) {
      const index = this.fileList.indexOf(file);
      const newFileList = this.fileList.slice();
      newFileList.splice(index, 1);
      this.fileList = newFileList;
    },
    beforeUpload(file) {
      this.fileList = [...this.fileList, file];
      return false;
    },
    handleUpload(fileList) {
      this.uploading = true;
      fileList.forEach(file => {
        const formData = new FormData();
        formData.append("file", file);
        uploadFlie(formData).then(res => {
          if (res.code) {
            this.$message.success(res.msg);
            file.url = res.data.url;
            this.fileUrl.push(file);
            this.uploading = false;
            this.fileList = [];
          }
        });
      });
    }
  }
};
</script>
<style scoped>
.editable-row-operations a {
  margin-right: 8px;
}
.file-box {
  margin-top: 20px;
}
.box-content {
  margin-top: 10px;
  padding: 10px;
  border: 1px solid rgba(0, 0, 0, 0.25);
  border-radius: 5px;
  color: rgba(0, 0, 0, 0.45);
  cursor: pointer;
}
</style>