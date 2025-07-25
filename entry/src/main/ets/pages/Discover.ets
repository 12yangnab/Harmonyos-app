import { getDiscoverDataApi } from '../api/discover'
import { IColor } from '../model/HomeData'
import { getWindowTopHeight, rvp } from '../utils/responsive'
import { IDanMuList, IPostZone } from '../model/DiscoverData'

import ScrollContainer from '../components/ScrollContainer'
import NavBar from '../views/Discover/NavBar'
import Bg from '../views/Discover/Bg'

import Ad from '../views/Discover/Ad'
import { PADDING } from '../constans/size'

@Component
export default struct Discover {
  @State danMuList1: IDanMuList = []
  @State danMuList2: IDanMuList = []
  @State postZone: IPostZone = {
    "mainPost": {
      "followerNum": 0,
      "title": '',
      "userAvatar": '',
      "userName": '',
      "postContent": '',
    },
    "contentBlockList": []
  }

  aboutToAppear(): void {
    this.getDiscoverData()
  }

  async getDiscoverData() {
    const discoverData = await getDiscoverDataApi()
    this.danMuList1 = discoverData.danMuList1
    this.danMuList2 = discoverData.danMuList2
    this.postZone = discoverData.postZone
  }

  @Builder
  navBuilder($$: IColor) {
    NavBar({ bgColor: $$.bgColor })
  }

  @Builder
  contentBuilder() {
    Stack() {
      Bg()
      Column() {
        Text('与剑来用户发现生活').margin({ top: rvp(44), left: rvp(16) }).fontSize(rvp(14))
        Column({ space: rvp(16) }) {

        }.width('100%').margin({ top: rvp(20) })

        Ad({ postZone: this.postZone })
      }
      .alignItems(HorizontalAlign.Start)
      .padding({ top: getWindowTopHeight(), left: rvp(PADDING), right: rvp(PADDING) })
      .width('100%')
    }.alignContent(Alignment.TopStart)
  }

  build() {
    ScrollContainer({
      contentBuilder: () => {
        this.contentBuilder()
      },
      navBuilder: this.navBuilder,
    })
  }
}