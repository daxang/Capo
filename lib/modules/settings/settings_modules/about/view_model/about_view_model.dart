import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';

class AboutViewModel with ChangeNotifier {
  String version;
  getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = "v" + packageInfo.version;
    notifyListeners();
  }

  bool _disposed = false;

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
