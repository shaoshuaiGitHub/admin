<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>会员管理</a-breadcrumb-item>
            <a-breadcrumb-item>增值服务</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">增值服务</span>
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
            <a-form-item>
              <a-input v-decorator="['inValue']" placeholder="输入条件" style="width:200px">
                <a-select v-decorator="['selKey',{initialValue: 'userName'}]" slot="addonBefore">
                  <a-select-option value="userName">会员名</a-select-option>
                  <a-select-option value="phone">手机号</a-select-option>
                </a-select>
              </a-input>
            </a-form-item>
            <a-form-item label="商品名称" >
              <a-input v-decorator="['goodsName']"></a-input>
            </a-form-item>
            <a-row v-if="isCollapse">
              <a-col>
                <a-form-item label="服务状态">
                  <a-select style="width:150px;" v-decorator="['sStatus']">
                    <a-select-option value="1">停用</a-select-option>
                    <a-select-option value="0">启用</a-select-option>
                    <a-select-option value="null">全部</a-select-option>
                  </a-select>
                </a-form-item>
                <a-form-item label="订单类型">
                  <a-select style="width:150px;" v-decorator="['goodsType']">
                    <a-select-option value="1">VIP订单</a-select-option>
                    <a-select-option value="2">实物订单</a-select-option>
                    <a-select-option value="3">应用订单</a-select-option>
                    <a-select-option value="4">信用点订单</a-select-option>
                    <a-select-option value="null">全部</a-select-option>
                  </a-select>
                </a-form-item>
              </a-col>
              <a-col>
                <a-form-item label="注册时间">
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
        <div :style="{display:'flex',flexDirection:'row',justifyContent:'flex-start'}">
          <a-button type="primary" style="margin-right:50px" @click="saveall">保存修改</a-button>
          <a-button
            type="primary"
            icon="plus"
            :style="{ margin: '0 0 24px 0 ' }"
            @click="addModal"
          >新增服务</a-button>
        </div>
        <a-table
          bordered
          :loading="tableLoading"
          :pagination="pagination"
          :showHeader="true"
          :dataSource="data"
          :columns="columns"
          :rowKey="record => record.sid"
          @change="handleTableChange"
          :scroll="{x:800}"
        >
          <template v-for="col in ['createTime', 'endTime']" :slot="col" slot-scope="text, record">
            <div :key="col">
              <a-date-picker
                showTime
                :defaultValue="moment( text, 'YYYY-MM-DD HH:mm:ss')"
                format="YYYY-MM-DD HH:mm:ss"
                @change="(tiem,timeString) => onChange(timeString, record.sid,col)"
              />
            </div>
          </template>
          <template slot="sStatus" slot-scope="text, record">
            <a-switch
              checkedChildren="启用"
              unCheckedChildren="停用"
              :defaultChecked="text === 0"
              @change="() => stopbution( record.sid,record.sStatus)"
            />
          </template>
        </a-table>
      </a-layout-content>
    </div>
    <a-modal
      centered
      title="新增服务"
      :visible="adduser.visible"
      :confirmLoading="adduser.confirmLoading"
      @cancel="userCancel"
      :footer="null"
    >
      <a-form :form="useraddform" @submit="adduserSubmit">
        <a-form-item label="商品名称" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-select
            style="width: 120px"
            v-decorator="['goodsId',{rules: [{ required: true, message: '请选择商品名称!' }]}]"
          >
            <a-select-option
              v-for=" item in goodData"
              :value="item.goodsId"
              :key="item.goodsId"
            >{{item.goodsName}}</a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item label="会员ID" :label-col="{ span: 5 }" :wrapper-col="{ span: 5 }">
          <a-input v-decorator="['userId',{rules: [{ required: true, message: '请输入会员ID!' }]}]" />
        </a-form-item>
        <a-form-item label="开始时间" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-date-picker
            showTime
            format="YYYY-MM-DD HH:mm:ss"
            v-decorator="['createTime',{rules: [{ required: true, message: '请选择开始时间!' }]}]"
          />
        </a-form-item>
        <a-form-item label="结束时间" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-date-picker
            showTime
            format="YYYY-MM-DD HH:mm:ss"
            v-decorator="['endTime',{rules: [{ required: true, message: '请选择结束时间！' }]}]"
          />
        </a-form-item>
        <a-form-item label="增值服务状态" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-switch
            checkedChildren="启用"
            unCheckedChildren="停用"
            defaultChecked
            v-decorator="['sStatus',{initialValue: adduser.sStatus}]"
          />
        </a-form-item>
        <a-form-item :wrapper-col="{ span: 12, offset: 6 }">
          <a-button type="primary" html-type="submit">保存</a-button>
        </a-form-item>
      </a-form>
    </a-modal>
  </div>
</template>
<script>
import {
  findAddServicePage,
  updateAddServiceBySid,
  addAddService,
  goodsInfo
} from "api";
import { match } from "minimatch";
import moment from "moment";

