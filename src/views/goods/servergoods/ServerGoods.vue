<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>商品管理</a-breadcrumb-item>
            <a-breadcrumb-item>服务商商品管理</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">服务商商品管理</span>
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
          :style="{display:'flex',flexDirection:'row',justifyContent:'flex-end'}"
        >
          <!-- <a-form layout="inline" :form="searchform" @submit="searchSubmit">
           
            <a-form-item label="商品名称">
              <a-input v-decorator="['goodsName']"></a-input>
            </a-form-item>
            <a-form-item label="商品类型">
              <a-select
                style="width:100px;"
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
            </a-form-item>
          </a-form>-->
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
          style="word-break: break-all;"
          :scroll="{x:1200}"
        >
          <template slot="goodsImg" slot-scope="text">
            <img
              :src="text"
              alt="未找到图片"
              :style="{width:'100px',height:'60px',cursor: 'pointer'}"
              @click="() => imgClick(text)"
            />
          </template>
          <template slot="goodsType" slot-scope="text">{{filterType(text)}}</template>
          <template slot="goodsStatus" slot-scope="text,record">
            <a-switch
              checkedChildren="已上架"
              unCheckedChildren="未上架"
              :defaultChecked="record.goodsStatus == 1"
              @change="() => stopbution(record.goodsId, record.goodsStatus)"
            />
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
      title="修改服务商商品配置"
      :visible="modify.visible"
      :confirmLoading="modify.confirmLoading"
      @cancel="modifyCancel"
      :footer="null"
    >
      <a-form :form="modifyform" @submit="modifySubmit">
        <a-form-item label="商品名称" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['goodsName',{initialValue: editValue.goodsName}]" />
        </a-form-item>
        <a-form-item label="商品类型" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
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
        <a-form-item label="购买信用点折扣（折）" :label-col="{ span: 8 }" :wrapper-col="{ span: 9 }">
          <a-input v-decorator="['discount',{initialValue: editValue.discount}]" />
        </a-form-item>
        <a-form-item label="订购期限" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['term',{initialValue: editValue.term}]" />
        </a-form-item>
        <a-form-item label="现金售价(RMB)" :label-col="{ span: 6 }" :wrapper-col="{ span: 11 }">
          <a-input v-decorator="['cashPrice',{initialValue: editValue.cashPrice}]" />
        </a-form-item>
        <a-form-item label="信用点售价" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['pointsPrice',{initialValue: editValue.pointsPrice}]" />
        </a-form-item>

        <a-form-item
          v-if="editValue.goodsId != 12"
          label="赠送信用点"
          :label-col="{ span: 5 }"
          :wrapper-col="{ span: 12 }"
        >
          <a-input
            v-decorator="['complimentaryPoints',{initialValue: editValue.complimentaryPoints}]"
          />
        </a-form-item>
        <a-form-item label="排序" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['goodsSort',{initialValue: editValue.goodsSort}]" />
        </a-form-item>
        <a-form-item label="新商品图片" :label-col="{ span: 5 }" :wrapper-col="{ span: 12}">
          <div>
            <a-upload
              listType="picture"
              :defaultFileList="fileListE"
              class="upload-list-inline"
              @preview="handlePreview"
              @change=" value => handleChange(value, editValue.goodsId)"
              :customRequest=" value => customRequest(value,editValue.goodsId)"
              v-decorator="['goodsImg']"
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
        <a-form-item label="商品类型" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-select style="width:100px;" v-decorator="['goodsType']">
            <a-select-option
              v-for="item in selectValue"
              :value="item.value"
              :key="item.value"
            >{{item.name}}</a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item label="购买信用点折扣（折）" :label-col="{ span: 8 }" :wrapper-col="{ span: 9 }">
          <a-input v-decorator="['discount']" />
        </a-form-item>
        <a-form-item label="订购期限" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['term']" />
        </a-form-item>
        <a-form-item label="现金售价(RMB)" :label-col="{ span: 6 }" :wrapper-col="{ span: 11 }">
          <a-input v-decorator="['cashPrice']" />
        </a-form-item>
        <a-form-item label="信用点售价" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['pointsPrice']" />
        </a-form-item>
        <a-form-item label="赠送信用点" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['complimentaryPoints']" />
        </a-form-item>

        <a-form-item label="排序" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
          <a-input v-decorator="['goodsSort']" />
        </a-form-item>
        <a-form-item label="商品状态" :label-col="{ span: 5 }" :wrapper-col="{ span: 8 }">
          <a-switch checkedChildren="已上架" unCheckedChildren="未上架" v-decorator="['goodsStatus']" />
        </a-form-item>
        <a-form-item label="商品图片" :label-col="{ span: 5 }" :wrapper-col="{ span: 12}">
          <div>
            <a-upload
              listType="picture"
              :defaultFileList="fileList"
              class="upload-list-inline"
              @preview="handlePreview"
              @change="handleChange"
              :customRequest="customRequest"
              v-decorator="['goodsImg']"
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
  serviceGoodsPage,
  updateServiceGoods,
  addServiceGoods,
  deleteServiceGoods,
  servicegoodsId,
  uploadGoodsPic
} from "api";
import moment from "moment";
import { match } from "minimatch";

