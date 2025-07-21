import ScrollContainer from '../components//ScrollContainer'
import NavBar from '../views/See/NavBar'
import FindRoom from '../views/See/FindRoom'

import { PADDING } from '../constans/size'
import { rvp } from '../utils/responsive'

@Component
export default struct See {
  @Builder
  navBuilder() {
    NavBar()
  }

  @Builder
  contentBuilder() {
    Column() {
      FindRoom()
    }.width('100%').height('100%').padding({ left: rvp(PADDING), right: rvp(PADDING) }).linearGradient({
      angle: 180,
      direction: GradientDirection.Top,
      colors: [
        ['#DEFBE5', 0],
        ['#ffffff', 0.3],
        ['#ffffff', 1],
      ],
      repeating: false,
    })
  }

  build() {
    ScrollContainer({
      navBuilder: this.navBuilder,
      contentBuilder: this.contentBuilder
    })

  }
}