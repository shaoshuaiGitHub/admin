<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>商品管理</a-breadcrumb-item>
            <a-breadcrumb-item>商品信息</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">商品信息</span>
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
          :style="{display:'flex',flexDirection:'row',justifyContent:'space-between'}"
        >
          <a-form layout="inline" :form="searchform" @submit="searchSubmit">
            <!-- 搜索框 -->
            <a-form-item label="商品名称">
              <a-input v-decorator="['goodsName']"></a-input>
            </a-form-item>
            <a-form-item label="订单类型">
              <a-select
                style="width:150px;"
                v-decorator="['goodsType', {rules: [{ required: false, message: '请选择类型' }]}]"
              >
                <a-select-option :value="1">VIP订单</a-select-option>
                <a-select-option :value="2">实物订单</a-select-option>
                <a-select-option :value="3">应用订单</a-select-option>
                <a-select-option :value="4">信用点订单</a-select-option>
                <a-select-option value="null">全部</a-select-option>
              </a-select>
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
          bordered
          :loading="tableLoading"
          :pagination="pagination"
          @change="handleTableChange"
          :showHeader="true"
          :dataSource="data"
          :columns="columns"
          :rowKey="record => record.goodsId"
          :scroll="{x:800}"
        >
          <template slot="goodsName" slot-scope="text, record">
            <a-icon style="margin-right:15px" slot="suffixIcon" type="smile" theme="twoTone" />
            <a-input
              style="width:100px"
              :defaultValue="text"
              class="sort-input"
              @blur="e => handleChange2(e.target.value, record.goodsId, 'goodsName')"
            />
          </template>
          <template slot="goodsBgi" slot-scope="text">
            <img
              :src="text"
              alt="未找到图片"
              :style="{width:'100px',height:'60px',cursor: 'pointer'}"
              @click="() => imgClick(text)"
            />
          </template>
          <template slot="goodsType" slot-scope="text, record">
            <a-select
              :defaultValue="filterType(text)"
              style="width: 120px"
              class="sort-input"
              @blur="value=>handleChange2(value,record.goodsId,'goodsType')"
            >
              <a-select-option
                v-for="item in selectValue"
                :value="item.value"
                :key="item.value"
              >{{item.name}}</a-select-option>
            </a-select>
          </template>
          <template v-for="col in ['term','goodsSort']" :slot="col" slot-scope="text,record">
            <div :key="col">
              <a-input
                style="width:50px"
                :defaultValue="text"
                class="sort-input"
                @blur="e => handleChange2(e.target.value, record.goodsId,col)"
              />
              <span v-if="col == 'term' " style="margin-left:5px">年</span>
            </div>
          </template>
          <template slot="goodsAmount" slot-scope="text, record">
            <div>
              <a-input
                style="width:80px"
                :defaultValue="text"
                class="sort-input"
                @blur="e => handleChange2(e.target.value, record.goodsId,'goodsAmount')"
              />
              <span style="margin-left:5px">元</span>
            </div>
          </template>
          <template slot="creditPoints" slot-scope="text, record">
            <div>
              <a-input
                style="width:80px"
                :defaultValue="text"
                class="sort-input"
                @blur="e => handleChange2(e.target.value, record.goodsId,'creditPoints')"
              />
            </div>
          </template>
          <template slot="operation" slot-scope="text, record">
            <div class="editable-row-operations">
              <a
                style="margin-right:10px;"
                slot="action"
                @click="() => editor(record.goodsId,record)"
              >编辑</a>
              <span>
                <a class="deletes" @click="() => deletes(record.goodsId)">删除</a>
              </span>
            </div>
          </template>
        </a-table>
      </a-layout-content>
    </div>
    <a-modal
      centered
      title="修改商品配置"
      :visible="modify.visible"
      :confirmLoading="modify.confirmLoading"
      @cancel="modifyCancel"
      :footer="null"
    >
      <a-form :form="modifyform" @submit="modifySubmit">
        <a-form-item label="商品名称" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['goodsName',{initialValue: editValue.goodsName}]" />
        </a-form-item>
        <a-form-item label="订购期限" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['term',{initialValue: editValue.term}]" />
        </a-form-item>
        <a-form-item label="商品价格" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['goodsAmount',{initialValue: editValue.goodsAmount}]" />
        </a-form-item>
        <a-form-item label="信用点价格" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['creditPoints',{initialValue: editValue.creditPoints}]" />
        </a-form-item>
        <a-form-item label="排序" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['goodsSort',{initialValue: editValue.goodsSort}]" />
        </a-form-item>
        <a-form-item label="订单类型" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-select
            style="width:100px;"
            v-decorator="['goodsType',{initialValue: editValue.goodsType }]"
          >
            <a-select-option
              v-for="item in selectValue"
              :value="item.value"
              :key="item.value"
            >{{item.name}}</a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item label="新商品图" :label-col="{ span: 5 }" :wrapper-col="{ span: 12}">
          <div>
            <a-upload
              listType="picture"
              :defaultFileList="fileListE"
              class="upload-list-inline"
              @preview="handlePreview"
              @change=" value => handleChange(value, editValue.goodsId)"
              :customRequest=" value => customRequest(value,editValue.goodsId)"
              v-decorator="['goodsBgi']"
            >
              <a-button v-if="fileListE.length < 1">
                <a-icon type="upload" />上传
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
    <a-modal
      centered
      title="新增商品配置"
      :visible="addservice.visible"
      :confirmLoading="addservice.confirmLoading"
      @cancel="serviceCancel"
      :footer="null"
    >
      <a-form :form="serviceaddform" @submit="addserviceSubmit">
        <a-form-item label="商品名称" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['goodsName']" />
        </a-form-item>
        <a-form-item label="订购期限" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['term']" />
        </a-form-item>
        <a-form-item label="商品价格" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['goodsAmount']" />
        </a-form-item>
        <a-form-item label="信用点价格" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['creditPoints']" />
        </a-form-item>
        <a-form-item label="排序" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['goodsSort']" />
        </a-form-item>
        <a-form-item label="订单类型" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-select style="width:100px;" v-decorator="['goodsType']">
            <a-select-option
              v-for="item in selectValue"
              :value="item.value"
              :key="item.value"
            >{{item.name}}</a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item label="商品图" :label-col="{ span: 5 }" :wrapper-col="{ span: 12}">
          <div>
            <a-upload
              listType="picture"
              :defaultFileList="fileList"
              class="upload-list-inline"
              @preview="handlePreview"
              @change="handleChange"
              :customRequest="customRequest"
              v-decorator="['goodsBgi']"
            >
              <a-button v-if="fileList.length < 1">
                <a-icon type="upload" />上传
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
  </div>
