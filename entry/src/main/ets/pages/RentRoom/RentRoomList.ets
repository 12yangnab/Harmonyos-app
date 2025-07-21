import { getWindowTopHeight, rvp } from '../../utils/responsive'

import NavBar from '../../components/Navbar'
import SearchFilter from '../../views/RentRoomList/SearchFileter'
import WaterfallFlow from '../../views/RentRoomList/WaterfallFlow'

@Entry
@Component
struct RentRoomList {
  build() {
    // 根容器使用 Column 并设置高度为 100%
    Column() {
      // 顶部固定区域
      Column() {
        NavBar({ title: '租房列表' })
        SearchFilter()
      }
      .width('100%')
      .backgroundColor('#FFFFFF') // 确保背景颜色一致

      // 可滚动内容区域
      Scroll() {
        Column() {
          WaterfallFlow()
        }
        .width('100%')
        .flexGrow(1) // 填充剩余空间
      }
      .width('100%')
      .flexGrow(1) // 填充剩余空间
    }
    .width('100%')
    .height('100%') // 占满整个屏幕
  }
}