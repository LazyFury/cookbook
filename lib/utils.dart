import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:url_launcher/url_launcher.dart';

String appkey = "369bd3e0501a26d1";
String baseUrl = "https://api.jisuapi.com";

launchUrl(String url) async {
  try {
    var can = await canLaunch(url);
    if (can) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  } catch (err) {
    throw err;
  }
}

class Fetch {
  static Dio? _instance;
  static Dio get dio {
    if (_instance == null) {
      _instance = getDioInstance();
    }
    return _instance!;
  }

  static Dio getDioInstance() {
    Dio dio =
        new Dio(BaseOptions(baseUrl: baseUrl, responseType: ResponseType.json));
    dio.interceptors.add(
        DioCacheInterceptor(options: CacheOptions(store: MemCacheStore())));
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions config, handler) {
      config.queryParameters.putIfAbsent("appkey", () => appkey);
      if (config.data != null) {
        try {
          var data = Map<String, dynamic>.from(config.data);
          data.putIfAbsent("appkey", () => appkey);
          config.data = data;
        } catch (err) {
          print(err);
        }
      }

      handler.next(config);
    }, onResponse: (res, handler) {
      handler.next(res);
    }));
    return dio;
  }
}

class Result {
  String status = "";
  String msg = "";
  dynamic result;

  Result.form(Map<String, dynamic> json)
      : status = "${json["status"]}",
        msg = json["msg"],
        result = json["result"];

  bool get ok {
    return status == "0";
  }
}

class Api {
  static var cate = () => Fetch.dio.get<dynamic>(
        "/recipe/class",
        queryParameters: {},
      );

  static var cateList =
      (int classid, {int start = 0, int num = 10}) => Fetch.dio.post<dynamic>(
            "/recipe/byclass",
            queryParameters: {"classid": classid, "start": start, "num": num},
          );

  static var search =
      (String keyword, {int start = 0, int num = 10}) => Fetch.dio.get(
            "/recipe/search",
            queryParameters: {"keyword": keyword, "start": start, "num": num},
          );
}
