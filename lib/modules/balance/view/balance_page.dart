import 'package:capo/modules/balance/view/balance_card.dart';
import 'package:capo/utils/capo_utils.dart';
import 'package:capo/utils/rnode_networking.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BalanceHomePage extends StatelessWidget {
  final _assetCard = AssetCard();
  Future _refresh() async {

//   Response response = await RNodeNetworking.revdefineDio.get("/api/validators");
//   print("response:${response.data}");
    return _assetCard.viewModel.getBalance(showLoading: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          title: Text(
            tr('bottomTabBar.balance'),
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(2.0),
        child: RefreshIndicator(
          onRefresh: _refresh,
          backgroundColor: HexColor.mainColor,
          color: Colors.white,
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return _assetCard;
            },
          ),
        ),
      ),
    );
  }
}
