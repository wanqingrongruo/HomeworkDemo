export default class NewsResult {
  reason: string;
  result: InnerResult;
  error_code: number;

  constructor() {
    this.reason = 'fault';
    this.error_code = -1;
    this.result = new InnerResult();
  }
}

export class InnerResult {
  stat: string;
  data: ListData[];
  page: string;
  pageSize: String;

  constructor() {
    this.stat = '';
    this.data = [];
    this.page = '1';
    this.pageSize = '30';
  }
}

export class ListData {
  uniquekey: string;
  title: string;
  date: string;
  author_name: string;
  url: string;
  thumbnail_pic_s: string;
  thumbnail_pic_s02: string;
  thumbnail_pic_s03: string;
}