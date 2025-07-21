import { BORDER_RADIUS } from '../constans/size';
import { rvp } from '../utils/responsive';

@Component
export default struct Card {
  @Prop cardPadding: number;
  @BuilderParam render: () => void

  build() {
    Column() {
      this.render()
    }
    .padding(this.cardPadding)
    .backgroundColor($r('app.color.white'))
    .borderRadius(rvp(BORDER_RADIUS))
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}