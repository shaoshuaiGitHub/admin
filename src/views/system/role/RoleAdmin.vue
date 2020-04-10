<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
      <div class="ant-page-header">
        <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>系统管理</a-breadcrumb-item>
            <a-breadcrumb-item>角色权限管理</a-breadcrumb-item>
            <a-breadcrumb-item>分配人员</a-breadcrumb-item>
        </a-breadcrumb>
        <div class="ant-page-header-heading">
          <span class="ant-page-header-heading-title">分配人员</span>
        </div>
      </div>
      </div>
    </div>
    <div class="wrap-children-content">
      
      <a-layout-content :style="{ margin: '24px 0', padding: '24px', background: '#fff', minHeight: '280px' }">
        <div class="pages-list-table-list">
          <a-button type="primary" icon="rollback" @click="back">返回</a-button>
          <div style="float:right">
            <a-button type="primary" style="margin-right:20px;" icon="plus" @click="addetes">新增人员</a-button>
            <a-button type="primary" icon="delete" @click="deletes">移除人员</a-button>
          </div>
        </div>
        
        <a-table :rowSelection="rowSelection" :loading="tableloading" :pagination="false" :columns="columns" :dataSource="data" rowKey="id">
                    
        </a-table>
        <a-pagination :defaultCurrent="1" :total="11" change="ueie" />
      </a-layout-content>
      <a-modal
      centered
        title="请确定"
        okText="确定"
        cancelText="取消"
        :visible="delmodal.visible"
        @ok="delhandleOk"
        :confirmLoading="delmodal.confirmLoading"
        @cancel="handleCancel"
        html-type="submit"
      >
        <p>
          {{delmodal.msg}}
        </p>
      </a-modal>

      <a-modal
      centered
        title="新增人员"
        okText="确定"
        cancelText="取消"
        :visible="addmodal.visible"
        @ok="add_handleOk"
        :confirmLoading="addmodal.confirmLoading"
        @cancel="add_handleCancel"
        html-type="submit"
        :footer="null"
        :width="800"
      >
        <a-form layout="inline" :form="form" @submit="searchSubmit">
          <a-form-item label="用户名/账号" :label-col="{ span: 9 }" :wrapper-col="{ span: 15 }" >
            <a-input v-decorator="['acccount',{rules: [{ required: true, message: '请输入用户名/账号！' }]}]" />
          </a-form-item>
           <a-form-item>
          <a-button type="primary" html-type="submit" >搜索</a-button>
          </a-form-item>
        </a-form>

        <div>
          <div class="pages-list-table-list">
          <a-button type="primary" style="margin-right:20px;" icon="plus" @click="_addUsermodal">新增</a-button>
        </div>
         <a-table :rowSelection="addrowSelection" :loading="addmodal.tableloading" :pagination="false" :columns="columns" :dataSource="admindata" rowKey="id">
                    
        </a-table>
        </div>
      </a-modal>

    </div>
  </div>
</template>
<script>
import { roleAdmin, raddUser, removeUser } from "api"
const columns = [{
  title: '用户名',
  dataIndex: 'name',
  scopedSlots: { customRender: 'name' }
}, {
  title: '账号',
  dataIndex: 'account',
  scopedSlots: { customRender: 'account' }
}]

export default {
  data() {
    return {
      delmsg: null,
      tableloading: true,
      data: null,
      admindata: null,
      columns,
      ModalText: 'Content of the modal',
      delmodal: {
        visible: false,
        confirmLoading: false,
        msg: null
      },
      addmodal: {
        visible: false,
        tableloading: true,
        confirmLoading: true
      },
      formLayout: 'horizontal',
      form: this.$form.createForm(this),
      adminIds: null
    }
  },
  created () {
    this._rolelist()
    this._roleadminlist()
  },
  methods: {
    addetes () {
      this.addmodal.visible = true
    },
    editor (id) {
      this.$router.push('/system/roleeditor/' + id)
    },
    _rolelist () {
      let that = this
      roleAdmin({roleId: this.$route.params.id}).then((response) => {
        // console.log(response)
        this.data = response.data.content
        setTimeout(() => {
          this.tableloading = false
        }, 1000)
      })
    },
    _roleadminlist () {
      let that = this
      roleAdmin({roleId: this.$route.params.id}).then((response) => {
        this.admindata = response.data.content
        setTimeout(() => {
          this.addmodal.tableloading = false
        }, 1000)
      })
    },
    searchSubmit (e) {
      e.preventDefault();
      this.form.validateFields((err, values) => {
        if (!err) {
          roleAdmin(values).then((response) => {
            this.admindata = response.data.content
            setTimeout(() => {
              this.addmodal.tableloading = false
            }, 1000)
          })
        }
      });
    },
    showModal () {
      this.$router.push('/system/roleadd')
    },
    add_handleCancel () {
      this.addmodal.visible = false
    },
    add_handleOk () {

    },
    _addUsermodal () {
      let that = this
      if (!this.addadminIds) {
        this.$message.success('请勾选对应人员')
        return false
      }
      this.$modal.confirm({
        centered: true,
        title: '请确定',
        content: '确定批量新增这些角色人员吗?',
        cancelText: '取消',
        okText: '确定',
        onOk() {
          that._addUser()
        },
        onCancel() {},
      })
    },
    _addUser () {
      raddUser({
        roleId: this.$route.params.id,
        adminIds: this.addadminIds
      }).then((res) => {
        if (res.code === 1) {
          this.$message.success(res.msg)
          this.addmodal.confirmLoading = true
          this.addmodal.tableloading = true
          this._roleadminlist()
        }
        // console.log(res)
      })
    },
    delhandleOk () {
      removeUser({
        roleId: this.$route.params.id,
        adminIds: this.adminIds
      }).then((res) => {
        if (res.code === 1) {
          this.$message.success(res.msg)
          this.delmodal.confirmLoading = true
          this.tableloading = true
          setTimeout(() => {            
            this.delmodal.visible = false
            this.delmodal.confirmLoading = false
            this._rolelist()
          }, 500)
        }
        // console.log(res)
      })
    },
    deletes (id) {
      let that = this
      if (!this.adminIds) {
        this.$message.success('请勾选对应人员')
        return false
      }
      this.$modal.confirm({
        centered: true,
        title: '请确定',
        content: '确定批量删除这些角色人员吗?',
        cancelText: '取消',
        okText: '确定',
        onOk() {
          that.delhandleOk()
        },
        onCancel() {},
      })
      // this.delmodal.visible = true
      // this.delmodal.msg = "确定批量删除这些角色人员吗?"
    },
    _addUserCancel () {
      this.addmodalok.visible = false
    },
    handleCancel(e) {
      this.delmodal.visible = false
    },
    handleSelectChange (value) {
      this.form.setFieldsValue({
        note: `Hi, ${value === 'male' ? 'man' : 'lady'}!`,
      });
    },
    back () {
      this.$router.back()
    }
  },
  computed: {
    addrowSelection(){
      const { selectedRowKeys } = this
      return {
        onChange: (selectedRowKeys, selectedRows) => {
          this.addadminIds = selectedRowKeys.join(',')
        },
        getCheckboxProps: record => ({
          props: {
            disabled: record.name === 'Disabled User',
            name: record.name
          }
        })
      }
    },
    rowSelection() {
      const { selectedRowKeys } = this
      return {
        onChange: (selectedRowKeys, selectedRows) => {
          this.adminIds = selectedRowKeys.join(',')
        },
        getCheckboxProps: record => ({
          props: {
            disabled: record.name === 'Disabled User',
            name: record.name
          }
        })
      }
    }
  },
}
</script>