// To parse this JSON data, do
//
//     final transferStateInfo = transferStateInfoFromJson(jsonString);

import 'dart:convert';

List<List<TransferStateInfo>> transferStateInfoFromJson(String str) =>
    List<List<TransferStateInfo>>.from(json.decode(str).map((x) =>
        List<TransferStateInfo>.from(
            x.map((x) => TransferStateInfo.fromJson(x)))));

String transferStateInfoToJson(List<List<TransferStateInfo>> data) =>
    json.encode(List<dynamic>.from(
        data.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))));

class TransferStateInfo {
  String fromAddr;
  String toAddr;
  int amount;
  String retUnforeable;
  Deploy deploy;
  bool success;
  String reason;

  TransferStateInfo({
    this.fromAddr,
    this.toAddr,
    this.amount,
    this.retUnforeable,
    this.deploy,
    this.success,
    this.reason,
  });

  factory TransferStateInfo.fromJson(Map<String, dynamic> json) =>
      TransferStateInfo(
        fromAddr: json["fromAddr"],
        toAddr: json["toAddr"],
        amount: json["amount"],
        retUnforeable: json["retUnforeable"],
        deploy: Deploy.fromJson(json["deploy"]),
        success: json["success"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "fromAddr": fromAddr,
        "toAddr": toAddr,
        "amount": amount,
        "retUnforeable": retUnforeable,
        "deploy": deploy.toJson(),
        "success": success,
        "reason": reason,
      };
}

class Deploy {
  String deployer;
  String term;
  int timestamp;
  String sig;
  SigAlgorithm sigAlgorithm;
  int phloPrice;
  int phloLimit;
  int validAfterBlockNumber;
  int cost;
  bool errored;
  String systemDeployError;

  Deploy({
    this.deployer,
    this.term,
    this.timestamp,
    this.sig,
    this.sigAlgorithm,
    this.phloPrice,
    this.phloLimit,
    this.validAfterBlockNumber,
    this.cost,
    this.errored,
    this.systemDeployError,
  });

  factory Deploy.fromJson(Map<String, dynamic> json) => Deploy(
        deployer: json["deployer"],
        term: json["term"],
        timestamp: json["timestamp"],
        sig: json["sig"],
        sigAlgorithm: sigAlgorithmValues.map[json["sigAlgorithm"]],
        phloPrice: json["phloPrice"],
        phloLimit: json["phloLimit"],
        validAfterBlockNumber: json["validAfterBlockNumber"],
        cost: json["cost"],
        errored: json["errored"],
        systemDeployError: json["systemDeployError"],
      );

  Map<String, dynamic> toJson() => {
        "deployer": deployer,
        "term": term,
        "timestamp": timestamp,
        "sig": sig,
        "sigAlgorithm": sigAlgorithmValues.reverse[sigAlgorithm],
        "phloPrice": phloPrice,
        "phloLimit": phloLimit,
        "validAfterBlockNumber": validAfterBlockNumber,
        "cost": cost,
        "errored": errored,
        "systemDeployError": systemDeployError,
      };
}

enum SigAlgorithm { SECP256_K1, SECP256_K1_ETH }

final sigAlgorithmValues = EnumValues({
  "secp256k1": SigAlgorithm.SECP256_K1,
  "secp256k1:eth": SigAlgorithm.SECP256_K1_ETH
});

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
