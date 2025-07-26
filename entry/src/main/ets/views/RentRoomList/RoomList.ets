import { getRentRoomListApi } from '../../api/rentRoom';
import { IGetRentRoomListParams, IRentRoomItem, RentRoomListDataSource } from '../../model/RentRoomData';
import { ITagItem } from '../../model/RoomRecommendDataSource';

import { BORDER_RADIUS } from '../../constans/size';
import { rvp } from '../../utils/responsive';
import { globalEmitter } from '../../utils/emitter';

@Component
export default struct RoomList {
  @State roomRoomListDataSource: RentRoomListDataSource = new RentRoomListDataSource([])
  @State total: number = 0
  @State isEnd: boolean = false
  @State searchOptions: IGetRentRoomListParams = {
    "page": 1,
    "limit": 10,
    "provinceCode": "",
    "cityCode": "",
    "districtCode": "",
    "minRent": "",
    "maxRent": "",
    // "paymentType": "",
    // "orderBy": "",
    // "orderType": ""
  }

  aboutToAppear() {
    this.getRentRoomList();
    this.registerGlobalEmitter();
  }
  registerGlobalEmitter() {
    globalEmitter.on('searchOptionsChange', async (searchOptions: Partial<IGetRentRoomListParams>) => {
      // 逐个字段安全合并，不使用解构、any、Object.assign
      if (searchOptions.provinceCode !== undefined) this.searchOptions.provinceCode = searchOptions.provinceCode;
      if (searchOptions.cityCode     !== undefined) this.searchOptions.cityCode     = searchOptions.cityCode;
      if (searchOptions.districtCode !== undefined) this.searchOptions.districtCode = searchOptions.districtCode;
      if (searchOptions.minRent      !== undefined) this.searchOptions.minRent      = searchOptions.minRent;
      if (searchOptions.maxRent      !== undefined) this.searchOptions.maxRent      = searchOptions.maxRent;
      if (searchOptions.paymentType  !== undefined) this.searchOptions.paymentType  = searchOptions.paymentType;
      if (searchOptions.orderBy      !== undefined) this.searchOptions.orderBy      = searchOptions.orderBy;
      if (searchOptions.orderType    !== undefined) this.searchOptions.orderType    = searchOptions.orderType;

      this.searchOptions.page  = 1;
      this.searchOptions.limit = 10;

      await this.getRentRoomList(false);   // 重新搜索
    });
  }

  // registerGlobalEmitter() {
  //   globalEmitter.on('searchOptionsChange', async (searchOptions: Partial<IGetRentRoomListParams>) => {
  //     console.log('收到搜索参数:', JSON.stringify(searchOptions));
  //     // this.searchOptions.page = 1;
  //     // this.searchOptions.limit = 10;
  //     // if (searchOptions.provinceCode) {
  //     //   this.searchOptions.provinceCode = searchOptions.provinceCode;
  //     // }
  //     // if (searchOptions.cityCode) {
  //     //   this.searchOptions.cityCode = searchOptions.cityCode;
  //     // }
  //     // if (searchOptions.districtCode) {
  //     //   this.searchOptions.districtCode = searchOptions.districtCode;
  //     // }
  //     // await this.getRentRoomList();
  //     const keys = Object.keys(searchOptions)
  //     keys.forEach(key => {
  //       const val:string=Reflect.get(this.searchOptions, key)
  //       Reflect.set(this.searchOptions, key,val)
  //     })
  //     this.searchOptions.page = 1;//重置页码
  //     this.searchOptions.limit = 10;//重置每页数量
  //     await this.getRentRoomList(false);
  //   })
  // }

  async getRentRoomList(isLoadMore = false) {
    if (!isLoadMore) {
      // 新条件搜索：重置页码 & 清空旧数据
      this.searchOptions.page = 1;
      this.roomRoomListDataSource.clear();
    }

    const res = await getRentRoomListApi(this.searchOptions);
    this.roomRoomListDataSource.pushDataList(res.records);
    this.total = res.total;
    this.isEnd = res.records.length < this.searchOptions.limit;
  }

  loadMore = () => {
    if (this.isEnd) return;
    this.searchOptions.page++;
    this.getRentRoomList(true);   // true = 加载更多
  }

