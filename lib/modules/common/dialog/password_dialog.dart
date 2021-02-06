import 'package:capo/modules/common/dialog/password_field.dart';
import 'package:capo_core_dart/capo_core_dart.dart';
import 'package:easy_localization/public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordDialog extends AlertDialog {
  final BasicWallet wallet;
  final ValueChanged<String> okClick;
  PasswordDialog({
    @required this.wallet,
    @required this.okClick,
    Key key,
  }) : super(key: key);

  @override
  Widget get content => PasswordWidget(
        this.wallet,
        this.okClick,
      );

  @override
  EdgeInsetsGeometry get contentPadding => EdgeInsets.all(0.0);

  @override
  Color get backgroundColor => Colors.transparent;
}

class PasswordWidget extends StatefulWidget {
  final ValueChanged<String> okClick;
  final BasicWallet wallet;

  PasswordWidget(this.wallet, this.okClick);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PasswordWidget> {
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();
  String errorMsg;

  bool _validatePassword() {
    String msg = "";
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty)
      msg = tr("password_dialog.empty_password");
    else if (passwordField.value.length < 8)
      msg = tr("password_dialog.password_length_error");
    if (msg != '') {
      setState(() {
        errorMsg = msg;
      });
      return false;
    }
    return true;
  }

  _handlePwd() {
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    if (_validatePassword()) {
      // Navigator.of(context).pop();
      widget.okClick(passwordField.value);
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

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
                        color: Theme.of(context).dialogBackgroundColor,
                        width: 1),
                    color: Theme.of(context).dialogBackgroundColor),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(tr("password_dialog.title"),
                          style: Theme.of(context).textTheme.headline6),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                      child: PasswordField(
                        fieldKey: _passwordFieldKey,
                        helperText: "",
                        labelText: tr("password_dialog.labelText"),
                        errorText: errorMsg,
                        autoFocus: true,
                        onFieldSubmitted: (value) {
                          _handlePwd();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: Row(children: [
                        Expanded(
                          child: CupertinoButton(
                            color: Color.fromARGB(255, 51, 118, 184),
                            padding: EdgeInsets.all(16),
                            pressedOpacity: 0.8,
                            child: Text(
                              tr("password_dialog.btn_title"),
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: _handlePwd,
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ))
          ],
        ));
  }
}
