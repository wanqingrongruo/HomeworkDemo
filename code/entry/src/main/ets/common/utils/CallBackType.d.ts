
/**
 * 声明文件学习: https://ts.xcatliu.com/basics/declaration-files.html
 */

declare var EmptyCallback: () => void
declare var BoolCallback: (value: Boolean) => void

// 防止命名冲突, 用 namespace 包裹一层
export declare namespace Homework {
  interface Callback<T> {
      (T): void
  }
}

export interface Callback<T> {
  (T): void
}