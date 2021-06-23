import 'dart:convert';
import 'model/catesModel.dart';

String appName = "简单食谱";
List<SecCate> menus = (json.decode("""[
                {
                    "classid": 224,
                    "name": "川菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/chuancai.jpeg"
                },
                {
                    "classid": 225,
                    "name": "湘菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/xiangcai.jpeg"
                },
                {
                    "classid": 226,
                    "name": "粤菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/yuecai.jpeg"
                },
                {
                    "classid": 227,
                    "name": "闽菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/mincai.jpeg"
                },
                {
                    "classid": 228,
                    "name": "浙菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/zhecai.jpeg"
                },
                {
                    "classid": 229,
                    "name": "鲁菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/lucai.jpeg"
                },
                {
                    "classid": 230,
                    "name": "苏菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/sucai.jpeg"
                },
                {
                    "classid": 231,
                    "name": "徽菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/huicai.jpeg"
                },
                {
                    "classid": 232,
                    "name": "京菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/jingcai.jpeg"
                },
                {
                    "classid": 233,
                    "name": "天津菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/天津菜.jpeg"
                },
                {
                    "classid": 234,
                    "name": "上海菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/上海菜.jpeg"
                },
                {
                    "classid": 235,
                    "name": "渝菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/渝菜.jpeg"
                },
                {
                    "classid": 236,
                    "name": "东北菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/东北菜.jpeg"
                },
                {
                    "classid": 237,
                    "name": "清真菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/清真菜.jpeg"
                },
                {
                    "classid": 238,
                    "name": "豫菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/豫菜.jpeg"
                },
                {
                    "classid": 239,
                    "name": "晋菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/晋菜.jpeg"
                },
                {
                    "classid": 240,
                    "name": "赣菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/赣菜.jpeg"
                },
                {
                    "classid": 241,
                    "name": "湖北菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/湖北菜.jpeg"
                },
                {
                    "classid": 242,
                    "name": "云南菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/云南菜.jpeg"
                },
                {
                    "classid": 243,
                    "name": "贵州菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/贵州菜.jpeg"
                },
                {
                    "classid": 244,
                    "name": "新疆菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/新疆菜.jpeg"
                },
                {
                    "classid": 245,
                    "name": "淮扬菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/淮扬菜.jpeg"
                },
                {
                    "classid": 246,
                    "name": "潮州菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/潮州菜.jpeg"
                },
                {
                    "classid": 247,
                    "name": "客家菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/客家菜.jpeg"
                },
                {
                    "classid": 248,
                    "name": "广西菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/广西菜.jpeg"
                },
                {
                    "classid": 249,
                    "name": "西北菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/西北菜.jpeg"
                },
                {
                    "classid": 250,
                    "name": "香港美食",
                    "parentid": 223,
                    "icon":"assets/images/menu/香港美食.jpeg"
                },
                {
                    "classid": 251,
                    "name": "台湾菜",
                    "parentid": 223,
                    "icon":"assets/images/menu/台湾菜.jpeg"
                },
                {
                    "classid": 254,
                    "name": "日本料理",
                    "parentid": 223,
                    "icon":"assets/images/menu/日本料理.jpeg"
                }
            ]""") as List<dynamic>).map((e) => SecCate.form(e)).toList();
