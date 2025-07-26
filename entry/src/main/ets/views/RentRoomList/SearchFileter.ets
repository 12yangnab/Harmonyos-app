import { getCityListApi, getDistrictListApi, getProvinceListApi } from '../../api/rentRoom'
import { BORDER_RADIUS_S } from '../../constans/size'
import {
  ICityItem,
  ICityList,
  IDistrictItem,
  IDistrictList,
  IGetRentRoomListParams,
  IProvinceItem,
  IProvinceList
} from '../../model/RentRoomData'
import { globalEmitter } from '../../utils/emitter'
import { rvp } from '../../utils/responsive'


@Component
export default struct SearchFilter {
  isShowSearchArea: boolean = false
  @State searchTypeList: string[] = ['地区', '租金', '付款方式', '排序']
  @State currentSearchType: string = ''
  @State provinceList: IProvinceList = [] // 省
  @State cityList: ICityList = [] // 市
  @State districtList: IDistrictList = [] // 区
  @State provinceCode: string = '' // 省code
  @State cityCode: string = '' // 市code
  @State districtCode: string = '' // 区code
  @State submitDistrictName: string = '' //查看房源时更新数据
  @State submitProvinceCode: string = ''
  @State submitCityCode: string = ''
  @State submitDistrictCode: string = ''

  chooseSearchType(searchType: string) {
    console.log(searchType)
    this.currentSearchType = searchType
    if (searchType === '地区') {
      // 发送请求，获取数据展示
      this.getProvinceList()
    }
  }

  // 获取省市区
  async getProvinceList() {
    const provinceList = await getProvinceListApi()
    this.provinceList = provinceList
    this.provinceCode = this.provinceCode || this.provinceList[0].code;
    this.getCityList()
  }

  async getCityList() {
    const cityList = await getCityListApi(this.provinceCode)
    this.cityList = cityList;
    this.cityCode = this.cityCode || this.cityList[0].code;
    this.getDistrictList()
  }

  async getDistrictList() {
    const districtList = await getDistrictListApi(this.cityCode)
    this.districtList = districtList
    this.districtCode = this.districtCode || this.districtList[0].code;
  }

  // 重置地区
  resetLocation = () => {
    this.provinceCode = this.provinceList[0]?.code ?? '';
    this.cityCode = this.cityList[0]?.code ?? '';   // 直接重置到第一项
    this.districtCode = this.districtList[0]?.code ?? '';
    this.getCityList();   // 刷新下一级
  }
  // 隐藏面板
  hidden = () => {
    this.isShowSearchArea = false;
    this.currentSearchType = '';
  }
  //处理搜索文本的变化
  handleSearchTextChange() {
    if(this.currentSearchType === '地区') {
        this.provinceCode = this.submitProvinceCode
        this.cityCode = this.submitCityCode
        this.districtCode = this.submitDistrictCode
        this.getDistrictList()
    }
  }
//查看房源
  submitPostion = () => {
    this.hidden()
    this.submitDistrictName = this.districtList.find(district => district.code === this.districtCode)!.name
    this.submitProvinceCode = this.provinceCode
    this.submitCityCode = this.cityCode
    this.submitDistrictCode = this.districtCode
    //搜索房源列表（待完成）
    const searchOptions : Partial<IGetRentRoomListParams>={
      provinceCode: this.provinceCode,
      cityCode: this.cityCode,
      districtCode: this.districtCode,
    }
    globalEmitter.emit('searchOptionsChange', searchOptions)//搜索房源列表（待完成
    this.handleSearchTextChange()
  }

