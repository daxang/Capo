import 'package:capo/utils/wallet_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static SharedPreferences sharedPreferences;
  static WalletViewModel walletViewModel;

  /// 由于是同步操作会导致阻塞,所以应尽量减少存储容量
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    walletViewModel = WalletViewModel();
    await walletViewModel.ready;
  }
}
