import { http } from '../utils/http';
import type {
  IRentRoomDetail,IReservationRoomParams
} from '../model/RentRoomDetailData.ets';

// 获取房间详情数据
export const getRoomDetailApi = (id:string): Promise<IRentRoomDetail> => {
  return http.get<IRentRoomDetail>('/house/detail',id )
}


// 预约租房
export const reservationRoomApi = (data:IReservationRoomParams): Promise<null> => {
  return http.post<null>('/auth/house/reservation',data )
}