  @Builder
  footer() {
    Row({ space: rvp(5) }) {
      LoadingProgress().width(rvp(20)).height(rvp(20)).color($r('app.color.gray'))
      Text('加载数据中...').fontSize(rvp(12)).fontColor($r('app.color.gray'))
    }.width('100%').backgroundColor($r('app.color.white')).justifyContent(FlexAlign.Center)
  }

  build() {
    WaterFlow({
      footer: () => {
        this.footer()
      }
    }) {
      LazyForEach(this.roomRoomListDataSource, (room: IRentRoomItem) => {
        FlowItem() {
          Stack() {
            Column() {
              if (room.activity) {
                Column() {
                  Row() {
                    Image(room.activity.icon).width(rvp(26))
                    Text(room.activity.title).fontSize(rvp(14)).fontWeight(700)
                  }

                  Text(room.activity.title)
                    .fontColor(room.activity.textColor)
                    .backgroundColor(room.activity.textBackGroundColor)
                    .padding({
                      top: rvp(4),
                      bottom: rvp(4),
                      left: rvp(8),
                      right: rvp(8)
                    })
                    .borderRadius(rvp(21))
                    .fontSize(rvp(10))
                    .margin({ top: rvp(3) })
                  Image(room.housePicture)
                    .width('100%')
                    .height(rvp(170))
                    .borderRadius(rvp(BORDER_RADIUS))
                    .objectFit(ImageFit.Fill)
                    .margin({ top: rvp(5) })
                }.padding({ left: rvp(10), right: rvp(10), top: rvp(10) }).alignItems(HorizontalAlign.Start)
              } else {
                Image(room.housePicture).width('100%').height(rvp(120)).objectFit(ImageFit.Fill).borderRadius({
                  topLeft: rvp(BORDER_RADIUS),
                  topRight: rvp(BORDER_RADIUS)
                })
              }
              Column() {
                Row() {
                  Text() {
                    Span(room.rentPriceListing).fontSize(rvp(14)).fontColor('#E03810')
                    Span(room.rentPriceUnit).fontSize(rvp(12)).fontColor('#E03810')
                  }.height(rvp(22))

                  Text(room.rentArea + '㎡').fontSize(rvp(10)).fontColor($r('app.color.gray'))
                }.width('100%').justifyContent(FlexAlign.SpaceBetween)

                Text(room.houseTitle)
                  .fontSize(rvp(12))
                  .margin({ top: rvp(1) })
                  .height(rvp(19))
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                Row({ space: rvp(6) }) {
                  ForEach(room.tags.slice(0, 2), (tag: ITagItem, index) => {
                    Text(tag.name)
                      .padding({
                        top: rvp(1),
                        bottom: rvp(1),
                        left: rvp(6),
                        right: rvp(6),
                      })
                      .fontColor(index === 0 ? $r('app.color.white') : '#B3B3B3')
                      .backgroundColor(index === 0 ? $r('app.color.primary') : $r('app.color.bg_gray'))
                      .fontSize(rvp(10))
                  }, (tag: ITagItem) => tag.name)
                }.width('100%').margin({ top: rvp(9) })
              }.padding(rvp(12)).alignItems(HorizontalAlign.Start).height(rvp(90))
            }.width('100%').alignItems(HorizontalAlign.Start)

            if (!room.activity) {
              Image($r('app.media.room_text_bg')).width('100%').height(rvp(120))
              Row({ space: rvp(6) }) {
                Image($r('app.media.location')).width(rvp(12)).height(rvp(14))
                Text(room.address).fontSize(rvp(10)).fontColor($r('app.color.white'))
              }.margin({ left: rvp(8), top: rvp(99) })
            }
          }
          .alignContent(Alignment.TopStart)
          .backgroundColor($r('app.color.white'))
          .borderRadius(rvp(BORDER_RADIUS))
          .height('100%')
          .width(rvp(165))
        }.height(room.activity ? rvp(320) : rvp(210))
      }, (room: IRentRoomItem) => room.id)
    }
    .columnsTemplate("1fr 1fr")
    .columnsGap(rvp(10))
    .rowsGap(rvp(10))
    .backgroundColor($r('app.color.bg_gray'))
    .width('100%')
    .layoutWeight(1)
    .layoutDirection(FlexDirection.Column)
    .padding({ left: rvp(10), right: rvp(10), top: rvp(10) })
    .onReachEnd(this.loadMore)
  }
}