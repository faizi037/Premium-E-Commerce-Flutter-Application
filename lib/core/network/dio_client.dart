import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.example.com', // Replace with actual API base URL
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add logging interceptor for development
  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (o) => debugPrint(o.toString()),
    ));
  }

  // Add custom interceptor for auth headers or error handling
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      // Add auth token if available
      // options.headers['Authorization'] = 'Bearer ...';
      return handler.next(options);
    },
    onError: (DioException e, handler) {
      // Handle global errors like 401 Unauthorized
      return handler.next(e);
    },
  ));

  return dio;
});
