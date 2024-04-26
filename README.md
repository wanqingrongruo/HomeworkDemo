# HomeworkDemo
鸿蒙学习 demo, 高级开发者认证作业

作业旨在实操

## 作业3
1. 新增登录逻辑, 打开 app 判断是否已登录(本地缓存用户数据), 如果未登录显示登录页面, 如果已登录显示原来的主页面(主页面显示状态栏 非全屏)
2. 登录页面全屏显示, 不现实状态栏, 沉浸式窗口. 输入账号 和验证码后 登录按钮变为可点击状态
3. 点击登录按钮 显示 图形验证码窗口(居中显示, 有背景色, 有输入框, 可切换图片验证码), 输入验证码, 正确后, 提示登录成功, 保存用户信息, 通知登录页面 切换到 主页面
4. 我的页面新增用户显示, 如果未登录显示空字符串, 已登录显示 用户名, 用户名下面有退出按钮, 点击退出按钮, 清除缓存的用户信息, 弹起登录页面

功能点:
1. 窗口使用, 全屏显示, 隐藏导航和状态栏, 创新子窗口: https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V2/js-apis-window-0000001477981397-V2
2. 用户信息缓存: @ohos.data.preferences, 对上次作业保存 tab 切换索引 以及本次用户信息的缓存 进行 工具类抽象
3. TextInput 等组件的使用
4. router.replace 使用
5. EventHub 的简单使用, 不同 page 之间的信息传递

资料:
包括 图片验证码图片, UI 预览图, 预览视频

## 作业2
1. 每次打开 app 显示上一次启动 app 最后切换停留的 tab 
2. 完成第三个 tab, web tab 的 UI

web tab的 内容: 
1. 设置导航, 构建两个相同样式不同文字的按钮, ui 样式见截图, 有导航标题 和菜单按钮 => 使用 @Styles 和 @Extend 对相同样式进行定义并考虑怎么跨文件使用, Navigation使用
2. 点击跳转到新页面分别加载本地 html 和 远端网页(www.baidu.com), UI 见截图, 使用 Navigator 实现跳转 => web组件的使用, Navigator 使用
3. 完成本地 html 的交互, 原生调用 js 方法: startDraw,  js 调用原生方法: 对象 name: Toast, 方法名: fly, 传递参数: { msg: "xxx"} => web 与原生的交互



资料:
见压缩包
注意关于本地 html 资源包含  index.html, index.js, index.css, 以及 img 资源, 解压后放入 rawfile 文件夹下, 各层目录保留(目录详情见截图, 具体原因可以查看 index.js 代码, 关于交互部分也可查看 js 代码) 



## 作业1 

### 截图

![1](./img/1.jpg)
![2](./img/2.jpg)
![3](./img/3.gif)

### 功能点:
1. 创建一个支持 4 个 tab的页面
2. 完成第一个 tab, 其他先空着

第一个 tab 内容:
1. 构建 列表 UI, 不要求完全一样, 学习构建 ui 即可
2. 网络请求数据, 支持上拉加载,下拉刷新 (引用第三方库实现即可)
3. 缓存历史数据, 每次打开 app 先显示历史缓存,获取到新数据后刷新
4. 点击一行打开对应详情页, 用基础 ui 写一个详情页, 全屏展示, 返回退出全屏

资料:
可以使用聚合数据的, 但是需要注册账号和实名认证
api详情: https://www.juhe.cn/docs/api/id/235
可以寻找其他免费的, 比如这个平台 https://www.free-api.com

#### 一些资源
几个色值:

```
 {
      "name": "white", // 背景色
      "value": "#FFFFFF"
    },
    {
      "name": "tab_separate_color",  // 分割线
      "value": "#E7E7E7"
    },
    {
      "name": "tab_normal_color", // tab 的 title 默认颜色
      "value": "#66666A"
    },
    {
      "name": "tab_selected_color", // tab 的 title 选中颜色
      "value": "#000000"
    }
```

icon 资源见icons文件夹

#### 一些说明
因为目前大家还都只能使用  api9, 所以使用第三方库依赖 如果调不通, 记得去看一下三方库的 readme 和 issue
有的库支持了 api10或者更高, 有不兼容的问题, api 需要使用指定版本
