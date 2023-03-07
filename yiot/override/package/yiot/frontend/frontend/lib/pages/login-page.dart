//  ────────────────────────────────────────────────────────────
//                     ╔╗  ╔╗ ╔══╗      ╔════╗
//                     ║╚╗╔╝║ ╚╣╠╝      ║╔╗╔╗║
//                     ╚╗╚╝╔╝  ║║  ╔══╗ ╚╝║║╚╝
//                      ╚╗╔╝   ║║  ║╔╗║   ║║
//                       ║║   ╔╣╠╗ ║╚╝║   ║║
//                       ╚╝   ╚══╝ ╚══╝   ╚╝
//    ╔╗╔═╗                    ╔╗                     ╔╗
//    ║║║╔╝                   ╔╝╚╗                    ║║
//    ║╚╝╝  ╔══╗ ╔══╗ ╔══╗  ╔╗╚╗╔╝  ╔══╗ ╔╗ ╔╗╔╗ ╔══╗ ║║  ╔══╗
//    ║╔╗║  ║║═╣ ║║═╣ ║╔╗║  ╠╣ ║║   ║ ═╣ ╠╣ ║╚╝║ ║╔╗║ ║║  ║║═╣
//    ║║║╚╗ ║║═╣ ║║═╣ ║╚╝║  ║║ ║╚╗  ╠═ ║ ║║ ║║║║ ║╚╝║ ║╚╗ ║║═╣
//    ╚╝╚═╝ ╚══╝ ╚══╝ ║╔═╝  ╚╝ ╚═╝  ╚══╝ ╚╝ ╚╩╩╝ ║╔═╝ ╚═╝ ╚══╝
//                    ║║                         ║║
//                    ╚╝                         ╚╝
//
//    Lead Maintainer: Roman Kutashenko <kutashenko@gmail.com>
//  ────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import 'package:yiot_portal/session/yiot-session.dart';

import 'package:yiot_portal/routes/routed-widget.dart';

import 'package:yiot_portal/components/ui/yiot-primary-button.dart';

// -----------------------------------------------------------------------------
class LoginPage extends StatefulWidget implements RoutedWidgetInterface {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();

  //
  //  RoutedWidgetInterface
  //
  String route() {
    return "/login";
  }

  IconData? icon() {
    return null;
  }

  String title() {
    return "";
  }
}

// -----------------------------------------------------------------------------
class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("YIoT CV-2SE"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 300,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 100,
                    maxWidth: 150,
                  ),
                  child: Image.asset(
                    'assets/images/yiot.png',
                  ),
                ),
                Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _username = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                SizedBox(height: 20),
                YIoTPrimaryButton(
                  text: 'Login',
                  onPressed: () async {

                    // Validate and save form
                    final FormState form = _formKey.currentState!;
                    if (!form.validate()) {
                      print('Form is invalid');
                      return;
                    }
                    form.save();

                    // Session login
                    final session = YIoTSession();
                    final ready = await session.login(_username, _password);

                    // Switch to the main view in case of success
                    if (ready) {
                      Navigator.pushReplacementNamed(context, '/');
                      return;
                    }

                    // Show error dialogue
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Login Failed'),
                        content: Text('Invalid username or password'),
                        actions: [
                          YIoTPrimaryButton(
                            text: 'OK',
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
