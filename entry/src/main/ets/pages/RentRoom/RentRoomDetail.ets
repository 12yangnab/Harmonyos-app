import { getRoomDetailApi } from '../../api/rentRoomDetail'
import { router } from '@kit.ArkUI'
import { IParams } from '../../model/RentRoomDetailData'

@Entry
@Component
struct RentRoomDetail {
  //获取详情

getRoomDetail =async () => {
  const params=router.getParams() as IParams
  const result=await getRoomDetailApi('BJ1827549448671068160')//后面是测试用记得删除
  console.log(JSON.stringify(result))
}
aboutToAppear() {
  this.getRoomDetail()
}
  build() {
    Column(){}
    .height('100%')
    .width('100%')
  }
}