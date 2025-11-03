import 'dart:convert';
import 'dart:developer';
import 'package:bloc_state_management/model/user_model.dart';
import 'package:bloc_state_management/services/local/local_service.dart';
import 'package:dio/dio.dart';

typedef Json = Map<String, dynamic>;

class NetworkService {
  final String baseUrl;
  final LocalStorageService storage;
  final Dio dio = Dio();

  NetworkService({required this.baseUrl, required this.storage}) {
    _initialize();
  }

  // ===== Public verbs (ready-to-use) =====
  Future<T> getJson<T>(
    String path, {
    Map<String, dynamic>? query,
    T Function(dynamic json)? parser, // parser gets either Map or List
  }) async {
    final res = await dio.get(path, queryParameters: query);
    final body = _handleResponse(res);
    return parser != null ? parser(body) : body as T;
  }

  Future<T> postRawJson<T>(
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic>? query,
    T Function(dynamic json)? parser,
  }) async {
    final res = await dio.post(path, data: jsonEncode(data), queryParameters: query);
    final body = _handleResponse(res);
    return parser != null ? parser(body) : body as T;
  }

  Future<T> postForm<T>(
    String path,
    FormData form, {
    Map<String, dynamic>? query,
    T Function(dynamic json)? parser,
  }) async {
    final res = await dio.post(path, data: form, queryParameters: query);
    final body = _handleResponse(res);
    return parser != null ? parser(body) : body as T;
  }

  Future<T> putRawJson<T>(
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic>? query,
    T Function(dynamic json)? parser,
  }) async {
    final res = await dio.put(path, data: jsonEncode(data), queryParameters: query);
    final body = _handleResponse(res);
    return parser != null ? parser(body) : body as T;
  }

  Future<T> patchRawJson<T>(
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic>? query,
    T Function(dynamic json)? parser,
  }) async {
    final res = await dio.patch(path, data: jsonEncode(data), queryParameters: query);
    final body = _handleResponse(res);
    return parser != null ? parser(body) : body as T;
  }

  Future<T> deleteJson<T>(
    String path, {
    Map<String, dynamic>? query,
    T Function(dynamic json)? parser,
  }) async {
    final res = await dio.delete(path, queryParameters: query);
    final body = _handleResponse(res);
    return parser != null ? parser(body) : body as T;
  }

  // ===== Internals =====
  void _initialize() {
    dio.options
      ..baseUrl = baseUrl
      ..responseType = ResponseType.json
      ..headers = {'Accept': 'application/json', 'Content-Type': 'application/json'};

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Pull token on every request to stay in sync with latest login
        final UserModel? user = await storage.getUserModel();
        final token = user?.accessToken;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        } else {
          options.headers.remove('Authorization');
        }
        handler.next(options);
      },
      onResponse: (r, h) => h.next(r), // keep default
      onError: (e, h) {
        // Normalize error message a bit (developer_message > message > HTTP)
        final resp = e.response;
        String msg = 'Something went wrong';
        if (resp?.data is Map) {
          final m = resp!.data as Map;
          msg = (m['developer_message'] ?? m['message'] ?? msg).toString();
        } else if (resp != null) {
          msg = '${resp.statusCode} ${resp.statusMessage}';
        }
        log('HTTP ERROR ${resp?.statusCode}: $msg\n${e.requestOptions.method} ${e.requestOptions.uri}',
            name: 'NetworkService', error: e);
        h.next(e);
      },
    ));
  }

  /// Accepts either:
  /// - `{status: 1|true, data: ..., message?: ...}` → returns `data`
  /// - any JSON (`Map` / `List`) → returns it as-is
  /// Throws `DioException` if `{status}` indicates failure or HTTP not OK.
  dynamic _handleResponse(Response res) {
    final sc = res.statusCode ?? 0;
    if (sc < 200 || sc >= 300) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
        error: '${res.statusCode} ${res.statusMessage}',
      );
    }

    final data = res.data;
    if (data is Map) {
      // Envelope shape
      if (data.containsKey('status')) {
        final s = data['status'];
        final ok = (s is int && s == 1) || (s is bool && s == true);
        if (!ok) {
          final msg = (data['developer_message'] ?? data['message'] ?? 'Request failed').toString();
          throw DioException(
            requestOptions: res.requestOptions,
            response: res,
            type: DioExceptionType.badResponse,
            error: msg,
          );
        }
        // Prefer 'data' if present, else return whole
        return data.containsKey('data') ? data['data'] : data;
      }
      // No envelope; return as-is
      return data;
    }

    // Array or primitive: just return
    return data;
  }
}
