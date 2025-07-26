import mediaQuery from '@ohos.mediaquery'
// responsiveFontSize.ets
export const lg = () => 16;   // 或你想要的默认值
export const sm = () => 12;
class Breakpoint {
  name: string = '';
  size: number = 0;
  mediaQueryListener?: mediaQuery.MediaQueryListener
}

export class BreakpointSystem {
  private currentBreakpoint: string = 'sm'
  // sm 对应 phone
  // md 对应 pad
  // lg 对应 pc 匹配不上也是 pc
  private breakpoints: Breakpoint[] = [{ name: 'sm', size: 768 },
    { name: 'md', size: 992 }, { name: 'lg', size: 1200 }]

  private updateCurrentBreakpoint(breakpoint: string) {
    if (this.currentBreakpoint !== breakpoint) {
      this.currentBreakpoint = breakpoint
      AppStorage.Set<string>('currentBreakpoint', this.currentBreakpoint)
      console.log('on current breakpoint: ' + this.currentBreakpoint)
    }
  }

  public register() {
    this.breakpoints.forEach((breakpoint: Breakpoint, index) => {
      let condition: string = ''
      if (index === this.breakpoints.length - 1) {
        condition = "(" + breakpoint.size + "vp<=width" + ")"
      } else {
        condition = "(" + breakpoint.size + "vp<=width<" + this.breakpoints[index + 1].size + "vp)"
      }
      breakpoint.mediaQueryListener = mediaQuery.matchMediaSync(condition)
      breakpoint.mediaQueryListener.on('change', (mediaQueryResult) => {
        if (mediaQueryResult.matches) {
          this.updateCurrentBreakpoint(breakpoint.name)
        }
      })
    })
  }

  public unregister() {
    this.breakpoints.forEach((breakpoint: Breakpoint) => {
      if (breakpoint.mediaQueryListener) {
        breakpoint.mediaQueryListener.off('change')
      }
    })
  }
}