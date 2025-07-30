import { http } from '../utils/http';

import type { IUserInfo } from '../model/UserData'
// 定义发送验证码请求的数据结构接口
interface ISMSCodeRequest {
  phone: string;
}


// 发送验证码
export const sendSMSCodeApi = (phone: string): Promise<string> => {
  return http.post<string>('/sendSMSCode', { phone } as ISMSCodeRequest);
}

// 登录
// export const loginApi = (phone: string, code: string): Promise<null> => {
//   return http.post<null>('/login', { phone, code } as ILoginRequest);
// }
// api/login.ets
// api/login.ets
// 定义登录请求的数据结构接口
interface LoginRequest {
  phone: string
  code: string
}

interface LoginResponse {
  token: string
}

export const loginApi = (phone: string, code: string): Promise<LoginResponse> => {
  const params: LoginRequest = { phone, code }
  return http.post<LoginResponse>('/login', params)
}

// 获取用户数据
export const getUserInfoApi = (): Promise<IUserInfo> => {
  return http.get<IUserInfo>('/auth/user/userInfo')
}