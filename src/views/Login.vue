<template>
  <div class="user-layout-wrapper tablet">
    <div class="container">
      <div class="header">
        <a href="/">
          <img src="../assets/logo.png" alt="logo" class="logo" />
          <span class="title">期望管家平台</span>
        </a>
      </div>
      <div class="desc">欢迎登录期望管家平台</div>
      <div class="main">
        <a-form
          id="components-form-demo-normal-login"
          :form="form"
          class="login-form"
          @submit="handleSubmit"
        >
          <a-form-item>
            <a-input
              v-decorator="[
          'account',
          { rules: [{ required: true, message: '请输入帐号!' }] }
        ]"
              placeholder="帐号"
            >
              <a-icon slot="prefix" type="user" style="color: rgba(0,0,0,.25)" />
            </a-input>
          </a-form-item>
          <a-form-item>
            <a-input
              v-decorator="[
          'password',
          { rules: [{ required: true, message: '请输入密码!' }] }
        ]"
              type="password"
              placeholder="密码"
            >
              <a-icon slot="prefix" type="lock" style="color: rgba(0,0,0,.25)" />
            </a-input>
          </a-form-item>
          <a-form-item>
            <a-checkbox
              v-decorator="[
          'remember',
          {
            valuePropName: 'checked',
            initialValue: true,
          }
        ]"
            >自动登录</a-checkbox>
            <a class="login-form-forgot" href>忘记密码</a>
            <a-button type="primary" html-type="submit" class="login-form-button">登录</a-button>
          </a-form-item>
        </a-form>
      </div>
    </div>
  </div>
</template>

<script>
import { mapMutations } from "vuex";
import { login, postResource } from "api";
export default {
  data() {
    return {};
  },
  beforeCreate() {
    this.form = this.$form.createForm(this);
  },
  methods: {
    ...mapMutations(["set_userinfo", "set_usermenu"]),
    handleSubmit(e) {
      e.preventDefault();

      this.form.validateFields((err, values) => {
        if (values.account && values.password) {
          let formData = new FormData();
          formData.append("account", values.account);
          formData.append("password", values.password);
          login(formData).then(res => {
            if (res.code) {
              this.$store.dispatch("set_userinfoFun", res.data.adminInfo);
              this.$store.dispatch("set_usermenuFun", res.data.resource);
              // postResource().then(Response => {
              //   if(Response.code){
              //     this.$store.dispatch("set_usermenuFun", Response.data.content);
              //     console.log(Response.data.content)
              //   }
              // });
              this.$router.replace("/");
            }
          });
        }
        if (!err) {
        }
      });
    }
  }
};
</script>
<style>
#components-form-demo-normal-login .login-form {
  max-width: 300px;
}
#components-form-demo-normal-login .login-form-forgot {
  float: right;
}
#components-form-demo-normal-login .login-form-button {
  width: 100%;
}
.user-layout-wrapper {
  height: 100%;
}
.container {
  width: 100%;
  min-height: 100%;
  background: #f0f2f5 url(../assets/background.5825f033.svg) no-repeat 50%;
  background-size: 100%;
  padding: 110px 0 144px;
  position: relative;
}
.main {
  min-width: 260px;
  width: 368px;
  margin: 0 auto;
}
.header {
  height: 44px;
  line-height: 44px;
  text-align: center;
}
.header .logo {
  height: 44px;
  vertical-align: top;
  margin-right: 16px;
  border-style: none;
}
.header .title {
  font-size: 33px;
  color: rgba(0, 0, 0, 0.85);
  font-family: Avenir, Helvetica Neue, Arial, Helvetica, sans-serif;
  font-weight: 600;
  position: relative;
  top: 2px;
}
.desc {
  font-size: 14px;
  color: rgba(0, 0, 0, 0.45);
  margin-top: 12px;
  margin-bottom: 40px;
  text-align: center;
}
</style>