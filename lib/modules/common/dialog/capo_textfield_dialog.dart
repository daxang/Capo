import 'package:easy_localization/public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef TextFieldDialogCallback = void Function(String);

class CapoTextFieldDialog extends AlertDialog {
  final TextFieldDialogCallback inputCallback;
  final String topTitle;
  final String labelText;
  final String hint;
  CapoTextFieldDialog({
    @required this.topTitle,
    @required this.labelText,
    this.hint,
    this.inputCallback,
    Key key,
  }) : super(key: key);

  @override
  Widget get content =>
      TextFieldWidget(topTitle, labelText, hint, inputCallback);

  @override
  EdgeInsetsGeometry get contentPadding => EdgeInsets.all(0.0);

  @override
  Color get backgroundColor => Colors.transparent;
}

class TextFieldWidget extends StatelessWidget {
  final TextFieldDialogCallback inputCallback;
  final String topTitle;
  final String labelText;
  final String hint;
  TextFieldWidget(this.topTitle, this.labelText, this.hint, this.inputCallback,
      {Key key})
      : super(key: key);

  final TextEditingController editingController = TextEditingController();
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
                      child: Text(topTitle),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                      child: TextField(
                        controller: editingController,
                        autofocus: true,
//                        maxLength: 12,
                        cursorColor:
                            Theme.of(context).textTheme.subtitle1.color,
                        keyboardType: TextInputType.text,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .apply(fontSizeDelta: -2),
                        decoration: InputDecoration(
                          labelText: labelText,
                          hintText: hint,
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
                              Navigator.pop(context);
                              if (inputCallback != null) {
                                inputCallback(editingController.text);
                              }
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
