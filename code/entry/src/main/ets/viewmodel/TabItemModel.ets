
/*
Tab Item 的模型类
 */

export default class TabItemModel {
  index: number; // 索引
  title: ResourceStr; // 标题
  icon: ResourceStr; // 正常态图标
  iconSelected: ResourceStr; // 选中态图标

  constructor(index: number, title: ResourceStr, icon: ResourceStr, iconSelected: ResourceStr) {
    this.index = index;
    this.title = title;
    this.icon = icon;
    this.iconSelected = iconSelected;
  }

  // 获取默认的tab items 数据
  static getDefaultTabs() : TabItemModel[] {
    return [
      new TabItemModel(0, $r('app.string.tab_movie'), $r('app.media.ic_movie'), $r('app.media.ic_movie_selected')),
      new TabItemModel(1, $r('app.string.tab_ui'), $r('app.media.ic_ui'), $r('app.media.ic_ui_selected')),
      new TabItemModel(2, $r('app.string.tab_web'), $r('app.media.ic_web'), $r('app.media.ic_web_selected')),
      new TabItemModel(3, $r('app.string.tab_mine'), $r('app.media.ic_mine'), $r('app.media.ic_mine_selected'))
    ]
  }
}