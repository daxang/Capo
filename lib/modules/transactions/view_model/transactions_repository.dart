import 'package:capo/modules/transactions/model/transfer_state_info.dart';
import 'package:capo/utils/rnode_networking.dart';
import 'package:capo/utils/wallet_view_model.dart';
import 'package:loading_more_list/loading_more_list.dart';

class TransactionsRepository extends LoadingMoreBase<Transaction> {
  int pageindex = 1;
  bool forceRefresh = false;
  final int rowsPerPage = 20;
  bool _hasMore = true;

  @override
  bool get hasMore => (_hasMore) || forceRefresh;

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) async {
    _hasMore = true;

    pageindex = 1;

    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
    forceRefresh = !notifyStateChanged;
    final bool result = await super.refresh(notifyStateChanged);
    forceRefresh = false;

    return result;
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    bool isSuccess = true;
    try {
      final String requestUrl =
          "/define/api/transactions/${WalletViewModel.shared.currentWallet.address}/transfer?rowsPerPage=$rowsPerPage&page=$pageindex";
      print("requestUrl: $requestUrl");
      var result = await RNodeNetworking.rNodeStatusDio
          .get(requestUrl)
          .catchError((error) {
        print("error: ${error.toString()}");
        isSuccess = false;
      });
      if (!isSuccess) {
        return isSuccess;
      }
      var model = TransactionsModel.fromJson(result.data);
      if (pageindex == 1) {
        this.clear();
      }

      for (final Transaction item in model.transactions) {
        if (!hasMore) {
          break;
        }
        if (!this.contains(item) && hasMore && !contains(item)) {
          add(item);
        }
      }
      _hasMore = model.transactions.length == rowsPerPage &&
          pageindex < model.pageInfo.totalPage;
      pageindex++;
    } catch (exception, stack) {
      isSuccess = false;
      print(exception);
      print(stack);
    }
    return isSuccess;
  }
}
