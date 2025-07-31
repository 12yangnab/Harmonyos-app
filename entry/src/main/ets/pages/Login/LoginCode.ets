import router from '@ohos.router'
import NavBar from '../../components/Navbar'

import {rvp} from '../../utils/responsive'
import { lg, sm } from '../../utils/responsiveFontSize'
import { sendSMSCodeApi, loginApi, getUserInfoApi } from '../../api/login'
import showToast from '../../utils/showToast'
import { CODE_REG } from '../../constans/regs'
import promptAction from '@ohos.promptAction'
@Entry
@Component
struct LoginCode {
  @StorageLink('token') token: string = ''

  // 发送验证码
  @State phone: string = ''
  aboutToAppear() {
    const params = router.getParams() as Record<string, string>
    this.phone = params.phone || ''
    this.sendSMSCode()
  }
  async sendSMSCode() {
    if (!this.phone) {
      showToast('手机号不能为空')
      return
    }
    this.startCountDown()
    this.isSendCode = true
    const code = await sendSMSCodeApi(this.phone)
    // 替换原来的 showToast(code)
    promptAction.showToast({
      message: `验证码：${code}`,
      duration: 5000// 持续时间，单位为毫秒
    })
  }

  // 倒计时
  @State isSendCode: boolean = false
  @State time: number = 61;
  timeId: number=0;
  startCountDown() {
    this.time--
    this.timeId = setInterval(() => {
      this.time--
      if (this.time <= 0) {
        this.time = 61
        clearInterval(this.timeId)
      }
    }, 1000)
  }

  aboutToDisappear() {
    clearInterval(this.timeId)
  }

  // 高亮
  @State code: string = ''
  @State isBtnActive: boolean = false
  handleInputChange(val: string) {
    this.code = val;
    this.isBtnActive = CODE_REG.test(val);
  }

  // 登录
  async login() {
    try {
      const res = await loginApi(this.phone, this.code)
      if (!res || !res.token) {
        showToast('验证码不正确')
        return
      }
      this.token = res.token
      const userData=await getUserInfoApi()//获取用户信息
      AppStorage.SetOrCreate('user',userData)
      router.back({ url: 'pages/Index', params: { currentIndex: 4 } })
    } catch {
      showToast('验证码不正确')
    }
  }

  @Builder LoginCodeForm() {
    Column() {
      Stack() {
        TextInput({ placeholder: '请输入验证码' }).inputStyles().onChange(this.handleInputChange.bind(this))
        if (this.time <= 60) {
          Text(`${this.time}s`).fontSize(lg()).fontColor($r('app.color.primary'))
        } else if (this.isSendCode) {
          Text(`重新发送`).fontSize(sm()).fontColor($r('app.color.primary')).onClick(this.sendSMSCode.bind(this))
        }
      }.alignContent(Alignment.End)

      Divider().color('#C4EDCE')
      Button('确认')
        .margin({ top: rvp(40) })
        .backgroundColor(this.isBtnActive ? $r('app.color.primary') : '#F0F0F0')
        .fontSize(sm())
        .width(rvp(100))
        .fontColor(this.isBtnActive ? $r('app.color.white') : '#C1C1C1')
        .padding({ top: rvp(12), bottom: rvp(12) })
        .enabled(this.isBtnActive)
        .onClick(this.login.bind(this))
    }.margin({ top: rvp(47) }).padding({ left: rvp(37), right: rvp(37) }).alignItems(HorizontalAlign.End)
  }

  build() {
    Column() {
      NavBar({ title: '验证码登录' })
      this.LoginCodeForm()
    }
    .width('100%').height('100%').linearGradient({
      angle: 180,
      colors: [
        ['#DEFBE5', 0],
        ['#ffffff', 0.3],
        ['#ffffff', 1],
      ]
    })
  }
}

@Styles function pressedStyles() {
  // 无法实现点击时，完全透明
  .backgroundColor('rgba(255, 255, 255, 0)')
  .borderRadius(0)
}

@Extend(TextInput) function inputStyles() {
  .padding({ left: 0, right: 0, top: 0, bottom: rvp(8) })
  .backgroundColor(Color.Transparent)
  .placeholderColor('#C1C1C1')
  .placeholderFont({ size: lg() })
  .caretColor('#C1C1C1')
  .type(InputType.PhoneNumber)
  .maxLength(11)
  .stateStyles({
    pressed: pressedStyles,
    clicked: pressedStyles
  })
}