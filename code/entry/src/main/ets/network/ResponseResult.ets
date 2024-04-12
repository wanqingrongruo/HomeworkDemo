export default class ResponseResult {
  code: string;
  msg: ResourceStr
  data: string | Object | ArrayBuffer;

  constructor() {
    this.code = '';
    this.msg = '';
    this.data = '';
  }
}