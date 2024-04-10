import Constants from '../common/constants/Constants';

@Component
export default struct UIPage {

  build() {
    Row() {
      Text('UI')
        .width(Constants.FULL_PERCENT)
        .textAlign(TextAlign.Center)
    }
    .backgroundColor($r('app.color.white'))
    .height(Constants.FULL_PERCENT)
    .width(Constants.FULL_PERCENT)
  }
}