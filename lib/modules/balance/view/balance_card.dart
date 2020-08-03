import 'package:capo/modules/balance/view_model/balance_card_view_model.dart';
import 'package:capo/provider/provider_widget.dart';
import 'package:capo/utils/capo_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

class AssetCard extends StatefulWidget {
  @override
  _AssetCardState createState() => _AssetCardState();
  final viewModel = CardViewModel();

  AssetCard({
    Key key,
  }) : super(key: key);
}

class _AssetCardState extends State<AssetCard>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  AnimationController _controller;
  Animation<double> _heightFactor;

  bool _isExpanded = false;
  final Duration _kExpand = Duration(milliseconds: 200);

  _AssetCardState();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _isExpanded = PageStorage.of(context)?.readState(context) ?? false;
    if (_isExpanded) _controller.value = 1.0;
//    viewModel.getBalance();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
  }

  Widget _buildCard(BuildContext context, Widget child) {
    return ProviderWidget<CardViewModel>(
      model: widget.viewModel,
      onModelReady: (model) => model.getWalletViewModel(context),
      builder: (_, viewModel, __) => viewModel.currentWallet == null
          ? Container()
          : GestureDetector(
              onTap: () {
                _handleTap();
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                decoration: BoxDecoration(
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.black12,
                      offset: new Offset(0.0, 1.0),
                      blurRadius: 2.0,
                    )
                  ],

                  color: Theme.of(context).cardColor,
                  borderRadius: new BorderRadius.circular((20.0)), // 圆角度
                ),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Stack(
                                alignment: const Alignment(0, 0),
                                children: <Widget>[
                                  viewModel.isFinishLoading
                                      ? Container()
                                      : SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.4,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    HexColor.mainColor),
                                          ),
                                        ),
                                  Image.asset(
                                    "resources/images/common/rchain_logo_red.png",
                                    fit: BoxFit.cover,
                                    height: 20.0,
                                    width: 20.0,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "REV",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .apply(
                                        fontSizeDelta: 0,
                                        fontWeightDelta: 2,
                                        fontFamily: "Karla"),
                              ),
                            ],
                          ),
                          Text(
                            (viewModel.walletViewModel.revBalance == null ||
                                    viewModel.walletViewModel.revBalance ==
                                        "--")
                                ? "--"
                                : capoNumberFormat(
                                    viewModel.walletViewModel.revBalance),
                            style: Theme.of(context).textTheme.headline6.apply(
                                fontFamily: "Karla",
                                fontSizeDelta: 1,
                                fontWeightDelta: 1),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              viewModel.currentWallet.address,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .apply(fontSizeDelta: 2),
                            ),
                          ),
                          IconButton(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.content_copy,
                              size: 15.0,
                            ),
                            onPressed: () async {
                              final data = ClipboardData(
                                  text: viewModel.currentWallet.address);
                              await Clipboard.setData(data);
                              showToast(tr("copy"));
                            },
                          ),
                          Text(
                            "",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .apply(fontFamily: "Karla", fontSizeDelta: 4),
                          ),
                        ],
                      ),
                      ClipRect(
                        child: Align(
                          heightFactor: _heightFactor.value,
                          child: child,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _child() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: CupertinoButton(
            padding: EdgeInsets.all(0),
            pressedOpacity: 0.8,
            color: Color.fromARGB(255, 30, 190, 210),
            child: Text(
              tr('balancePage.receiveBtn'),
              style: Theme.of(context).textTheme.button,
            ),
            onPressed: () {
              Navigator.pushNamed(context, "capo://icapo.app/balance/receive");
            },
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: CupertinoButton(
            padding: EdgeInsets.all(0),
            pressedOpacity: 0.8,
            color: HexColor.mainColor,
            child: Text(
              tr(
                'balancePage.sendBtn',
              ),
              style: Theme.of(context).textTheme.button,
            ),
            onPressed: () async {
              Navigator.pushNamed(context, "capo://icapo.app/balance/send");
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
        animation: _controller.view,
        builder: _buildCard,
        child: closed ? null : _child());
  }
}
