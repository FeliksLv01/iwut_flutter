
enum WHUTCampus {
  YuJiaTou, NanHu, JianHu, XiYuan, DongYuan
}
/// 文字转换为WHUTCampus枚举对象的快捷方法
WHUTCampus? strToCampus(String str) {
  switch(str) {
    case '余家头校区': return WHUTCampus.YuJiaTou;
    case '余家头': return WHUTCampus.YuJiaTou;
    case '南湖校区': return WHUTCampus.NanHu;
    case '南湖': return WHUTCampus.NanHu;
    case '东院校区': return WHUTCampus.DongYuan;
    case '东院': return WHUTCampus.DongYuan;
    case '西院校区': return WHUTCampus.XiYuan;
    case '西院': return WHUTCampus.XiYuan;
    case '鉴湖校区': return WHUTCampus.JianHu;
    default: return null;
  }
}
/// WHUTCampus枚举转换为长文字
String whutCampusFullTitle(WHUTCampus campus) {
  switch(campus) {
    case WHUTCampus.YuJiaTou: return "余家头校区";
    case WHUTCampus.NanHu: return "南湖校区";
    case WHUTCampus.DongYuan: return "东院校区";
    case WHUTCampus.XiYuan: return "西院校区";
    case WHUTCampus.JianHu: return "鉴湖校区";
    default: return "未知校区";
  }
}
/// WHUTCampus枚举转换为短文字
String whutCampusShortTitle(WHUTCampus? campus) {
  if(campus==null) return "校区";
  switch(campus) {
    case WHUTCampus.YuJiaTou: return "余家头";
    case WHUTCampus.NanHu: return "南湖";
    case WHUTCampus.DongYuan: return "东院";
    case WHUTCampus.XiYuan: return "西院";
    case WHUTCampus.JianHu: return "鉴湖";
    default: return "未知";
  }
}