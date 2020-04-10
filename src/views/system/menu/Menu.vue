<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>系统管理</a-breadcrumb-item>
            <a-breadcrumb-item>菜单管理</a-breadcrumb-item>
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
        <a-button
          type="primary"
          icon="plus"
          :style="{ margin: '0 0 24px 0 ' }"
          @click="newPlan(null,1)"
        >新增菜单</a-button>

        <a-table
          bordered
          :loading="tableLoading"
          :pagination="pagination"
          :columns="columns"
          :dataSource="data"
          :rowKey="record => record.resourceId"
          :defaultExpandAllRows="true"
          :indentSize="50"
          :scroll="{x:1130}"
        >
          <template v-for="col in ['key','url','icon']" :slot="col" slot-scope="text, record">
            <a-input
              :key="col"
              style="width:150px"
              :defaultValue="text"
              @change="e => handleChange2(e.target.value, record.resourceId,col, record.parentId)"
              class="aa"
            />
          </template>
          <template slot="name" slot-scope="text, record">
            <a-input
              style="width:150px"
              :defaultValue="text"
              @change="e => handleChange2(e.target.value, record.resourceId,'title',record.parentId)"
              class="aa"
            />
          </template>
          <template slot="sort" slot-scope="text, record">
            <a-input
              style="width:50px"
              :defaultValue="text"
              @change="e => handleChange2(e.target.value, record.resourceId,'sort',record.parentId)"
              class="aa"
            />
          </template>
          <template slot="operation" slot-scope="text, record">
            <div class="editable-row-operations">
              <span>
                <a @click="() => newPlan(record.resourceId,record.type+1)">添加</a>
              </span>
              <span>
                <a
                  v-if="editValue && record.resourceId == editId"
                  @click="() => save(record.resourceId,record.parentId)"
                >保存</a>
                <span v-else style="margin-right: 8px; color:#666">保存</span>
              </span>
              <span>
                <a class="deletes" @click="() => deletes(record.resourceId)">删除</a>
              </span>
            </div>
          </template>
        </a-table>
      </a-layout-content>
    </div>
    <a-modal
      :visible="menuuser.visible"
      :confirmLoading="menuuser.confirmLoading"
      @cancel="menuCancel"
      :footer="null"
      centered
      title="新增菜单"
    >
      <a-form :form="menuaddform" @submit="menuaddSubmit">
        <a-form-item label="菜单名称" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['title',{rules: [{ required: true, message: '请输入菜单名称!' }]}]" />
        </a-form-item>
        <a-form-item label="父级Id" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input
            v-decorator="['parentId',{initialValue: this.menuuser.id != null ? this.menuuser.id : null}]"
          />
        </a-form-item>
        <a-form-item label="Key" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['key',{rules: [{ required: true, message: '请输入菜单key!' }]}]" />
        </a-form-item>
        <a-form-item label="优先级" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['sort']" />
        </a-form-item>
        <a-form-item label="链接地址" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['url']" />
        </a-form-item>
        <a-form-item label="类型" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['type',{initialValue: this.menuuser.type}]" />
        </a-form-item>
        <a-form-item label="图片" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['icon']" />
        </a-form-item>
        <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
          <a-button type="primary" html-type="submit">提交</a-button>
        </a-form-item>
      </a-form>
    </a-modal>
  </div>
</template>
<script>
import {
  getAllResource,
  saveResource,
  updateResource,
  deleteResources,
  deleteResource
} from "api";
import { match } from "minimatch";
const columns = [
  {
    title: "菜单名称",
    dataIndex: "title",
    // width: "25%",
    scopedSlots: { customRender: "name" }
  },
  {
    title: "父级ID",
    dataIndex: "parentId",
    // width: "25%",
    scopedSlots: { customRender: "parentId" }
  },
  {
    title: "Key",
    dataIndex: "key",
    scopedSlots: { customRender: "key" }
  },
  {
    title: "优先级",
    dataIndex: "sort",
    scopedSlots: { customRender: "sort" }
  },
  {
    title: "链接地址",
    dataIndex: "url",
    scopedSlots: { customRender: "url" }
  },
  {
    title: "类型",
    dataIndex: "type",
    scopedSlots: { customRender: "type" }
  },
  {
    title: "图标",
    dataIndex: "icon",
    scopedSlots: { customRender: "icon" }
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
      editValue: {},
      editId: null,
      menuuser: {
        visible: false,
        confirmLoading: true,
        id: null,
        type: null
      },
      delmsg: null,
      visible: false,
      confirmLoading: false,
      tableLoading: true,
      // datetypeData,
      pagination: {
        total: 0,
        defaultCurrent: 0,
        defaultPageSize: 10,
        showTotal: total => `共 ${total} 条数据`,
      },
      name: this.$route.params.name,
      menuaddform: this.$form.createForm(this)
    };
  },
  created() {
    this._postResource();
  },
  methods: {
    _postResource() {
      //获取菜单列表
      let that = this;
      getAllResource({}).then(response => {
        that.data = response.data.content;
        console.log(that.data)
        that.cacheData = that.data.map(item => ({ ...item })); // 初始缓存数据
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },

    newPlan(Aid, type) {
      //新增按钮
      this.menuuser.visible = true;
      this.menuuser.id = Aid;
      this.menuuser.type = type;
    },
    menuCancel() {
      // 新增页面返回
      this.menuuser.visible = false;
    },
    menuaddSubmit(e) {
      // 提交
      let that = this;
      e.preventDefault();
      that.menuaddform.validateFields((err, values) => {
        if (!err) {
          saveResource(values).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that._postResource();
              that.menuuser.visible = false;
              that.menuaddform.resetFields();
            }
          });
        }
      });
    },
    handleChange2(value, id, column, parentId) {
      this.editId = id;
      this.editValue[column] = value;
    
    },
    save(id, parentId) {
      // 保存
      let that = this;
      if ((that.editId = id)) {
        that.$modal.confirm({
          centered: true,
          title: "请确定",
          content: "确定保存该菜单配置？",
          cancelText: "取消",
          okText: "确定",
          onOk() {
            that.handleSaveOk();
          },
          onCancel() {}
        });
      }
    
    },
    handleSaveOk() {
      //确定保存
      let that = this;
      that.editValue.resourceId = that.editId;
      updateResource(that.editValue).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          that.tableLoading = true;
          that.editValue = {};
          that.editId = null;
          setTimeout(() => {
            that.visible = false;
            that.tableLoading = false;
            that.confirmLoading = false;
            // that._postResource();
          }, 200);
        }
      });
    },
    deletes(id) {
      //删除事件
      let that = this;
      that.delID = id;
      that.$modal.confirm({
        centered: true,
        title: "请确定",
        content: "确定删除该菜单配置？",
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
      deleteResource({ resourceId: this.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          that.tableLoading = true;
          setTimeout(() => {
            that.visible = false;
            that.confirmLoading = false;
            that._postResource();
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
.aa {
  color: #1890ff;
  border: none;
  border-bottom: 1px solid white !important;
  box-shadow: none;
}
.deletes {
  color: #f5222d;
}
</style>