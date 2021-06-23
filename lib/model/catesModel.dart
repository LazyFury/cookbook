class FirstCate extends SecCate {
  List<SecCate> list = [];

  FirstCate.form(Map<String, dynamic> json)
      : list = getList(json['list']),
        super.form(json);

  static List<SecCate> getList(List<dynamic> list) {
    return list.map((e) => SecCate.form(e)).toList();
  }
}

class SecCate {
  int classid = 0;
  String name = "";
  int parentid = 0;
  String icon = "";

  SecCate({String? name, int? classid, int? parentid, String? icon})
      : assert(name != null),
        name = name!,
        classid = classid ?? 0,
        parentid = parentid ?? 0,
        icon = icon ?? "";

  SecCate.form(Map<String, dynamic> json)
      : classid = json["classid"] as int,
        name = json["name"] as String,
        parentid = json["parentid"] as int,
        icon = (json["icon"] ?? "") as String;
}
