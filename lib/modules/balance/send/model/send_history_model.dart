import 'dart:convert';

import 'package:flutter/cupertino.dart';

enum TransactionStatus { pending, success, failed, unknown }
enum TransactionType { send, receive }
TransactionHistoryModel transactionHistoryModelFromJson(String str) =>
    TransactionHistoryModel.fromJson(json.decode(str));

String transactionHistoryModelToJson(TransactionHistoryModel data) =>
    json.encode(data.toJson());

class TransactionHistoryModel {
  List<TransactionHistory> transactionHistoryList;

  TransactionHistoryModel({
    this.transactionHistoryList,
  });

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) =>
      TransactionHistoryModel(
        transactionHistoryList: List<TransactionHistory>.from(
            json["transactions"].map((x) => TransactionHistory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "transactions":
            List<dynamic>.from(transactionHistoryList.map((x) => x.toJson())),
      };
}

class TransactionHistory {
  TransactionType type;
  String to;
  String from;
  String amount;
  String deployId;
  TransactionStatus status;
  String minerFee;
  String timestamp;
  String blockHash;
  String failedDesc;

  TransactionHistory({
    @required this.type,
    @required this.to,
    @required this.from,
    @required this.amount,
    @required this.deployId,
    @required this.status,
    @required this.timestamp,
    this.blockHash,
    this.minerFee,
    this.failedDesc,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) =>
      TransactionHistory(
        type: json["type"] == "send"
            ? TransactionType.send
            : TransactionType.receive,
        to: json["to"],
        from: json["from"],
        amount: json["amount"],
        deployId: json["deployID"],
        status: getTransactionStatus(json["status"]),
        timestamp: json["timestamp"],
        minerFee: json["minerFee"],
        blockHash: json["blockHash"],
        failedDesc: json["failedDesc"],
      );

  static TransactionStatus getTransactionStatus(String status) {
    if (status == "pending") {
      return TransactionStatus.pending;
    }
    if (status == "success") {
      return TransactionStatus.success;
    }
    if (status == "failed") {
      return TransactionStatus.failed;
    }
    return TransactionStatus.pending;
  }

  Map<String, dynamic> toJson() => {
        "type": type.toString().split(".").last,
        "to": to,
        "from": from,
        "amount": amount,
        "deployID": deployId,
        "status": status.toString().split(".").last,
        "minerFee": minerFee,
        "timestamp": timestamp,
        "blockHash": blockHash,
        "failedDesc": failedDesc
      };
}
