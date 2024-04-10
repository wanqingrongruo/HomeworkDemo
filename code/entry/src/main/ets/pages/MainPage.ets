import Constants from '../common/constants/Constants';
import TabItemModel from '../viewmodel/TabItemModel';
import MinePage from './MinePage';
import MoviesPage from './MoviesPage';
import UIPage from './UIPage';
import WebPage from './WebPage';

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  @State tabBarArray: TabItemModel[] = TabItemModel.getDefaultTabs();

  @Builder TabBuilder(index: number) {
    Column() {
        Column() {
          Image(this.currentIndex === index ? this.tabBarArray[index].iconSelected : this.tabBarArray[index].icon)
            .size({ width: 20, height: 20 })
          Text(this.tabBarArray[index].title)
            .fontSize($r('app.float.bar_font'))
            .fontColor(this.currentIndex === index ? $r('app.color.tab_selected_color') : $r('app.color.tab_normal_color'))
        }
        .width(Constants.FULL_PERCENT)
        .height('40vp')
        .justifyContent(FlexAlign.SpaceBetween)
    }
    .justifyContent(FlexAlign.Center)
    .height($r('app.float.tab_height'))
    .width(Constants.FULL_PERCENT)
    .border({
      width: {top: 1, left: 0, right: 0, bottom: 0}
    })
    .borderColor($r('app.color.tabBgColor'))
  }

  aboutToAppear() {

  }

  onPageShow() {

  }

  build() {
    Column() {
      Tabs() {
        ForEach(this.tabBarArray, (tabItem: TabItemModel, index?: number) => {
          TabContent() {
            if (tabItem.index == 0) {
              MoviesPage()
            } else if (tabItem.index == 1) {
              UIPage()
            } else if (tabItem.index == 2) {
              WebPage()
            } else {
              MinePage()
            }
          }.tabBar(this.TabBuilder(tabItem.index))
        }, (tabItem: TabItemModel) => JSON.stringify(tabItem))
      }
      .backgroundColor($r('app.color.white'))
      .barHeight($r('app.float.tab_height'))
      .height(Constants.FULL_PERCENT)
      .barMode(BarMode.Fixed)
      .barPosition(BarPosition.End)
      .shadow({
        radius: 4,
        color: $r('app.color.tabBgColor')
      })
      .onChange((index: number) => {
        this.currentIndex = index;
      })
    }
    .width(Constants.FULL_PERCENT)
    .height(Constants.FULL_PERCENT)
    .backgroundColor($r('app.color.white'))
  }

  onPageHide() {

  }

  aboutToDisappear() {

  }
}
