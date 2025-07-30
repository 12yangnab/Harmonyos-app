import { getCityListApi, getDistrictListApi, getProvinceListApi } from '../../api/rentRoom'
import { BORDER_RADIUS_S, PADDING } from '../../constans/size'
import {
  ICityItem,
  ICityList,
  IDistrictItem,
  IDistrictList,
  IGetRentRoomListParams,
  IProvinceItem,
  IProvinceList,
  IRentPriceItem,
  IRentPriceList,
  ISortItem,
  ISortList,
} from '../../model/RentRoomData'
// import { RentPriceItem, RentPriceList } from '../../model/RentRoomListData'
import { globalEmitter } from '../../utils/emitter'
import { rvp } from '../../utils/responsive'

//页面完成记得删除，测试用
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
  @State paymentWayList :string[]= ['月付', '季付', '半年付', '年付']
  @State paymentWay : string = ''
  //租金列表
  @State rentPriceList: IRentPriceList=[
    {
      id: 1,
      minRent: '0',
      maxRent: '0',
      text: '不限'
    },
    {
      id: 2,
      minRent: '0',
      maxRent: '1500',
      text: '1500元以下'
    },
    {
      id: 3,
      minRent: '1500',
      maxRent: '2500',
      text: '1500-2500元'
    },
    {
      id: 4,
      minRent: '2500',
      maxRent: '3500',
      text: '2500-3500元'
    },
    {
      id: 5,
      minRent: '3500',
      maxRent: '4500',
      text: '3500-4500元'
    },
    {
      id: 6,
      minRent: '4500',
      maxRent: '6000',
      text: '4500-6000元'
    },
    {
      id: 7,
      minRent: '6000',
      maxRent: '8000',
      text: '6000-8000元'
    },
    {
      id: 8,
      minRent: '8000',
      maxRent: '10000',
      text: '8000-10000元'
    },
    {
      id: 9,
      minRent: '10000',
      maxRent: '0',
      text: '10000元以上'
    }
  ]

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
  //处理搜索文本的变化,回显
  handleSearchTextChange() {
    if(this.currentSearchType === '地区') {
        this.provinceCode = this.submitProvinceCode
        this.cityCode = this.submitCityCode
        this.districtCode = this.submitDistrictCode
        this.getDistrictList()
    }else if(this.currentSearchType === '付款方式') {
      this.paymentWay = this.submitPaymentWayText
    }else if(this.currentSearchType === '租金') {
      this.rentText= this.submitRentPriceText
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
//地区查询方式
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

 //
  //租金查询方式
  @State rentText: string = ''
  //重置
  resetRentPrice = () => {
    this.rentText = ''
  }
  @State submitRentPriceText: string = ''
  submitRentPrice = () => {
    //更新数据
    this.submitRentPriceText = this.rentText
    //触发搜索
    const rent=this.rentPriceList.find(rent=>rent.text===this.rentText)
    const searchOptions : Partial<IGetRentRoomListParams>={
      minRent:rent?.minRent,
      maxRent:rent?.maxRent
    }
    globalEmitter.emit('searchOptionsChange',searchOptions)
  this.hidden()
  }
  @Builder
  RentPriceRender() {
    Grid(){
      ForEach(this.rentPriceList, (rentPrice: IRentPriceItem) => {
        GridItem(){
          Text(rentPrice.text)
            .textExtends(this.rentText===rentPrice.text,95)
            .onClick(()=>{
              this.rentText = rentPrice.text
            })
        }
      }, (rentPrice: IRentPriceItem) => rentPrice.id+'')
    }.width("100%")
    .padding(rvp(PADDING))
    .columnsTemplate('1fr 1fr 1fr')
    .rowsGap(rvp(8))
    .height(rvp(120))

    Row({ space: rvp(22) }) {
      Button('重置')
        .buttonStyles(rvp(95), '#F0F0F0', $r('app.color.gray_second')).onClick(this.resetRentPrice)
      Button('查看房源')
        .buttonStyles(rvp(211), '#67C0A8', $r('app.color.white')).onClick(this.submitRentPrice)
    }.height(rvp(58)).width('100%').backgroundColor($r('app.color.white')).justifyContent(FlexAlign.Center)
    //蒙层补到这两个 Builder 的最后即可
    Row()
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('rgba(0, 0, 0, 0.7)')
      .onClick(this.hidden)
  }

  //
  // 支付方式列表
  @State submitPaymentWayText: string = ''
  resetPaymentWay = () => {
    this.paymentWay = ''
  }
  // 选择支付方式查询
  submitPaymentWay = () => {
    this.submitPaymentWayText = this.paymentWay
    this.hidden()
    const searchOptions : Partial<IGetRentRoomListParams>={paymentType:this.paymentWay}
    globalEmitter.emit('searchOptionsChange',searchOptions)
  }
  @Builder
  PaymentTypeRender() {
    Row(){
      ForEach(this.paymentWayList, (paymentWay: string) => {
        Text(paymentWay)
          .textExtends(this.paymentWay===paymentWay,70)
          .onClick(()=>{
            this.paymentWay = paymentWay
          })
      }, (paymentWay: string) => paymentWay)
    }.width("100%").padding(rvp(PADDING)).justifyContent(FlexAlign.SpaceBetween)
    Row({ space: rvp(22) }) {
      Button('重置')
        .buttonStyles(rvp(95), '#F0F0F0', $r('app.color.gray_second')).onClick(this.resetPaymentWay)
      Button('查看房源')
        .buttonStyles(rvp(211), '#67C0A8', $r('app.color.white')).onClick(this.submitPaymentWay)
    }.height(rvp(58)).width('100%').backgroundColor($r('app.color.white')).justifyContent(FlexAlign.Center)
    //蒙层补到这两个 Builder 的最后即可
    Row()
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('rgba(0, 0, 0, 0.7)')
      .onClick(this.hidden)
  }
//排序列表
@State sortList :ISortList=[
  {
    icon:$r('app.media.sort'),
    text:'综合排序',
    orderBy:'',
    orderType:''
  },
  { icon:$r('app.media.rent'),
  text:'价格从底到高',
  orderBy:'price',
  orderType:'asc'
},
  {icon:$r('app.media.rent'),
text:'价格从高到底',
orderBy:'price',
orderType:'desc'
},
  {icon:$r('app.media.area'),
text:'面积从大到小',
orderBy:'area',
orderType:'desc'
},
  {icon:$r('app.media.rent'),
text:'面积从小到大',
orderBy:'area',
orderType:'asc'
},
]

@State sortText:string=''
//选择排序方式
  @Builder
  SortRender() {
    Column(){
      ForEach(this.sortList,(sort:ISortItem)=>{
        Row({space:rvp(8)}){
          Image(sort.icon).width(rvp(16)).height(rvp(16))
          Text(sort.text).fontSize(rvp(12)).fontColor(this.sortText===sort.text ? '#67C0A8':$r('app.color.gray_second'))
        }.height(rvp(34)).onClick(()=>{
         this.sortText=sort.text
          const searchOptions : Partial<IGetRentRoomListParams>={
            orderBy:sort.orderBy,
            orderType:sort.orderType
          }
          globalEmitter.emit('searchOptionsChange',searchOptions)
          this.hidden()

        })
      },(sort:ISortItem)=>sort.text)
    }.width('100%').alignItems(HorizontalAlign.Start).padding({left:rvp(32),bottom:rvp(16)})
  }
//选择搜索类型
  getSearchText=(text:string)=>{
    if (text === '地区') {
      return this.submitDistrictName||text
    }else if (text ==='付款方式') {
      return this.submitPaymentWayText||text
    }else if (text ==='租金') {
      return this.submitRentPriceText||text
    }
    else {
      return this.sortText||text
    }
  }
//选择高亮
  getSearchTextColor=(text:string)=>{
    if (text === '地区') {
      return this.submitDistrictName ? $r('app.color.primary'):'#333333'
    }else if (text ==='付款方式') {
      return this.submitPaymentWayText ? $r('app.color.primary'):'#333333'
    }else if (text ==='租金') {
      return this.submitRentPriceText ? $r('app.color.primary'):'#333333'
    }
    else {
      return this.sortText ? $r('app.color.primary'):'#333333'
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

@Extend(Text) function textExtends(isActive: boolean,width:number){
  .width(rvp(width))
  .height(rvp(26))
  .borderRadius(rvp(BORDER_RADIUS_S))
  .backgroundColor( isActive?'#67C0A8' : $r('app.color.bg_gray'))
  .fontSize(rvp(12))
  .fontColor(isActive ? $r('app.color.white') :$r('app.color.gray_second'))
  .textAlign(TextAlign.Center)
}