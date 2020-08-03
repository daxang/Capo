// To parse this JSON data, do
//
//     final balanceModel = balanceModelFromJson(jsonString);

import 'dart:convert';

BalanceModel balanceModelFromJson(String str) =>
    BalanceModel.fromJson(json.decode(str));

String balanceModelToJson(BalanceModel data) => json.encode(data.toJson());

class BalanceModel {
  List<Expr> expr;
  Block block;

  BalanceModel({
    this.expr,
    this.block,
  });

  factory BalanceModel.fromJson(Map<String, dynamic> json) => BalanceModel(
        expr: List<Expr>.from(json["expr"].map((x) => Expr.fromJson(x))),
        block: Block.fromJson(json["block"]),
      );

  Map<String, dynamic> toJson() => {
        "expr": List<dynamic>.from(expr.map((x) => x.toJson())),
        "block": block.toJson(),
      };
}

class Block {
  String blockHash;
  String sender;
  int seqNum;
  String sig;
  String sigAlgorithm;
  String shardId;
  String extraBytes;
  int version;
  int timestamp;
  String headerExtraBytes;
  List<String> parentsHashList;
  int blockNumber;
  String preStateHash;
  String postStateHash;
  String bodyExtraBytes;
  List<Bond> bonds;
  String blockSize;
  int deployCount;
  double faultTolerance;

  Block({
    this.blockHash,
    this.sender,
    this.seqNum,
    this.sig,
    this.sigAlgorithm,
    this.shardId,
    this.extraBytes,
    this.version,
    this.timestamp,
    this.headerExtraBytes,
    this.parentsHashList,
    this.blockNumber,
    this.preStateHash,
    this.postStateHash,
    this.bodyExtraBytes,
    this.bonds,
    this.blockSize,
    this.deployCount,
    this.faultTolerance,
  });

  factory Block.fromJson(Map<String, dynamic> json) => Block(
        blockHash: json["blockHash"],
        sender: json["sender"],
        seqNum: json["seqNum"],
        sig: json["sig"],
        sigAlgorithm: json["sigAlgorithm"],
        shardId: json["shardId"],
        extraBytes: json["extraBytes"],
        version: json["version"],
        timestamp: json["timestamp"],
        headerExtraBytes: json["headerExtraBytes"],
        parentsHashList:
            List<String>.from(json["parentsHashList"].map((x) => x)),
        blockNumber: json["blockNumber"],
        preStateHash: json["preStateHash"],
        postStateHash: json["postStateHash"],
        bodyExtraBytes: json["bodyExtraBytes"],
        bonds: List<Bond>.from(json["bonds"].map((x) => Bond.fromJson(x))),
        blockSize: json["blockSize"],
        deployCount: json["deployCount"],
        faultTolerance: json["faultTolerance"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "blockHash": blockHash,
        "sender": sender,
        "seqNum": seqNum,
        "sig": sig,
        "sigAlgorithm": sigAlgorithm,
        "shardId": shardId,
        "extraBytes": extraBytes,
        "version": version,
        "timestamp": timestamp,
        "headerExtraBytes": headerExtraBytes,
        "parentsHashList": List<dynamic>.from(parentsHashList.map((x) => x)),
        "blockNumber": blockNumber,
        "preStateHash": preStateHash,
        "postStateHash": postStateHash,
        "bodyExtraBytes": bodyExtraBytes,
        "bonds": List<dynamic>.from(bonds.map((x) => x.toJson())),
        "blockSize": blockSize,
        "deployCount": deployCount,
        "faultTolerance": faultTolerance,
      };
}

class Bond {
  String validator;
  int stake;

  Bond({
    this.validator,
    this.stake,
  });

  factory Bond.fromJson(Map<String, dynamic> json) => Bond(
        validator: json["validator"],
        stake: json["stake"],
      );

  Map<String, dynamic> toJson() => {
        "validator": validator,
        "stake": stake,
      };
}

class Expr {
  ExprInt exprInt;
  ExprString exprString;
  Expr({this.exprInt, this.exprString});

  factory Expr.fromJson(Map<String, dynamic> json) => Expr(
      exprInt: ExprInt.fromJson(json["ExprInt"]),
      exprString: ExprString.fromJson(json["ExprString"]));

  Map<String, dynamic> toJson() => {
        "ExprInt": exprInt.toJson(),
        "ExprString": exprString.toJson(),
      };
}

class ExprInt {
  int data;

  ExprInt({
    this.data,
  });

  factory ExprInt.fromJson(Map<String, dynamic> json) => ExprInt(
        data: json == null ? null : json["data"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}

class ExprString {
  String data;

  ExprString({
    this.data,
  });

  factory ExprString.fromJson(Map<String, dynamic> json) => ExprString(
        data: json == null ? null : json["data"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