</template>
<script>
import {
  goodsInfo,
  updateGoods,
  addGoods,
  deleteGoods,
  uploadGoodsPic
} from "api";
import moment from "moment";
import { match } from "minimatch";

const columns = [
  {
    title: "商品名称",
    // width: "18%",
    dataIndex: "goodsName",
    scopedSlots: { customRender: "goodsName" }
  },
  {
    title: "订单类型",
    // width: "18%",
    dataIndex: "goodsType",
    scopedSlots: { customRender: "goodsType" }
  },
  {
    title: "订购期限（年）",
    // width: "18%",
    dataIndex: "term",
    scopedSlots: { customRender: "term" }
  },
  {
    title: "商品价格（元）",
    // width: "18%",
    dataIndex: "goodsAmount",
    scopedSlots: { customRender: "goodsAmount" }
  },
  {
    title: "商品图片",
    // width: "18%",
    dataIndex: "goodsBgi",
    scopedSlots: { customRender: "goodsBgi" }
  },
  {
    title: "信用点价格",
    // width: "18%",
    dataIndex: "creditPoints",
    scopedSlots: { customRender: "creditPoints" }
  },
  {
    title: "排序(越小越靠前)",
    // width: "18%",
    dataIndex: "goodsSort",
    scopedSlots: { customRender: "goodsSort" },
     sorter: (a,b) => a.goodsSort - b.goodsSort
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
      delmsg: null,
      visible: false,
      confirmLoading: false,
      tableLoading: true,
      modify: {
        visible: false,
        confirmLoading: true
      },
      addservice: {
        visible: false,
        confirmLoading: true
      },
      editValue: {},
      selectValue: [
        { name: "VIP订单", value: 1 },
        { name: "实物订单", value: 2 },
        { name: "应用订单", value: 3 },
        { name: "信用点订单", value: 4 }
      ],
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
      modifyform: this.$form.createForm(this),
      serviceaddform: this.$form.createForm(this),
      searchform: this.$form.createForm(this),
      fileListE: [],
      fileList: [],
      previewVisible: false,
      previewImage: "",
      imgVisible: false, //以上传图片的放大页面key外
      showImage: "" //放大图片rul外
    };
  },
  created() {
    this._goodsInfo();
  },
  methods: {
    //判断订单类型
    filterType(text) {
      if (text) {
        const item = this.selectValue.filter(item => text == item.value)[0];
        return item.name;
      }
    },
    compare(property) {
      // 排序规则
      return function(a, b) {
        var value1 = a[property];
        var value2 = b[property];
        return value1 - value2;
      };
    },
    moment,
    _goodsInfo() {
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
      goodsInfo(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    handleChange2(value, goodsId, column) {
      // 失去焦点改变内容
      let formData = {};
      formData.goodsId = goodsId;
      formData[column] = value;
      const target = this.data.filter(item => goodsId === item.goodsId)[0];
      if (target[column] != value) {
        updateGoods(formData).then(res => {
          if (res.code) {
            this.$message.success(res.msg);
            target[column] = value;
          }
        });
      }
    },
    customRequest(data, id) {
      //自定义上传
      const formData = new FormData();
      formData.append("file", data.file);
      uploadGoodsPic(formData).then(res => {
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
    imgClick(text) {
      //点击图片放大外
      this.imgVisible = true;
      this.showImage = text;
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
        let formData = {};
        if (values.goodsBgi) {
          if (values.goodsBgi.fileList[0]) {
            formData.goodsBgi = values.goodsBgi.fileList[0].url;
          }
        }
        if (values.goodsAmount) {
          formData.goodsAmount = values.goodsAmount;
        }
        if (values.creditPoints) {
          formData.creditPoints = values.creditPoints;
        }
        if (values.goodsName) {
          formData.goodsName = values.goodsName;
        }
        if (values.goodsSort) {
          formData.goodsSort = values.goodsSort;
        }
        if (values.goodsType) {
          formData.goodsType = values.goodsType;
        }
        if (values.term) {
          formData.term = values.term;
        }
        if (!err) {
          addGoods(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that._goodsInfo();
              that.addservice.visible = false;
              that.fileList.splice(0, that.fileList.length);
            }
          });
        }
      });
    },
    serviceCancel() {
      //新增页面撤销
      this.addservice.visible = false;
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
        let formData = {};
        formData.goodsId = that.editId;
        if (values.goodsBgi) {
          if (values.goodsBgi.fileList[0]) {
            formData.goodsBgi = values.goodsBgi.fileList[0].url;
          } else {
            formData.goodsBgi = that.editValue.goodsBgi;
          }
        }
        if (values.goodsAmount) {
          formData.goodsAmount = values.goodsAmount;
        }
        if (values.creditPoints) {
          formData.creditPoints = values.creditPoints;
        }
        if (values.goodsName) {
          formData.goodsName = values.goodsName;
        }
        if (values.goodsSort) {
          formData.goodsSort = values.goodsSort;
        }
        if (values.goodsType) {
          formData.goodsType = values.goodsType;
        }
        if (values.term) {
          formData.term = values.term;
        }
        if (!err) {
          updateGoods(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that._goodsInfo();
              that.modify.visible = false;
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
    //重置搜索
    resetSearch() {
      this.searchform.resetFields();
      this._goodsInfo();
    },
    //搜索
    searchSubmit(e) {
      this.queryParam = this.firstParam;
      e.preventDefault();
      this.searchform.validateFields((err, values) => {
        console.log(values);

        let target = {};
        target.goodsName = values.goodsName;
        if (values.goodsType === "null") {
          values.goodsType = null;
        }
        target.goodsType = values.goodsType;
        this.queryParam = Object.assign({}, this.queryParam, target);
        this.getTableList();
      });
    },
    handleOk() {
      //确定删除
      let that = this;
      deleteGoods({ goodsId: this.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          that.tableLoading = true;
          setTimeout(() => {
            that.visible = false;
            that.confirmLoading = false;
            that._goodsInfo();
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
        content: "确定删除该配置？",
        cancelText: "取消",
        okText: "确定",
        onOk() {
          that.handleOk();
        },
        onCancel() {}
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