import Constants from '../common/constants/Constants';
import NewsResult, { ListData } from '../network/NewsResult';
import { PullToRefresh } from '@ohos/pulltorefresh'
import NewsApiManager from '../network/NewsApiManager';
import distributedKVStore from '@ohos.data.distributedKVStore';
import KeyStorageManager from '../common/utils/KeyStorageManager';
import router from '@ohos.router';

@Component
export default struct MoviePage {
  private scroller: Scroller = new Scroller();
  @State dataSource: ListData[] = []
  private page: number = 1
  private isInit = true
  private dataStoreIdKey: string = "StoreIdKeyCacheData"
  private dataStoreDataKey: string = "StoreDataKeyCacheData"
  private managerConfig = {
    context: getContext(this),
    bundleName: "com.roni.homework"
  }
  private storageManager: KeyStorageManager

  // 获取网络数据
  loadData(callback: Callback<Boolean>) {
    let param = new NewParam(this.page);
    NewsApiManager.request(param).then((value: NewsResult) => {
      if (value.error_code == 0) {
        this.dataSource = value.result.data
        callback(true);
      } else {
        callback(false);
      }
    });
  }

  // 创建本地key-value
  createStorageManager() {
    this.storageManager = new KeyStorageManager(this.managerConfig, this.dataStoreIdKey);
  }

  getLocalData(): Promise<ListData[]> {
    return new Promise((resolve: Function) => {
      let dataArray: ListData[] = []
      if (this.storageManager) {
        this.storageManager.getData(this.dataStoreDataKey).then((value: ListData[]) => {
          resolve(value);
        }).catch((e) => {
          console.error(`获取 value 失败. Code: ${e.code}, message: ${e.message}`)
          resolve(dataArray);
        });
      }
    });
  }

  savaData() {
     let jsonString = JSON.stringify(this.dataSource);
     if (this.storageManager) {
       this.storageManager.putData(this.dataStoreDataKey, jsonString);
     }
  }

  aboutToAppear() {
    if (this.isInit) {
      this.createStorageManager()
      this.getLocalData().then((value: ListData[]) => {
        this.dataSource = value;
        this.loadData((isSuccess) => {
          if (isSuccess) {
            this.savaData();
          }
        });
      });
    }

    this.isInit = false;
  }

  build() {
    Column() {
      PullToRefresh({
        // 必传项，列表组件所绑定的数据
        data: $dataSource,
        // 必传项，需绑定传入主体布局内的列表或宫格组件
        scroller: this.scroller,
        // 必传项，自定义主体布局，内部有列表或宫格组件
        customList: () => {
          // 一个用@Builder修饰过的UI方法
          this.getListView();
        },
        // 可选项，下拉刷新回调
        onRefresh: () => {
          this.page = 1;
          return new Promise<string>((resolve, reject) => {
            this.loadData((isSuccess) => {
              if (isSuccess) {
                resolve('刷新成功');
              } else {
                resolve('刷新失败');
              }
            });
          });
        },
        // 可选项，上拉加载更多回调
        onLoadMore: () => {
          this.page += 1;
          return new Promise<string>((resolve, reject) => {
             this.loadData((isSuccess) => {
               if (isSuccess) {
                 resolve('');
               } else {
                 resolve('刷新失败');
               }
             });
          });
        },
        customLoad: null,
        customRefresh: null,
      })
    }
    .backgroundColor($r('app.color.white'))
    .height(Constants.FULL_PERCENT)
    .width(Constants.FULL_PERCENT)
  }

  @Builder
  private getListView() {
    List({ space: 0, scroller: this.scroller }) {
      ForEach(this.dataSource, (item: ListData) => {
        ListItem() {
          Column( { space: 20}) {
            Row() {
              Text(item.title)
                .fontColor($r('app.color.title_color'))
                .fontSize($r('app.float.title_font'))
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .layoutWeight(1)
              Text(item.author_name)
                .fontColor($r('app.color.red'))
                .fontSize($r('app.float.desc_font'))
                .maxLines(1)
                .margin({ left: 20 })
                .alignSelf(ItemAlign.Start)
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .width(Constants.FULL_PERCENT)
            .padding({ top: 8, left: 8, right: 8, bottom: 0 })

            if (item.thumbnail_pic_s && item.thumbnail_pic_s.length > 0) {
              Row() {
                Text(item.title)
                  .fontColor($r('app.color.tab_normal_color'))
                  .fontSize($r('app.float.desc_font'))
                  .alignSelf(ItemAlign.Start)
                  .margin({ top: 20, left: 8, right: 0, bottom: 20 })
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .layoutWeight(1)
                Image(item.thumbnail_pic_s)
                  .width(100)
                  .height(100)
                  .margin({ top: 20, left: 20, right: 8, bottom: 20 })
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)
              .height(140)
              .width(Constants.FULL_PERCENT)
            }

            Row() {
              Text(item.date)
                .fontColor($r('app.color.tab_normal_color'))
                .fontSize($r('app.float.desc_font'))
            }
            .justifyContent(FlexAlign.Start)
            .alignItems(VerticalAlign.Center)
            .height(30)
            .width(Constants.FULL_PERCENT)
            .padding({ top: 0, left: 8, right: 8, bottom: 0})
            .alignSelf(ItemAlign.Start)
          }
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .onClick(() => {
          router.pushUrl({
            url: "pages/NewsDetailPage",
            params: {
              item: item
            }
          })
        })
      }, item => item.uniquekey);
    }
    .width(Constants.FULL_PERCENT)
    .height(Constants.FULL_PERCENT)
    .backgroundColor($r('app.color.white'))
    .divider({ strokeWidth: 1, color: $r('app.color.tab_separate_color') })
    .edgeEffect(EdgeEffect.None) // 必须设置列表为滑动到边缘无效果
  }
}

class NewParam {
  key: string = '295029fb6afcfe5013d787ff167d05a7'
  page: number = 1;
  pageSize: number = 10;
  is_filter: number = 1;

  constructor(page: number) {
    this.page = page;
  }
}

interface Callback<T> {
  (T): void
}