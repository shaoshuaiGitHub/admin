<template>
  <div style="margin: -24px -24px 0px;">
    <div class="page-header-warp">
      <div class="ant-pro-grid-content">
        <div class="ant-page-header">
          <a-breadcrumb>
            <a-breadcrumb-item>首页</a-breadcrumb-item>
            <a-breadcrumb-item>会员管理</a-breadcrumb-item>
            <a-breadcrumb-item>会员列表</a-breadcrumb-item>
          </a-breadcrumb>
          <div class="ant-page-header-heading">
            <span class="ant-page-header-heading-title">会员列表</span>
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
          :style="{display:'flex',flexDirection:'row',justifyContent:'space-between',marginBottom:'40px'}"
        >
          <a-form layout="inline" :form="searchform" @submit="searchSubmit">
            <!-- 搜索框 -->
            <a-form-item>
              <a-input v-decorator="['inValue']" placeholder="输入条件" style="width:300px">
                <a-select v-decorator="['selKey',{initialValue: 'userName'}]" slot="addonBefore">
                  <a-select-option value="userName">会员名</a-select-option>
                  <a-select-option value="phone">手机号</a-select-option>
                  <a-select-option value="realName">真实姓名</a-select-option>
                </a-select>
              </a-input>
            </a-form-item>
            <a-form-item label="推荐人手机号">
              <a-input v-decorator="['upUserPhone']"></a-input>
            </a-form-item>
            <a-row v-if="isCollapse">
              <a-col>
                <a-form-item label="会员类型">
                  <a-select style="width:150px;" v-decorator="['vtype']">
                    <a-select-option value="1">初级vip</a-select-option>
                    <a-select-option value="2">中级vip</a-select-option>
                    <a-select-option value="3">高级vip</a-select-option>
                    <a-select-option value="4">至尊vip</a-select-option>
                    <a-select-option value="null">全部</a-select-option>
                  </a-select>
                </a-form-item>
                <a-form-item label="状态">
                  <a-select style="width:150px;" v-decorator="['statu']">
                    <a-select-option value="0">停用</a-select-option>
                    <a-select-option value="1">启用</a-select-option>
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
        <a-table
          :loading="tableLoading"
          :columns="columns"
          :dataSource="data"
          :pagination="pagination"
          :rowKey="record => record.uid"
          @change="handleTableChange"
          :scroll="{x:800}"
        >
          <template slot="vtype" slot-scope="text">{{typeFilter(text)}}</template>
          <template slot="headPic" slot-scope="text">
            <img
              :src="text"
              alt="未找到图片"
              :style="{width:'50px',height:'50px'}"
              @click="() => imgClick(text)"
            />
          </template>
          <template slot="statu" slot-scope="text, record">
            <a-switch
              checkedChildren="启用"
              unCheckedChildren="停用"
              :defaultChecked="record.statu === 1"
              @change="() => stopbution(record.uid, record.statu)"
            />
          </template>
          <template slot="action" slot-scope="text, record">
            <a style="margin-right:10px;" slot="action" @click="() => editor(record.uid,record)">编辑</a>
          </template>
        </a-table>
      </a-layout-content>
      <a-modal
        centered
        title="修改服务配置"
        :visible="modify.visible"
        :confirmLoading="modify.confirmLoading"
        @cancel="modifyCancel"
        :footer="null"
      >
        <a-form :form="modifyform" @submit="modifySubmit">
          <a-form-item label="会员名" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['userName',{initialValue: editValue.userName}]" />
          </a-form-item>
          <a-form-item label="手机号" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['phone',{initialValue: editValue.phone}]" />
          </a-form-item>
          <a-form-item label="微信号" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['wechatId',{initialValue: editValue.wechatId}]" />
          </a-form-item>
          <a-form-item label="推荐人ID" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['upUserId',{initialValue: editValue.upUserId}]" />
          </a-form-item>
          <a-form-item label="推荐人手机号" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-input v-decorator="['upUserPhone',{initialValue: editValue.upUserPhone}]" />
          </a-form-item>
          <a-form-item label="性别" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-select style="width:100px;" v-decorator="['sex',{initialValue: editValue.sex}]">
              <a-select-option :value="0">男</a-select-option>
              <a-select-option :value="1">女</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="出生日期" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-date-picker
              format="YYYY-MM-DD"
              v-decorator="['birthday',{initialValue: editValue.birthday ? moment( editValue.birthday,'YYYY-MM-DD HH:mm:ss') : null}]"
            />
          </a-form-item>
          <!-- <a-form-item label="所在地" :label-col="{ span: 5 }" :wrapper-col="{ span: 18 }">
            <v-distpicker
              :province="getListData.province"
              :city="getListData.city"
              :area="getListData.district"
              @province="onChangeProvince"
              @city="onChangeCity"
              @area="onChangeArea"
            ></v-distpicker>
          </a-form-item>-->
          <a-form-item label="详细地址" :label-col="{ span: 5 }" :wrapper-col="{ span: 16 }">
            <a-input v-decorator="['address',{initialValue: editValue.address}]" />
          </a-form-item>
          <a-form-item label="会员类型" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-select style="width:100px;" v-decorator="['vtype',{initialValue: editValue.vtype }]">
              <a-select-option :value="1">初级vip</a-select-option>
              <a-select-option :value="2">中级vip</a-select-option>
              <a-select-option :value="3">高级vip</a-select-option>
              <a-select-option :value="4">至尊vip</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="服务商类型" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-select
              style="width:100px;"
              v-decorator="['serviceType',{initialValue: editValue.serviceType}]"
            >
              <a-select-option :value="1">初级</a-select-option>
              <a-select-option :value="2">中级</a-select-option>
              <a-select-option :value="3">高级</a-select-option>
              <a-select-option :value="4">至尊</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="新头像" :label-col="{ span: 5 }" :wrapper-col="{ span: 12}">
            <div>
              <a-upload
                listType="picture"
                :defaultFileList="fileListE"
                class="upload-list-inline"
                @preview="handlePreview"
                @change=" value => handleChange(value, editValue.headPic)"
                :customRequest=" value => customRequest(value,editValue.uid)"
                v-decorator="['headPic', {rules: [{ required: false, message: '请上传图片' }]}]"
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
          <a-form-item label="状态" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch
              checkedChildren="启用"
              unCheckedChildren="停用"
              v-decorator="['statu',{ initialValue: editValue.statu === 1,valuePropName: 'checked'}]"
            />
          </a-form-item>
          <a-form-item label="是否微信绑定" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch
              checkedChildren="是"
              unCheckedChildren="否"
              v-decorator="['isSubscribe',{ initialValue: editValue.isSubscribe === 1,valuePropName: 'checked'}]"
            />
          </a-form-item>
          <a-form-item label="是否实名认证" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }">
            <a-switch
              checkedChildren="是"
              unCheckedChildren="否"
              v-decorator="['isRealNameAuthentication',{ initialValue: editValue.isRealNameAuthentication === 1,valuePropName: 'checked'}]"
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
  userList,
  UchangeStatu,
  userInfoBase,
  updateUserInfoBase,
  uploadUseHead,
  updateUserList
} from "api";
import moment from "moment";
import VDistpicker from "v-distpicker";
const columns = [
  {
    title: "头像",
    dataIndex: "headPic",
    scopedSlots: { customRender: "headPic" }
  },
  {
    title: "UID",
    dataIndex: "uid"
  },
  {
    title: "会员名",
    dataIndex: "userName"
  },
  {
    title: "手机号",
    dataIndex: "phone",
    scopedSlots: { customRender: "phone" }
  },
  {
    title: "昵称",
    dataIndex: "nickName",
    scopedSlots: { customRender: "nickName" }
  },
  {
    title: "真实姓名",
    dataIndex: "realName",
    scopedSlots: { customRender: "realName" }
  },
  {
    title: "会员类型",
    dataIndex: "vtype",
    scopedSlots: { customRender: "vtype" }
  },
  {
    title: "注册时间",
    dataIndex: "createTime",
    scopedSlots: { customRender: "createTime" }
  },
  {
    title: "推荐人手机号",
    dataIndex: "upUserPhone",
    scopedSlots: { customRender: "upUserPhone" }
  },
  {
    title: "会员状态",
    width:100,
    dataIndex: "statu",
    scopedSlots: { customRender: "statu" }
  },
  {
    title: "操作",
    width:"6%",
    dataIndex: "action",
    scopedSlots: { customRender: "action" }
  }
];

