import { http } from '../utils/http';
import type { IHomeData,IRoomRecommendItem, IRoomRecommendList } from '../model/HomeData';

// 获取首页数据
export const getHomeDataApi = (): Promise<IHomeData> => {
  return http.get<IHomeData>('/home/info');
}

// 获取房源数据
export const getRoomRecommendListApi = (): Promise<IRoomRecommendList> => {
  return http.get<IRoomRecommendList>('/house/nearbyHouses');
}
