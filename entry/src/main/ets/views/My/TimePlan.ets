import { BORDER_RADIUS } from '../../constans/size'
import { rvp } from '../../utils/responsive'

@Component
export default struct TimePlan {
  build() {
    Column({ space: rvp(11) }) {
      Row() {
        Text('小米粒时光计划').fontColor('#2C5B37').fontSize(rvp(16)).fontWeight(700)
        Image($r('app.media.arrow_right')).width(6).height(12).fillColor('#FF2C5B37').objectFit(ImageFit.Fill)
      }.width('100%').justifyContent(FlexAlign.SpaceBetween)

      Text('充值后可解锁更多权益').fontColor('#2C5B37').fontSize(rvp(12))
    }
    .width('100%')
    .height(rvp(80))
    .margin({ top: rvp(15) })
    .borderRadius(rvp(BORDER_RADIUS))
    .padding({
      left: rvp(22),
      right: rvp(22),
      top: rvp(18),
      bottom: rvp(18)
    })
    .alignItems(HorizontalAlign.Start)
    .linearGradient({
      angle: 116,
      colors: [
        ['#FFF1CD', 0],
        ['#FFEBB5', 1],
      ]
    })
  }
}