export default {
  data() {
    return {
      isCollapse: false,
      tableLoading: true,
      delmsg: null,
      data: null,
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
      firstParam: {
        pageNum: 0, //第几页
        pageSize: 10 //每页中显示数据的条数
      },
      searchform: this.$form.createForm(this),
      modifyform: this.$form.createForm(this),
      startValue: null,
      endValue: null,
      endOpen: false,
      fileListE: [],
      previewVisible: false,
      previewImage: "",
      bgImgUrl: "",
      imgVisible: false, //以上传图片的放大页面key外
      showImage: "" //放大图片rul外
      // getListData: {
      //   province: "",
      //   city: "",
      //   district: ""
      // }
    };
  },
  components: { VDistpicker },
  created() {
    this._userList();
  },
  methods: {
    moment,
    _userList() {
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
      userList(that.queryParam).then(res => {
        const pagination = { ...that.pagination };
        pagination.total = res.data.total;
        that.pagination = pagination;
        that.data = res.data.list;
        setTimeout(() => {
          that.tableLoading = false;
        }, 200);
      });
    },
    typeFilter(text) {
      if (text === 1) {
        return "初级vip";
      } else if (text === 2) {
        return "中级vip";
      } else if (text === 3) {
        return "高级vip";
      } else {
        return "至尊vip";
      }
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

    stopbution(id, status) {
      //状态切换
      let that = this;
      const target = that.data.filter(item => id === item.uid)[0];
      if (status == 1) {
        status = 0;
      } else {
        status = 1;
      }
      let formData = {};
      formData.uid = id;
      formData.statu = status;
      UchangeStatu(formData).then(res => {
        if (res.code) {
          status === 1
            ? that.$message.success("已经启用了该账号")
            : that.$message.success("已经停用了该账号");
          target.statu = status;
        }
      });
    },

    editor(id, editValue) {
      //点击修改按钮
      this.editValue = editValue;
      this.editId = id;
      this.modify.visible = true;
      userInfoBase({ uid: id }).then(res => {
        if (res.code) {
          //  let addressStr = res.data.address
          //  let addressArr = [];
          //   if(addressStr.indexOf("-") != -1){
          //     addressArr = addressStr.split("-");
          //     this.getListData.province = addressArr[0];
          //     this.getListData.city = addressArr[1];
          //     this.getListData.district = addressArr[3];
          //     res.data.address = addressArr[4];
          //   }
          console.log(res.data);
          this.editValue = { ...res.data, ...this.editValue };
        }
      });
    },
    customRequest(data, id) {
      console.log(id);
      //自定义上传
      const formData = new FormData();
      formData.append("file", data.file);
      uploadUseHead(formData).then(res => {
        if (res.code) {
          this.$message.success(res.msg);
          this.fileListE[0].status = "done";
          this.bgImgUrl = res.data.url;
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
    handleChange({ fileList }, id) {
      // 上传片列表回调
      this.fileListE = fileList;
    },

    // // 地址联级接收
    // onChangeProvince(data) {
    //   this.getListData.province = data.value;
    // },
    // onChangeCity(data) {
    //   this.getListData.city = data.value;
    // },
    // onChangeArea(data) {
    //   this.getListData.district = data.value;
    // },
    // 修改用户
    modifySubmit(e) {
      let that = this;
      e.preventDefault();
      that.modifyform.validateFields((err, values) => {
        // console.log(values);
        values.uid = that.editId;
        values.userInfoId = that.editValue.userInfoId;
        if (values.statu) {
          values.statu = 1;
        } else {
          values.statu = 0;
        }
        if (values.isRealNameAuthentication) {
          values.isRealNameAuthentication = 1;
        } else {
          values.isRealNameAuthentication = 0;
        }
        if (values.isSubscribe) {
          values.isSubscribe = 1;
        } else {
          values.isSubscribe = 0;
        }
        if (values.birthday) {
          values.birthday = values.birthday.format("YYYY-MM-DD HH:mm:ss");
        }
        if (values.headPic) {
          values.headPic = that.bgImgUrl;
        }
        let formData = {};
        for (var key in values) {
          if (values.hasOwnProperty(key)) {
            formData[key] = values[key];
            console.log(formData);
          }
        }
        if (!err) {
          updateUserInfoBase(formData).then(res => {
            if (res.code) {
              updateUserList(formData).then(res => {
                if (res.code) {
                  that.$message.success(res.msg);
                  that.bgImgUrl = "";
                  that.fileListE = [];
                  that.previewImage = "";
                  that.modify.visible = false;
                  that._userList();
                }
              });
            }
          });
        }
      });
    },
    modifyCancel() {
      this.bgImgUrl = "";
      this.fileListE = [];
      this.previewImage = "";
      this.modify.visible = false;
    },
    resetSearch() {
      this.searchform.resetFields();
      this.queryParam = this.firstParam;
      this._financeOrder();
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
        if (values.statu === "null") {
          values.statu = null;
        }
        if (values.vtype === "null") {
          values.vtype = null;
        }
        target.endTime = values.endTime;
        target.startTime = values.startTime;
        target.statu = values.statu;
        target.vType = values.vtype;
        target.upUserPhone = values.upUserPhone;
        if (values.inValue) {
          const str = values.selKey;
          target[str] = values.inValue;
        }
        this.queryParam = Object.assign({}, this.queryParam, target);
        this.getTableList();
      });
    }
  }
};
</script>