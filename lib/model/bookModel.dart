import 'dart:convert';

class BookModel {
  int classid = 0;
  String content = "";
  String cookingtime = "";
  int id = 0;
  List<MaterialModel> material = [];
  String name = "";
  String peoplenum = "";
  String pic = "";
  String preparetime = "";
  List<ProcessModel> process = [];
  String tag = "";

  BookModel.form(Map<String, dynamic> json)
      : classid = json["classid"] as int,
        content = json["content"],
        cookingtime = json["cookingtime"],
        id = json["id"] as int,
        material = getMaterialList(json["material"] ?? []),
        name = json["name"],
        peoplenum = json["peoplenum"],
        pic = json["pic"],
        preparetime = json["preparetime"],
        process = getProgressList(json["process"] ?? []),
        tag = json["tag"];

  Map toJson() => {
        "classid": classid,
        "content": content,
        "cookingtime": cookingtime,
        "id": id,
        "name": name,
        "peoplenum": peoplenum,
        "pic": pic,
        "preparetime": preparetime,
        "tag": tag,
        "material": material.map((e) => e.toJson()).toList(),
        "process": process.map((e) => e.toJson()).toList()
      };

  String toString() {
    return json.encode(toJson());
  }

  static List<MaterialModel> getMaterialList(List<dynamic> list) {
    return list.map((e) => MaterialModel.form(e)).toList();
  }

  static List<ProcessModel> getProgressList(List<dynamic> list) {
    return list.map((e) => ProcessModel.form(e)).toList();
  }
}

class ProcessModel {
  String pcontent = "";
  String pic = "";

  ProcessModel.form(Map<String, dynamic> json)
      : pcontent = json["pcontent"],
        pic = json["pic"];

  Map toJson() => {
        "pcontent": pcontent,
        "pic": pic,
      };
}

class MaterialModel {
  String amount = "";
  String mname = "";
  int type = 0; //0调料 1材料

  MaterialModel.form(Map<String, dynamic> json)
      : amount = json["amount"],
        mname = json["mname"],
        type = json["type"] as int;

  Map toJson() => {
        "amount": amount,
        "mname": mname,
        "type": type,
      };
}
