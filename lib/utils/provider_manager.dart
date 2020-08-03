import 'package:capo/utils/storage_manager.dart';
import 'package:capo/utils/theme_view_model.dart';
import 'package:capo/utils/wallet_view_model.dart';
import 'package:provider/provider.dart';

List<SingleChildCloneableWidget> providers = [
  ChangeNotifierProvider<ThemeViewModel>(
      create: (context) => ThemeViewModel()),
  ChangeNotifierProvider<WalletViewModel>(
      create: (context) => StorageManager.walletViewModel),
];
