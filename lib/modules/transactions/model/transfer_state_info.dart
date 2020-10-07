// To parse this JSON data, do
//
//     final transactionsModel = transactionsModelFromJson(jsonString);

import 'dart:convert';

TransactionsModel transactionsModelFromJson(String str) =>
    TransactionsModel.fromJson(json.decode(str));

String transactionsModelToJson(TransactionsModel data) =>
    json.encode(data.toJson());

class TransactionsModel {
  TransactionsModel({
    this.transactions,
    this.pageInfo,
  });

  List<Transaction> transactions;
  PageInfo pageInfo;

  factory TransactionsModel.fromJson(Map<String, dynamic> json) =>
      TransactionsModel(
        transactions: List<Transaction>.from(
            json["transactions"].map((x) => Transaction.fromJson(x))),
        pageInfo: PageInfo.fromJson(json["pageInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
        "pageInfo": pageInfo.toJson(),
      };
}

class PageInfo {
  PageInfo({
    this.totalPage,
    this.currentPage,
  });

  int totalPage;
  int currentPage;

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
        totalPage: json["totalPage"],
        currentPage: json["currentPage"],
      );

  Map<String, dynamic> toJson() => {
        "totalPage": totalPage,
        "currentPage": currentPage,
      };
}

class Transaction {
  Transaction({
    this.fromAddr,
    this.toAddr,
    this.amount,
    this.transactionType,
    this.blockHash,
    this.blockNumber,
    this.deployId,
    this.timestamp,
    this.isFinalized,
    this.isSucceeded,
    this.reason,
  });

  String fromAddr;
  String toAddr;
  int amount;
  TransactionType transactionType;
  String blockHash;
  int blockNumber;
  String deployId;
  int timestamp;
  bool isFinalized;
  bool isSucceeded;
  String reason;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        fromAddr: json["fromAddr"],
        toAddr: json["toAddr"],
        amount: json["amount"],
        transactionType: transactionTypeValues.map[json["transactionType"]],
        blockHash: json["blockHash"],
        blockNumber: json["blockNumber"],
        deployId: json["deployId"],
        timestamp: json["timestamp"],
        isFinalized: json["isFinalized"],
        isSucceeded: json["isSucceeded"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "fromAddr": fromAddr,
        "toAddr": toAddr,
        "amount": amount,
        "transactionType": transactionTypeValues.reverse[transactionType],
        "blockHash": blockHash,
        "blockNumber": blockNumber,
        "deployId": deployId,
        "timestamp": timestamp,
        "isFinalized": isFinalized,
        "isSucceeded": isSucceeded,
        "reason": reason,
      };
}

enum TransactionType { TRANSFER, DEPLOY }

final transactionTypeValues = EnumValues(
    {"deploy": TransactionType.DEPLOY, "transfer": TransactionType.TRANSFER});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
