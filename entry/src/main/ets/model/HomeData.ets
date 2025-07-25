
// https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-rendering-control-lazyforeach-V5
export class BannerListDataSource implements IDataSource {


  // 内部用来触发UI更新对象
  listeners: DataChangeListener[] = []
  // 管理数据
  bannerList: IBannerList = []

  // 实现了 IDataSource 接口
  // 接口要求我们必须定义四个方法：getData、totalCount、registerDataChangeListener、unregisterDataChangeListener
  // 读取对应下标的数据
  getData(index: number): IBannerItem {
    return this.bannerList[index]
  }

  // 返回数据总长度
  totalCount(): number {
    return this.bannerList.length
  }

  // 保存单个数据
  setData(item: IBannerItem) {
    // 只会更新数据，不会更新UI
    this.bannerList.push(item);
    // 更新UI
    this.notifyDataAdd(this.bannerList.length - 1);
  }

  // 更新所有数据
  setList(list: IBannerList) {
    this.bannerList = list;
    this.notifyDataReload();
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  // 通知LazyForEach组件将from索引和to索引处的子组件进行交换
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }
}

export interface IHomeData {
  "bannerList": IBannerList
  "navList": INavList
  "tileList": ITileList
  "planList": IPlanList
  "roomRecommendList": IRoomRecommendList
  "adPicture": string
}

export interface IBannerItem {
  "id": string
  "name": string
  "imageURL": string
}

export type IBannerList = IBannerItem[]

export interface INavItem {
  "id": string
  "title": string
  "imageURL": string
}

export type INavList = INavItem[]

export interface ITileItem {
  "id": string
  "imageURL": string
  "title": string
  "sub_title": string
}
export type ITileList = ITileItem[]

export interface IPlanItem {
  "id": string
  "imageURL": string
}
export type IPlanList = IPlanItem[]


export interface ITagItem {
  "name": string
}
export type ITagList = ITagItem[]

export interface IRoomRecommendItem {
  "id": string
  "housePicture": string
  "tags":ITagList
  "houseTile":string
  "address":string
  "rentPriceUnit":string
  "rentPriceListing":string
  "rentArea":string
  "houseTitle": string;
}

export type IRoomRecommendList = IRoomRecommendItem[]

export interface IColor {
  fontColor: string;
  bgColor: string;
}

export class RoomRecommendDataSource implements IDataSource {
  // 内部用来触发UI更新对象
  listeners: DataChangeListener[] = []
  roomRecommendList: IRoomRecommendList=[]
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }
  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }
getData(index: number): IRoomRecommendItem {
  return this.roomRecommendList[index]}
  totalCount(): number {
    return this.roomRecommendList.length
  }
setList(list: IRoomRecommendList) {
    this.roomRecommendList = list;
    this.notifyDataReload();
}

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }
}




