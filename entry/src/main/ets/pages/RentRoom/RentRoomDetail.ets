import { getRoomDetailApi, reservationRoomApi } from '../../api/rentRoomDetail'
import { promptAction, PromptAction, router } from '@kit.ArkUI'
import { IFormatDate, IFormatDateList, IParams, IReservationRoomParams } from '../../model/RentRoomDetailData'
import Drawer from '../../components/Drawer/Index'
import { BORDER_RADIUS_S, PADDING } from '../../constans/size'
import { rvp } from '../../utils/responsive'
import createDateList from '../../utils/dataList'

@Entry
@Component
struct RentRoomDetail {
@State dateList:IFormatDateList=createDateList()
  @State isShow: boolean = false
  @State val:boolean=false
  @State currentDate:IFormatDate = this.dateList[0]
  @State isShowDataList:boolean=true
  @State reservationData:IReservationRoomParams={
    name:'',
    phone:'',
    date:'',
    comment:'',
    houseId:''
  }

  //获取详情

getRoomDetail =async () => {
  const params=router.getParams() as IParams
  const result=await getRoomDetailApi('BJ1831290689866956800')//后面是测试用记得删除
  console.log(JSON.stringify(result))
}
aboutToAppear() {
  this.getRoomDetail()
}
  build() {
  Stack() {
    Column() {
    }
    .height('100%')
    .width('100%')


    Row(){
      Column({space:10}){
        Image($r('app.media.love')).width(18)
        Text('99+').fontSize(12).fontColor($r('app.color.black'))
      }
      Column({space:10}){
        Image($r('app.media.message')).width(18).fillColor($r('app.color.black'))
        Text('咨询').fontSize(12).fontColor($r('app.color.black'))
      }

      Button('立即预定',{type:ButtonType.Normal})
        .backgroundColor('#24A178')
        .borderRadius(10)
        .padding({left:30,right:30})
        .height(30)

        .onClick(()=>{
          this.isShow=true
        })
        Button('去看房',{type:ButtonType.Normal})
          .borderRadius(10)
          .backgroundColor('#6BE3BE')
          .padding({left:30,right:30})
          .height(30)
    }.backgroundColor('#FFFFFF')
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.SpaceEvenly)
    .margin({top:10})

    Drawer({ show: $isShow ,contentHeight:180}) {
      Text('预约信息').fontSize(16).fontColor($r('app.color.black')).fontWeight(700)
      Column({space:rvp(8)}){
        Row({space:rvp(16)}){
          Text('姓名').width(rvp(56)).fontSize(rvp(14))
          TextInput({placeholder:'请输入姓名'}).fontColor($r('app.color.black')).fontWeight(700) .layoutWeight(1)
            .onChange((value)=>{
              this.reservationData.name=value
            })
        }.width('100%')
        Row({space:rvp(16)}){
          Text('手机号').width(rvp(56)).fontSize(rvp(14))
          TextInput({placeholder:'请输入手机号'}).fontColor($r('app.color.black')).fontWeight(700) .layoutWeight(1)
            .onChange((value)=>{
              this.reservationData.phone=value
            })
        }.width('100%')

        Row({space:rvp(16)}){
          Text('预约时间').width(rvp(56)).fontSize(rvp(14))
          Text(`${this.currentDate.date}(${this.currentDate.week})`)
            .fontSize(rvp(14)).fontColor('#999').layoutWeight(1)
          //下拉(或隐藏)选择时间
          if (this.isShowDataList){
            Image($r('app.media.icon_arrown_up_blue')).width(rvp(24)).height(rvp(24))
            .onClick(()=>{
              this.isShowDataList=false
            })
          }else {
            Image($r('app.media.icon_arrown_down_blue')).width(rvp(24)).height(rvp(24))
            .onClick(()=>{
              this.isShowDataList=true
            })
          }

        }.width('100%').margin({top:rvp(10) ,bottom:rvp(5)})

        if (this.isShowDataList) {
          Grid() {
            ForEach(this.dateList, (date: IFormatDate) => {
              GridItem() {
                Column() {
                  Text(`(${date.week})`).fontSize(rvp(10))
                    .fontColor(this.currentDate.date === date.date ? '#24A17B' : '#999')
                  Text(date.date).fontSize(rvp(10))
                    .fontColor(this.currentDate.date === date.date ? '#24A17B' : '#999')
                }
                .height(rvp(32))
                .width(rvp(73))
                .border({
                  width: 1,
                  color: this.currentDate.date === date.date ? '#24A17B' : '#E4E4E4'
                })
                .borderRadius(rvp(BORDER_RADIUS_S))
                .justifyContent(FlexAlign.Center)
              }.onClick(() => {
                this.currentDate = date
              })
            }, (date: IFormatDate) => date.date)
          }
          .width('100%')
          .columnsTemplate('1fr 1fr 1fr')
          .columnsGap(rvp(6))
          .rowsGap(rvp(8))
          .height(rvp(118))
          .alignSelf(ItemAlign.End)
          .margin({ bottom: rvp(5) })
        }

        Row({space:rvp(16)}){
          Text('备注信息').width(rvp(56)).fontSize(rvp(14))
          TextInput({placeholder:'请输入备注信息'}).fontColor($r('app.color.black')).fontWeight(700)
            .layoutWeight(1).borderRadius(0)
            .maxLines(2)
            .height(rvp(60))
            .onChange((value)=>{
              this.reservationData.comment=value
            })
        }.width('100%')
      }.width('100%').backgroundColor('#FFFFFF').padding(rvp(PADDING))
      .margin({top:rvp(16) ,bottom:rvp(16)})

      Button('预约看房').type(ButtonType.Normal).width('100%').backgroundColor('#24A178')
        .onClick(async ()=>{
          const params=router.getParams() as IParams
          const data:IReservationRoomParams={
            name:this.reservationData.name,
            phone:this.reservationData.phone,
            comment:this.reservationData.comment,
            date:this.currentDate.date,
            houseId:params.id
          }
          if (!this.reservationData.name.trim()) {
                  promptAction.showToast({ message: '请输入姓名' });
                  return;
                }
                if (!this.reservationData.phone.trim()) {
                  promptAction.showToast({ message: '请输入手机号' });
                  return;
                }
                if (!/^\d{11}$/.test(this.reservationData.phone)) {
                  promptAction.showToast({ message: '请输入11位有效手机号' });
                  return;
                }
            reservationRoomApi(data)
          this.isShow=false;
           promptAction.showToast({ message:'预约成功' })
        })
      // Button('预约看房')
      //   .type(ButtonType.Normal)
      //   .width('100%')
      //   .backgroundColor('#24A178')
      //   .onClick(async () => {
      //     const params = router.getParams() as IParams;
      //     const name = this.reservationData.name;
      //     const phone = this.reservationData.phone;
      //
      //     if (!name.trim()) {
      //       promptAction.showToast({ message: '请输入姓名' });
      //       return;
      //     }
      //     if (!phone.trim()) {
      //       promptAction.showToast({ message: '请输入手机号' });
      //       return;
      //     }
      //     if (!/^\d{11}$/.test(phone)) {
      //       promptAction.showToast({ message: '请输入11位有效手机号' });
      //       return;
      //     }
      //     const data: IReservationRoomParams = {
      //       name,
      //       phone,
      //       comment: this.reservationData.comment,
      //       date: this.currentDate.date,
      //       houseId: params.id
      //     };
      //       await reservationRoomApi(data);
      //       this.isShow = false;
      //       promptAction.showToast({ message: '预约成功' });
      //   })
    }

  }.width('100%').height('100%').alignContent(Alignment.Bottom)
  }
}

