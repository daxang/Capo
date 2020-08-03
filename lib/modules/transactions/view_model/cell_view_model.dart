import 'package:capo/modules/balance/send/model/send_history_model.dart';
import 'package:capo/modules/transactions/model/transfer_state_info.dart';
import 'package:capo/utils/rnode_networking.dart';
import 'package:capo/utils/wallet_view_model.dart';
import 'package:capo_core_dart/capo_core_dart.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hex/hex.dart';
import 'package:intl/intl.dart';
import 'package:rxbus/rxbus.dart';

class TransactionCellViewModel with ChangeNotifier {
  final TransactionHistory history;
  TransactionCellViewModel({@required this.history});

  fetchTransactionStatus() async {
    if (history.status == TransactionStatus.failed ||
        history.status == TransactionStatus.success) {
      notifyListeners();
      return;
    }
    fetchBlockHash();
  }

  fetchBlockHash() async {
    if (history.status == TransactionStatus.failed ||
        history.status == TransactionStatus.success) {
      notifyListeners();
      return;
    }

    if (history.blockHash != null && history.blockHash.length > 0) {
      fetchTransactionFee();
      return;
    }
    FindDeployQuery query = FindDeployQuery();
    query.deployId = HEX.decode(history.deployId);
    var gRPC = await RNodeNetworking.gRPC;

    FindDeployResponse findDeployResponse =
        await gRPC.deployService.findDeploy(query);
    String error = findDeployResponse.error.messages.length > 0
        ? findDeployResponse.error.messages.first
        : null;
    if (error != null) {
      bool timeout = isTimeout();
      if (timeout) {
        history.status = TransactionStatus.failed;
        transactionStatusChanged();
        return;
      }
      Future.delayed(Duration(seconds: 10), () {
        if (_disposed) {
          return;
        }
        fetchBlockHash();
      });
      return;
    }
    String blockHash = findDeployResponse.blockInfo.blockHash;
    if (blockHash != null && blockHash.length > 0) {
      history.blockHash = blockHash;
      transactionStatusChanged();
      fetchTransactionFee();
    }
  }

  fetchBlockStatus() async {
    if (history.status == TransactionStatus.failed ||
        history.status == TransactionStatus.success) {
      notifyListeners();
      return;
    }
    IsFinalizedQuery finalizedQuery = IsFinalizedQuery();
    finalizedQuery.hash = history.blockHash;
    var gRPC = await RNodeNetworking.gRPC;
    IsFinalizedResponse isFinalizedResponse =
        await gRPC.deployService.isFinalized(finalizedQuery);

    if (isFinalizedResponse.isFinalized) {
      var blockHash = history.blockHash;
      Response<String> response = await RNodeNetworking.transferStateDio.get(
          "getTransaction/$blockHash",
          options: buildCacheOptions(Duration(days: 7)));
      if (response.statusCode == 200) {
        var responseBody = response.data;
        final transferStateInfo = transferStateInfoFromJson(responseBody);
        var info = transferStateInfo.first.firstWhere((stateInfo) {
          return stateInfo.deploy.sig == history.deployId;
        });
        if (info.success) {
          history.status = TransactionStatus.success;
        } else {
          history.status = TransactionStatus.failed;
          history.failedDesc = info.reason;
        }
        transactionStatusChanged();
        WalletViewModel.shared.getBalance();
      } else {
        history.status = TransactionStatus.unknown;
        history.failedDesc =
            "Unable to get transfer status now, please try again later";
        transactionStatusChanged();
      }
    } else {
      bool timeout = isTimeout();
      if (timeout) {
        history.status = TransactionStatus.failed;
        transactionStatusChanged();
        return;
      }
      Future.delayed(Duration(seconds: 10), () {
        if (_disposed) {
          return;
        }
        fetchBlockStatus();
      });
    }
  }

  fetchTransactionFee() async {
    if (history.minerFee != null &&
        history.status == TransactionStatus.pending) {
      fetchBlockStatus();
      return;
    }
    BlockQuery blockQuery = BlockQuery();
    blockQuery.hash = history.blockHash;
    var gRPC = await RNodeNetworking.gRPC;
    BlockResponse blockResponse = await gRPC.deployService.getBlock(blockQuery);
    DeployInfo deployInfo = blockResponse.blockInfo.deploys.firstWhere((block) {
      return block.sig == history.deployId;
    });

    if (deployInfo.errored) {
      history.status = TransactionStatus.failed;
      history.failedDesc = 'Deploy error when executing Rholang code.';
      transactionStatusChanged();
      return;
    }
    if (deployInfo.systemDeployError != null &&
        deployInfo.systemDeployError.length > 0) {
      history.status = TransactionStatus.failed;
      history.failedDesc = deployInfo.systemDeployError;
      transactionStatusChanged();
      return;
    }
    if (deployInfo.cost > 0) {
      history.minerFee = (deployInfo.cost.toInt() / 10e7).toString();
      transactionStatusChanged();
      fetchBlockStatus();
    }
  }

  bool isTimeout() {
    DateTime dateNow = DateTime.now();
    int timestamp = int.parse(history.timestamp);
    DateTime sendTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    var difference = dateNow.difference(sendTime);
    if (difference.inHours > 24) {
      return true;
    }
    return false;
  }

  transactionStatusChanged() {
    RxBus.post(history.from, tag: "SaveTransactions");
    RxBus.post("", tag: "TransactionStatusChanged");
  }

  Color getIndicatorColor() {
    Color color =
        history.status == TransactionStatus.failed ? Colors.red : Colors.green;
    if (history.type == TransactionType.receive) {
      color = Colors.green;
    }
    if (history.status == TransactionStatus.unknown) {
      color = Colors.yellow;
    }
    return color;
  }

  bool shouldAnimate() {
    if (history.status == TransactionStatus.pending) {
      return true;
    }
    return false;
  }

  String getStatus() {
    return history.status.toString().split(".").last;
  }

  String getTime() {
    int timestamp = int.parse(history.timestamp);
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    date.toLocal();
    var formatter = new DateFormat('yyyy/MM/dd HH:mm:ss');
    String dateString = formatter.format(date);
    return dateString;
  }

  String getType(TransactionHistory history) {
    if (history.type == TransactionType.send) {
      return "To:" + history.to;
    }
    return "From:" + history.from;
  }

  String getAmount() {
    if (history.type == TransactionType.send) {
      return "-" + history.amount;
    }
    return "+" + history.amount;
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
