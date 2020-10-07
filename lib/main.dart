import 'package:capo/utils/storage_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageManager.init();

  runApp(EasyLocalization(child: CapoApp()));
}
