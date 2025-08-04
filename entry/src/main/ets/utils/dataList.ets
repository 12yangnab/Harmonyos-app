import { IFormatDate, IFormatDateList } from '../model/RentRoomDetailData'

// 补0函数
function addZero(val: number) {
  return val < 10 ? '0' + val : `${val}`;
}

function formatDate(time: number): IFormatDate {
  const date = new Date(time)
  const year = date.getFullYear()
  const month = addZero(date.getMonth() + 1)
  const day = addZero(date.getDate())
  const week = formatWeekText(date.getDay())

  const formatDate: IFormatDate = {
    week,
    date: `${year}-${month}-${day}`
  }
  return formatDate
}

function formatWeekText(week: number): string {
  switch (week) {
    case 1:
      return '周一'
    case 2:
      return '周二'
    case 3:
      return '周三'
    case 4:
      return '周四'
    case 5:
      return '周五'
    case 6:
      return '周六'
    default:
      return '周日'
  }
}

export default function createDateList(): IFormatDateList {
  const nowTime = Date.now()
  const oneDay = 24 * 60 * 60 * 1000
  const dateList: IFormatDateList = []

  for (let i = 0; i < 7; i++) {
    const date = formatDate(nowTime + i * oneDay)
    if (i === 0) {
      date.week = '今天'
    }
    dateList.push(date)
  }

  return dateList
}