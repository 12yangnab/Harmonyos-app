// 获取状态栏高度
export const getWindowTopHeight = () => {
  return px2vp(AppStorage.get('windowTopHeight') || 0)
}

// 获取底部高度
export const getWindowBottomHeight = () => {
  return px2vp(AppStorage.get('windowBottomHeight') || 0)
}

// 获取屏幕宽度，进行缓存
let windowWidth: number;

export function getWindowWidth() {
  if (windowWidth) {
    return windowWidth;
  }
  // 获取到的屏幕宽度是px单位
  const storageWindowWidth = AppStorage.get<number>('windowWidth');
  if (storageWindowWidth) {
    // 将屏幕宽度转化为vp单位
    windowWidth = px2vp(storageWindowWidth)
  } else {
    // 预览器没法获取屏幕宽度，所以读取的到值为0，会进入这里，我们给默认值360
    windowWidth = 360
    // 预览器平板测试使用这个值
    // windowWidth = 640
  }
  return windowWidth
}

// 将元素按照原来比例进行转化
export function rvp(val: number) {
  /*
    * 设计稿总宽度：360 (固定值)
    * 设计稿某个元素大小：120 -> val
    * 实际设备屏幕宽度：400 -> 通过 window.getWindowProperties().windowRect.width 方式获取, 得到单位是 px，需要转 vp 计算
    * 元素实际大小：x
    * x / 400 = val / 360
    *
    * 解方程式得出: x = val / 360 * 实际设备屏幕宽度
   */
  return val / 360 * getWindowWidth()
}