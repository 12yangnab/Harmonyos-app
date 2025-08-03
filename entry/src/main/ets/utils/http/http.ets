import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios';
import {promptAction} from '@kit.ArkUI'
const request = axios.create({
   //baseURL: 'http://192.168.31.57:6060', // 通过 ipconfig 查询当前电脑的 ip，使用自己电脑的 ip 地址/4#408
  baseURL: 'http://10.106.0.205:6060', // 通过 ipconfig 查询当前电脑的 ip，使用自己电脑的 ip 地址 /4#110jk1102
  timeout: 20000,
})

request.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    //tian加token函数
    const token=AppStorage.Get<string>('token');
    if(token){
      config.headers.token=token;
    }
    return config;
  }
)

request.interceptors.response.use(
  (response: AxiosResponse) => {
    if (response.data.code === 200) {
      return response.data.data;
    } else {
      return Promise.reject(response.data.message);
    }
  },
  (error: AxiosError) => {
    return Promise.reject(error.message);
  }
)

export default class Http {
  get<T>(url: string, params?: Object) {
    return request.get<null, T>(url, {
      params
    })
  }

  post<T>(url: string, data?: Object) {
    return request.post<null, T>(url, data)
  }

  put<T>(url: string, data?: Object) {
    return request.put<null, T>(url, data)
  }

  delete<T>(url: string, params?: Object) {
    return request.delete<null, T>(url, {
      params
    })
  }
};