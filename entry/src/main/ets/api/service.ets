import { http } from '../utils/http';
import type { IServiceData } from '../model/ServiceData'

// 获取租房列表数据
export const getServiceDataApi = (): Promise<IServiceData> => {
  return http.get<IServiceData>('/service/info')
}