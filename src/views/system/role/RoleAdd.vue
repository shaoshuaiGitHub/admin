<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>系统管理</a-breadcrumb-item>
            <a-breadcrumb-item>角色权限管理</a-breadcrumb-item>
            <a-breadcrumb-item>新增角色</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">新增角色</span>
          </div>
        </div>
      </div>
    </div>
    <div class="wrap-children-content">
      <a-layout-content
        :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }"
      >
        <div class="pages-list-table-list">
          <a-button type="primary" icon="rollback" @click="back">返回</a-button>
        </div>
        <a-form :form="form" @submit="handleSubmit">
          <a-form-item label="角色名称" :label-col="{ span: 3 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['name',{rules: [{ required: true, message: '请输入用户名！' }]}]" />
          </a-form-item>

          <a-form-item label="说明" :label-col="{ span: 3 }" :wrapper-col="{ span: 12 }">
            <a-textarea
              v-decorator="['descr',{rules: [{ required: true, message: '请输入说明' }]}]"
              :rows="4"
            />
          </a-form-item>

          <a-form-item label="角色模块权限" :label-col="{ span: 3 }" :wrapper-col="{ span: 20 }">
            <div style="border:1px solid #ddd;">
              <a-row style="background:#ddd;height:30px;line-height:30px;">
                <a-col :span="4">主模块</a-col>
                <a-col :span="8">子模块</a-col>
              </a-row>
              <div v-for="(item, index) in data" :key="index">
                <a-row style="border-bottom:1px solid #ddd;">
                  <a-col :span="4" style="padding:10px;">
                    <a-checkbox-group
                      v-decorator="['resourceIds']"
                      @change=" value => onChangechec(value, item.resourceId,'one')"
                    >
                      <a-row>
                        <a-col>
                          <a-checkbox
                            :value="item.resourceId"
                            @change=" value => onCheckAllChange(value,item.resourceId,'one')"
                          >{{item.title}}</a-checkbox>
                        </a-col>
                      </a-row>
                    </a-checkbox-group>
                  </a-col>
                  <a-col :span="20">
                    <div class="tabetwobor" v-for="(items, indexs) in item.children" :key="indexs">
                      <a-col :span="8">
                        <a-checkbox-group
                          v-decorator="['resourceIds']"
                          @change=" value => onChangechec(value, item.resourceId,'two')"
                        >
                          <a-row>
                            <a-col>
                              <a-checkbox
                                :value="items.resourceId"
                                @change=" value => onCheckAllChange(value,items.resourceId,'two')"
                              >{{items.title}}</a-checkbox>
                            </a-col>
                          </a-row>
                        </a-checkbox-group>
                      </a-col>
                      <a-col :span="8">
                        <a-checkbox-group
                          v-decorator="['resourceIds']"
                          @change=" value => onChangechec(value, items.resourceId,'three')"
                          v-for="(itemsw, indexsw) in items.children"
                          :key="indexsw"
                        >
                          <a-row>
                            <a-col>
                              <a-checkbox
                                :value="itemsw.resourceId"
                                @change=" value => onCheckAllChange(value,itemsw.resourceId,'three')"
                              >{{itemsw.title}}</a-checkbox>
                            </a-col>
                          </a-row>
                        </a-checkbox-group>
                      </a-col>
                    </div>
                  </a-col>
                </a-row>
              </div>
            </div>
          </a-form-item>
          <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
            <a-button type="primary" html-type="submit">提交</a-button>
          </a-form-item>
        </a-form>
      </a-layout-content>
    </div>
  </div>
</template>
<script>
import { getAllResource, roleAdd, getResourceById } from "api";

export default {
  data() {
    return {
      data: [],
      ModalText: "Content of the modal",
      formLayout: "horizontal",
      form: this.$form.createForm(this),
      // routerId: this.$route.params.id,
    };
  },
  created() {
    this.rolePage();
  },
  computed: {},
  methods: {
    rolePage() {
      let that = this;
         getAllResource({}).then(res => {
            that.data = res.data.content;
          });
    },
    onChangechec(checkedList, id, col) {
    },
    onCheckAllChange(e, id, col) {},
    handleSubmit(e) {
      e.preventDefault();
      this.form.validateFields((err, values) => {
        if (!err) {
          roleAdd(values).then(res => {
            if (res.code) {
              this.$message.success(res.msg);
            }
          });
        }
      });
    },
    back() {
      this.$router.back();
    }
  }
};
</script>
<style>
.tabetwobor {
  width: 100%;
  overflow: hidden;
  border-bottom: 1px solid #ddd;
}
</style>
