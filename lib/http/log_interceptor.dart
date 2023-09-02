import 'package:dio/dio.dart';
import 'package:iwut_flutter/config/log/log.dart';

class IwutLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Log.info('onRequest :${options.baseUrl} ## ${options.path}', tag: '网络');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Log.info('onResponse, statusCode: ${response.statusCode}, statusMessage: ${response.statusMessage}', tag: '网络');
    Log.debug('ResponseData: ${response.data}', tag: '网络');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    Log.error('onError : ${err.message}', tag: '网络');
    super.onError(err, handler);
  }
}
