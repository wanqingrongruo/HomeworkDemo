import window from '@ohos.window'

/**
 * 窗口管理类,单例
 * 支持设置沉浸窗口和普通窗口
 * 支持创建显示指定 page 的子窗口, 自定义窗口 size
 * 官方文档: https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V2/js-apis-window-0000001477981397-V2#ZH-CN_TOPIC_0000001573929313__window
 */
export default class WindowManager {
  private static instance: WindowManager

  // 窗口管理器
  private windowStage?: window.WindowStage;
  // 子窗口
  private subWindow?: window.Window;

  // 初始化方法私有-创建单例的方式
  private constructor() {
  }

  // 单例
  static getInstance(): WindowManager {
    if (!WindowManager.instance) {
      WindowManager.instance = new WindowManager();
    }

    return WindowManager.instance;
  }

  setWindowStage(windowStage: window.WindowStage) {
    this.windowStage = windowStage;
  }

  /*
   * 设置沉浸式主窗口
   * 全屏显示, 隐藏状态栏和导航栏
   * */
  setMainWindowImmersive() {
    if (this.windowStage === undefined) {
      return;
    }

    this.windowStage.getMainWindow().then((window: window.Window) => {
      // 全屏显示, 全屏状态下状态栏 导航栏仍然显示
      window.setWindowLayoutFullScreen(true);
      // 状态栏 导航栏隐藏
      window.setWindowSystemBarEnable([]);
    });
  }

  /*
   * 设置普通主窗口
   * 全屏显示, 状态栏和导航栏显示
   * 支持设置状态栏和导航栏属性
   * */
  setMainWindowNormal(systemBarProperties?: window.SystemBarProperties) {
    if (this.windowStage === undefined) {
      return;
    }

    this.windowStage.getMainWindow().then((window: window.Window) => {
      // 全屏显示
      window.setWindowLayoutFullScreen(false);
      // 状态栏 导航栏显示
      window.setWindowSystemBarEnable(['status', 'navigation']);
      // 设置 导航栏状态栏属性
      if (systemBarProperties) {
        window.setWindowSystemBarProperties(systemBarProperties);
      }
    });
  }

  destroySubWindow() {
    if (this.subWindow) {
      this.subWindow.destroyWindow();
    }
  }

  createSubWindow(rect: WindowRect, pagePath: string, windowBgColor?: string) {
    if (this.windowStage === undefined) {
      return;
    }

    this.windowStage.createSubWindow("subWindow").then((window) => {
      this.subWindow = window;
      this.subWindow.moveWindowTo(rect.x, rect.y);
      this.subWindow.resize(rect.width, rect.height);
      this.subWindow.setUIContent(pagePath).then(() => {
        if (windowBgColor) {
          this.subWindow.setWindowBackgroundColor(windowBgColor);
        }
        this.subWindow.showWindow();
      })
    });
  }
}

export class WindowRect {
  x: number;
  y: number;
  width: number;
  height: number;

  constructor(x: number, y: number, width: number, height: number) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  static createWithContainer(containerW: number, containerH: number, windowW: number, windowH: number): WindowRect {
    let x = (containerW - windowW) / 2
    let y = (containerH - windowH) / 2
    return new WindowRect(x, y, windowW, windowH);
  }
}