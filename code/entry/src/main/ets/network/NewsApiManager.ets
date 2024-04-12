import http from '@ohos.net.http';
import NetworkManager, { ContentType } from './NetworkManager';
import NewsResult from './NewsResult';
import ResponseResult from './ResponseResult';

export default class NewsApiManager {
  private static baseUrl = "http://v.juhe.cn/toutiao/index"

  static request(params?: Object): Promise<NewsResult> {
    let result = NetworkManager.request(this.baseUrl, http.RequestMethod.GET, ContentType.URLENCODED, params);
    let serverData = new NewsResult();
    // Processes the data and returns.
    return new Promise((resolve: Function) => {
      result.then((value: ResponseResult) => {
        if (value.code === '200') {
          resolve(value.data)
        } else {
          resolve(serverData);
        }
      }).catch(() => {
        resolve(serverData);
      });
    });
  }
}