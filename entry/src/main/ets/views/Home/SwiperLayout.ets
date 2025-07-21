import type { BannerListDataSource, IBannerItem } from '../../model/HomeData';
import { getWindowTopHeight, rvp } from '../../utils/responsive';

@Component
export default struct SwiperLayout {
  @Prop bannerList: BannerListDataSource

  build() {
    if (this.bannerList.totalCount()) {
      Swiper() {
        LazyForEach(this.bannerList, (banner: IBannerItem) => {
          Image(banner.imageURL).width('100%').height(rvp(175) + getWindowTopHeight())
        }, (item: IBannerItem) => item.id + '')
      }
      .loop(true)
      .indicator(
        Indicator.dot()// 设置圆形导航点样式
          .color('#CCCBCB')
          .selectedColor($r('app.color.primary'))
      )
    }
  }
}