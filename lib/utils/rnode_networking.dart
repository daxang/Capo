import 'package:capo/modules/settings/settings_modules/node_settings/view/readonly/view_model/readonly_view_model.dart';
import 'package:capo/modules/settings/settings_modules/node_settings/view/validator/model/validator_cell_model.dart';
import 'package:capo/modules/settings/settings_modules/node_settings/view/validator/view_model/validator_view_model.dart';
import 'package:capo/utils/capo_utils.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:rnode_grpc_dart/rnode_grpc_dart.dart';

const kCapoUserReadonlyNodeSettings = 'kCapoUserReadonlyNodeSettingsV0.1.1';
const kCapoUserValidatorNodeSettings = 'kCapoUserValidatorNodeSettingsV0.1.1';

class RNodeNetworking {
  static Future setDeployGRPCNetwork() async {
    var model = await ValidatorViewModel.getValidatorNodeSetting();
    String host;
    int port;
    if (model.autoSelected) {
      Response response =
          await rNodeStatusDio.get("/api/validators").catchError((_) {
        if (model.selectedNode.host != null) {
          RNodeDeployGRPCService.shared.setDeployChannelHost(
              host: model.selectedNode.host, port: model.selectedNode.grpcPort);
        } else {
          RNodeDeployGRPCService.shared.setDeployChannelHost(
              host: model.validators.first.host,
              port: model.validators.first.grpcPort);
        }
      });
      rNodeStatusDio.close();
      CoopNodes bestValidatorModel = CoopNodes.fromJson(response.data);

      if (bestValidatorModel.nextToPropose != null) {
        host = bestValidatorModel.nextToPropose.host;
        port = bestValidatorModel.nextToPropose.grpcPort;
      } else {
        host = model.validators.first.host;
        port = model.validators.first.grpcPort;
      }
    } else {
      host = model.selectedNode.host;
      port = model.selectedNode.grpcPort;
    }
    RNodeDeployGRPCService.shared.setDeployChannelHost(host: host, port: port);
  }

  static Future setExploratoryDeployGRPCNetwork() async {
    var model = await ReadonlyViewModel.getReadOnlyNodeSetting();
    final String host = model.selectedNode;
    RNodeExploratoryDeployGRPCService.shared.setDeployChannelHost(host: host);
  }

  static Dio get rNodeStatusDio {
    Dio dio =
        Dio(BaseOptions(baseUrl: "http://revdefine.io", connectTimeout: 20000));
    // if (!inProduction) {
    //   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //       (client) {
    //     client.findProxy = (uri) {
    //       return "PROXY 192.168.55.121:8888";
    //     };
    //   };
    // }
    return dio;
  }
}
