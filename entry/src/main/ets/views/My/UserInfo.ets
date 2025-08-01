import Avatar from '../../components/Avatar'
import  {getUserInfoApi}  from '../../api/login'
import { rvp } from '../../utils/responsive'
import { router } from '@kit.ArkUI'
import {IUserInfo} from '../../model/UserData'
@Component
export default struct UserInfo {
  @StorageProp('token') token: string = ''
  @State isLoggingOut: boolean = false;
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
            Text('米粒点1500').fontSize(14).fontColor($r('app.color.white'))

          }.alignItems(HorizontalAlign.Start)
          Row() {
            // 2. 替换原来的 Button
            Button(this.isLoggingOut ? '退出中...' : '退出登录')
              .fontSize(14)
              .fontColor($r('app.color.white'))
              .backgroundColor(
                this.isLoggingOut
                  ? $r('app.color.primary')   // 灰色，自己定义
                  : $r('app.color.primary')
              )
              .enabled(!this.isLoggingOut)       // 禁用防止连点
              .onClick(async () => {
                if (this.isLoggingOut) return;
                this.isLoggingOut = true;

                // 1. 给出 1 秒左右“加载”时间（也可以换成真正的网络请求）
                await new Promise<void>(resolve => setTimeout(resolve, 1000));


                // 2. 真正退出
                AppStorage.SetOrCreate('token', '');
                AppStorage.SetOrCreate('user', { id: 0, nickname: '', avatar: '' });
                router.replaceUrl({ url: 'pages//My' });

                // 3. 复原状态（非必须，页面会立即跳转）
                this.isLoggingOut = false;
              })
          }
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