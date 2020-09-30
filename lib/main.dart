import 'package:capo/utils/rnode_networking.dart';
import 'package:capo/utils/storage_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageManager.init();
  // RNodeNetworking.setDeployGRPCNetwork();
  // RNodeNetworking.setExploratoryDeployGRPCNetwork();

  runApp(EasyLocalization(child: CapoApp()));
}
