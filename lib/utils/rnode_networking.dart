import 'package:capo/modules/settings/settings_modules/node_settings/view/readonly/view_model/readonly_view_model.dart';
import 'package:capo/modules/settings/settings_modules/node_settings/view/validator/view_model/validator_view_model.dart';
import 'package:capo_core_dart/capo_core_dart.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

const kCapoUserReadonlyNodeSettings = 'kCapoUserReadonlyNodeSettingsV0.0.6';
const kCapoUserValidatorNodeSettings = 'kCapoUserValidatorNodeSettingsV0.0.6';

class RNodeNetworking {
  static Future<RNodeGRPC> get gRPC async {
    var model = await ValidatorViewModel.getValidatorNodeSetting();
    String baseUrl = model.selectedNode;
    var s = baseUrl.split(':');
    final String host = s.first;
    final int port = int.parse(s.last);
    return RNodeGRPC(host: host, port: port);
  }

  static Future<Dio> get rNodeDio async {
    var model = await ReadonlyViewModel.getReadOnlyNodeSetting();
    String baseUrl = model.selectedNode;
    Dio dio = Dio(BaseOptions(baseUrl: baseUrl, connectTimeout: 20000));
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);
    return dio;
  }

  static Dio get transferStateDio {
    String baseUrl = "https://revdefine.io/capo/";
    Dio dio = Dio(BaseOptions(baseUrl: baseUrl, connectTimeout: 20000));
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);
    return dio;
  }
}