const columns = [
  {
    title: "会员名称",
    // width: "18%",
    dataIndex: "userName",
    scopedSlots: { customRender: "userName" }
  },
  {
    title: "会员ID",
    // width: "18%",
    dataIndex: "userId",
    scopedSlots: { customRender: "userId" }
  },
  {
    title: "手机号",
    // width: "18%",
    dataIndex: "phone",
    scopedSlots: { customRender: "phone" }
  },

  {
    title: "商品名称",
    // width: "18%",
    dataIndex: "goodsName",
    scopedSlots: { customRender: "goodsName" }
  },
  {
    title: "开始时间",
    // width: "18%",
    dataIndex: "createTime",
    scopedSlots: { customRender: "createTime" },
     sorter: (a, b) =>
      moment(a.createTime).format("YYYY-MM-DD HH:mm:ss") >
      moment(b.createTime).format("YYYY-MM-DD HH:mm:ss")
  },
  {
    title: "结束时间",
    // width: "18%",
    dataIndex: "endTime",
    scopedSlots: { customRender: "endTime" }
  },
  {
    title: "排序(越小越靠前)",
    // width: "18%",
    dataIndex: "goodsSort",
    scopedSlots: { customRender: "goodsSort" },
     sorter: (a, b) =>
      a.goodsSort - b.goodsSort
  },
  {
    title: "会员增值服务状态",
    width: "10%",
    dataIndex: "sStatus",
    scopedSlots: { customRender: "sStatus" }
  }
];
export default {
  data() {
    let self = this;
    return {
      isCollapse: false,
      data: [],
      cacheData: [],
      columns,
      delmsg: null,
      visible: false,
      confirmLoading: false,
      tableLoading: true,
      goodData: null,
      startValue: null,
      endValue: null,
      endOpen: false,
      pagination: {
        total: 0,
        defaultCurrent: 1,
        defaultPageSize: 10,
        showTotal: total => `共 ${total} 条数据`,
        showSizeChanger: true,
        pageSizeOptions: ["5", "10", "15", "20"],
        showQuickJumper: true
      },
      adduser: {
        visible: false,
        confirmLoading: true,
        sStatus: 1
      },
      useraddform: this.$form.createForm(this),
      searchform: this.$form.createForm(this),
      queryParam: {
        pageNum: 0, //第几页
        pageSize: 10 //每页中显示数据的条数
      },
      firstParam: {
        pageNum: 0, //第几页
        pageSize: 10 //每页中显示数据的条数
      }
    };
  },
  created() {
    this.queryParam = this.firstParam;
    this._goodsInfo();
    this._findAddServicePage();
  },
  methods: {
    _goodsInfo() {
      //获取商品列表
      let that = this;
      goodsInfo({}).then(res => {
        that.goodData = res.data.list;
      });
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
    moment,
    compare(property) {
      // 排序规则
      return function(a, b) {
        var value1 = a[property];
        var value2 = b[property];
        return value1 - value2;
      };
    },

    getTableList() {
      //获取列表
      let that = this;
      findAddServicePage(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        const target = that.compare("goodsSort");
        const nData = that.data.sort(target);
        that.data = nData;
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    _findAddServicePage() {
      //获取vip会员信息列表
      this.getTableList();
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
      this._findAddServicePage();
    },
    // 搜索框展开
    openSearch() {
      this.isCollapse = !this.isCollapse;
    },
    searchSubmit(e) {
      //搜索
      this.queryParam = this.firstParam;
      e.preventDefault();
      this.searchform.validateFields((err, values) => {
        // console.log(values);
        let target = {};
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
        if (values.sStatus === "null") {
          values.sStatus = null;
        }
        if (values.goodsType === "null") {
          values.goodsType = null;
        }
        target.endTime = values.endTime;
        target.startTime = values.startTime;
        target.sStatus = values.sStatus;
        target.goodsType = values.goodsType;
        target.goodsName = values.goodsName;
        if (values.inValue) {
          const str = values.selKey;
          target[str] = values.inValue;
        }
        this.queryParam = Object.assign({}, this.queryParam, target);
        this.getTableList();
      });
    },
    addModal() {
      //打开新增服务
      this.adduser.visible = true;
    },
    adduserSubmit(e) {
      //新增服务保存
      let that = this;
      e.preventDefault();
      that.useraddform.validateFields((err, values) => {
        console.log(values);
        values.createTime = moment(values.createTime).format(
          "YYYY-MM-DD HH:mm:ss"
        ); //转换时间格式
        values.endTime = moment(values.endTime).format("YYYY-MM-DD HH:mm:ss");
        if (values.sStatus) {
          values.sStatus = 0;
        } else {
          values.sStatus = 1;
        }
        const target = that.goodData.filter(
          item => values.goodsId == item.goodsId
        )[0];
        values.goodsSort = target.goodsSort;
        if (!err) {
          addAddService(values).then(res => {
            if (res.code) {
              that.tableLoading = true;
              that.$message.success(res.msg);
              that.adduser.visible = false;
              that._findAddServicePage();
              setTimeout(() => {
                that.tableLoading = false;
              }, 200);
            }
          });
        }
      });
    },
    userCancel() {
      //关闭新增服务页面
      this.adduser.visible = false;
    },
    stopbution(id, status) {
      //状态切换
      let that = this;
      const target = that.data.filter(item => id === item.sid)[0];
      if (status == 1) {
        status = 0;
      } else {
        status = 1;
      }
      let formData = {};
      formData.sid = id;
      formData.sStatus = status;

      updateAddServiceBySid(formData).then(res => {
        if (res.code) {
          status === 0
            ? that.$message.success("已经启用了该账号")
            : that.$message.success("已经停用了该账号");
          target.sStatus = status;
        }
      });
    },
    onChange(value, id, column) {
      //监听值变化
      const newData = [...this.data];
      const target = newData.filter(item => id === item.sid)[0];
      console.log(value, id, column);
      if (target) {
        target[column] = value;
        target.editable = true;
        this.data = newData;
      }
    },
    saveall() {
      //保存修改
      const target = this.data.filter(item => true === item.editable);
      //   console.log(target);
      for (var i = 0; i < target.length; i++) {
        let formData = {};
        formData.sid = target[i].sid;
        formData.createTime = target[i].createTime;
        formData.endTime = target[i].endTime;
        updateAddServiceBySid(formData).then(res => {
          if (res.code) {
            this.$message.success(res.msg);
          }
        });
        delete target[i].editable;
      }
    }
  }
};
</script>
<style scoped>
.editable-row-operations a {
  margin-right: 8px;
}
</style>