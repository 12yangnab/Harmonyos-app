import NavBar from '../../components/Navbar'
import { rvp } from '../../utils/responsive'
import { lg, sm } from '../../utils/responsiveFontSize'   // ① 确保文件真的导出 lg/sm
import { PHONE_REG } from '../../constans/regs'

@Entry
@Component
struct LoginPhone {
  @State phone: string = ''
  @State isPhoneValid: boolean = false
  @State isAgree: boolean = false
  @State isBtnActive: boolean = false

  /* ---------- 业务方法 ---------- */
  handleInputChange(val: string) {               // ② 显式标注类型
    this.phone = val
    this.isPhoneValid = PHONE_REG.test(val)
    this.handleBtnActive()
  }

  handleAgree() {
    this.isAgree = !this.isAgree
    this.handleBtnActive()
  }

  handleBtnActive() {
    this.isBtnActive = this.isAgree && this.phone.length > 0
  }

  /* ---------- UI ---------- */
  @Builder LoginPhoneForm() {
    Column() {
      Stack() {
        TextInput({ placeholder: '请输入手机号' })
          .inputStyles()
          .onChange((val: string) => this.handleInputChange(val))   // ③ 不用 bind
        if (this.isPhoneValid) {
          Image($r('app.media.success'))
            .width(rvp(12)).height(rvp(8)).margin({ right: rvp(5) })
        }
      }.alignContent(Alignment.End)

      Divider().color('#C4EDCE')

      Row() {
        Image(this.isAgree ? $r('app.media.radio_active') : $r('app.media.radio'))
          .width(rvp(14))
          .height(rvp(14))
          // 👇 圆心颜色切换
          .fillColor(this.isAgree ? $r('app.color.primary') : '#C1C1C1')
          .onClick(() => this.handleAgree())
        Text() {
          Span('同意').fontSize(sm()).fontColor('#C1C1C1')
          Span('《用户协议》').fontSize(sm()).fontColor($r('app.color.primary'))
          Span('和').fontSize(sm()).fontColor('#C1C1C1')
          Span('《隐私政策》').fontSize(sm()).fontColor($r('app.color.primary'))
        }.margin({ left: rvp(6) })
      }.margin({ top: rvp(16) }).width('100%')

      Button('获取验证码')
        .margin({ top: rvp(40) })
        .backgroundColor(this.isBtnActive ? $r('app.color.primary') : '#F0F0F0')
        .fontColor(this.isBtnActive ? $r('app.color.white') : '#C1C1C1')
        .fontSize(sm())
        .padding({ top: rvp(12), bottom: rvp(12), left: rvp(15), right: rvp(15) })
    }
    .margin({ top: rvp(47) })
    .padding({ left: rvp(37), right: rvp(37) })
    .alignItems(HorizontalAlign.End)
  }

  build() {
    Column() {
      NavBar({ title: '验证码登录' })
      this.LoginPhoneForm()
    }
    .width('100%').height('100%')
    .linearGradient({ angle: 180, colors: [['#DEFBE5', 0], ['#ffffff', 0.3], ['#ffffff', 1]] })
  }
}

/* ---------- 样式扩展 ---------- */
@Styles function pressedStyles() {
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
  .stateStyles({ pressed: pressedStyles, clicked: pressedStyles })
}