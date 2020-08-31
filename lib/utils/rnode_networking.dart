import 'package:capo/modules/settings/settings_modules/node_settings/view/readonly/view_model/readonly_view_model.dart';
import 'package:capo/modules/settings/settings_modules/node_settings/view/validator/model/validator_cell_model.dart';
import 'package:capo/modules/settings/settings_modules/node_settings/view/validator/view_model/validator_view_model.dart';
import 'package:capo_core_dart/capo_core_dart.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import 'capo_utils.dart';

const kCapoUserReadonlyNodeSettings = 'kCapoUserReadonlyNodeSettingsV0.0.9';
const kCapoUserValidatorNodeSettings = 'kCapoUserValidatorNodeSettingsV0.0.9';

class RNodeNetworking {
  static Future<RNodeGRPC> get gRPC async {
    var model = await ValidatorViewModel.getValidatorNodeSetting();
    if (model.autoSelected) {
      Response response = await rNodeStatusDio.get("/api/validators");
      rNodeStatusDio.close();
      CoopNodes bestValidatorModel = CoopNodes.fromJson(response.data);
      if (bestValidatorModel.nextToPropose != null) {
//        print(
//            "bestValidatorModel:${bestValidatorModel.nextToPropose.grpcPort}");
        return RNodeGRPC(
            host: bestValidatorModel.nextToPropose.host,
            port: bestValidatorModel.nextToPropose.grpcPort);
      } else {
        return RNodeGRPC(
            host: model.validators.first.host,
            port: model.validators.first.grpcPort);
      }
    } else {
      CoopValidators selectedNode = model.selectedNode;
      return RNodeGRPC(host: selectedNode.host, port: selectedNode.grpcPort);
    }
  }

  static Future<Dio> get rNodeDio async {
    var model = await ReadonlyViewModel.getReadOnlyNodeSetting();
    String baseUrl = model.selectedNode;
    Dio dio = Dio(BaseOptions(baseUrl: baseUrl, connectTimeout: 60000));
    if (!inProduction) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = (url) {
          return "PROXY 127.0.0.1:9999";
        };
      };
    }
    return dio;
  }

  static Dio get rNodeStatusDio {
    Dio dio = Dio(BaseOptions(
        baseUrl: "https://status.rchain.coop", connectTimeout: 60000));
    if (!inProduction) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = (url) {
          return "PROXY 127.0.0.1:9999";
        };
      };
    }
    return dio;
  }

  static Dio get revdefineDio {
//    http://revdefine.io:7070/
    Dio dio = Dio(BaseOptions(
        baseUrl: "https://revdefine.io", connectTimeout: 60000));
    if (!inProduction) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = (url) {
          return "PROXY 192.168.110.143:9999";
        };
      };
    }
    return dio;
  }



}
