import {rvp} from '../../utils/responsive';
import {PADDING} from '../../constans/size';


@Component
export default struct Drawer {
  @Link show: boolean;
  @BuilderParam contentBuilderParams:()=>void=this.custom;
  @Require @Prop contentHeight: number;
@Builder
  custom() {}
close=()=>{
  this.show=false;
}
  build() {
    if (this.show) {
      Stack() {
        Column() {
        }.width('100%').height('100%').backgroundColor('rgba(0, 0, 0, 0.7)')
        .onClick(this.close).transition(
          TransitionEffect.OPACITY.animation({duration:200,curve:Curve.Linear})
        )

        Column() {
          this.contentBuilderParams()
        }.backgroundColor('#F6F6F6').width('100%').padding(rvp(15)).borderRadius({
          topLeft: rvp(10),
          topRight: rvp(10)
        })
        .transition(
          TransitionEffect.translate({x:0,y:this.contentHeight}).animation({duration:200,curve:Curve.Linear})
        )
        .alignItems(HorizontalAlign.Start)

      }
      .width('100%')
      .height('100%')
      .position({ x: 0, y: 0 })
      .zIndex(999)
      .alignContent(Alignment.BottomStart)
    }
  }
}