  @Builder
  LocationRender() {
    Row() {
      List() {
        ForEach(this.provinceList, (item: IProvinceItem) => {
          ListItem() {
            Row() {
              Text(item.name)
                .fontSize(rvp(12))
                .fontColor(item.code === this.provinceCode ? $r('app.color.primary') :
                $r('app.color.black'))
            }
            .width('100%')
            .padding({
              left: rvp(16),
              right: rvp(16),
              top: rvp(6),
              bottom: rvp(6)
            })
          }.onClick(() => {
            this.provinceCode = item.code;
            this.getCityList()
          })
        }, (item: IProvinceItem) => item.code)
      }.width(rvp(120)).height('100%').backgroundColor($r('app.color.bg_gray')).scrollBar(BarState.Off)

      List() {
        ForEach(this.cityList, (item: ICityItem) => {
          ListItem() {
            Row() {
              Text(item.name)
                .fontSize(rvp(12))
                .fontColor(item.code === this.cityCode ? $r('app.color.primary') : $r('app.color.black'))
            }
            .width('100%')
            .padding({
              left: rvp(16),
              right: rvp(16),
              top: rvp(6),
              bottom: rvp(6)
            })
          }.onClick(() => {
            this.cityCode = item.code;
            this.getDistrictList()
          })
        }, (item: ICityItem) => item.code)
      }.width(rvp(120)).height('100%').backgroundColor('#EBEBEB').scrollBar(BarState.Off)

      List() {
        ForEach(this.districtList, (item: IDistrictItem) => {
          ListItem() {
            Row() {
              Text(item.name)
                .fontSize(rvp(12))
                .fontColor(item.code === this.districtCode ? $r('app.color.primary') :
                $r('app.color.black'))
            }
            .width('100%')
            .padding({
              left: rvp(16),
              right: rvp(16),
              top: rvp(6),
              bottom: rvp(6)
            })
          }.onClick(() => {
            this.districtCode = item.code;
          })
        }, (item: IDistrictItem) => item.code)
      }.width(rvp(120)).height('100%').backgroundColor('#E6E6E6').scrollBar(BarState.Off)
    }.height(rvp(240)).width('100%').backgroundColor($r('app.color.white'))

    Row({ space: rvp(22) }) {
      Button('重置')
        .buttonStyles(rvp(95), '#F0F0F0', $r('app.color.gray_second')).onClick(this.resetLocation)
      Button('查看房源')
        .buttonStyles(rvp(211), '#67C0A8', $r('app.color.white')).onClick(this.submitPostion)
    }.height(rvp(58)).width('100%').backgroundColor($r('app.color.white')).justifyContent(FlexAlign.Center)

    Row() {
    }.width('100%').layoutWeight(1).backgroundColor('rgba(0, 0, 0, 0.7)').onClick(this.hidden)
  }

  @Builder
  RentPriceRender() {
    Text('RentPriceRender')
  }

  @Builder
  PaymentTypeRender() {
    Text('PaymentTypeRender')
  }

  @Builder
  SortRender() {
    Text('SortRender')
  }

  getSearchText=(text:string)=>{
    if (text === '地区') {
      return this.submitDistrictName||text
    }else {
      return text
    }
  }

  getSearchTextColor=(text:string)=>{
    if (text === '地区') {
      return this.submitDistrictName ? $r('app.color.primary'):'#333333'
    }else {
      return text
    }
  }

  build() {
    // 搜索类型列表
    Column() {
      Row() {
        ForEach(this.searchTypeList, (item: string) => {
          Row({ space: rvp(6) }) {
            Text(this.getSearchText(item))//更新搜索地区
              .fontSize(rvp(12))
              .fontColor(this.getSearchTextColor(item))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .constraintSize({
                maxWidth: rvp(60),//限制字符最大宽度
              })

            if (this.currentSearchType === item) {
              Image($r('app.media.arrow_down_3_active'))
                .width(rvp(12)).height(rvp(12)).objectFit(ImageFit.Fill)
            } else {
              Image($r('app.media.arrow_down_3'))
                .width(rvp(6)).height(rvp(3)).objectFit(ImageFit.Fill)
            }
          }.width('25%').height('100%').justifyContent(FlexAlign.Center)
          .onClick(() => {this.chooseSearchType(item)})
        }, (item: string) => item)
      }.width('100%').height(rvp(44)).justifyContent(FlexAlign.SpaceBetween)

      if (this.currentSearchType === '地区') {
        this.LocationRender()
      }
      if (this.currentSearchType === '租金') {
        this.RentPriceRender()
      }
      if (this.currentSearchType === '付款方式') {
        this.PaymentTypeRender()
      }
      if (this.currentSearchType === '排序') {
        this.SortRender()
      }
    }
  }
}


@Extend(Button)
function buttonStyles(width: number, bgColor: string | Resource, fontColor: string | Resource) {
  .type(ButtonType.Normal)
  .width(width)
  .height(rvp(26))
  .borderRadius(rvp(BORDER_RADIUS_S))
  .fontSize(rvp(12))
  .backgroundColor(bgColor)
  .fontColor(fontColor)
}