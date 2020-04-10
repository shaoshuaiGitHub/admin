import Vue from 'vue'
import { Layout, Button, Menu, LocaleProvider, InputNumber, Icon, Row, Col, Tabs, Select, Input, DatePicker, message, Breadcrumb, Dropdown, Avatar, Table, Modal, Form, Checkbox, Pagination, Radio, Popconfirm, TimePicker, List, Switch, Upload, Drawer } from 'ant-design-vue'
import VDistpicker from 'v-distpicker'
import vcolorpicker from 'vcolorpicker'

Vue.use(Button)
Vue.use(Menu)
Vue.use(Icon)
Vue.use(Layout)
Vue.use(Breadcrumb)
Vue.use(Dropdown)
Vue.use(Avatar)
Vue.use(Table)
Vue.use(Modal)
Vue.use(Form)
Vue.use(Input)
Vue.use(message)
Vue.use(Checkbox)
Vue.use(Pagination)
Vue.use(Radio)
Vue.use(Row)
Vue.use(Col)
Vue.use(Select)
Vue.use(DatePicker)
Vue.use(LocaleProvider)
Vue.use(InputNumber)
Vue.use(Tabs)
Vue.use(Popconfirm)
Vue.use(TimePicker)
Vue.use(List)
Vue.use(Switch)
Vue.use(Upload)
Vue.component('v-distpicker', VDistpicker)
Vue.use(vcolorpicker)
Vue.use(Drawer)

Vue.prototype.$message = message
Vue.prototype.$modal = Modal