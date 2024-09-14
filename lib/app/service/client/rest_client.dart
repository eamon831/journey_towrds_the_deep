import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_options.dart';
import 'error_catcher.dart';
import 'utils/failures.dart';
import 'utils/pretty_dio_logger.dart';

class RestClient {
  static final RestClient _instance = RestClient._internal();

  factory RestClient({
    required String baseUrl,
    required String token,
    int connectionTimeout = 30000,
    int receiveTimeout = 30000,
  }) {
    _instance._initialize(
      baseUrl,
      token,
      connectionTimeout,
      receiveTimeout,
    );
    return _instance;
  }

  RestClient._internal();

  late Dio _dio;
  late String baseUrl;
  late String token;

  void _initialize(
    String baseUrl,
    String token,
    int connectionTimeout,
    int receiveTimeout,
  ) {
    this.baseUrl = baseUrl;
    this.token = token;

    final BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(
        milliseconds: connectionTimeout,
      ),
      receiveTimeout: Duration(
        milliseconds: receiveTimeout,
      ),
    );

    _dio = Dio(options);
    _setDioInterceptors();
  }

  void setToken(String newToken) {
    token = newToken;
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void _setDioInterceptors() {
    final List<Interceptor> interceptors = [];

    if (kDebugMode) {
      interceptors.add(PrettyDioLogger());
    }

    _dio.interceptors.addAll(interceptors);
  }

  Future<Options> _getRequestOptions(
    APIType apiType, {
    Map<String, dynamic>? customHeaders,
  }) async {
    final options = await _getOptions(apiType);

    if (customHeaders != null) {
      options.headers?.addAll(customHeaders);
    }

    return options;
  }

  Future<Options> _getOptions(APIType apiType) async {
    switch (apiType) {
      case APIType.protected:
        return ProtectedApiOptions(token).options;
      case APIType.public:
      default:
        return PublicApiOptions().options;
    }
  }

  Future<Response<dynamic>> get(
    APIType apiType,
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    final options = await _getRequestOptions(apiType, customHeaders: headers);
    return _makeRequest(
      () {
        return _dio.get(
          path,
          queryParameters: query,
          options: options,
        );
      },
    );
  }

  Future<Response<dynamic>> post(
    APIType apiType,
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
  }) async {
    final options = await _getRequestOptions(
      apiType,
      customHeaders: headers,
    );
    return _makeRequest(
      () {
        return _dio.post(
          path,
          data: data,
          options: options,
          queryParameters: query,
        );
      },
    );
  }

  Future<Response<dynamic>> postFormData(
    APIType apiType,
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
  }) async {
    final options = await _getRequestOptions(
      apiType,
      customHeaders: {
        ...?headers,
        'Content-Type': 'multipart/form-data',
      },
    );

    return _makeRequest(
      () {
        return _dio.post(
          path,
          data: FormData.fromMap(data),
          options: options,
          queryParameters: query,
        );
      },
    );
  }

  Future<Response<dynamic>> patch(
    APIType apiType,
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
  }) async {
    final options = await _getRequestOptions(
      apiType,
      customHeaders: headers,
    );
    return _makeRequest(
      () => _dio.patch(
        path,
        data: data,
        options: options,
        queryParameters: query,
      ),
    );
  }

  Future<Response<dynamic>> put(
    APIType apiType,
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
  }) async {
    final options = await _getRequestOptions(
      apiType,
      customHeaders: headers,
    );
    return _makeRequest(
      () => _dio.put(
        path,
        data: data,
        options: options,
        queryParameters: query,
      ),
    );
  }

  Future<Response<dynamic>> delete(
    APIType apiType,
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
  }) async {
    final options = await _getRequestOptions(
      apiType,
      customHeaders: headers,
    );
    return _makeRequest(
      () {
        return _dio.delete(
          path,
          data: data,
          options: options,
          queryParameters: query,
        );
      },
    );
  }

  Future<Response<dynamic>> putFormData(
    APIType apiType,
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
  }) async {
    final options = await _getRequestOptions(
      apiType,
      customHeaders: {
        ...?headers,
        'Content-Type': 'multipart/form-data',
      },
    );
    data['_method'] = 'PUT';

    return _makeRequest(
      () => _dio.post(
        path,
        data: FormData.fromMap(data),
        options: options,
        queryParameters: query,
      ),
    );
  }

  Future<Response> fileUploadInS3Bucket({
    required String preAssignedUrl,
    required File file,
  }) async {
    return _makeRequest(() async {
      final fileLength = await file.length();
      return _dio.put(
        preAssignedUrl,
        data: file.openRead(),
        options: Options(
          headers: {
            Headers.contentLengthHeader: fileLength,
          },
        ),
      );
    });
  }

  Future<Response<dynamic>> _makeRequest(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      return await request();
    } catch (error) {
      _handleException(error);
      throw Unexpected('An unknown error occurred');
    }
  }

  void _handleException(dynamic error) {
    final errorData = error is DioException ? error.response?.data : null;
    final statusCode =
        error is DioException ? error.response?.statusCode : null;

    ErrorCatcher.setError(
      exception: error,
      stackTrace: StackTrace.current,
      hasError: true,
      statusCode: statusCode,
    );

    if (kDebugMode) {
      print('ErrorCatch: ${ErrorCatcher().toJson()}');
    }

    if (errorData == null) {
      if (error is DioException &&
          (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout)) {
        throw const RequestTimeout(null);
      }
      throw const Unexpected(null);
    }

    throw _mapStatusCodeToException(
      statusCode,
      errorData,
    );
  }

  Failure _mapStatusCodeToException(int? statusCode, dynamic errorData) {
    switch (statusCode) {
      case 400:
        return BadRequest(errorData);
      case 401:
        return Unauthorized(errorData);
      case 403:
        return Forbidden(errorData);
      case 404:
        return NotFound(errorData);
      case 405:
        return MethodNotAllowed(errorData);
      case 406:
        return NotAcceptable(errorData);
      case 408:
        return RequestTimeout(errorData);
      case 409:
        return Conflict(errorData);
      case 410:
        return Gone(errorData);
      case 411:
        return LengthRequired(errorData);
      case 412:
        return PreconditionFailed(errorData);
      case 413:
        return PayloadTooLarge(errorData);
      case 414:
        return URITooLong(errorData);
      case 415:
        return UnsupportedMediaType(errorData);
      case 416:
        return RangeNotSatisfiable(errorData);
      case 417:
        return ExpectationFailed(errorData);
      case 422:
        return UnprocessableEntity(errorData);
      case 429:
        return TooManyRequests(errorData);
      case 500:
        return InternalServerError(errorData);
      case 501:
        return NotImplemented(errorData);
      case 502:
        return BadGateway(errorData);
      case 503:
        return ServiceUnavailable(errorData);
      case 504:
        return GatewayTimeout(errorData);
      default:
        return Unexpected(errorData);
    }
  }
}
