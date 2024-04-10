import Constants from '../common/constants/Constants';

@Component
export default struct MoviePage {

  build() {
    Row() {
      Text('Movie')
        .width(Constants.FULL_PERCENT)
        .textAlign(TextAlign.Center)
    }
    .backgroundColor($r('app.color.white'))
    .height(Constants.FULL_PERCENT)
    .width(Constants.FULL_PERCENT)
  }
}