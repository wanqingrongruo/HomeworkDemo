
import http from '@ohos.net.http';
import Constants from '../common/constants/Constants';
import ResponseResult from './ResponseResult';

export const enum ContentType {
    JSON = 'application/json',
    FORM = 'multipart/form-data',
    URLENCODED = 'application/x-www-form-urlencoded'
}

export default class NetworkManager {
   static request(url: string, method: http.RequestMethod, contentType: ContentType, params?: Object): Promise<ResponseResult> {
        let httpRequest = http.createHttp();
        var extraData = params
        // 处理 get 请求传递的参数
        if (method == http.RequestMethod.GET) {
            extraData = null;
            if (params != null) {
                var paramStr = '';
                var index = 0;
                Object.entries(params).forEach(([k, v]) => {
                    let str: string
                    if (index == 0) {
                        str = k + "=" + v
                    } else {
                        str = "&" + k + "=" + v
                    }
                    paramStr += str;
                    index += 1;
                });

                if (paramStr.length != 0) {
                    if (url.includes("?")) {
                      url = url.concat('&' + paramStr)
                    } else {
                      url = url.concat("?" + paramStr)
                    }
                }
            }
        }

        let responseResult = httpRequest.request(url, {
            method: method,
            readTimeout: Constants.HTTP_READ_TIMEOUT,
            header: {
                'Content-Type': contentType
            },
            connectTimeout: Constants.HTTP_READ_TIMEOUT,
            extraData: extraData
        });
        let serverData = new ResponseResult();
        // Processes the data and returns.
        return responseResult.then((value: http.HttpResponse) => {
            if (value.responseCode === Constants.HTTP_CODE_200) {
                // Obtains the returned data.
                let result = `${value.result}`;
                // 根据接口约定设计
                // 此处当 http 请求成功后, 直接判断成功
                // 具体业务层是否成功, 解析 resultJson, 根据约定判定
                let resultJson = JSON.parse(result);
                serverData.data = resultJson;
                serverData.code = "200";
                serverData.msg = "";
            } else {
                serverData.msg = `${$r('app.string.http_error_message')}&${value.responseCode}`;
            }
            return serverData;
        }).catch(() => {
            serverData.msg = $r('app.string.http_error_message');
            return serverData;
        });
    }
}