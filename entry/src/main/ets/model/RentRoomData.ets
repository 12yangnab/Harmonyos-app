import type { IRoomRecommendItem } from '../model/RoomRecommendDataSource'

export type IPaymentType = "月付" | "季付" | "半年付" | "年付"

export type IOrderBy = "面积" | "价格"

export type IOrderType = "asc" | "desc"

export interface IGetRentRoomListParams {
  "page": number
  "limit": number
  "provinceCode"?: string
  "cityCode"?: string
  "districtCode"?: string
  "minRent"?: string
  "maxRent"?: string
  "paymentType"?: string
  "orderBy"?: string,
  "orderType"?: string
}

export interface IGetRentRoomListResponse {
  records: IRentRoomList
  total: number
}

export interface IActivity {
  "title": string
  "textColor": string
  "textBackGroundColor": string
  "#text": string
  "icon": string
}

export interface IRentRoomItem extends IRoomRecommendItem {
  "activity"?: IActivity
}

export type IRentRoomList = IRentRoomItem[]


export class RentRoomListDataSource implements IDataSource {
  data: IRentRoomList = [];
  private listeners: DataChangeListener[] = [];

  constructor(list: IRentRoomList) {
    this.pushDataList(list);
  }

  public totalCount(): number {
    return this.data.length;
  }

  public getData(index: number) {
    return this.data[index];
  }

  // 增加数据
  public pushData(item: IRentRoomItem) {
    this.data.push(item);
    this.notifyDataAdd(this.data.length - 1);
  }

  // 增加数据列表
  public pushDataList(list: IRentRoomList) {
    list.forEach(item => {
      this.pushData(item);
    })
  }

  // 重新加载数据
  public reloadDataList(list: IRentRoomList): void {
    this.data = list
    this.notifyDataReload()
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
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

  // 清空所有数据
  clear(): void {
    this.data = [];
    this.notifyDataReload();
  }
}

export interface IProvinceItem {
  code: string;
  name: string;
}

export type IProvinceList = IProvinceItem[]

export interface ICityItem {
  "code": string
  "name": string
  "provinceCode": string
}

export type ICityList = ICityItem[]

export interface IDistrictItem {
  "code": string
  "name": string
  "cityCode": string
  "provinceCode": string
}

export type IDistrictList = IDistrictItem[]

export interface GetCityListParams {
  provinceCode: string
}

export interface GetDistrictListParams {
  cityCode: string
}

// ...
export interface IRentPriceItem {
  id: number;
  minRent: string;
  maxRent: string;
  text: string;
}

export type IRentPriceList = IRentPriceItem[]
// ...
export interface ISortItem {
  id: number;
  icon: Resource;
  text: string;
  orderBy: IOrderBy;
  orderType: IOrderType;
}

export type ISortList = ISortItem[]