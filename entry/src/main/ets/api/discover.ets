import { http } from '../utils/http';
import type { IDiscoverData } from '../model/DiscoverData';

// 获取发现列表数据
export const getDiscoverDataApi = (): Promise<IDiscoverData> => {
  return http.get<IDiscoverData>('/discover/info')
}