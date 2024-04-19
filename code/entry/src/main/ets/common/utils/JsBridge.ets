/**
 * Js 桥接文件
 */
import webview from '@ohos.web.webview';

/**
 * define the runJavaScript code.
 * 这里需要与 web 端沟通
 * web 端使用原生方式:
 * window.ohosCallNative.callNative('原生方法名', { 参数key: 参数值 });
 * 例如: window.ohosCallNative.callNative('fly', { msg: roni });
 */
/*
  原生端的使用
  声明JSBridge:
  private jsBridge: JSBridge = new JSBridge(this.webController);
  使用:
   Web({
        src: $rawfile('MainPage.html'),
        controller: this.webController
      })
        .javaScriptAccess(true)
        .javaScriptProxy(this.jsBridge.javaScriptProxy)
        .height($r('app.float.web_height'))
        .onPageBegin(() => {
          this.jsBridge.initJsBridge();
        })
 */
const code = `
  const JSBridgeMap = {};
  let callID = 0;

  function JSBridgeCallback (id, params){
    JSBridgeMap[id](params);
    JSBridgeMap[id] = null;
    delete JSBridgeMap[id];
  }

  window.ohosCallNative = {
    callNative(method, params, callback){
      const id = callID++;
      const paramsObj = {
          callID: id,
          data: params || null
      }
      JSBridgeMap[id] = callback || (() => {});
      JSBridgeHandle.call(method, JSON.stringify(paramsObj));
    }
  }
`;

/**
 * javaScriptProxy object type.
 * 定义接口类型
 */
export interface callType {
  call: (func: string, params: string) => void
}

export interface JavaScriptItem {
  object: callType,
  name: string,
  methodList: Array<string>,
  controller: WebviewController
}

export interface ParamsItem {
  callID: number,
  data: Object
}

export default class JsBridge {
  controller: webview.WebviewController;

  constructor(controller: webview.WebviewController) {
    this.controller = controller;
  }

  /**
   * Injects the JavaScript object into window and invoke the function in window.
   *
   * @returns javaScriptProxy object.
   * 这里的 JSBridgeHandle 这个 name 来自于注入的 js code => JSBridgeHandle.call(method, JSON.stringify(paramsObj));
   */
  get javaScriptProxy(): JavaScriptItem {
    let result: JavaScriptItem = {
      object: {
        call: this.call
      },
      name: "JSBridgeHandle",
      methodList: ['call'],
      controller: this.controller
    }
    return result;
  }

  /**
   * initialize the bridge.
   * 在网页打开时调用，注入一些 js 代码
   */
  initJsBridge(): void {
    this.controller.runJavaScript(code);
  }

  // 随意实现的一个方法
  changeAmount = (): Promise<string> => {
    AppStorage.Set<boolean>('isClick', true);
    return new Promise((resolve) => {
      resolve('success');
    })
  }

  fly = (message: string): void => {
      AlertDialog.show({
        message: `${message} 直接原地起飞`,
        confirm: {
          value: '确定',
          action: () => {

          }
        },
        cancel: () => {
        }
      })
  }

  /**
   * Invoke the chooseContact function.
   * 具体的原生方法实现
   * 提供了两个实例
   */
  call = (func: string, params: string): void => {
    // 解析的参数, 具体使用在什么方法内, 是什么样子, 根据每个接口前端的定义决定
    const paramsObject: ParamsItem = JSON.parse(params);
    switch (func) {
      case 'changeAmount':
        let result = this.changeAmount();
        // js需要回调的处理
        result.then((data: string) => {
          this.callback(paramsObject?.callID, data);
        })
        break;
      case 'fly':
        // 不需要回调的处理
        let msg = paramsObject.data['msg']
        this.fly(msg);
        break;
      default:
        break;
    }

  }

  /**
   * The ArkTS invoke the WebView by using runJavaScript.
   */
  callback = (id: number, data: string): void => {
    // 注意这里的 "JSBridgeCallback" 来自  initJsBridge 方法中注入的 js code
    this.controller.runJavaScript(`JSBridgeCallback("${id}", ${JSON.stringify(data)})`);
  }
}