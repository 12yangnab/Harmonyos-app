import { http } from '../utils/http';
import type {
  GetCityListParams,
  GetDistrictListParams,
  ICityList,
  IDistrictList,
  IGetRentRoomListParams,
  IGetRentRoomListResponse,
  IProvinceList
} from '../model/RentRoomData';

// 获取租房列表数据
export const getRentRoomListApi = (params: IGetRentRoomListParams): Promise<IGetRentRoomListResponse> => {
  return http.get<IGetRentRoomListResponse>('/house/search', params)
}

// 获取省份数据
export const getProvinceListApi = (): Promise<IProvinceList> => {
  return http.get<IProvinceList>('/province')
}

// 获取城市数据
export const getCityListApi = (provinceCode: string): Promise<ICityList> => {
  const params: GetCityListParams = { provinceCode }
  return http.get<ICityList>('/city', params)
}

// 获取区县数据
export const getDistrictListApi = (cityCode: string): Promise<IDistrictList> => {
  const params: GetDistrictListParams = { cityCode }
  return http.get<IDistrictList>('/area', params)
}