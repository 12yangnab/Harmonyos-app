import { getServiceDataApi } from '../api/service';
import { IColor } from '../model/HomeData';
import { IHomeServiceList, IVipServiceList } from '../model/ServiceData';
import { getWindowTopHeight, rvp } from '../utils/responsive';
import { PADDING } from '../constans/size';

import Bg from '../views/Service/Bg';
import ScrollContainer from '../components/ScrollContainer';
import NavBar from '../views/Service/NavBar';
import VIP from '../views/Service/VIP';

@Component
export default struct Service {
  @State vipServiceList: IVipServiceList = [];
  @State homeServiceList: IHomeServiceList = [];

  aboutToAppear() {
    this.getServiceData()
  }

  async getServiceData() {
    const serviceData = await getServiceDataApi();
    this.vipServiceList = serviceData.vipServiceList;
    this.homeServiceList = serviceData.homeServiceList;
  }

  @Builder
  navBuilder($$: IColor) {
    NavBar($$)
  }

  @Builder
  contentBuilder() {
    Stack() {
      Bg()
      Column() {
        VIP({ vipServiceList: this.vipServiceList })
      }.padding({ left: rvp(PADDING), right: rvp(PADDING), top: getWindowTopHeight() })
    }.alignContent(Alignment.TopStart)
  }

  build() {
    ScrollContainer({
      navBuilder: this.navBuilder,
      contentBuilder: () => {
        this.contentBuilder()
      }
    })
  }
}