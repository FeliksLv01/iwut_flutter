import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'log_interceptor.dart';

typedef OnSuccessList<T>(List<T>? list);

typedef OnSuccess<T>(T value);

typedef OnFail(String message);

//定义dio变量
late Dio dio;

//Http请求处理工具,提供了Get及Post请求封装方法
class HttpRequest {
  //获取HttpUtil实例
  static HttpRequest? get instance => _getInstance();
  //定义HttpUtil实例
  static HttpRequest? _httpRequest;
  //获取HttpUtil实例方法,工厂模式
  static HttpRequest? _getInstance() {
    if (_httpRequest == null) {
      _httpRequest = HttpRequest();
    }
    return _httpRequest;
  }

  //构造方法
  HttpRequest() {
    //选项
    BaseOptions options = BaseOptions(
      //连接超时
      connectTimeout: 5000,
      //接收超时
      receiveTimeout: 5000,
    );
    //实例化Dio
    dio = Dio(options);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
      return null;
    };
    dio.interceptors.add(IwutLogInterceptor());
  }

  //封装get请求
  Future get(String url, {Map<String, dynamic>? parameters, Options? options}) async {
    final response = await dio.get(
      url,
      queryParameters: parameters,
      options: options,
    );
    //返回数据
    return response.data;
  }

  //封装post请求
  Future post(String url, {Map<String, dynamic>? parameters, Options? options}) async {
    //返回对象
    Response response = await dio.post(url, data: parameters, options: options);
    //返回数据
    return response.data;
  }

  Future formDataPost(String url, {FormData? formData, Options? options}) async {
    //返回对象
    Response response = await dio.post(url, data: formData, options: options);
    //返回数据
    return response.data;
  }
}