const columns = [
  {
    title: "创建时间",
   
    dataIndex: "createTime",
    scopedSlots: { customRender: "createTime" },
     sorter: (a, b) =>
      moment(a.createTime).format("YYYY-MM-DD HH:mm:ss") >
      moment(b.createTime).format("YYYY-MM-DD HH:mm:ss")
  },
  {
    title: "商品名称",
  
    dataIndex: "goodsName",
    scopedSlots: { customRender: "goodsName" }
  },
  {
    title: "商品ID",
    // width: "18%",
    dataIndex: "goodsId"
  },
  {
    title: "商品图片",
    // width: "18%",
    dataIndex: "goodsImg",
    scopedSlots: { customRender: "goodsImg" }
  },
  {
    title: "商品类型(预留)",
    // width: "18%",
    dataIndex: "goodsType",
    scopedSlots: { customRender: "goodsType" }
  },
  {
    title: "订购期限（年）",
    dataIndex: "term",
    scopedSlots: { customRender: "term" }
  },
  {
    title: "现金售价(RMB)",
    width:100,
    dataIndex: "cashPrice",
    scopedSlots: { customRender: "cashPrice" }
  },
  {
    title: "信用点售价",
    width:100,
    dataIndex: "pointsPrice",
    scopedSlots: { customRender: "pointsPrice" }
  },
  {
    title: "赠送信用点",
    width:100,
    dataIndex: "complimentaryPoints",
    scopedSlots: { customRender: "complimentaryPoints" }
  },
  {
    title: "购买信用点折扣（折）",
    // width: "18%",
    dataIndex: "discount",
    scopedSlots: { customRender: "discount" }
  },
  {
    title: "销量",
    // width: "18%",
    dataIndex: "sales",
    scopedSlots: { customRender: "sales" }
  },
   {
    title: "排序(越小越靠前)",
    // width: "18%",
    dataIndex: "goodsSort",
    scopedSlots: { customRender: "goodsSort" },
    sorter: (a,b) => a.goodsSort - b.goodsSort
  },
  {
    title: "商品状态",
    width: "7%",
    dataIndex: "goodsStatus",
    scopedSlots: { customRender: "goodsStatus" }
  },
  {
    title: "操作",
    width: "7%",
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
        { name: "VIP商品", value: 1 },
        { name: "实物商品", value: 2 },
        { name: "应用商品", value: 3 },
        { name: "服务商", value: 4 },
        { name: "信用点充值", value: 5 }
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
      //   searchform: this.$form.createForm(this),
      fileListE: [],
      fileList: [],
      previewVisible: false,
      previewImage: "",
      imgVisible: false, //以上传图片的放大页面key外
      showImage: "" //放大图片rul外
    };
  },
  created() {
    this._serviceGoodsPage();
  },
  methods: {
    //判断商品类型
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
    _serviceGoodsPage() {
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
      serviceGoodsPage(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    stopbution(id, status) {
      //状态切换
      let that = this;
      const newData = [...that.data];
      const target = newData.filter(item => id === item.goodsId)[0];
      if (status == 1) {
        status = 0;
      } else {
        status = 1;
      }
      let formData = {};
      formData.paramsId = id;
      formData.goodsStatus = status;
      updateServiceGoods(formData).then(res => {
        if (res.code && target) {
          status === 1
            ? that.$message.success("已上架")
            : that.$message.success("已下架");
          target.goodsStatus = status;
          that.data = newData;
        }
      });
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
    cancelImg() {
      //取消放大图片外
      this.imgVisible = false;
    },
    imgClick(text) {
      //点击图片放大外
      this.imgVisible = true;
      this.showImage = text;
    },
    handleChange(value, id) {
      // 上传片列表回调
      if (id) {
        this.fileListE = value.fileList;
      } else {
        this.fileList = value.fileList;
      }
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
        if (values.goodsImg) {
          if (values.goodsImg.fileList[0]) {
            formData.goodsImg = values.goodsImg.fileList[0].url;
          }
        }
        if (values.cashPrice) {
          formData.cashPrice = values.cashPrice;
        }
        if (values.pointsPrice) {
          formData.pointsPrice = values.pointsPrice;
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
        if (values.complimentaryPoints) {
          formData.complimentaryPoints = values.complimentaryPoints;
        }
        if (values.discount) {
          formData.discount = values.discount;
        }
        if (values.goodsStatus) {
          if (values.goodsStatus === true) {
            formData.goodsStatus = 1;
          } else {
            formData.goodsStatus = 0;
          }
        }
        if (!err) {
          addServiceGoods(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that._serviceGoodsPage();
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
        formData.paramsId = that.editId;
        if (values.goodsImg) {
          if (values.goodsImg.fileList[0]) {
            formData.goodsImg = values.goodsImg.fileList[0].url;
          } else {
            formData.goodsImg = that.editValue.goodsImg;
          }
        }
        if (values.cashPrice) {
          formData.cashPrice = values.cashPrice;
        }
        if (values.pointsPrice) {
          formData.pointsPrice = values.pointsPrice;
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
        if (values.complimentaryPoints) {
          formData.complimentaryPoints = values.complimentaryPoints;
        }
        if (values.discount) {
          formData.discount = values.discount;
        }
        if (!err) {
          updateServiceGoods(formData).then(res => {
            if (res.code) {
              that.$message.success(res.msg);
              that._serviceGoodsPage();
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
    // //搜索
    // searchSubmit(e) {
    //   this.queryParam = this.firstParam;
    //   e.preventDefault();
    //   this.searchform.validateFields((err, values) => {
    //     console.log(values);

    //     let target = {};
    //     target.goodsName = values.goodsName;
    //     if (values.goodsType === "null") {
    //       values.goodsType = null;
    //     }
    //     target.goodsType = values.goodsType;
    //     this.queryParam = Object.assign({}, this.queryParam, target);
    //     this.getTableList();
    //   });
    // },
    handleOk() {
      //确定删除
      let that = this;
      deleteServiceGoods({ paramsId: this.delID }).then(res => {
        if (res.code) {
          that.$message.success(res.msg);
          that.confirmLoading = true;
          that.tableLoading = true;
          setTimeout(() => {
            that.visible = false;
            that.confirmLoading = false;
            that._serviceGoodsPage();
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