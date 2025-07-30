import router from '@ohos.router'

import NavBar from '../../components/Navbar'
import {rvp} from '../../utils/responsive'
import { lg, sm } from '../../utils/responsiveFontSize'
import { PHONE_REG } from '../../constans/regs'
import showToast from '../../utils/showToast'

@Entry
@Component
struct LoginPhone {

  // 手机号功能
  @State phone: string = ''
  @State isPhoneValid: boolean = false
  handleInputChange(val:string) {
    this.phone = val;
    this.isPhoneValid = PHONE_REG.test(val);
    this.handleBtnActive()
  }

  // 用户协议功能
  @State isAgree: boolean = false
  handleAgree() {
    this.isAgree = !this.isAgree;
    this.handleBtnActive()
  }

  // 获取验证码按钮功能
  @State isBtnActive: boolean = false;
  handleBtnActive() {
    if (this.isAgree && this.phone) {
      this.isBtnActive = true
    } else {
      this.isBtnActive = false
    }
  }

  // 点击跳转LoginCode页面
  goLoginCode() {
    if (!this.isBtnActive) return;
    if (!this.isPhoneValid) {
      showToast('手机号不符合格式')
      return;
    }
    // 验证码在下一个页面发送
    router.pushUrl({ url: 'pages/Login/LoginCode', params: { phone: this.phone } })
  }


  @Builder LoginPhoneForm() {
    Column() {
      Stack() {
        TextInput({ placeholder: '请输入手机号' }).inputStyles().onChange(this.handleInputChange.bind(this))
        if (this.isPhoneValid) {
          Image($r('app.media.success')).width(rvp(12)).height(rvp(8)).margin({ right: rvp(5) })
        }
      }.alignContent(Alignment.End)

      Divider().color('#C4EDCE')
      Row() {
        Image(this.isAgree ? $r('app.media.radio_active') : $r('app.media.radio'))
          .width(rvp(14))
          .height(rvp(14))
          .onClick(this.handleAgree.bind(this))
        Text() {
          Span('同意').fontSize(sm()).fontColor('#C1C1C1')
          Span('《用户协议》').fontSize(sm()).fontColor($r('app.color.primary'))
          Span('和').fontSize(sm()).fontColor('#C1C1C1')
          Span('《隐私政策》').fontSize(sm()).fontColor($r('app.color.primary'))
        }.margin({ left: rvp(6) })
      }.margin({ top: rvp(16) }).width('100%')

      Button('获取验证码')
        .margin({ top: rvp(40) }).backgroundColor(this.isBtnActive ? $r('app.color.primary') : '#F0F0F0').fontSize(sm())
        .fontColor(this.isBtnActive ? $r('app.color.white') : '#C1C1C1')
        .padding({ top: rvp(12), bottom: rvp(12), left: rvp(15), right: rvp(15) })
        .onClick(this.goLoginCode.bind(this))
    }.margin({ top: rvp(47) }).padding({ left: rvp(37), right: rvp(37) }).alignItems(HorizontalAlign.End)
  }

  build() {
    Column() {
      NavBar({ title: '验证码登录' })
      this.LoginPhoneForm()
    }
    .width('100%').height('100%').linearGradient({//渐变北京
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