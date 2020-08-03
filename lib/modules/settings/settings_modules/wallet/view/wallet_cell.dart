import 'package:capo_core_dart/capo_core_dart.dart';
import 'package:flutter/material.dart';

class WalletCell extends StatelessWidget {
  final BasicWallet wallet;
  final bool selected;
  WalletCell({Key key, @required this.wallet, @required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "capo://icapo.app/settings/wallets/detail",
            arguments: wallet);
      },
      child: Container(
          padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
          margin: EdgeInsets.fromLTRB(16, 10, 16, 0),
          decoration: BoxDecoration(
            boxShadow: [
              new BoxShadow(
                color: Colors.black12,
                offset: new Offset(0.0, 1.0),
                blurRadius: 2.0,
              )
            ],
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular((10.0)), // 圆角度
          ),
          child: Row(
            children: <Widget>[
              Container(
//                color: Colors.black12,
                height: 60,
                width: 60,
                child: Stack(
                  alignment: const Alignment(0, 0),
                  children: <Widget>[
                    Image.asset(
                      "resources/images/common/rchain_logo_red.png",
                      fit: BoxFit.cover,
                      height: 40.0,
                      width: 40.0,
                    ),
                    selected
                        ? Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 15.0,
                              height: 15.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              child: Icon(
                                Icons.check_circle,
                                size: 15,
                                color: Color.fromARGB(255, 51, 118, 184),
                              ),
                            ))
                        : Container(),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(wallet.capoMeta.name),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          wallet.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )), //),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ],
          )),
    );
  }
}
