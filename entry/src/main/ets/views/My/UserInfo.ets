import Avatar from '../../components/Avatar'
import  {getUserInfoApi}  from '../../api/login'
import { rvp } from '../../utils/responsive'
import { router } from '@kit.ArkUI'
import {IUserInfo} from '../../model/UserData'
@Component
export default struct UserInfo {
  @StorageProp('token') token: string = ''
  @StorageProp('user') user: IUserInfo={
    id:0,
    nickname: '',
    avatar: ''
  }

  aboutToAppear(): void {
    if (this.user.nickname||!this.token) {
      return;
    }
    console.log('token'+this.token)
    this.getUserInfo();
  }
getUserInfo = async()=>{
    const user=await getUserInfoApi();
  AppStorage.SetOrCreate('user',user);
  console.log(JSON.stringify(user));
}

  build() {
    Row({ space: rvp(10) }) {
      Avatar({ src: this.user?.avatar, avatarSize: rvp(60) })
      // Column({ space: rvp(4) }) {
      //   Text('登录/注册').fontSize(18).fontColor($r('app.color.white')).fontWeight(700)
      //   Text('点击登录注册').fontSize(18).fontColor($r('app.color.white'))
      // }.alignItems(HorizontalAlign.Start)
        if (this.user.nickname) {
          Column({ space: rvp(4) }) {
            Text(this.user.nickname).fontSize(18).fontColor($r('app.color.white')).fontWeight(700)
            Text('米粒点15').fontSize(14).fontColor($r('app.color.white'))
          }.alignItems(HorizontalAlign.Start)
        }else {
          Text('请登录').fontSize(18).fontColor($r('app.color.white')).fontWeight(700)
        }

    }.margin({ top: rvp(11) }).width('100%') .onClick(() => {
      if (this.user.nickname) {
        return;
      }router.pushUrl({ url: 'pages/Login/LoginPhone' })
    })
  }
}