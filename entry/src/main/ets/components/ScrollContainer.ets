import { window } from '@kit.ArkUI';
import { IColor } from '../model/HomeData';
import { getWindowTopHeight, rvp } from '../utils/responsive';

@Component
export default struct ScrollContainer {
  @BuilderParam contentBuilder: () => void = this.defaultBuilder
  @BuilderParam navBuilder: ($$: IColor) => void = this.defaultBuilder
  scrollY: number = 0;
  @State bgColor: string = 'rgba(255, 255, 255, 0)'
  @State fontColor: string = 'rgb(255, 255, 255)'
  // 设置 window 状态栏颜色
  setWindowStatusColor = async () => {
    const windowClass = await window.getLastWindow(getContext())
    windowClass.setWindowSystemBarProperties({
      statusBarContentColor: this.fontColor,
      navigationBarContentColor: this.fontColor
    })
  }

  @Builder
  defaultBuilder() {
  }

  // 处理滚动
  handleScroll = (scrollX: number, scrollY: number) => {
    // 更新并修正 scrollY 的值
    this.scrollY += scrollY;
    if (this.scrollY < 0) {
      this.scrollY = 0
    }
    this.calcColor();
    this.setWindowStatusColor();
  }
  // 计算颜色
  calcColor = () => {
    if (this.scrollY > 10) {
      this.bgColor = 'rgba(255, 255, 255, 1)'
      this.fontColor = '#000000'
    } else {
      this.bgColor = 'rgba(255, 255, 255, 0)'
      this.fontColor = '#ffffff'
    }
  }

  build() {
    Stack() {
      Scroll() {
        Column() {
          // 渲染内容
          this.contentBuilder()
        }.align(Alignment.TopStart)
      }
      .height('100%')
      .scrollBar(BarState.Off)
      .align(Alignment.TopStart)
      .backgroundColor($r('app.color.bg_gray_second'))
      .padding({ bottom: rvp(10) })
      .onDidScroll(this.handleScroll)

      Column() {
        // 渲染头部导航
        this.navBuilder({ fontColor: this.fontColor, bgColor: this.bgColor })
      }.backgroundColor(this.bgColor).padding({ top: getWindowTopHeight() })

    }.height('100%').alignContent(Alignment.TopStart)
  }
}