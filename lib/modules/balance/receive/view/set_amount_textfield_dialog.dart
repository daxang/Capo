import 'package:easy_localization/public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef AmountInputCallback = void Function(String);

class AmountTextFieldDialog extends AlertDialog {
  final AmountInputCallback inputCallback;
  AmountTextFieldDialog({
    @required this.inputCallback,
    Key key,
  }) : super(key: key);

  @override
  Widget get content => AmountTextFieldWidget(inputCallback);

  @override
  EdgeInsetsGeometry get contentPadding => EdgeInsets.all(0.0);

  @override
  Color get backgroundColor => Colors.transparent;
}

class AmountTextFieldWidget extends StatelessWidget {
  final AmountInputCallback inputCallback;
  final TextEditingController editingController = TextEditingController();

  AmountTextFieldWidget(this.inputCallback, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black54,
        ),
        child: Wrap(
          children: <Widget>[
            Container(
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                        color: Theme.of(context).cardColor, width: 1),
                    color: Theme.of(context).cardColor),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(tr('receivePage.set_amount_page.title')),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                      child: TextField(
                        enableInteractiveSelection: false,
                        autofocus: true,
                        controller: editingController,
                        maxLength: 19,
                        cursorColor:
                            Theme.of(context).textTheme.subtitle1.color,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .apply(fontSizeDelta: -2),
                        decoration: InputDecoration(
                          labelText: tr('receivePage.set_amount_page.hint'),
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        Expanded(
                          child: CupertinoButton(
                            color: Color.fromARGB(255, 51, 118, 184),
                            padding: EdgeInsets.all(16),
                            pressedOpacity: 0.8,
                            child: Text(
                              tr("settings.wallets.detail.text_field_dialog.btn_title"),
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              String inputString = editingController.text;
                              inputCallback(inputString);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ]),
                    ),
                  ],
                ))
          ],
        ));
  }
}
