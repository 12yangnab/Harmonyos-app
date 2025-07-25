import { PADDING } from '../../constans/size';
import { rvp } from '../../utils/responsive';

@Component
export default struct SearchBar {
  @Prop bgColor: string;
  @Prop fontColor: string;

  build() {
    Row() {
      Text("北京").fontSize(rvp(14)).fontColor(this.fontColor)
      Row() {
        Image($r("app.media.search")).imageStyles(rvp(18)).margin({ right: rvp(10) })
        // layoutWeight(1) 占剩下的空间的1份（占据剩下空间）
        TextInput({ placeholder: '公司/地铁/小区，马上搜索' })
          .layoutWeight(1)
          .height('100%')
          .fontSize(rvp(12))
          .placeholderColor($r('app.color.gray'))
          .placeholderFont({ size: rvp(12) })
          .caretColor($r('app.color.gray'))// 光标颜色
          .padding(0)
          .backgroundColor($r('app.color.white'))
          .stateStyles({
            // 状态样式
            pressed: textInputStyles // 按下状态的样式
          })

        Column() {
        }.width(rvp(1)).height(rvp(18)).backgroundColor('#D7D7D7').margin({ left: rvp(10) })

        Image($r("app.media.position")).imageStyles(rvp(18)).margin({ left: rvp(16) })
      }
      .width(rvp(244))
      .height(rvp(38))
      .backgroundColor($r('app.color.white'))
      .padding({ left: rvp(PADDING), right: rvp(PADDING) })
      .border({
        width: rvp(1),
        radius: rvp(52),
        color: '#D7D7D7'
      })

      // 图片需要通过 fillColor 修改颜色，只有 svg 图片能用
      Image($r("app.media.message")).imageStyles(rvp(24)).fillColor(this.fontColor)
    }
    .width('100%')
    .padding({
      left: rvp(PADDING),
      right: rvp(PADDING),
      top: rvp(4),
      bottom: rvp(4)
    })
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(this.bgColor)
  }
}

/*
  @Styles: 用来定义复用样式
  @Extend: 用来扩展组件样式（只有这个组件能用）

  @Styles 和 @Extend 都可以用来复用样式，有什么区别：
    1. @Styles 只支持通用属性和通用事件。@Extend 即通用属性和通用事件，也支持定义组件私有属性和私有事件
    2. @Styles 不支持传参。@Extend 支持传参（更灵活）
    3. @Styles 可以定义组件内或全局。@Extend 只支持

    注意：全局指的是当前文件内生效。不是真正的全局
 */

@Extend(Image)
function imageStyles(size: number) {
  .width(size).height(size).objectFit(ImageFit.Fill)
}

@Styles
function textInputStyles() {
  .backgroundColor('#fff')
}