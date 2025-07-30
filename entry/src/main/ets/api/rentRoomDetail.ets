import { http } from '../utils/http';
import type {
  IRentRoomDetail
} from '../model/RentRoomDetailData.ets';

// 获取房间详情数据
export const getRoomDetailApi = (id:string): Promise<IRentRoomDetail> => {
  return http.get<IRentRoomDetail>('/house/detail',id )
}