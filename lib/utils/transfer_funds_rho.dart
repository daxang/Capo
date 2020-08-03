import 'package:flutter/cupertino.dart';

String transferFundsRho(
    {@required String revAddrFrom,
    @required String revAddrTo,
    @required num amount}) {
  String rho = """
     new rl(\`rho:registry:lookup\`), RevVaultCh in {
    rl!(\`rho:rchain:revVault\`, *RevVaultCh) |
    for (@(_, RevVault) <- RevVaultCh) {
      new vaultCh, vaultTo, revVaultkeyCh,
        deployerId(\`rho:rchain:deployerId\`),
        deployId(\`rho:rchain:deployId\`)
      in {
        match ("$revAddrFrom", "$revAddrTo", $amount) {
          (revAddrFrom, revAddrTo, amount) => {
            @RevVault!("findOrCreate", revAddrFrom, *vaultCh) |
            @RevVault!("findOrCreate", revAddrTo, *vaultTo) |
            @RevVault!("deployerAuthKey", *deployerId, *revVaultkeyCh) |
            for (@vault <- vaultCh; key <- revVaultkeyCh; _ <- vaultTo) {
              match vault {
                (true, vault) => {
                  new resultCh in {
                    @vault!("transfer", revAddrTo, amount, *key, *resultCh) |
                    for (@result <- resultCh) {
                      match result {
                        (true , _  ) => deployId!((true, "Transfer successful."))
                        (false, err) => deployId!((false, err))
                      }
                    }
                  }
                }
                err => {
                  deployId!((false, "REV vault cannot be found or created."))
                }
              }
            }
          }
        }
      }
    }
  }
  """;
  return rho;
}
